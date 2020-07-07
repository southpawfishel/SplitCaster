//
//  FileUtils.swift
//  SplitCaster
//
//  Created by Dave Fishel on 7/5/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import Foundation

struct FileUtils {
  static func getDocumentsPath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
  }

  static func createDirInDocumentsIfMissing(dirName: String) {
    let fileManager = FileManager.default
    let path = (FileUtils.getDocumentsPath() as NSString).appendingPathComponent(dirName)
    if !fileManager.fileExists(atPath: path) {
      try! fileManager.createDirectory(
        atPath: path, withIntermediateDirectories: true, attributes: nil)
    }
  }
}
