//
//  AppState.swift
//  SplitCaster
//
//  Created by Dave Fishel on 6/30/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import Foundation

public struct AppState: Equatable {
  public enum State {
    case needsPermissions
    case stopped
    case running
  }

  public let state: State
  public let route: RouteModel

  public init() {
    state = .needsPermissions
    route = RouteModel(name: "",
                       gameName: "",
                       platform: nil,
                       attemptCount: 0,
                       splits: [],
                       bestRun: nil,
                       currentSplit: 0,
                       currentRun: [])
  }

  public init(state: State, route: RouteModel!) {
    self.state = state
    self.route = route
  }
}
