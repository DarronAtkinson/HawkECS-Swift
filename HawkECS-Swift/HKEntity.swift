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
 ## HKEntity
 
 A meta entity struct
 
 ### Conforms to
    - Hashable
    - CustomStringConvertible
    - CustomDebugStringConvertible
 
 ### Properties
 
 #### Private
    - `unowned let engine: HKEngine`
    - `let identifier: HKEntityIdentifier`
 
 #### Public
    - `var id: Int`
    - `var name: String`
    - `var group: String`
 */
struct HKEntity {
  
  /**
   Identification data for the entity
   */
  private let identifier: HKEntityIdentifier
  
  /**
   - Returns: The entity id
   */
  var id: Int { return identifier.id }
  
  /**
   - Returns: The entity name
   */
  var name: String { return identifier.name }
  
  /**
   - Returns: The entity group
   */
  var group: String { return identifier.group }
  
  /**
   Pointer to the engine that holds the entity
   */
  private unowned let engine: HKEngine
  
  /**
   Initialize the entity with an instance of HKEntityIdentifier
   
   - Parameters: 
      - identity: An instance of HKEntityIdentifier
      - engine: The engine that the entity belongs to
   */
  init(identity: HKEntityIdentifier, engine: HKEngine) {
    identifier = identity
    self.engine = engine
  }
  
  /**
   Initialize the entity without using an instance of HKEntityIdentifier
   
   - Parameters:
      - id: Unique `Int` representing the entity
      - name: Unique `String` representing the entity
      - group: A `String` used to group entities together
      - engine: The engine that the entity belongs to
   */
  init(id: Int, name: String, group: String, engine: HKEngine) {
    identifier = HKEntityIdentifier(id: id, name: name, group: group)
    self.engine = engine
  }
}

// MARK: Adjustments
extension HKEntity {
  
  /**
   Checks if the entity has the given component
   
   - Parameter component: The component type to check
   
   - Returns: `true` if the entity has the specified component
   
   #### Example
   
        entity.hasComponent(ExampleComponent.self)
   */
  func hasComponent<T: HKComponent>(component: T.Type) -> Bool {
    return engine.components.collection[T.type] != nil
  }
  
  /**
   Adds a component to the entity
   
   - Parameter component: The component to add
   
   #### Example
   
        entity.addComponent(ExampleComponent())
   */
  func addComponent(component: HKComponent) {
    engine.components.insert(component, forEntity: id)
  }
  
  /**
   Retieve a component belonging to the entity
   
   - Returns: The an optional HKComponent instance of the specified type
   
   #### Example
   
        if let component: ExampleComponent = entity.getComponent() {
            // Do something with component
        }
   */
  func getComponent<T: HKComponent>() -> T? {
    return engine.components.get(forEntity: id)
  }
  
  /**
   Remove a component from the entity
   
   - Parameter component: The component to remove
   
   #### Example
   
        entity.removeComponent(ExampleComponent.self)
   */
  func removeComponent(component: HKComponent.Type) {
    engine.components.remove(component.type, forEntity: id)
  }
  
  /**
   Adjust the properties of a component
   - Important: Only use with struct components
   
   - Parameters:
      - component: The component type to adjust
      - runBlock: Provides the component to be mutated
   
   #### Example
   
        entity.adjustComponent(PositionComponent.self) {
          $0.x += 10
          $0.y += 10
        }
   */
  func adjustComponent<T: HKComponent>(component: T.Type, runBlock: inout T -> ()) {
    guard let comp: T = getComponent() else { return }
    var c = comp
    runBlock(&c)
    addComponent(c)
  }

  /**
   Removes the entity from the engine
   
   `removeEntity(id: )` is called on the HKEngineDelegate with the engine before removing any components. This allows for any renderable components to be removed from the scene
   
   #### Example
   
        entity.destroy()
   */
  func destroy() {
    engine.removeEntity(id)
  }
}

// MARK: Grouping
extension HKEntity {
  
  /**
   Retrieve an array of entities belonging to the same group
   
   - Returns: An array of HKEntity belong to the same group
   
   #### Example
   
        let group = entity.getEntityGroup()
   */
  func getEntityGroup() -> [HKEntity] {
    return engine.getEntityGroup(group)
  }
}

// MARK: Hashable
extension HKEntity: Hashable {
  
  var hashValue: Int {
    return identifier.hashValue
  }
}

// MARK: Equatable
func ==(lhs: HKEntity, rhs: HKEntity) -> Bool {
  return lhs.hashValue == rhs.hashValue
}

// MARK: CustomStringConvertible
extension HKEntity: CustomStringConvertible, CustomDebugStringConvertible {
  
  var description: String {
    var s = identifier.description
    let components = engine.components.entity(id)
    s += "components: ["
    for component in components {
      s += "\n\t\(component.1.type)"
    }
    s += "]"
    return s
  }

  var debugDescription: String {
    var s = identifier.description
    let components = engine.components.entity(id)
    s += "components: ["
    for component in components {
      s += "\n\t\(component.1.type)"
    }
    s += "]"
    return s
  }
}




