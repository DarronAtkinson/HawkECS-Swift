//
//  HKEngineDelegate.swift
//  HawkEngine
//
//  Created by Jade Turnbull on 28/07/2016.
//  Copyright © 2016 Darron Atkinson. All rights reserved.
//

import SpriteKit

/**
## HKEngineDelegate
Provide default functions for using HawkEngine ECS with a rendering engine such as SpriteKit
 
### Properties:
 
`var engine: HKEngine! { get }`

### Functions:
 
`addEntity(entity: )`
 
 - Add any renderable components to the scene
 
 
`removeEntity(id: )`
 
  - Remove any renderable components to the scene
*/
protocol HKEngineDelegate: class {
  
  /**
  A pointer to the engine
  */
  var engine: HKEngine { get }
  
  /**
  Called by the engine when an entity is removed
   
  - Important: Remove any renderable components from the scene
   
  - Parameter id: The id of the entity to be removed
  */
  func removeEntity(id: Int)
  
  /**
  Implement a function to add any renderable components to the scene
   
  - Important: This is not called by engine
   
  - Parameter entity: The instance of HKEntity to be added to the scene
  */
  func addEntity(entity: HKEntity)
}


extension GameScene: HKEngineDelegate {
  
  func removeEntity(id: Int) {
    if let render: RenderComponent = engine.components.get(forEntity: id) {
      render.removeFromParent()
    }
  }
  
  func newEntity(name: String, group: String) -> HKEntity {
    return engine.createEntity(name, group: group)
  }
  
  func addEntity(entity: HKEntity) {
    addEntity(entity, toLayer: .sprites)
  }

  func addEntity(entity: HKEntity, toLayer layer: HKGameLayer) {
    guard let render: RenderComponent = engine.getComponent(forEntity: entity.id) else { return }
    addNode(render, to: layer)
    
    if let emitter: EmitterComponent = engine.getComponent(forEntity: entity.id) {
      emitter.targetNode = self
    }
  }
}