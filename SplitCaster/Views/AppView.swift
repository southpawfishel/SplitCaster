//
//  AppView.swift
//  SplitCaster
//
//  Created by Dave Fishel on 7/2/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import SwiftUI

struct AppView: View {
  @EnvironmentObject var stateOwner: AppStateController

  var body: some View {
    Group {
      /**
       * Just show permissions prompt if in permissions state
       */
      if stateOwner.state.state == .needsPermissions {
        permissionsScreen
      } else {
        splitsScreen
      }
    }
  }

  var permissionsScreen: some View {
    GeometryReader { g in
      HStack {
        Text("You must grant permissions to read global keyboard events in order to use this app. Please do so in the Accessibility Settings and re-launch the app")
          .frame(width: g.size.width * 0.5,
                 height: g.size.height)
      }
    }
  }

  var splitsScreen: some View {
    List(stateOwner.state.route.currentRun, id: \.name) { split in
      SplitRow(split: split)
    }
  }
}

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    let testState = AppStateController(filename: "route.json")
    return AppView().environmentObject(testState)
  }
}
