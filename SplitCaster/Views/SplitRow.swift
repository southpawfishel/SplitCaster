//
//  SplitRow.swift
//  SplitCaster
//
//  Created by Dave Fishel on 7/2/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import SwiftUI

struct SplitRow: View {
  var split: SplitModel

  var body: some View {
    HStack {
      if split.iconFilename != nil {
        Image(split.iconFilename!)
          .resizable()
          .frame(width: 50.0,
                 height: 50.0,
                 alignment: .leading)
          .offset(x: 10.0)
      }
      Text(split.name)
        .font(.title)
        .offset(x: 20.0)
        .frame(alignment: .leading)
      Spacer()
      Text(split.startTimestamp != nil ? String(split.startTimestamp!) : "-")
        .font(.title)
        .padding(20.0)
        .frame(alignment: .trailing)
      Text(split.elapsed != nil ? String(split.elapsed!) : "-")
        .font(.title)
        .padding(20.0)
        .frame(alignment: .trailing)
    }
      .frame(height: 60.0)
  }
}

struct SplitRow_Previews: PreviewProvider {
  static var previews: some View {
    SplitRow(split: SplitModel(name: "BOB (1)",
                               iconFilename: "bob6",
                               bestTime: 0,
                               startTimestamp: 0,
                               endTimestamp: 12.3,
                               currentTimestamp: 0))
  }
}
