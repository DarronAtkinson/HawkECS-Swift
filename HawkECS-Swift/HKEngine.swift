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
 ## HKEngine
 
 An entity component system engine for game development
 
 ### Conforms to
 - HKUpdatable

 ### Properties
 
- `var entities: HKEntityCollection`
- `var components: HKComponentDictionary`
- `var systems: HKSystemCollection`
 */
class HKEngine {
  
  /**
   Holds the next entity ID
   */
  private var _lowestID = -1
  
  /**
   A list of dead entity IDs to be reused before generating a new one
   */
  private var deadIDs: [Int] = []
  
  /**
   A HKComponentDictionary to hold all the components in the engine
   */
  var components = HKComponentDictionary()
  
  /**
   An array of HKEntityIdentier structs
   */
  var entities = HKEntityCollection()
  
  /**
   An array of HKComponentSystems
   */
  var systems = HKSystemCollection()
  
  /**
   A weak pointer to a HKEngineDelegate. e.g. SKScene
   */
  weak var delegate: HKEngineDelegate?
}

// MARK: UniqueID
extension HKEngine {
  
  /**
   - Returns: the next entity ID by incrementing _lowestID.
   - Throws: A fatal error when the number of entities exceed Int.max
   
   - IDs are taken from the deadIDs array first
   - If the nextID is greater then Int.max, the entities array is looped to find a free ID.
   */
  var nextID: Int {
    
    guard deadIDs.isEmpty else {
      return deadIDs.removeLast()
    }
    
    if _lowestID + 1 > Int.max {
      
      for i in 0..<Int.max {
        guard entities.contains(i)  else { continue }
        return i
      }
      
      fatalError(HKError.tooManyEntities.rawValue)
      
    } else {
      
      _lowestID += 1
      return _lowestID
      
    }
    
  }
}

// MARK: Systems
extension HKEngine: HKUpdatable {
  
  /**
   Adds a new component system to the engine
   
   - Parameter system: The system to be added to the  engine
   
   #### Example
   
        engine.addSystem(MovementSystem())
   */
  func addSystem(system: HKComponentSystem) {
    systems.append(system, withEngine: self)
  }
  
  /**
   Adds a new component system to the engine with a priority
   
   - Parameters:
      - system: The system to be added to the  engine
      - withPriority: The position of the system in the update cycle
   
   #### Example
   
        engine.addSystem(MovementSystem(), withPriority: 1)
   */
  func addSystem(system: HKComponentSystem, withPriority: Int) {
    systems.append(system, withEngine: self, priority: withPriority)
  }
  
  /**
   Retrieve a system from the engine
   
   - Returns: The component system equal to the delcared type
   
   #### Example
   
        if let movementSystem: MovementSystem = engine.getSystem {
          // Do something
        }
   */
  func getSystem<T: HKComponentSystem>() -> T? {
    return systems.get()
  }
  
  /**
   Removes a system from the engine
   
   - Parameter system: The system type to be removed
   
   #### Example
   
        engine.remove(MovementSystem.self)
   */
  func remove<T: HKComponentSystem>(system: T.Type) {
    systems.remove(system, fromEngine: self)
  }
  
  /**
   Removes all systems from the engine
   
   #### Example
   
        engine.removeAllSystems()
   */
  func removeAllSystems() {
    systems.removeAll(fromEngine: self)
  }
  
  /**
   Updates the systems, should be called every frame
   
   #### Example
   
        engine.updateWithDeltaTime(deltaTime)
   */
  func updateWithDeltaTime(seconds: NSTimeInterval) {
    systems.updateWithDeltaTime(seconds)
  }
  
}

// MARK: Entities
extension HKEngine {
  
  /**
   Create a new entity
   
   - Parameters: 
      - name: A unique String property to identify the entity
      - group: A String property used to group entities
   
   - Returns: An instance of HKEntity
   
   #### Example
   
        let player = engine.createEntity("player", group: "userControlled")
   */
  func createEntity(name: String, group: String) -> HKEntity {
    let identifier = HKEntityIdentifier(id: nextID, name: name, group: group)
    entities.add(identifier)
    return identifier.asEntity(self)
  }
  
  /**
   Get an entity from the engine by name
   
   - Parameter name: A String property matching the name of the entity to be found
   
   - Returns: An optional HKEntity instance
   
   #### Example
   
        if let player = engine.getEntity("player") {
          // Do something
        }
   */
  func getEntity(named: String) -> HKEntity? {
    return entities.get(name: named)?.asEntity(self)
  }
  
  /**
   Get an entity from the engine by id
   
   - Parameter id: An Int property matching the id of the entity to be found
   
   - Returns: An optional HKEntity instance
   
   #### Example
   
        if let entity = engine.getEntity(1) {
          // Do something
        }
   */
  func getEntity(id: Int) -> HKEntity? {
    return entities.get(id: id)?.asEntity(self)
  }
  
  /**
   Get an array of entities from the engine by group name
   
   - Parameter group: A String property matching the group name of the entities to be found
   
   - Returns: An array of HKEntity instances
   
   #### Example
   
        let enemies = engine.getEntityGroup("enemies")
   */
  func getEntityGroup(group: String) -> [HKEntity] {
    return entities.map(group, runBlock: { $0.asEntity(self) })
  }
  
  /**
   Remove and entity by id
   
   - Parameter id: The id of the entity to be removed
   
   #### Example
   
        engine.removeEntity(1)
   */
  func removeEntity(id: Int) {
    delegate?.removeEntity(id)
    components.remove(entity: id)
    entities.remove(id: id)
    deadIDs.append(id)
  }
  
  /**
   Remove and entity by name
   
   - Parameter name: The name of the entity to be removed
   
   #### Example
   
        engine.removeEntity("player")
   
   - Note: Removing by id is faster than removing by name
   */
  func removeEntity(name: String) {
    if let id = entities.remove(name: name) {
      delegate?.removeEntity(id)
      components.remove(entity: id)
      deadIDs.append(id)
    }
  }
  
  /**
   Remove a group of entities by group name
   
   - Parameter group: The name of the group to be removed
   
   #### Example
   
        engine.removeEntityGroup("enemies")
   */
  func removeEntityGroup(group: String) {
    entities.remove(group: group) {
      self.delegate?.removeEntity($0)
      self.components.remove(entity: $0)
      self.deadIDs.append($0)
    }
  }
  
  /**
   Removes all the entities from the system and resets the lowestID to 0
   
   #### Example
   
        engine.removeAllEntities()
   */
  func removeAllEntities() {
    for i in entities.collection.keys {
      removeEntity(i)
    }
    
    _lowestID = 0
  }
}

// MARK: Components
extension HKEngine {

  /**
   Retrieve a component from the engine
   
   - Parameters:
      - forEntity: The id of the entity
   
   - Returns: An optional HKComponent matching the declared type
   
   #### Example
   
        if let position: PositionComponent = engine.getComponent(forEntity: 1) {
          // Do something
        }
   */
  func getComponent<T: HKComponent>(forEntity id: Int) -> T? {
    return components.get(forEntity: id)
  }
  
  /**
   Retrieve a component from the engine
   
   - Parameters:
      - forEntity: The name of the entity
   
   - Returns: An optional HKComponent matching the declared type
   
   #### Example
   
        if let position = PositionComponent = engine.getComponent("player") {
          // Do something
        }
   */
  func getComponent<T: HKComponent>(forEntity name: String) -> T? {
    
    if let i = entities.id(forName: name) {
      return components.get(forEntity: i)
    }
    return nil
  }
  
  /**
   Retrieve a group of components from the engine
   
   - Parameters:
      - forEntityGroup: The name of the group
   
   - Returns: An array of HKComponent matching the declared type
   
   #### Example
   
        let enemyPositions: [PositionComponent] = engine.getComponents(forEntityGroup: "enemies")
   */
  func getComponents<T: HKComponent>(forEntityGroup name: String) -> [T] {
    return entities.map(name) { self.components.get(forEntity: $0.id) }
  }
  
  /**
   Adds a component to a group of entities
   
   - Parameters:
      - component: The HKComponent to be added
      - toGroup: The name of the entity group
   
   #### Example
   
        let position = PositionComponent()
        engine.add(component: position, toGroup: "enemies")
   */
  func add(component c: HKComponent, toGroup: String) {
    entities.map(toGroup) { self.components.insert(c, forEntity: $0.id) }
  }
  
   /**
   Adds a component to am entity
   
   - Parameters:
      - component: The HKComponent to be added
      - toEntity: The name of the entity
   
   - Note: Adding components using entity id is faster
   
   #### Example
   
        let position = PositionComponent()
        engine.add(component: position, toEntity: "player")
   */
  func add(component c: HKComponent, toEntity: String) {
    if let id = entities.id(forName: toEntity) {
      components.insert(c, forEntity: id)
    }
  }
  
  /**
   Adds a component to an entity
   
   - Parameters:
      - component: The HKComponent to be added
      - toEntity: The id of the entity
   
   #### Example
   
        let position = PositionComponent()
        engine.add(component: position, toEntity: 1)
   */
  func add(component c: HKComponent, toEntity: Int) {
    components.insert(c, forEntity: toEntity)
  }
  
  /**
   Adds a component to an entity
   
   - Parameters:
      - component: The HKComponent to be added
      - toEntity: An istance of HKEntityIdentifier representing the entity
   
   #### Example
   
        let player = HKEntityIdentifier(id: 0, name: "player", group: "userControlled")
   
        let position = PositionComponent()
        engine.add(component: position, toEntity: player)
   */
  func add(component c: HKComponent, toEntity: HKEntityIdentifier) {
    components.insert(c, forEntity: toEntity.id)
  }
}

// MARK: Filtering
extension HKEngine {
  
  /**
   Filters the componentssystems for the specified type and returns it ready for mutation in the runBlock method
   
   - Parameters:
      - systemType: The type of system to filter, declared as `ExampleSystem.self`
      - runBlock: Provides a mutable instance of the system type
   
   #### Example
   
        engine.filter(MovementSystem.self) {
          movementSystem in
   
          // Do something
        }
   */
  func filter<T: HKComponentSystem>(systemType: T.Type, runBlock: inout T -> ()) {
    systems.filter(systemType, runBlock: runBlock)
  }
  
  /**
   Filters the entities for the specified group and returns an instance of HKEntity in the runBlock method
   
   - Parameters:
      - group: The name of the entity group to filter
      - runBlock: Provides an instance of HKEntity for each entity in the group
   
   #### Example
   
          engine.filter("enemies") {
            enemy in
   
            // Do something
          }
   */
  func filter(group: String, runBlock: HKEntity -> ()) {
    entities.each(group) {
      let entity = $0.asEntity(self)
      runBlock(entity)
    }
  }
  
  /**
   Filters the entities for the specified group and checks for the component of type T.
   
   - Parameters:
      - component: The Type of HKComponent to be filtered. Declared as `ExampleComponent.self`
      - entityGroup: The name of the entity group to filter
      - runBlock: A tuple of `(HKEntityIdentifier, T)` is dispatched with the runBlock method
   
   #### Example
   
        engine.filter(PositionComponent.self, entityGroup: "enemies") {
          entity, position in
   
          // Do something
        }
   */
  func filter<T: HKComponent>(component: T.Type, entityGroup: String, runBlock: (HKEntityIdentifier, T) -> ()) {
    
    let comps = components.all(component)
    
    for comp in comps {
      guard let e = entities.get(id: comp.0) where e.group == entityGroup else { continue }
      runBlock(e, comp.1)
    }
  }

  /**
   Filters the components by type T and displatches a tuple
   of (HKEntityIdentifier, T) with the runBlock method
   
   - Parameters:
      - component: The Type of HKComponent to be filtered. Declared as `ExampleComponent.self`
      - runBlock: A tuple of `(HKEntityIdentifier, T)` is dispatched with the runBlock method
   
   #### Example
   
        engine.filter(PositionComponent.self) {
          entity, position in
   
          // Do something
        }
   */
  func filter<T: HKComponent>(component: T.Type, runBlock: (HKEntityIdentifier, T) -> ()) {
    
    let comps = components.all(component)
    
    for comp in comps {
      let e = entities[comp.0]
      runBlock(e, comp.1)
    }
  }
  
}
