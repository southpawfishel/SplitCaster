//
//  RouteModel.swift
//  SplitCaster
//
//  Created by Dave Fishel on 6/25/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import Foundation

/// The model that represents a route
///
/// A route is mostly the splits that it's comprised of, and this owns the
/// data for a specific run, as well as the abstract split data for all runs.
/// Also owns the data about the best run ever for this route.
public struct RouteModel: Codable, Equatable {

  // MARK: Persistable properties

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

  // MARK: Ephemeral properties

  /// The index of the current split that is being actively timed
  public let currentSplit: Int
  ///
  /// The splits of the current run that's in progress.
  /// This is where we put the data about the specific split times for  this run as opposed to in "splits" above
  ///
  public let currentRun: [SplitModel]

  // MARK: Helper Functions

  /// The amount of time that has elapsed since the start of the first split and the end of the last split with an end timestamp
  /// For a completed run, this will give the total run time, or for an in progress run, this gives the elapsed time of the run as of the current split
  public static func totalTimeOfRun(_ run: [SplitModel]) -> Double? {
    let lastSplit = run.last { $0.endTime != nil }
    return RouteModel.totalTimeOfRun(run, lastSplit)
  }

  /// The amount of time that has elapsed since the start of the first split and the end of the run at the provided index
  /// Useful for getting the time of our best run up to a certain split
  public static func totalTimeOfRun(_ run: [SplitModel], _ upToIndex: Int) -> Double? {
    return RouteModel.totalTimeOfRun(run, run[upToIndex])
  }

  /// The amount of time that  has elapsed between the start of a run and the given split
  private static func totalTimeOfRun(_ run: [SplitModel], _ lastSplit: SplitModel?) -> Double? {
    if let start = run[0].startTime, let end = lastSplit?.endTime {
      return end - start
    } else {
      return nil
    }
  }
}
