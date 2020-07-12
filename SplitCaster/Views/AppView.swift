//
//  AppView.swift
//  SplitCaster
//
//  Created by Dave Fishel on 7/2/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import SwiftUI

struct AppView: View {
  @EnvironmentObject var stateStore: AppStateController

  var body: some View {
    Group {
      if stateStore.state.hasPermissions {
        SplitsScreen
      } else {
        PermissionsScreen
      }
    }
  }

  var SplitsScreen: some View {
    let indexed = stateStore.state.route.currentRun.enumerated().map({ $0 })
    return VStack {
      SplitsHeader
      List(indexed, id: \.element.name) { i, split in
        SplitRow(split: split, index: i)
      }
      SplitsFooter
    }
  }

  var SplitsHeader: some View {
    VStack {
      Text(stateStore.state.route.gameName)
        .font(
          .system(
            size: 22.0,
            weight: .regular,
            design: .default))
      ZStack {
        HStack {
          Text(stateStore.state.route.name)
            .frame(alignment: .center)
            .font(
              .system(
                size: 20.0,
                weight: .regular,
                design: .default))
        }
        HStack {
          Spacer()
          Text(String(stateStore.state.route.attemptCount))
            .font(
              .system(
                size: 20.0,
                weight: .regular,
                design: .default)
            )
            .frame(alignment: .trailing)
            .padding(.trailing, 10.0)
        }
      }
    }
    .padding(.top, 4.0)
  }

  var SplitsFooter: some View {
    VStack {
      HStack {
        Spacer()
        Text(
          TimeFormatting.formatDurationHMSMS(
            seconds: RouteModel.totalTimeOfRun(stateStore.state.route.currentRun))
        )
        .font(
          .system(
            size: 32.0,
            weight: .regular,
            design: .monospaced)
        )
        .frame(alignment: .trailing)
        .padding(.trailing, 10.0)
      }
    }
    .padding(.bottom, 4.0)
  }

  var PermissionsScreen: some View {
    GeometryReader { g in
      HStack {
        Text(
          "You must grant permissions to read global keyboard events in order to use this app. Please do so in the Accessibility Settings and re-launch the app"
        )
        .frame(
          width: g.size.width * 0.5,
          height: g.size.height)
      }
    }
  }
}

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    let testState = AppStateController(filename: AppStateController.routeFilename)
    testState.handlePermissionsResult(hasPermissions: true)
    return AppView().environmentObject(testState)
  }
}
