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
 * An entity component system engine for game development
 */
class HKEngine {
  
  /**
   * Holds the next entity ID
   */
  private var _lowestID = -1
  
  /**
   * A HKComponentDictionary to hold all the components in the engine
   */
  var components = HKComponentDictionary()
  
  /**
   * An array of entity IDs
   */
  var entities: [Int] = []
  
  /**
   * A dictionary of entity name. Key: EntityID, Value: EntityName
   */
  var entityNames: [Int: String] = [:]
  
  /**
   * An array of HKComponentSystems
   */
  var systems: [HKComponentSystem] = []
  
  /**
   * A weak pointer to the current scene
   */
  //weak var scene: GameScene?
}

// MARK: UniqueID
extension HKEngine {
  
  /**
   * Return the next entity ID by incrementing _lowestID.
   * If the nextID is greater then Int.max, the entities array is looped to find a free ID.
   * Maximum entities is equal to Int.max
   */
  var nextID: Int {
    
    if _lowestID + 1 > Int.max {
      
      for i in 0..<Int.max {
        if !entities.contains(i) {
          return i
        }
      }
      
      fatalError(HKError.tooManyEntities.rawValue)
      
    } else {
      
      _lowestID += 1
      return _lowestID
      
    }
    
  }
}

// MARK: Entities
extension HKEngine {
  
  /**
   * Adds a new entity to the engine
   */
  func addEntity() -> HKEntity {
    let ID = nextID
    entities.append(ID)
    return HKEntity(ID: ID, engine: self)
  }
  
  /**
   * Adds a new entity to the engine with a specified name
   */
  func addEntity(withName name: String) -> HKEntity {
    let ID = nextID
    entities.append(ID)
    entityNames[ID] = name
    return HKEntity(name: name, ID: ID, engine: self)
  }
  
  /**
   * Removes and entity from the engine
   */
  func remove(entity: HKEntity) {
    entities = entities.filter({ $0 != entity.ID })
    entityNames[entity.ID] = nil
    components.remove(entity: entity.ID)
  }
  
  /**
   * Removes and entity from the engine
   */
  func remove(entity: Int) {
    entities = entities.filter({ $0 != entity })
    entityNames[entity] = nil
    components.remove(entity: entity)
  }
  
  /**
   * Sets a name for the given entity ID
   */
  func set(name: String?, forEntity id: Int) {
    entityNames[id] = name
  }
  
  /**
   * Returns an array of HKEntity with the specified name
   */
  func getEntites(name: String) -> [HKEntity] {
    return entityNames
      .filter({ $0.1 == name })
      .map({ HKEntity(name: $0.1, ID: $0.0, engine: self) })
  }
}

// MARK: Systems
extension HKEngine: HKUpdatable {
  
  /**
   * Adds a new component system to the engine
   */
  func addSystem(system: HKComponentSystem) {
    var system = system
    system.engine = self
    systems.append(system)
  }
  
  /**
   * Adds an array of new component systems to the engine
   */
  func addSystems(systems: [HKComponentSystem]) {
    for system in systems {
      var system = system
      system.engine = self
      self.systems.append(system)
    }
  }
  
  /**
   * Retrieve a system from the engine
   */
  func get<T: HKComponentSystem>() -> T? {
    for system in systems {
      if system.type == T.type {
        return system as? T
      }
    }
    return nil
  }
  
  /**
   * Updates the engines systems, should be called every frame
   */
  func updateWithDeltaTime(seconds: NSTimeInterval) {
    
    for i in 0..<systems.count {
      systems[i].updateWithDeltaTime(seconds)
    }
  }
  
}
