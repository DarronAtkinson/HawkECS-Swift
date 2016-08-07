//
//  Array + Extensions.swift
//  HawkEngine
//
//  Created by Jade Turnbull on 07/08/2016.
//  Copyright © 2016 Darron Atkinson. All rights reserved.
//

import Foundation

extension Array {
  
  mutating func filter(predicate: Element -> Bool, runBlock: Element -> ()) -> [Element] {
    return  self.filter({

      if predicate($0) {
        runBlock($0)
        return true
      } else {
        return false
      }
    })
  }
  
}