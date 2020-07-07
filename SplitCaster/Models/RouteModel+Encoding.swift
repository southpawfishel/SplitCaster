//
//  RouteModel+Encoding.swift
//  SplitCaster
//
//  Created by Dave Fishel on 7/6/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import Foundation

extension RouteModel {
  private enum CodingKeys: String, CodingKey {
    case name
    case gameName
    case platform
    case attemptCount
    case splits
    case bestRun
    case currentSplit
    case currentRun
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decode(String.self, forKey: .name)
    gameName = try container.decode(String.self, forKey: .gameName)
    platform = try container.decodeIfPresent(String.self, forKey: .platform)
    attemptCount = try container.decode(Int.self, forKey: .attemptCount)
    splits = try container.decode([SplitModel].self, forKey: .splits)
    bestRun = try container.decodeIfPresent([SplitModel].self, forKey: .bestRun)
    currentSplit = 0
    currentRun = splits
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(gameName, forKey: .gameName)
    try container.encodeIfPresent(platform, forKey: .platform)
    try container.encode(attemptCount, forKey: .attemptCount)
    try container.encode(splits, forKey: .splits)
    try container.encodeIfPresent(bestRun, forKey: .bestRun)
  }
}
