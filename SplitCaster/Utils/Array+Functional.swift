//
//  Array+Functional.swift
//  SplitCaster
//
//  Created by Dave Fishel on 7/3/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import Foundation

extension Array {
  ///
  /// An method for replacing an element in an array when using immutable arrays
  ///
  /// Will return a copy of the original array with the element at "index" replaced by "with", or just a copy of the original
  /// if the index passed in is outside the bounds of the array
  ///
  func arrayByReplacing(index toReplace: Int, with newElement: Element) -> [Element] {
    self.enumerated().map { (i, existingElement) in
      i == toReplace ? newElement : existingElement
    }
  }
}
