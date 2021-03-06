//  Created by Darron Atkinson on 28/07/2016.
//  Copyright © 2016 Darron Atkinson
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this
//  software and associated documentation files (the "Software"), to deal in the Software
//  without restriction, including without limitation the rights to use, copy, modify, merge,
//  publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
//  to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//  substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
//  PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
//  FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.

import Foundation

/**
 ## HKComponent
 
 A protocol that all components must conform to
 
 ### Conforms to
 - HKType
 - HKUpdatable
 
 Can be used to convert any struct, enum or class into a component that can be used with a HKEngine
 
 #### Example
      extension CGPoint: HKComponent
      public typealias PositionComponent = CGPoint
 
      extension SKNode: HKComponent
      public typealias RenderComponent = SKNode
 */
protocol HKComponent: HKType, HKUpdatable {

}


/**
 Provides a defulat blank implementation of HKUpdatable
 */
extension HKComponent {
  
  func updateWithDeltaTime(seconds: NSTimeInterval) {
  
  }
  
}
