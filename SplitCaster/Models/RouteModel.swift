//
//  RouteModel.swift
//  SplitCaster
//
//  Created by Dave Fishel on 6/25/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import Foundation

public struct RouteModel: Codable, Equatable {
  // Persistable properties
  public let name: String
  public let gameName: String
  public let platform: String?
  public let attemptCount: Int
  public let splits: [SplitModel]
  public let bestRun: [SplitModel]?

  // Ephemeral properties
  public let currentSplit: Int
  public let currentRun: [SplitModel]
}
