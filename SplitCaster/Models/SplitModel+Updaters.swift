//
//  SplitModel+Updaters.swift
//  SplitCaster
//
//  Created by Dave Fishel on 6/30/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import Foundation

extension SplitModel {
  public func copy() -> SplitModel {
    return SplitModel(
      name: self.name,
      iconFilename: self.iconFilename,
      bestElapsedTime: self.bestElapsedTime,
      startTime: self.startTime,
      endTime: self.endTime,
      runStartTime: self.runStartTime)
  }

  public func withName(_ newName: String!) -> SplitModel {
    return SplitModel(
      name: newName,
      iconFilename: self.iconFilename,
      bestElapsedTime: self.bestElapsedTime,
      startTime: self.startTime,
      endTime: self.endTime,
      runStartTime: self.runStartTime)
  }

  public func withIconFilename(_ newFilename: String!) -> SplitModel {
    return SplitModel(
      name: self.name,
      iconFilename: newFilename,
      bestElapsedTime: self.bestElapsedTime,
      startTime: self.startTime,
      endTime: self.endTime,
      runStartTime: self.runStartTime)
  }

  public func withBestTime(_ newBestTime: Double) -> SplitModel {
    return SplitModel(
      name: self.name,
      iconFilename: self.iconFilename,
      bestElapsedTime: newBestTime,
      startTime: self.startTime,
      endTime: self.endTime,
      runStartTime: self.runStartTime)
  }

  public func withStartTime(_ newStart: Double) -> SplitModel {
    return SplitModel(
      name: self.name,
      iconFilename: self.iconFilename,
      bestElapsedTime: self.bestElapsedTime,
      startTime: newStart,
      endTime: self.endTime,
      runStartTime: self.runStartTime)
  }

  public func withEndTime(_ newEnd: Double) -> SplitModel {
    return SplitModel(
      name: self.name,
      iconFilename: self.iconFilename,
      bestElapsedTime: self.bestElapsedTime,
      startTime: self.startTime,
      endTime: newEnd,
      runStartTime: self.runStartTime)
  }

  public func withRunStartTime(_ newTimestamp: Double) -> SplitModel {
    return SplitModel(
      name: self.name,
      iconFilename: self.iconFilename,
      bestElapsedTime: self.bestElapsedTime,
      startTime: self.startTime,
      endTime: self.endTime,
      runStartTime: newTimestamp)
  }
}
