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
import CoreGraphics

// MARK: Declaration
/**
 ## HKComponentDictionary
 
 A custom collection type used to store HKComponents
 
 ### Properties
 
 #### TypeAliases
 - `EntityID = Int`
 - `ByEntity = [EntityID: HKComponent]`
 - `ComponentType = String`
 - `Collection = [ComponentType: ByEntity]`
 
 #### Private
 - `var collection: Collection`
 
 #### Public
 - `isEmpty: Bool`
 
 */
struct HKComponentDictionary {
  /**
   EntityID is a typealias for `Int`
   */
  typealias EntityID = Int
  
  /**
   ComponentType is a typealias for `String`
   */
  typealias ComponentType = String
  
  /**
   ByEntity is a typealias for `[EntityID: HKComponent]`
   */
  typealias ByEntity = [EntityID: HKComponent]
  
  /**
   Collection is a typealias for `[ComponentType, ByEntity]`
   */
  typealias Collection = [ComponentType: ByEntity]
  
  /**
   The collection property holds the data in the component dictionary
   */
  private(set) var collection: Collection
  
  /**
   A `Bool` to indicate whether the collection is empty
   
   - Returns: `true` if the collection is empty
   */
  var isEmpty: Bool {
    return collection.isEmpty
  }
  
  /**
   Initializes an empty collection
   */
  init() {
    collection = [:]
  }
  
  /**
   Initializes the component dictionary with components from another collection
   */
  init(collection: Collection) {
    self.collection = collection
  }
}

// MARK: Insert, Remove, Update, Get
extension HKComponentDictionary {
  
  /**
   Retreive a component from the collection
   
   - Parameter forEntity: The id for the entity
   
   - Returns: An optional component for the specified type
   
   #### Example
   
        if let position: PositionComponent = components.get(forEntity: 1) {
          // Do something with position
        }
   */
  func get<T: HKComponent>(forEntity id: EntityID) -> T? {
    return collection[T.type]?[id] as? T
  }
  
  /**
   Insert a component into the collection
   
   - Parameters:
      - component: The component to be added
      - forEntity: The id for the entity
   
   #### Example
   
        let position = PositionComponent(x: 10, y: 30)
        components.insert(position, forEntity: 1)
   */
  mutating func insert(component: HKComponent, forEntity id: EntityID) {
    
    // Checks to see if a component of the given type is already present in the collection
    guard collection[component.type] != nil else {
      
      // If the component type is not present in the collection 
      // a new ByEntity collection is created
      collection[component.type] = [id: component]
      return
    }
    
    // Inserts the new component into the collection
    collection[component.type]![id] = component
  }
  
  /**
   Insert multiple components into the collection
   
   - Parameters:
      - components: An array of components to be added
      - forEntity: The id of the entity
   
   #### Example
   
        let positions = [PositionComponent(), VelocityComponent()]
        components.insert(components, forEntity: 2)
   */
  mutating func insert(components: [HKComponent], forEntity id: EntityID) {
    
    for component in components {
      insert(component, forEntity: id)
    }
  }
  
  /**
   Remove a component from the collection
   
   - Parameters:
      - component: The component to be remove, declared as `ExampleComponent.self`
      - forEntity: The id for the entity
   
   #### Example
   
        components.remove(PositionComponent.self, forEntity: 1)
   */
  mutating func remove<T: HKComponent>(component: T.Type, forEntity id: EntityID) {
    collection[T.type]?.removeValueForKey(id)
  }
  
  /**
   Remove a component from the collection
   
   - Parameters:
      - component: A `String` equal to the result of `HKComponent.type`
      - forEntity: The id for the entity
   
   #### Example
   
        components.remove("PositionComponent", forEntity: 1)
   */
  mutating func remove(component: ComponentType, forEntity id: EntityID) {
    collection[component]?.removeValueForKey(id)
  }
  
  /**
   Removes all the components from the collection for the given entity ID
   
   - Parameter entity: The id of the entity to remove
   
   #### Example
   
        components.remove(entity: 1)
   */
  mutating func remove(entity id: EntityID) {

    for type in collection.keys {
      remove(type, forEntity: id)
    }
  }
  
  /**
   Remove all components from the collection
   
   #### Example
   
        components.removeAll()
   */
  mutating func removeAll() {
    collection.removeAll()
  }
  
  /**
   Updates the component in the collection for the given entity ID
   
   - Important: Only needs to be used when a component is a value type. e.g. struct or enum
   
   - Parameters:
      - component: An instance of HKComponent
      - forEntity: The id for the entity
   
   #### Example
   
        let x = position.x += velocity.dx
        let y = position.y += velocity.dy
        let updatedPosition = PositionComponent(x: x, y: y)
   
        components.update(updatedPosition, forEntity: 1)
   */
  mutating func update<T: HKComponent>(component: T, forEntity id: EntityID) {
    insert(component, forEntity: id)
  }
  
  
}

// MARK: Sorting
extension HKComponentDictionary {
  
  /**
   Retrieve an array of components for the specified type
   
   e.g. `let array: [ExampleComponent] = components.all()`
   
   - Returns: An array of components for the specified type
   
   #### Example
   
        let positions: [PositionComponent] = components.all()
   */
  func all<T: HKComponent>() -> [T] {
    guard let byEntity = collection[T.type] else {
      return []
    }
    
    return byEntity.map({ $0.1 }) as! [T]
  }
  
  /**
   Retrieve a dictionary of components for an entity
   
   - Parameter id: The entity id
   
   - Returns: A `Dictionary` of components for the specified entity id
   
   #### Example
   
        let entity = components.entity(1)
   */
  func entity(id: EntityID) -> [ComponentType: HKComponent] {
    
    var entity: [ComponentType: HKComponent] = [:]
    
    for (type, sub) in collection {
      if let component = sub[id] {
        entity[type] = component
      }
    }
    
    return entity
  }
  
  /**
   Retrieve an array of `(EntityID, HKComponent)` for all components of the given type
   
   - Parameter component: The type of component to find
   
   - Returns: An array of `(EntityID, HKComponent)'
   
   #### Example
   
        for (entityID, position) in components.all(PositionComponent.self) {
          // Do something
        }
   */
  func all<T: HKComponent>(component: T.Type) -> [(EntityID, T)] {
    return collection[component.type]!.map({ ($0, $1 as! T) })
  }
  
}
