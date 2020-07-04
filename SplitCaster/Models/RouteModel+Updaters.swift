//
//  RouteModel+Updaters.swift
//  SplitCaster
//
//  Created by Dave Fishel on 6/30/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import Foundation

/**
 * Functional style update methods for routes. Intended to be used instead of setters, these methods all return a new object with the value set on it.
 * So if you have a route  and you want to increment the attempt count on it, you'd call
 * let updated: RouteModel = route.attemptCount(route.attemptCount + 1)
 */
extension RouteModel {
  public func copy() -> RouteModel {
    return RouteModel(name: self.name,
                      gameName: self.gameName,
                      platform: self.platform,
                      attemptCount: self.attemptCount,
                      splits: self.splits,
                      bestRun: self.bestRun,
                      currentSplit: self.currentSplit,
                      currentRun: self.currentRun)
  }

  public func name(_ newName: String!) -> RouteModel {
    return RouteModel(name: newName,
                      gameName: self.gameName,
                      platform: self.platform,
                      attemptCount: self.attemptCount,
                      splits: self.splits,
                      bestRun: self.bestRun,
                      currentSplit: self.currentSplit,
                      currentRun: self.currentRun)
  }

  public func gameName(_ newGameName: String!) -> RouteModel {
    return RouteModel(name: self.name,
                      gameName: newGameName,
                      platform: self.platform,
                      attemptCount: self.attemptCount,
                      splits: self.splits,
                      bestRun: self.bestRun,
                      currentSplit: self.currentSplit,
                      currentRun: self.currentRun)
  }

  public func platform(_ newPlatform: String!) -> RouteModel {
    return RouteModel(name: self.name,
                      gameName: self.gameName,
                      platform: newPlatform,
                      attemptCount: self.attemptCount,
                      splits: self.splits,
                      bestRun: self.bestRun,
                      currentSplit: self.currentSplit,
                      currentRun: self.currentRun)
  }

  public func attemptCount(_ newAttemptCount: Int) -> RouteModel {
    return RouteModel(name: self.name,
                      gameName: self.gameName,
                      platform: self.platform,
                      attemptCount: newAttemptCount,
                      splits: self.splits,
                      bestRun: self.bestRun,
                      currentSplit: self.currentSplit,
                      currentRun: self.currentRun)
  }

  public func splits(_ newSplits: [SplitModel]!) -> RouteModel {
    return RouteModel(name: self.name,
                      gameName: self.gameName,
                      platform: self.platform,
                      attemptCount: self.attemptCount,
                      splits: newSplits,
                      bestRun: self.bestRun,
                      currentSplit: self.currentSplit,
                      currentRun: self.currentRun)
  }

  public func bestRun(_ newBestRun: [SplitModel]!) -> RouteModel {
    return RouteModel(name: self.name,
                      gameName: self.gameName,
                      platform: self.platform,
                      attemptCount: self.attemptCount,
                      splits: self.splits,
                      bestRun: newBestRun,
                      currentSplit: self.currentSplit,
                      currentRun: self.currentRun)
  }

  public func currentSplit(_ newCurrentSplit: Int) -> RouteModel {
    return RouteModel(name: self.name,
                      gameName: self.gameName,
                      platform: self.platform,
                      attemptCount: self.attemptCount,
                      splits: self.splits,
                      bestRun: self.bestRun,
                      currentSplit: newCurrentSplit,
                      currentRun: self.currentRun)
  }

  public func currentRun(_ newCurrentRun: [SplitModel]!) -> RouteModel {
    return RouteModel(name: self.name,
                      gameName: self.gameName,
                      platform: self.platform,
                      attemptCount: self.attemptCount,
                      splits: self.splits,
                      bestRun: self.bestRun,
                      currentSplit: self.currentSplit,
                      currentRun: newCurrentRun)
  }
}
