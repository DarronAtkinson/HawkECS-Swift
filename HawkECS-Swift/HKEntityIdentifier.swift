//
//  HKEntityIdentifier.swift
//  HawkEngine
//
//  Created by Jade Turnbull on 06/08/2016.
//  Copyright © 2016 Darron Atkinson. All rights reserved.
//

import Foundation

/**
 ## HKEntityIdentifier
 
 A struct containing the identifcation data for an instance of HKEntity
 
 ### Conforms to
  - Hashable
  - CustomStringConvertible
  - CustomDebugStringConvertible
 
 ### Properties
  - `let id: Int`
  - `let name: String`
  - `let group: String`
 
 ### Functions
  - `func asEntity(engine: ) -> HKEntity`
 
 note. Does not provide a link to the engine
 */
struct HKEntityIdentifier {
  
  /**
   Unique Integer, used to identify an entity in a HKEngine
   */
  let id: Int
  
  /**
   Unique String, used to indentify an entity by name. e.g. "player"
   */
  let name: String
  
  /**
   Group entities together using a simple String. e.g. "enemies"
   */
  let group: String
  
  /**
   Converts the HKEntityIndentifier into an instance of HKEntity
   
   - Parameter engine: The engine containing the entity that `self` refers to
   
   - Returns: An instance of HKEntity
   
   #### Example
   
        let data = HKEntityIdentifier(id: 0, name: "player", group: "userControlled")
        let player = data.asEntity(engine)
   
   */
  func asEntity(engine: HKEngine) -> HKEntity {
    return HKEntity(identity: self, engine: engine)
  }
}

// MARK: CustomStringConvertible
extension HKEntityIdentifier: CustomStringConvertible, CustomDebugStringConvertible {

  var description: String {
    return "HKEntityIdentifer: \n\tID: \(id)\n\tname: \(name)\n\tgroup: \(group)"
  }
  
  var debugDescription: String {
    return "HKEntityIdentifer: \n\tID: \(id)\n\tname: \(name)\n\tgroup: \(group)"
  }
}

// MARK: Hashable
extension HKEntityIdentifier: Hashable {
  
  /**
   * Hash value
   */
  var hashValue: Int {
    return id.hashValue + name.hashValue + group.hashValue
  }
}

// MARK: Equatable
func ==(lhs: HKEntityIdentifier, rhs: HKEntityIdentifier) -> Bool {
  return lhs.hashValue == rhs.hashValue
}

