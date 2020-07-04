//
//  TimeFormatting.swift
//  SplitCaster
//
//  Created by Dave Fishel on 7/4/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import Foundation

struct TimeFormatting {
  static let kSecondsInMinute: Double = 60.0
  static let kSecondsInHour: Double = 60.0 * kSecondsInMinute

  static func formatDuration(seconds: Double?) -> String {
    guard let totalSeconds: Double = seconds else {
      return "-"
    }

    let hours: Int = Int(totalSeconds / kSecondsInHour)
    let minutes: Int = Int((totalSeconds - (Double(hours) * kSecondsInHour)) / kSecondsInMinute)
    let seconds: Int = Int(totalSeconds - (Double(hours) * kSecondsInHour) - (Double(minutes) * kSecondsInMinute))
    let fraction: Double = totalSeconds - (Double(hours) * kSecondsInHour) - (Double(minutes) * kSecondsInMinute) - Double(seconds)

    return [
      hours > 0 ? String(format: "%d:", hours) : "",
      minutes > 0 ? String(format: hours > 0 ? "%02d:" : "%d:", minutes) : "",
      seconds > 0 ? String(format: hours > 0 || minutes > 0 ? "%02d." : "%d.", seconds) : "0.",
      String(format: "%02.0f", fraction * 100),
    ].joined()
  }
}
