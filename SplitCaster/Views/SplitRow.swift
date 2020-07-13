//
//  SplitRow.swift
//  SplitCaster
//
//  Created by Dave Fishel on 7/2/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import SwiftUI

struct SplitRow: View {
  static let height: CGFloat = 52.0
  static let imgHeight: CGFloat = SplitRow.height - 20.0

  let split: SplitModel
  let index: Int

  var body: some View {
    HStack {
      if split.iconFilename != nil {
        Image(split.iconFilename!)
          .resizable()
          .frame(
            width: SplitRow.imgHeight,
            height: SplitRow.imgHeight,
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
        .foregroundColor(colorForElapsedTime())
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
    }.frame(height: SplitRow.height).background(
      index % 2 == 0
        ? Color.init(red: 0.15, green: 0.15, blue: 0.15)
        : Color.init(red: 0.2, green: 0.2, blue: 0.2)
    ).padding(.init(top: -10, leading: -10, bottom: -10, trailing: -10))
  }

  func colorForElapsedTime() -> Color {
    if split.elapsed != nil {
      if split.isGoldSplit {
        return AppView.gold
      } else if split.isAheadOfPb {
        return AppView.green
      } else {
        return AppView.red
      }
    } else {
      return Color.white
    }
  }
}

struct SplitRow_Previews: PreviewProvider {
  static var previews: some View {
    SplitRow(
      split: SplitModel(
        name: "BOB (1)",
        iconFilename: "bob6",
        bestElapsedTime: 0,
        startTime: 1000.0,
        endTime: 4801.3,
        runStartTime: 0,
        isGoldSplit: false,
        isAheadOfPb: true),
      index: 0)
  }
}
