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

  private var _globalEventMonitor: Any?
  private var _localEventMonitor: Any?
  private var _timer: Timer? = nil

  public init(filename: String!) {
    loadRouteFromFile(filename: filename)
  }

  ///
  /// Load the route data from the given file name and assign it to the current state
  ///
  public func loadRouteFromFile(filename: String!) {
    let splitFilename = filename.split(separator: ".")
    if let url = Bundle.main.url(
      forResource: String(splitFilename[0]),
      withExtension: String(splitFilename[1]))
    {
      do {
        let decoder = JSONDecoder()
        let json = try Data.init(contentsOf: url)
        let route = try decoder.decode(RouteModel.self, from: json)
        state = state.route(route.currentRun(route.splits)).runInProgress(false)
      } catch {
        print("Error loading json: \(error)")
      }
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
    state = state.hasPermissions(hasPermissions)
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
    let oldRunInProgress = state.runInProgress
    state = splitEventUpdateReducer(curState: state, timestamp: timestamp)

    // Do the side effect of start/stop timer independent of state reducer
    if state.runInProgress != oldRunInProgress {
      if state.runInProgress {
        startUpdateTimer()
      } else {
        stopUpdateTimer()
      }
    }
  }

  ///
  /// Takes in the current state and the time at which the split event
  /// occurred, and produces an updated app state.
  ///
  private func splitEventUpdateReducer(curState: AppState, timestamp: Double) -> AppState {
    var newState = curState
    if !newState.runInProgress {
      // Initially populate current run with default splits data, start on split 0, increment attempt count
      newState = newState.route(
        newState.route
          .currentRun(newState.route.splits)
          .currentSplit(0)
          .attemptCount(1 + newState.route.attemptCount))

      // Set start of first split to event timestamp, end to current time
      // (This might be called a millisecond or so after the initial event)
      let curSplitIndex = newState.route.currentSplit
      let updatedCurSplit = newState.route.currentRun[curSplitIndex]
        .startTimestamp(timestamp)
        .globalStartTimestamp(timestamp)
        .endTimestamp(ProcessInfo.processInfo.systemUptime)
      newState = newState.route(
        newState.route.currentRun(
          newState.route.currentRun.arrayByReplacing(index: curSplitIndex, with: updatedCurSplit)))

      // Update that the run is now in progress
      newState = newState.runInProgress(true)
    } else if (newState.runInProgress) {
      // Update current split's end timestamp to the event timestamp,
      let curSplitIndex = state.route.currentSplit
      let updatedCurSplit = state.route.currentRun[curSplitIndex]
        .endTimestamp(timestamp)
      newState = newState.route(
        newState.route.currentRun(
          newState.route.currentRun.arrayByReplacing(index: curSplitIndex, with: updatedCurSplit)))

      // TODO: check if this is our best split time, save best split time

      if (curSplitIndex == newState.route.splits.count - 1) {
        // TODO: update route pb if necessary

        // Run is now no longer in progress
        newState = newState.runInProgress(false)
      } else {
        // Update nest split's start timestamp to the event timestamp
        let updatedNextSplit = newState.route.currentRun[1 + curSplitIndex]
          .startTimestamp(timestamp)
          .globalStartTimestamp(newState.route.currentRun[0].startTimestamp!)
          .endTimestamp(ProcessInfo.processInfo.systemUptime)
        newState = newState.route(
          newState.route.currentRun(
            newState.route.currentRun.arrayByReplacing(
              index: 1 + curSplitIndex, with: updatedNextSplit)))
        newState = newState.route(newState.route.currentSplit(1 + curSplitIndex))
      }
    }
    return newState
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
    let currentSplit = curState.route.currentSplit
    return curState.route(
      curState.route.currentRun(
        curState.route.currentRun.arrayByReplacing(
          index: currentSplit,
          with: curState.route.currentRun[currentSplit]
            .endTimestamp(currentTime))))
  }
}
