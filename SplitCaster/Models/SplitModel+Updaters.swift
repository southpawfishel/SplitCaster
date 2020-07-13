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
      runStartTime: self.runStartTime,
      isGoldSplit: self.isGoldSplit,
      isAheadOfPb: self.isAheadOfPb)
  }

  public func withName(_ newName: String!) -> SplitModel {
    return SplitModel(
      name: newName,
      iconFilename: self.iconFilename,
      bestElapsedTime: self.bestElapsedTime,
      startTime: self.startTime,
      endTime: self.endTime,
      runStartTime: self.runStartTime,
      isGoldSplit: self.isGoldSplit,
      isAheadOfPb: self.isAheadOfPb)
  }

  public func withIconFilename(_ newFilename: String!) -> SplitModel {
    return SplitModel(
      name: self.name,
      iconFilename: newFilename,
      bestElapsedTime: self.bestElapsedTime,
      startTime: self.startTime,
      endTime: self.endTime,
      runStartTime: self.runStartTime,
      isGoldSplit: self.isGoldSplit,
      isAheadOfPb: self.isAheadOfPb)
  }

  public func withBestTime(_ newBestTime: Double) -> SplitModel {
    return SplitModel(
      name: self.name,
      iconFilename: self.iconFilename,
      bestElapsedTime: newBestTime,
      startTime: self.startTime,
      endTime: self.endTime,
      runStartTime: self.runStartTime,
      isGoldSplit: self.isGoldSplit,
      isAheadOfPb: self.isAheadOfPb)
  }

  public func withStartTime(_ newStart: Double) -> SplitModel {
    return SplitModel(
      name: self.name,
      iconFilename: self.iconFilename,
      bestElapsedTime: self.bestElapsedTime,
      startTime: newStart,
      endTime: self.endTime,
      runStartTime: self.runStartTime,
      isGoldSplit: self.isGoldSplit,
      isAheadOfPb: self.isAheadOfPb)
  }

  public func withEndTime(_ newEnd: Double) -> SplitModel {
    return SplitModel(
      name: self.name,
      iconFilename: self.iconFilename,
      bestElapsedTime: self.bestElapsedTime,
      startTime: self.startTime,
      endTime: newEnd,
      runStartTime: self.runStartTime,
      isGoldSplit: self.isGoldSplit,
      isAheadOfPb: self.isAheadOfPb)
  }

  public func withRunStartTime(_ newTimestamp: Double) -> SplitModel {
    return SplitModel(
      name: self.name,
      iconFilename: self.iconFilename,
      bestElapsedTime: self.bestElapsedTime,
      startTime: self.startTime,
      endTime: self.endTime,
      runStartTime: newTimestamp,
      isGoldSplit: self.isGoldSplit,
      isAheadOfPb: self.isAheadOfPb)
  }

  public func withIsGold(_ isGold: Bool) -> SplitModel {
    return SplitModel(
      name: self.name,
      iconFilename: self.iconFilename,
      bestElapsedTime: self.bestElapsedTime,
      startTime: self.startTime,
      endTime: self.endTime,
      runStartTime: self.runStartTime,
      isGoldSplit: isGold,
      isAheadOfPb: self.isAheadOfPb)
  }

  public func withIsAheadOfPb(_ isAheadOfPb: Bool) -> SplitModel {
    return SplitModel(
      name: self.name,
      iconFilename: self.iconFilename,
      bestElapsedTime: self.bestElapsedTime,
      startTime: self.startTime,
      endTime: self.endTime,
      runStartTime: self.runStartTime,
      isGoldSplit: self.isGoldSplit,
      isAheadOfPb: isAheadOfPb)
  }
}
