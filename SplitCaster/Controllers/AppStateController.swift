//
//  AppStateController.swift
//  SplitCaster
//
//  Created by Dave Fishel on 7/1/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import AppKit
import Foundation

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
        state = state.route(route.currentRun(route.splits)).state(.stopped)
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
  private func handlePermissionsResult(hasPermissions: Bool) -> Void {
    state = state.state((hasPermissions ? .stopped : .needsPermissions))
  }

  /**
   * Registers our controller for global key events
   */
  public func registerForEvents() -> Void {
    acquireGlobalKeyEventPermissions()
    if state.state != .needsPermissions {
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
    if (state.state == .stopped) {
      state = state.route(state.route
        .currentRun(state.route.splits)
        .currentSplit(0)
        .attemptCount(1 + state.route.attemptCount))
      let currentSplit = state.route.currentSplit
      state = state.route(state.route.currentRun(
        state.route.currentRun.arrayByReplacing(index: currentSplit, with: state.route.currentRun[currentSplit]
          .startTimestamp(timestamp)
          .endTimestamp(ProcessInfo.processInfo.systemUptime))))
      state = state.state(.running)

      startUpdateTimer()
    } else if (state.state == .running) {
      if (state.route.currentSplit == state.route.splits.count - 1) {
        // Handle last split
        // TODO: update final split time
        // TODO: update pb if necessary
        state = state.state(.stopped)
      } else {
        // Handle all other splits
        // TODO: update current and next split times
        // TODO: check if this is our best split time, save best split time
        // TODO: move on to next split
      }
    }
  }

  /**
   * Starts the update timer which will update the model each time it fires
   */
  private func startUpdateTimer() {
    stopUpdateTimer()
    _timer = Timer.scheduledTimer(withTimeInterval: (1 / 60.0), repeats: true, block: handleTimerUpdate)
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
