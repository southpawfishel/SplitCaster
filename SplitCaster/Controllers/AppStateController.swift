//
//  AppStateController.swift
//  SplitCaster
//
//  Created by Dave Fishel on 7/1/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import AppKit
import Foundation

/// This class essentially owns the business logic of the application.
///
/// It exposes a readonly app state that the SwiftUI views use to draw the screen,
/// and handles all app state mutations in response to keyboard events and timer updates.
class AppStateController: ObservableObject {
  @Published public private(set) var state: AppState = AppState()
  public static let routeFilename = "mario64.json"

  private var _globalEventMonitor: Any?
  private var _localEventMonitor: Any?
  private var _timer: Timer? = nil

  public init(filename: String!) {
    let dataDirPath = NSString(string: "SplitCasterData").appendingPathComponent(filename)
    if let route = loadRouteFromDocumentsPath(path: dataDirPath) {
      state = state.withRoute(route.withCurrentRun(route.splits)).withRunInProgress(false)
    } else if let route = loadRouteFromBundle(filename: filename) {
      state = state.withRoute(route.withCurrentRun(route.splits)).withRunInProgress(false)
    } else {
      print("Failed to load route from \(filename!)!")
    }
  }

  ///
  /// Load the route data from the given file name and assign it to the current state
  ///
  public func loadRouteFromBundle(filename: String) -> RouteModel? {
    let splitFilename = filename.split(separator: ".")
    if let url = Bundle.main.url(
      forResource: String(splitFilename[0]),
      withExtension: String(splitFilename[1]))
    {
      do {
        let decoder = JSONDecoder()
        let json = try Data.init(contentsOf: url)
        let route = try decoder.decode(RouteModel.self, from: json)
        return route
      } catch {
        print("Error loading bundle json: \(error)")
      }
    }
    return nil
  }

  ///
  /// Load the route data from the given path (assumed to be in the documents directory) and assign it to the current state
  ///
  public func loadRouteFromDocumentsPath(path: String) -> RouteModel? {
    let url = URL(
      fileURLWithPath: (FileUtils.getDocumentsPath() as NSString).appendingPathComponent(path))
    do {
      let decoder = JSONDecoder()
      let json = try Data.init(contentsOf: url)
      let route = try decoder.decode(RouteModel.self, from: json)
      return route
    } catch {
      print("Error loading json: \(url)")
    }
    return nil
  }

  ///
  /// Save the current route state to the documents dir
  ///
  public func saveRouteToDocuments(path: String) {
    let url = URL(
      fileURLWithPath: (FileUtils.getDocumentsPath() as NSString).appendingPathComponent(path))
    do {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      let json = try encoder.encode(state.route)
      try json.write(to: url)
    } catch {
      print("Error saving json: \(url)")
    }
  }

  ///
  /// Checks if we have global keyboard permissions (so we can check key events while our app doesn't have focus)
  ///
  /// If this check fails, user needs to grant the permission and restart the app
  ///
  private func acquireGlobalKeyEventPermissions() {
    let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
    let hasGlobalKeyEventAccess = AXIsProcessTrustedWithOptions(options)
    handlePermissionsResult(hasPermissions: hasGlobalKeyEventAccess)
  }

  ///
  /// Handle permissions received event and update app state accordingly
  ///
  func handlePermissionsResult(hasPermissions: Bool) {
    state = state.withPermissions(hasPermissions)
  }

  ///
  /// Registers our controller for global key events
  ///
  public func registerForEvents() {
    acquireGlobalKeyEventPermissions()
    if state.hasPermissions {
      _globalEventMonitor = NSEvent.addGlobalMonitorForEvents(
        matching: NSEvent.EventTypeMask.keyDown, handler: handleGlobalKeyEvent)
      _localEventMonitor = NSEvent.addLocalMonitorForEvents(
        matching: NSEvent.EventTypeMask.keyDown, handler: handleLocalKeyEvent)
    }
  }

  ///
  /// Deregisters our controller for global key events
  ///
  public func unregisterForEvents() {
    if let globalMonitor: Any = _globalEventMonitor {
      NSEvent.removeMonitor(globalMonitor)
    }
    if let localMonitor: Any = _localEventMonitor {
      NSEvent.removeMonitor(localMonitor)
    }
  }

  ///
  /// Handle key events and update app state accordingly
  ///
  private func handleGlobalKeyEvent(event: NSEvent) {
    handleKeyEvent(event: event)
  }

  private func handleLocalKeyEvent(event: NSEvent) -> NSEvent? {
    handleKeyEvent(event: event)
    return event
  }

  ///
  /// Takes in keyboard events and determines if they should be translated
  /// to events that can update the app's state
  ///
  private func handleKeyEvent(event: NSEvent) {
    // print(
    //   "event time: \(event.timestamp), uptime: \(ProcessInfo.processInfo.systemUptime), keycode: \(event.keyCode)"
    // )
    if event.keyCode == Keycode.space {
      handleSplitKeyPressed(timestamp: event.timestamp)
    }
  }

  private func handleSplitKeyPressed(timestamp: Double) {
    var shouldSave = false
    let oldRunInProgress = state.runInProgress
    state = splitEventUpdateReducer(state, timestamp)

    // Do the side effect of start/stop timer independent of state reducer
    if state.runInProgress != oldRunInProgress {
      if state.runInProgress {
        startUpdateTimer()
      } else {
        stopUpdateTimer()
      }
      // We want to save at the start or end of a run (start saves attempt count increase)
      shouldSave = true
    }

    // Save data to disk if we need to
    if shouldSave {
      let dataDirPath = NSString(string: "SplitCasterData").appendingPathComponent(
        AppStateController.routeFilename)
      saveRouteToDocuments(path: dataDirPath)
    }
  }

  ///
  /// Takes in the current state and the time at which the split event
  /// occurred, and produces an updated app state.
  ///
  private func splitEventUpdateReducer(_ curState: AppState, _ timestamp: Double) -> AppState {
    return curState.runInProgress
      ? doNextSplitReducer(curState, timestamp)
      : startNewRunReducer(curState, timestamp)
  }

  ///
  /// Takes in the current state and performs returns state updated for start of a new run
  ///
  /// Initially populate current run with default splits data, start on split 0, increment attempt count
  ///
  /// Set start of first split to event timestamp, end to current time
  /// (This might be called a millisecond or so after the initial event)
  ///
  /// Update that the run is now in progress
  private func startNewRunReducer(_ curState: AppState, _ timestamp: Double) -> AppState {
    let curSplitIndex = 0
    return curState.withRoute(
      curState.route
        .withCurrentSplit(curSplitIndex)
        .withAttemptCount(1 + curState.route.attemptCount)
        .withCurrentRun(startOfSplitReducer(curState.route.splits, curSplitIndex, timestamp))
    ).withRunInProgress(true)
  }

  ///
  /// Takes a run, split index, and timestamp, and produces an updated run where the current split is updated for the start of a new split
  ///
  private func startOfSplitReducer(_ run: [SplitModel], _ splitIndex: Int, _ ts: Double)
    -> [SplitModel]
  {
    return run.arrayByReplacing(
      index: splitIndex,
      with: run[splitIndex]
        .withStartTime(ts)
        .withRunStartTime(splitIndex == 0 ? ts : run[0].startTime!)
        .withEndTime(ProcessInfo.processInfo.systemUptime))
  }

  ///
  /// Takes a run, split index, and timestamp, and produces an updated run where the current split is updated for the end of a split
  ///
  private func endOfSplitReducer(
    _ run: [SplitModel], _ bestRun: [SplitModel]?, _ splitIndex: Int, _ ts: Double
  )
    -> [SplitModel]
  {
    let updatedSplit = run[splitIndex].withEndTime(ts)
    let isGold =
      bestRun == nil
      ? true
      : updatedSplit.elapsed! <= bestRun![splitIndex].elapsed!
    return run.arrayByReplacing(
      index: splitIndex,
      with: updatedSplit.withIsGold(isGold))
  }

  ///
  /// Takes in the current state and performs returns state updated with next split logic handled
  ///
  private func doNextSplitReducer(_ curState: AppState, _ timestamp: Double) -> AppState {
    // Update current split's end timestamp to the event timestamp,
    let curSplitIndex = curState.route.currentSplit

    // If not on the last split, new next split is 1 + previous split index
    let nextSplitIndex =
      (curSplitIndex == curState.route.splits.count - 1)
      ? curSplitIndex
      : 1 + curSplitIndex

    // Update run for end of current split
    let runWithUpdatedCurSplit = endOfSplitReducer(
      curState.route.currentRun,
      curState.route.bestRun,
      curSplitIndex,
      timestamp)

    // If not on the last split, update start time of next split
    let updatedRun =
      (curSplitIndex == curState.route.splits.count - 1)
      ? runWithUpdatedCurSplit
      : startOfSplitReducer(runWithUpdatedCurSplit, 1 + curSplitIndex, timestamp)

    // If on the last split, run will be not in progress after this
    let runInProgress = (curSplitIndex == curState.route.splits.count - 1) ? false : true

    // If on the last split, update our PB run
    let bestRun: [SplitModel]? =
      (curSplitIndex == curState.route.splits.count - 1)
      ? runPbReducer(curState.route.bestRun, updatedRun)
      : curState.route.bestRun

    // If on the last split, update individual split PBs
    let updatedSplits =
      (curSplitIndex == curState.route.splits.count - 1)
      ? splitPbReducer(curState.route.splits, curState.route.currentRun)
      : curState.route.splits

    return curState.withRoute(
      curState.route
        .withCurrentRun(updatedRun)
        .withSplits(updatedSplits)
        .withCurrentSplit(nextSplitIndex)
        .withBestRun(bestRun)
    ).withRunInProgress(runInProgress)
  }

  ///
  /// Produces the best run for the route given the existing best run and the current run
  ///
  private func runPbReducer(_ bestRun: [SplitModel]?, _ currentRun: [SplitModel]) -> [SplitModel] {
    if let bestRun = bestRun {
      if let pbRunTime = RouteModel.totalTimeOfRun(bestRun) {
        if RouteModel.totalTimeOfRun(currentRun)! < pbRunTime {
          return currentRun
        }
      }
      // If we made it here, return old best run
      return bestRun
    } else {
      return currentRun
    }
  }

  ///
  /// Produces an updated splits array if a new split PB was achieved
  ///
  private func splitPbReducer(
    _ splits: [SplitModel], _ runThatJustFinished: [SplitModel]
  ) -> [SplitModel] {
    return splits.enumerated().map { index, split in
      if let splitPb = split.bestElapsedTime {
        // If the split time is better than our previous personal-best, update it
        if runThatJustFinished[index].elapsed! < splitPb {
          return split.withBestTime(runThatJustFinished[index].elapsed!)
        }
      } else {
        // If there's no PB, record this split time as the PB
        return split.withBestTime(runThatJustFinished[index].elapsed!)
      }
      // If we reach the bottom, just return what was passed in
      return split
    }
  }

  ///
  /// Starts the update timer which will update the model each time it fires
  ///
  private func startUpdateTimer() {
    stopUpdateTimer()
    _timer = Timer.scheduledTimer(
      withTimeInterval: (1 / 30.0), repeats: true, block: handleTimerUpdate)
  }

  ///
  /// Stops the update timer. No-op if timer is nil
  ///
  private func stopUpdateTimer() {
    if let timer = _timer {
      timer.invalidate()
      _timer = nil
    }
  }

  ///
  /// Timer callback function
  ///
  private func handleTimerUpdate(timer: Timer) {
    state = timerUpdateReducer(curState: state, currentTime: ProcessInfo.processInfo.systemUptime)
  }

  ///
  /// Take in the current app state and time and produce a new state with updated
  /// splits given the current time
  ///
  private func timerUpdateReducer(curState: AppState, currentTime: Double) -> AppState {
    let curSplitIndex = curState.route.currentSplit
    let currentRun = curState.route.currentRun
    let updatedRun = currentRun.arrayByReplacing(
      index: curSplitIndex,
      with: currentRun[curSplitIndex].withEndTime(currentTime))

    // Check if our time is better than PB
    let isFasterThanPb =
      (curState.route.bestRun == nil)
      ? true
      : RouteModel.totalTimeOfRun(currentRun, curSplitIndex)! <= RouteModel.totalTimeOfRun(
        curState.route.bestRun!, curSplitIndex)!

    let finalUpdatedRun = updatedRun.arrayByReplacing(
      index: curSplitIndex,
      with: updatedRun[curSplitIndex].withIsAheadOfPb(isFasterThanPb))

    return curState.withRoute(curState.route.withCurrentRun(finalUpdatedRun))
  }
}
