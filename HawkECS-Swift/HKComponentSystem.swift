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
 ## HKComponentSystem
 
 Allows any struct or class to be used as a component system
 
 ### Conforms to
    - HKType
    - HKUpdatable
 
 ### Properties
    - `var engine: HKEngine! { get set }`
 
 ### Functions
  - `mutating func didMoveTo(engine: HKEngine)`
  - `mutating func willMoveFrom(engine: HKEngine)`
 
 Provides default implementations of the following functions:
  - `func filter<T: HKComponent>(component: T.Type) -> [(Int, T)]`
  - `func update(component: HKComponent, forEntity id: Int)`
  - `func update(components: [HKComponent], forEntity id: Int)`
 */
protocol HKComponentSystem: HKType, HKUpdatable {
  /**
   A pointer the the engine that holds the component system
   */
  var engine: HKEngine! { get set }
  
  /**
   Called when a system is added to an engine
   
   - Parameter engine: The HKEngine instance that holds the system
   */
  mutating func didMoveTo(engine: HKEngine)
  
  /**
   Called when a system is removed from an engine
   
   - Parameter engine: The HKEngine instance that holds the system
   */
  mutating func willMoveFrom(engine: HKEngine)
}

extension HKComponentSystem {
  
  /**
  Filters all entities in the engine with the component type given
   
  - Parameter component: The HKComponent to filter
   
  - Returns: An array of `(Int, HKComponent)`
   
   #### Example
   
        for (entityID, position) in filter(PositionComponent.self) {
          // Update position
        }
   
  */
  func filter<T: HKComponent>(component: T.Type) -> [(Int, T)] {
    return engine.components.all(component)
  }
  
  /**
   Updates a component in the engine. 
   
   - Important: Only use when a component is a value type
   
   - Parameters:
      - component: The HKComponent to update
      - forEntity: The entity id to update
   
   #### Example
   
        let updatedComponent = update(component)
        update(updatedComponent, forEntity: entity)
   */
  func update(component: HKComponent, forEntity id: Int) {
    engine.components.insert(component, forEntity: id)
  }
  
  /**
   Updates a group of components in the engine.
   
   - Important: Only use when the components are value types
   
   - Parameters:
      - components: An array HKComponent to update
      - forEntity: The entity id to update
   
   #### Example
   
        let pos = update(position)
        let vel = update(velocity)
        update([pos, vel], forEntity: entity)
   */
  func update(components: [HKComponent], forEntity id: Int) {
    engine.components.insert(components, forEntity: id)
  }
}
