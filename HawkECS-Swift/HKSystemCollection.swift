//
//  HKSystemCollection.swift
//  HawkEngine
//
//  Created by Jade Turnbull on 07/08/2016.
//  Copyright © 2016 Darron Atkinson. All rights reserved.
//

import Foundation

/**
 ## HKSystemCollection
 
 ### Conforms to
 - HKUpdatable
 
 ### Properties
 
 #### Typealias
 - Element = HKComponentSystem
 
 #### Public
 - `var systems: [Element]`
 - `var count: Int`
 - `var isEmpty: Bool`
 - `var active: Bool`
*/

struct HKSystemCollection {
  
  /**
   Typealias for HKComponentSystem
   */
  typealias Element = HKComponentSystem
  
  /**
   An array of HKComponentSystem
   */
  var systems: [Element] = []
  
  /**
   System count
   - Returns: The number of systems in the collection
   */
  var count: Int { return systems.count }
  
  /**
   Check for emptiness
   - Returns: `true` if the collection is empty
   */
  var isEmpty: Bool { return systems.isEmpty }
  
  /**
   Activate or deactivate the collection.
   
   `updateWithDeltaTime(seconds: )` is only called when active
   */
  var active = true
}

extension HKSystemCollection: HKUpdatable {
  
  /**
   Add a new system to the end of the collection
   
   - Parameters:
      - system: Element to be added
      - engine: The engine holding the collection
   
   #### Example
        
        let movementSystem = MovementSystem()
        systems.append(movementSystem, withEngine: engine)
   */
  mutating func append(system: Element, withEngine engine: HKEngine) {
    var s = system
    s.didMoveTo(engine)
    systems.append(s)
  }
  
  /**
   Add a new system to the collection with a priority
   
   - Parameters:
      - system: Element to be added
      - engine: The engine holding the collection
      - priority: The position in the update cycle. Lowest is 0
   
   #### Example
   
        let movementSystem = MovementSystem()
        systems.append(movementSystem, withEngine: engine, priority: 0)
   */
  mutating func append(system: Element, withEngine engine: HKEngine, priority: Int) {
    if priority >= count {
      append(system, withEngine: engine)
    } else {
      var s = system
      s.didMoveTo(engine)
      systems.insert(s, atIndex: priority)
    }
  }
  
  /**
   Retrieve a system from the collection
   
   - Returns: An optional HKComponentSystem
   
   #### Example
   
        if let movementSystem: MovementSystem = systems.get() {
          // Do something
        }
   */
  func get<T: HKComponentSystem>() -> T? {
    return systems.filter({ $0.type == T.type }).first as? T
  }
  
  /**
   Removes a system from the collection
   
   - Parameters:
      - system: The system type to remove
      - fromEngine: The engine holding the collection
   
   #### Example
   
        systems.remove(MovementSystem.self, fromEngine: engine)
   */
  mutating func remove<T: HKComponentSystem>(system: T.Type, fromEngine: HKEngine) {
    systems = systems.filter({ $0.type == system.type }) {
      var a = $0
      a.willMoveFrom(fromEngine)
    }
  }
  
  /**
   Removes all systems from the collection
   
   - Parameter fromEngine: The engine holding the collection
   
   #### Example
   
        systems.removeAll(fromEngine: engine)
   
   */
  mutating func removeAll(fromEngine engine: HKEngine) {
    for i in 0..<count {
      systems[i].willMoveFrom(engine)
    }
    
    systems = []
  }
  
  /**
   Updates the systems in the collection
   
   - Parameter seconds: Delta time
   
   #### Example
   
        systems.updateWithDeltaTime(deltaTime)
   */
  func updateWithDeltaTime(seconds: NSTimeInterval) {
    guard active else { return }
    
    for i in 0..<count {
      systems[i].updateWithDeltaTime(seconds)
    }
  }
  
  /**
   Filters the systems for the specified type and returns it ready for mutation in the runBlock method
   
   - Parameters:
      - systemType: The HKComponentSystem type to filter
      - runBlock: The function to perform on the filtered system
   
   #### Example
   
        systems.filter(MovementSystem.self) {
          movementSystem in
          
          // Do something
        }
   */
  mutating func filter<T: HKComponentSystem>(systemType: T.Type, runBlock: inout T -> ()) {
    for i in 0..<systems.count
      where systems[i].type == T.type {
        var s = systems[i] as! T
        runBlock(&s)
        systems[i] = s
    }
  }
}