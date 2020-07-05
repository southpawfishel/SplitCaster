//
//  AppStateController.swift
//  SplitCaster
//
//  Created by Dave Fishel on 7/1/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import AppKit
import Foundation

/**
 * This class essentially owns the business logic of the application.
 *
 * It exposes a readonly app state that the SwiftUI views use to draw the screen, and handles all app state mutations
 * in response to keyboard events and timer updates.
 */
class AppStateController: ObservableObject {
  @Published public private(set) var state: AppState = AppState()

  private var _globalEventMonitor: Any?
  private var _localEventMonitor: Any?
  private var _timer: Timer? = nil

  public init(filename: String!) {
    loadRouteFromFile(filename: filename)
  }

  /**
   * Load the route data from the given file name and assign it to the current state
   */
  public func loadRouteFromFile(filename: String!) -> Void {
    let splitFilename = filename.split(separator: ".")
    if let url = Bundle.main.url(forResource: String(splitFilename[0]),
                                 withExtension: String(splitFilename[1])) {
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

  /**
   * Checks if we have global keyboard permissions (so we can check key events while our app doesn't have focus)
   *
   * If this check fails, user needs to grant the permission and restart the app
   */
  private func acquireGlobalKeyEventPermissions() -> Void {
    let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
    let hasGlobalKeyEventAccess = AXIsProcessTrustedWithOptions(options)
    handlePermissionsResult(hasPermissions: hasGlobalKeyEventAccess)
  }

  /**
   * Handle permissions received event and update app state accordingly
   */
  func handlePermissionsResult(hasPermissions: Bool) -> Void {
    state = state.hasPermissions(hasPermissions)
  }

  /**
   * Registers our controller for global key events
   */
  public func registerForEvents() -> Void {
    acquireGlobalKeyEventPermissions()
    if state.hasPermissions {
      _globalEventMonitor = NSEvent.addGlobalMonitorForEvents(
        matching: NSEvent.EventTypeMask.keyDown, handler: handleGlobalKeyEvent)
      _localEventMonitor = NSEvent.addLocalMonitorForEvents(
        matching: NSEvent.EventTypeMask.keyDown, handler: handleLocalKeyEvent)
    }
  }

  /**
   * Deregisters our controller for global key events
   */
  public func unregisterForEvents() -> Void {
    if let globalMonitor: Any = _globalEventMonitor {
      NSEvent.removeMonitor(globalMonitor)
    }
    if let localMonitor: Any = _localEventMonitor {
      NSEvent.removeMonitor(localMonitor)
    }
  }

  /**
   * Handle key events and update app state accordingly
   */
  private func handleGlobalKeyEvent(event: NSEvent) -> Void {
    handleKeyEvent(event: event)
  }

  private func handleLocalKeyEvent(event: NSEvent) -> NSEvent? {
    handleKeyEvent(event: event)
    return event
  }

  private func handleKeyEvent(event: NSEvent) {
    if (event.keyCode == Keycode.space) {
//      print("event time: \(event.timestamp), uptime: \(ProcessInfo.processInfo.systemUptime), keycode: \(event.keyCode)")
      handleSplitKeyPressed(timestamp: event.timestamp)
    }
  }

  private func handleSplitKeyPressed(timestamp: Double) {
    if (!state.runInProgress) {
      // Initially populate current run with default splits data, start on split 0, increment attempt count
      state = state.route(state.route
        .currentRun(state.route.splits)
        .currentSplit(0)
        .attemptCount(1 + state.route.attemptCount))

      // Set start of first split to event timestamp, end to current time
      // (This might be called a millisecond or so after the initial event)
      let curSplitIndex = state.route.currentSplit
      let updatedCurSplit = state.route.currentRun[curSplitIndex]
        .startTimestamp(timestamp)
        .globalStartTimestamp(timestamp)
        .endTimestamp(ProcessInfo.processInfo.systemUptime)
      state = state.route(state.route.currentRun(
        state.route.currentRun.arrayByReplacing(index: curSplitIndex, with: updatedCurSplit)))

      // Update that the run is now in progress
      state = state.runInProgress(true)

      startUpdateTimer()
    } else if (state.runInProgress) {
      // Update current split's end timestamp to the event timestamp,
      let curSplitIndex = state.route.currentSplit
      let updatedCurSplit = state.route.currentRun[curSplitIndex]
        .endTimestamp(timestamp)
      state = state.route(state.route.currentRun(
        state.route.currentRun.arrayByReplacing(index: curSplitIndex, with: updatedCurSplit)))

      // TODO: check if this is our best split time, save best split time

      if (curSplitIndex == state.route.splits.count - 1) {
        // TODO: update route pb if necessary

        // Run is now no longer in progress
        state = state.runInProgress(false)
        stopUpdateTimer()
      } else {
        // Update nest split's start timestamp to the event timestamp
        let updatedNextSplit = state.route.currentRun[1 + curSplitIndex]
          .startTimestamp(timestamp)
          .globalStartTimestamp(state.route.currentRun[0].startTimestamp!)
          .endTimestamp(ProcessInfo.processInfo.systemUptime)
        state = state.route(state.route.currentRun(
          state.route.currentRun.arrayByReplacing(index: 1 + curSplitIndex, with: updatedNextSplit)))
        state = state.route(state.route.currentSplit(1 + curSplitIndex))
      }
    }
  }

  /**
   * Starts the update timer which will update the model each time it fires
   */
  private func startUpdateTimer() {
    stopUpdateTimer()
    _timer = Timer.scheduledTimer(withTimeInterval: (1 / 30.0), repeats: true, block: handleTimerUpdate)
  }

  /**
   * Stops the update timer. No-op if timer is nil
   */
  private func stopUpdateTimer() {
    if let timer = _timer {
      timer.invalidate()
      _timer = nil
    }
  }

  /**
   * Grabs the current time to update the current split
   */
  private func handleTimerUpdate(timer: Timer) {
    let currentSplit = state.route.currentSplit
    state = state.route(state.route.currentRun(
      state.route.currentRun.arrayByReplacing(index: currentSplit, with: state.route.currentRun[currentSplit]
        .endTimestamp(ProcessInfo.processInfo.systemUptime))))
  }
}
