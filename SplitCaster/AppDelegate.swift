//
//  AppDelegate.swift
//  SplitCaster
//
//  Created by Dave Fishel on 6/22/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import Cocoa
import Foundation
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var window: NSWindow!

  private var _appStateController: AppStateController? = nil

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Create app data dir
    FileUtils.createDirInDocumentsIfMissing(dirName: "SplitCasterData")
    // Create initial app state
    _appStateController = AppStateController(filename: AppStateController.routeFilename)

    // Create the SwiftUI view that provides the window contents.
    let appView = AppView().environmentObject(_appStateController!)

    // Create the window and set the content view.
    window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 480, height: 640),
      styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
      backing: .buffered, defer: false)
    window.center()
    window.setFrameAutosaveName("SplitCaster")
    window.contentView = NSHostingView(rootView: appView)
    window.makeKeyAndOrderFront(nil)

    // Insert code here to initialize your application
    _appStateController!.registerForEvents()
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
    _appStateController!.unregisterForEvents()
  }

}

struct AppDelegate_Previews: PreviewProvider {
  static var previews: some View {
    let testState = AppStateController(filename: AppStateController.routeFilename)
    testState.handlePermissionsResult(hasPermissions: true)
    return AppView().environmentObject(testState)
  }
}
