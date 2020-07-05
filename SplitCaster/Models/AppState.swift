//
//  AppState.swift
//  SplitCaster
//
//  Created by Dave Fishel on 6/30/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import Foundation

public struct AppState: Equatable {
  /** Whether or not the app has global key event permissions */
  public let hasPermissions: Bool
  /** Whether or not there is a run in progress */
  public let runInProgress: Bool
  /** Data for the current route */
  public let route: RouteModel

  public init() {
    hasPermissions = false
    runInProgress = false
    route = RouteModel(name: "",
                       gameName: "",
                       platform: nil,
                       attemptCount: 0,
                       splits: [],
                       bestRun: nil,
                       currentSplit: 0,
                       currentRun: [])
  }

  public init(hasPermissions: Bool, runInProgress: Bool, route: RouteModel) {
    self.hasPermissions = hasPermissions
    self.runInProgress = runInProgress
    self.route = route
  }
}
