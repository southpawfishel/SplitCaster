//
//  SplitModel+Encoding.swift
//  SplitCaster
//
//  Created by Dave Fishel on 7/6/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import Foundation

extension SplitModel {
  private enum CodingKeys: String, CodingKey {
    case name
    case iconFilename
    case bestElapsedTime
    case startTime
    case endTime
    case runStartTime
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decode(String.self, forKey: .name)
    iconFilename = try container.decodeIfPresent(String.self, forKey: .iconFilename)
    bestElapsedTime = try container.decodeIfPresent(Double.self, forKey: .bestElapsedTime)
    startTime = try container.decodeIfPresent(Double.self, forKey: .startTime)
    endTime = try container.decodeIfPresent(Double.self, forKey: .endTime)
    runStartTime = try container.decodeIfPresent(Double.self, forKey: .runStartTime)
    isGoldSplit = false
    isAheadOfPb = false
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encodeIfPresent(iconFilename, forKey: .iconFilename)
    try container.encodeIfPresent(bestElapsedTime, forKey: .bestElapsedTime)
    try container.encodeIfPresent(startTime, forKey: .startTime)
    try container.encodeIfPresent(endTime, forKey: .endTime)
    try container.encodeIfPresent(runStartTime, forKey: .runStartTime)
  }
}
