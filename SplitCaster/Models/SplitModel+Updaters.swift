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
    return SplitModel(name: self.name,
                      iconFilename: self.iconFilename,
                      bestTime: self.bestTime,
                      startTimestamp: self.startTimestamp,
                      endTimestamp: self.endTimestamp,
                      currentTimestamp: self.currentTimestamp)
  }

  public func name(_ newName: String!) -> SplitModel {
    return SplitModel(name: newName,
                      iconFilename: self.iconFilename,
                      bestTime: self.bestTime,
                      startTimestamp: self.startTimestamp,
                      endTimestamp: self.endTimestamp,
                      currentTimestamp: self.currentTimestamp)
  }

  public func iconFilename(_ newFilename: String!) -> SplitModel {
    return SplitModel(name: self.name,
                      iconFilename: newFilename,
                      bestTime: self.bestTime,
                      startTimestamp: self.startTimestamp,
                      endTimestamp: self.endTimestamp,
                      currentTimestamp: self.currentTimestamp)
  }

  public func bestTime(_ newBestTime: Double) -> SplitModel {
    return SplitModel(name: self.name,
                      iconFilename: self.iconFilename,
                      bestTime: newBestTime,
                      startTimestamp: self.startTimestamp,
                      endTimestamp: self.endTimestamp,
                      currentTimestamp: self.currentTimestamp)
  }

  public func startTimestamp(_ newStart: Double) -> SplitModel {
    return SplitModel(name: self.name,
                      iconFilename: self.iconFilename,
                      bestTime: self.bestTime,
                      startTimestamp: newStart,
                      endTimestamp: self.endTimestamp,
                      currentTimestamp: self.currentTimestamp)
  }

  public func endTimestamp(_ newEnd: Double) -> SplitModel {
    return SplitModel(name: self.name,
                      iconFilename: self.iconFilename,
                      bestTime: self.bestTime,
                      startTimestamp: self.startTimestamp,
                      endTimestamp: newEnd,
                      currentTimestamp: self.currentTimestamp)
  }

  public func currentTimestamp(_ newTimestamp: Double) -> SplitModel {
    return SplitModel(name: self.name,
                      iconFilename: self.iconFilename,
                      bestTime: self.bestTime,
                      startTimestamp: self.startTimestamp,
                      endTimestamp: self.endTimestamp,
                      currentTimestamp: newTimestamp)
  }
}
