//  Created by Darron Atkinson on 6/08/2016.
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
 ## HKEntityCollection
 
 A custom dictionary collection to store HKEntityIndentifier structs
 
 ### Properties
 
 #### Typealias
 - EntityId = Int
 - Element = HKEntityIdentifier
 
 #### Private
 - `var items: [EntityID: Element]`
 
 #### Public
 - `var collection: [EntityID: Element]`
 
 */
struct HKEntityCollection {
  
  /**
   EntityID is a typealias for `Int`
   */
  typealias EntityID = Int
  
  /**
   Element is a typealias for `HKEntityIdentifier`
   */
  typealias Element = HKEntityIdentifier
  
  /**
   The dictionary collection of entities
   */
  private var items: [EntityID: Element] = [:]
  
  /**
   - Returns: The `items` property. 
   
   Mutating this will not affect the underlying collection
   */
  var collection: [EntityID: Element] { return items }
}

// MARK: Retrieval
extension HKEntityCollection {
  
  /**
   Checks to see if the collection contains an entity id
   
   - Parameter id: The entity id to check
   
   - Returns: `true` if the collection contain the id
   
   #### Example
   
        if entities.contains(1) {
          // Do something
        }
   */
  func contains(id: EntityID) -> Bool {
    return items[id] != nil
  }
  
  /**
   Retrieve an entity from the collection
   
   - Parameter id: The entity id to retrieve
   
   - Returns: An optional Element
   
   #### Example
   
        if let entity = entities.get(1) {
          // Do something with player
        }
   */
  func get(id i: EntityID) -> Element? {
    return items[i]
  }
  
  /**
   Retrieve an entity from the collection by name
   
   - Parameter name: The entity name to retrieve
   
   - Returns: An optional Element
   
   #### Example
   
        if let entity = entities.get("player") {
          // Do something with player
        }
   */
  func get(name s: String) -> Element? {
    for element in items.values
      where element.name == s {
        return element
    }
    return nil
  }
  
  /**
   Retrieve an array of entities from the collection
   
   - Parameter group: The entity group to retrieve
   
   - Returns: An array of Element belonging to the specified group
   
   #### Example
    
        let group = entities.get("enemies")
   */
  func get(group s: String) -> [Element] {
    return items.values.filter({ $0.group == s })
  }
  
  /**
   Perform a block on a group of entities and maps the result to a new array
   
   - Parameters:
      - group: The entity group to loop over
      - runBlock: Provides the Element in the group and expects an optional return value
   
   - Returns: The result of runBlock in an array
   
   #### Example
   
        let names: [String] = entities.map("enemies") {
          entity in
   
          // Do something
        }
   */
  func map<T>(group: String, runBlock: Element -> T?) -> [T] {
    return items.values.flatMap({ $0.group == group ? runBlock($0) : nil })
  }
  
  /**
   Perform a block on a group of entities
   
   - Parameters:
      - group: The entity group to loop over
      - runBlock: Provides the Element in the group
   
   #### Example
   
        entities.each("activeEnemies") {
          enemy in
   
          // Do something
        }
   */
  func each(group: String, runBlock: Element -> ()) {
    items.values.forEach({ if $0.group == group { runBlock($0) } })
  }
  
  /**
   Retrieve the id belonging to an entity
   
   - Parameter forName: The entity name
   
   - Returns: An `Int` matching the id of the entity
   
   #### Example
   
        let playerID = entities.id(forName: "player")
   */
  func id(forName name: String) -> EntityID? {
    return get(name: name)?.id
  }
  
  /**
   Returns an array of entity ids
   */
  var ids: [EntityID] { return Array(items.keys) }
  
  /**
   Returns an array of entity names
   */
  var names: [String] { return items.values.map({ $0.name }) }
  
  /**
   Returns an array of entity group names
   */
  var groups: [String] { return items.values.map({ $0.group }) }
  
  /**
   Retrieve an array of entity ids for a given group name
   
   - Parameter group: The name of the group to retrieve
   
   - Returns: An array of ids for the given group name
   
   #### Example
   
        let enemyIDs = entities.groupIDs("enemies")
   */
  func groupIDs(group: String) -> [EntityID] {
    return items.values.flatMap({ $0.group == group ? $0.id : nil })
  }
}

// MARK: Addition and removal
extension HKEntityCollection {
  
  /**
   Remove an Element from the collection by id
   
   - Parameter id: The entity id to remove
   
   #### Example
   
        entities.remove(1)
   */
  mutating func remove(id i: EntityID) {
    items[i] = nil
  }
  
  /**
   Remove an Element from the collection by name
   
   - Parameter name: The entity name to remove
   
   - Returns: The id of the entity removed
   
   #### Example
   
        entities.remove("player")
   
   */
  mutating func remove(name s: String) -> EntityID? {
    if let i = items.indexOf({ $0.1.name == s }) {
      let (id, _) = items.removeAtIndex(i)
      return id
    }
    return nil
  }
  
  /**
   Remove a group of Elements from the collection by group
   
   - Parameters:
      - group: The group name to remove
      - block: Provides the entity id removed
   
   #### Example
   
        entities.remove("enemies") {
          entityID in
   
          // Do something
        }
   */
  mutating func remove(group s: String, block: EntityID -> ()) {
    for (k, v) in items where v.group == s {
      items[k] = nil
      block(k)
    }
  }
  
  /**
   Add a new Element to the collection
   
   - Parameter entity: The HKEntityIdentifier to be added
   
   #### Example
   
        let entity = HKEntityIdentifier(id: 0, name: "boss", group: "enemies")
        entities.add(entity)
   */
  mutating func add(entity: Element) {
    items[entity.id] = entity
  }
  
  /**
   Creates an instance of HKEntityIdentifier with no name or group and adds it to the collection
   
   - Parameter id: The entity to be added
   
   #### Example
   
        entities.add(0)
   
   */
  mutating func add(id: EntityID) {
    let element = Element(id: id, name: "", group: "")
    add(element)
  }
}

// MARK: Subscript
extension HKEntityCollection {
  
  /**
   Retrieve an Element for the given id
   
   - Parameter id: The entity id
   
   - Returns: The Element associated with the id
   
   - Throws: Fatal error if the entity does not exist
   
   #### Example
   
        let entity = entities[0]
   */
  subscript(id: EntityID) -> Element {
    get {
      guard let element = get(id: id) else {
        fatalError("EntityCollection: No entity exists with id \(id)")
      }
      return element
    }
  }
  
  /**
   Retrieve an Element for the given name
   
   - Parameter name: The entity name
   
   - Returns: The Element associated with the name
   
   - Throws: Fatal error if the entity does not exist
   
   #### Example
   
        let entity = entities["player"]
   */
  subscript(name: String) -> Element {
    get {
      guard let element = get(name: name) else {
        fatalError("EntityCollection: No entity exists with name \(name)")
      }
      return element
    }
  }
}