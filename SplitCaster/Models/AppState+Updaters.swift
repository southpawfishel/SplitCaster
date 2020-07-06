//
//  AppState+Updaters.swift
//  SplitCaster
//
//  Created by Dave Fishel on 7/1/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import Foundation

extension AppState {
  public func hasPermissions(_ newHasPermissions: Bool) -> AppState {
    return AppState(
      hasPermissions: newHasPermissions,
      runInProgress: self.runInProgress,
      route: self.route)
  }

  public func runInProgress(_ newRunInProgress: Bool) -> AppState {
    return AppState(
      hasPermissions: self.hasPermissions,
      runInProgress: newRunInProgress,
      route: self.route)
  }

  public func route(_ newRoute: RouteModel!) -> AppState {
    return AppState(
      hasPermissions: self.hasPermissions,
      runInProgress: self.runInProgress,
      route: newRoute)
  }
}
