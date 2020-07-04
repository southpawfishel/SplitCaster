//
//  AppState+Updaters.swift
//  SplitCaster
//
//  Created by Dave Fishel on 7/1/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import Foundation

extension AppState {
  public func state(_ newState: State) -> AppState {
    return AppState(state: newState, route: self.route)
  }

  public func route(_ newRoute: RouteModel!) -> AppState {
    return AppState(state: self.state, route: newRoute)
  }
}
