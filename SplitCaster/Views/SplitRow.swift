//
//  SplitRow.swift
//  SplitCaster
//
//  Created by Dave Fishel on 7/2/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import SwiftUI

struct SplitRow: View {
  static let height: CGFloat = 44.0

  var split: SplitModel

  var body: some View {
    HStack {
      if split.iconFilename != nil {
        Image(split.iconFilename!)
          .resizable()
          .frame(
            width: 50.0,
            height: 50.0,
            alignment: .leading
          )
          .offset(x: 10.0)
      }
      Text(split.name)
        .font(
          .system(
            size: 20.0,
            weight: .regular,
            design: .default)
        )
        .offset(x: 10.0)
        .frame(alignment: .leading)
      Spacer()
      Text(TimeFormatting.formatDurationHMS(seconds: split.elapsed))
        .font(
          .system(
            size: 16.0,
            weight: .regular,
            design: .monospaced)
        )
        .frame(width: 90, alignment: .trailing)
      Text(TimeFormatting.formatDurationHMS(seconds: split.globalElapsed))
        .font(
          .system(
            size: 16.0,
            weight: .regular,
            design: .monospaced)
        )
        .padding(10.0)
        .frame(width: 90, alignment: .trailing)
    }.frame(height: SplitRow.height)
  }
}

struct SplitRow_Previews: PreviewProvider {
  static var previews: some View {
    SplitRow(
      split: SplitModel(
        name: "BOB (1)",
        iconFilename: "bob6",
        bestTime: 0,
        startTimestamp: 1000.0,
        endTimestamp: 4801.3,
        globalStartTimestamp: 0))
  }
}
