//
//  RouteModel.swift
//  SplitCaster
//
//  Created by Dave Fishel on 6/25/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import Foundation

public struct RouteModel: Codable, Equatable {
  ///
  /// Persistable properties
  ///

  /// The name of the route (e.g. "16 star")
  public let name: String
  /// The name of the game (e.g. "Mario 64")
  public let gameName: String
  /// The platform the game is being played on
  public let platform: String?
  /// How many times this run has been attempted (increments each reset / new run)
  public let attemptCount: Int
  /// The data for each individual split that comprises the run
  public let splits: [SplitModel]
  /// The splits for the fastest completion (personal best) of this route by this user
  public let bestRun: [SplitModel]?

  ///
  /// Ephemeral properties
  ///

  /// The index of the current split that is being actively timed
  public let currentSplit: Int
  ///
  /// The splits of the current run that's in progress.
  /// This is where we put the data about the specific split times for  this run as opposed to in "splits" above
  ///
  public let currentRun: [SplitModel]

  ///
  /// Computed  properties
  ///

  /// The amount of time that has elapsed since the start of the first split and the end of the current split
  public var elapsed: Double? {
    if let start = currentRun[0].startTimestamp, let end = currentRun[currentSplit].endTimestamp {
      return end - start
    } else {
      return nil
    }
  }
}
