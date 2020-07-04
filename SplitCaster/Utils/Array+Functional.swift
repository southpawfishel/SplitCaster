//
//  Array+Functional.swift
//  SplitCaster
//
//  Created by Dave Fishel on 7/3/20.
//  Copyright © 2020 Dave Fishel. All rights reserved.
//

import Foundation

extension Array {
  func arrayByReplacing(index toReplace: Int, with newElement: Element) -> [Element] {
    self.enumerated().map { (i, existingElement) in
      i == toReplace ? newElement : existingElement
    }
  }
}
