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
struct HKComponentDictionary {
  /**
   * EntityID is a typealias for Int
   */
  typealias EntityID = Int
  
  /**
   * ComponentType is a typealias for String
   */
  typealias ComponentType = String
  
  /**
   * ByEntity is a typealias for Dictionary<EntityID, HKComponent>
   */
  typealias ByEntity = [EntityID: HKComponent]
  
  /**
   * Collection is a typealias for Dictionary<ComponentType, ByEntity>
   */
  typealias Collection = [ComponentType: ByEntity]
  
  /**
   * The collection property holds the data in the component dictioanry
   */
  private(set) var collection: Collection
  
  /**
   * Initializes the component dictionary with no components in the collection
   */
  init() {
    collection = [:]
  }
  
  /**
   * Initializes the component dictionary with components from another collection
   */
  init(collection: Collection) {
    self.collection = collection
  }
}

// MARK: Insert, Remove, Update, Get
extension HKComponentDictionary {
  
  /**
   * Returns the component of the specified type for the given entity ID
   */
  func get<T: HKComponent>(forEntity id: EntityID) -> T? {
    return collection[T.type]?[id] as? T
  }
  
  /**
   * Adds the component to the collection for the given entity ID
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
   * Adds the components to the collection for the given entity ID
   */
  mutating func insert(components: [HKComponent], forEntity id: EntityID) {
    
    for component in components {
      insert(component, forEntity: id)
    }
  }
  
  /**
   * Removes the component from the collection for the given entity ID
   */
  mutating func remove<T: HKComponent>(component: T.Type, forEntity id: EntityID) {
    collection[T.type]?.removeValueForKey(id)
  }
  
  /**
   * Removes the component from the collection for the given entity ID
   */
  mutating func remove(component: ComponentType, forEntity id: EntityID) {
    collection[component]?.removeValueForKey(id)
  }
  
  /**
   * Removes all the components from the collection for the given entity ID
   */
  mutating func remove(entity id: EntityID) {

    for type in collection.keys {
      remove(type, forEntity: id)
    }
  }
  
  /**
   * Updates the component in the collection for the given entity ID
   */
  mutating func update<T: HKComponent>(component: T, forEntity id: EntityID) {
    insert(component, forEntity: id)
  }
  
  
}

// MARK: Sorting
extension HKComponentDictionary {
  
  /**
   * Returns an array of components for the given type
   */
  func all<T: HKComponent>() -> [T] {
    guard let byEntity = collection[T.type] else {
      return []
    }
    
    return byEntity.map({ $0.1 }) as! [T]
  }
  
  /**
   * Returns a dictionary of components for the given entity
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
   * Returns and array of (EntityID, HKComponent) for all components of the given type
   */
  func all<T: HKComponent>(component: T.Type) -> [(EntityID, T)] {
    return collection[component.type]!.map({ ($0, $1 as! T) })
  }
  
}