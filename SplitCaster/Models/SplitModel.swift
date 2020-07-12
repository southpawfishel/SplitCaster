//
//  SplitModel.swift
//  SplitCaster
//
//  Created by Dave Fishel on 6/25/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import Foundation

/// A model representing an individual split of a route
///
/// This is the abstract data for a split, the specific data for a split
/// during a run, with specific start/end times, and also an owner
/// for the best possible time ever for a split, which is not necessarily
/// the same as the time for this split in the overall fastest run.
public struct SplitModel: Codable, Equatable {
  ///
  /// Persistable  properties
  ///

  /// The name of this split
  public let name: String
  /// The name of the icon file to use for this split
  public let iconFilename: String?
  /// The best time ever recorded for this particular split
  public let bestElapsedTime: Double?

  ///
  /// Ephemeral  properties
  ///

  /// The time at which this split started
  public let startTime: Double?
  /// The time at which this split ended
  public let endTime: Double?
  /// The time at which the run started (same as the first split time)
  public let runStartTime: Double?

  ///
  /// Computed  properties
  ///

  ///
  /// The amount of time that has elapsed between the start and end of this split
  /// If the split is still in progress, end timestamp will be updated every time our update timer fires
  ///
  public var elapsed: Double? {
    if let start = startTime, let end = endTime {
      return end - start
    } else {
      return nil
    }
  }

  ///
  /// The amount of time that has elapsed between the start of the run and the end of this split
  /// If the split is still in progress, end timestamp will be updated every time our update timer fires 
  ///
  public var globalElapsed: Double? {
    if let start = runStartTime, let end = endTime {
      return end - start
    } else {
      return nil
    }
  }
}
