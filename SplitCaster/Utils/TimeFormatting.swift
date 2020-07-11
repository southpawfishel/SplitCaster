//
//  TimeFormatting.swift
//  SplitCaster
//
//  Created by Dave Fishel on 7/4/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import Foundation

/// Utilities for taking a numerical duration and converting to a string representation of that elapsed time
struct TimeFormatting {
  static let kSecondsInMinute: Double = 60.0
  static let kSecondsInHour: Double = 60.0 * kSecondsInMinute

  ///
  /// Formats a duration expressed as elapsed seconds string as HH:MM:SS.MS
  ///
  /// If the duration is less than an hour, hours will be omitted from the output
  /// If the duration is less than a minute, minutes will be omitted from the output
  /// The most significant unit (hours, minutes, seconds) will not contain zero padding to two digits
  /// Returns "-" if a nil duration is passed in
  ///
  static func formatDurationHMSMS(seconds: Double?) -> String {
    guard let totalSeconds: Double = seconds else {
      return "-"
    }

    let hours: Int = Int(totalSeconds / kSecondsInHour)
    let minutes: Int = Int((totalSeconds - (Double(hours) * kSecondsInHour)) / kSecondsInMinute)
    let seconds: Int = Int(
      totalSeconds - (Double(hours) * kSecondsInHour) - (Double(minutes) * kSecondsInMinute))
    let fraction: Double =
      totalSeconds - (Double(hours) * kSecondsInHour) - (Double(minutes) * kSecondsInMinute)
      - Double(seconds)

    return [
      hours > 0 ? String(format: "%d:", hours) : "",
      minutes > 0 ? String(format: hours > 0 ? "%02d:" : "%d:", minutes) : "",
      String(format: hours > 0 || minutes > 0 ? "%02d." : "%d.", seconds),
      String(format: "%02.0f", fraction * 100),
    ].joined()
  }

  ///
  /// Formats a duration expressed as elapsed seconds string as HH:MM:SS
  ///
  /// If the duration is less than an hour, hours will be omitted from the output
  /// The most significant unit (hours, minutes, seconds) will not contain zero padding to two digits
  /// Returns "-" if a nil duration is passed in
  ///
  static func formatDurationHMS(seconds: Double?) -> String {
    guard let totalSeconds: Double = seconds else {
      return "-"
    }

    let hours: Int = Int(totalSeconds / kSecondsInHour)
    let minutes: Int = Int((totalSeconds - (Double(hours) * kSecondsInHour)) / kSecondsInMinute)
    let seconds: Int = Int(
      totalSeconds - (Double(hours) * kSecondsInHour) - (Double(minutes) * kSecondsInMinute))

    return [
      hours > 0 ? String(format: "%d:", hours) : "",
      minutes > 0 ? String(format: hours > 0 ? "%02d:" : "%d:", minutes) : "0:",
      String(format: "%02d", seconds),
    ].joined()
  }
}
