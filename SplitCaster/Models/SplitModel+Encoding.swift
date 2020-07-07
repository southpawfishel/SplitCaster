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
    case bestTime
    case startTimestamp
    case endTimestamp
    case globalStartTimestamp
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decode(String.self, forKey: .name)
    iconFilename = try container.decodeIfPresent(String.self, forKey: .iconFilename)
    bestTime = try container.decodeIfPresent(Double.self, forKey: .bestTime)
    startTimestamp = try container.decodeIfPresent(Double.self, forKey: .startTimestamp)
    endTimestamp = try container.decodeIfPresent(Double.self, forKey: .endTimestamp)
    globalStartTimestamp = try container.decodeIfPresent(Double.self, forKey: .globalStartTimestamp)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encodeIfPresent(iconFilename, forKey: .iconFilename)
    try container.encodeIfPresent(bestTime, forKey: .bestTime)
    try container.encodeIfPresent(startTimestamp, forKey: .startTimestamp)
    try container.encodeIfPresent(endTimestamp, forKey: .endTimestamp)
    try container.encodeIfPresent(globalStartTimestamp, forKey: .globalStartTimestamp)
  }
}
