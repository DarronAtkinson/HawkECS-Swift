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
 * Allows any struct or class to be used as a comopnent system in a HKEngine
 */
protocol HKComponentSystem: HKType, HKUpdatable {
  /**
   * A pointer the the engine that holds the component system
   */
  var engine: HKEngine! { get set }
  
  //func didMoveToEngine()
  //func willMoveFromEngine()
}

extension HKComponentSystem {
  
  /**
   * Filters all entities in the engine with the component type given
   */
  func filter<T: HKComponent>(component: T.Type) -> [(Int, T)] {
    return engine.components.all(component)
  }
  
  /**
   * Updates a component in the engine. Used when a component is a struct
   */
  func update(component: HKComponent, forEntity id: Int) {
    engine.components.insert(component, forEntity: id)
  }
  
  /**
   * Updates components in the engine. Used when the components are structs
   */
  func update(components: [HKComponent], forEntity id: Int) {
    engine.components.insert(components, forEntity: id)
  }
}
