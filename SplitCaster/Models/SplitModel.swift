//
//  SplitModel.swift
//  SplitCaster
//
//  Created by Dave Fishel on 6/25/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import Foundation

public struct SplitModel: Codable, Equatable {
  // Persistable properties
  public let name: String!
  public let iconFilename: String?
  public let bestTime: Double?

  // Ephemeral properties
  public let startTimestamp: Double?
  public let endTimestamp: Double?
  public let currentTimestamp: Double?

  // Computed properties
  public var elapsed: Double? {
    if let start = startTimestamp, let end = endTimestamp {
      return end - start
    } else {
      return nil
    }
  }
}
