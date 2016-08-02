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
 * A meta entity struct
 */
struct HKEntity {
  
  /**
   * Optional name property, can be used to group entities
   */
  var name: String? = nil {
    // Assigns the name to the entity ID in the engine class
    didSet {
      engine.set(name, forEntity: ID)
    }
  }
  
  /**
   * A unique property, used to identify an entity in the engine
   */
  let ID: Int
  
  /**
   * An unowned pointer to the engine
   */
  unowned private let engine: HKEngine
  
  /**
   * Initialize the entity with a name and ID
   */
  init(name: String, ID: Int, engine: HKEngine) {
    self.ID = ID
    self.name = name
    self.engine = engine
  }
  
  /**
   * Initialize the entity with an ID
   */
  init(ID: Int, engine: HKEngine) {
    self.ID = ID
    self.engine = engine
  }
  
  /**
   * Initialize the entity by letting the engine create the entity
   */
  init(engine: HKEngine) {
    self = engine.addEntity()
  }
}


extension HKEntity {
  
  /**
   * Adds a HKComponent to the entity
   */
  func addComponent(component: HKComponent) {
    engine.components.insert(component, forEntity: ID)
  }
  
  /**
   * Returns an optional HKComponent for the entity
   */
  func getComponent<T: HKComponent>() -> T? {
    return engine.components.get(forEntity: ID)
  }
  
  /**
   * Removes the given component from the entity
   */
  func removeComponent(component: HKComponent.Type) {
    engine.components.remove(component.type, forEntity: ID)
  }
  
  /**
   * Removes a RenderComponent from it's parent and then removes
   * the entity from the engine
   */
  func destroy() {
    if let render: RenderComponent = getComponent() {
      render.removeFromParent()
    }
    engine.remove(self)
  }
}