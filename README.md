![alt text](https://github.com/DarronAtkinson/HawkECS-Swift/blob/master/HawkEngine.png "HawkEngine Logo")

# HawkECS-Swift
A protocol oriented entity component system written in Swift

Inspired by: 
   
   https://github.com/adamgit/Entity-System--RDBMS-Inspired--Objective-C
   
   http://www.swift-studies.com/blog/2015/7/21/making-gameplaykit-swift-ier

## Protocols
### HKType
 - Provides a type property that returns the DynamicType as a String

### HKUpdatable
  - Declares one function: updateWithDeltaTime(seconds: )

### HKComponent
  - Conforms to HKType and HKUpdatable
  - Provides a default implementation of HKUpdatable
  - Can be used to turn anything in your code into a component. e.g SKPhysicsBody, CGPoint
  - Immutable structs are preferred for components

### HKComponentSystem
  - Conforms to HKType and HKUpdatable
  - Declares one property, var engine: HKEngine!
  - Use updateWithDeltaTime(seconds: ) to update components in your engine
  - You can define your component system as a struct or a class


## Structs
Structs are favoured where possible
### HKEntity
  - A simple struct allowing your code to be more readable
  - It has five properties: 
        identifier: HKEntityIdentifier
        ID: Int
        name: String
        group: String
        engine: HKEngine
  - Provides convenience functions
 
### HKEntityIdentifier
  - Store identity data for the entities in your game
  - It has three properties
        id: Int
        name: string
        group: String

### HKComponentDictionary
  - The component dictionary is the heart of the engine
  - It stores all of the components in your game
  - Components are organised by type
  - Each type is further organised by entity id

### HKEntityCollection
  - The entity collection stores HKEntityIdentifier structs
 
### HKSystemCollection
  - Stores the HKComponentSystems used in your game


## Classes
### HKEngine
  - Conforms to HKUpdatable
  - Manages creating and maintaining entities
  - Holds HKComponentSystems and sequentially updates them when updateWithDeltaTime(seconds: ) is called


  
  
## Usage
  
  Initialize
  ```Swift
  let engine = HKEngine()
  ```
  
  Create a custom component
  ```Swift
  struct HealthComponent: HKComponent {
    let max = 100
    let current = 100
  }
  ```
  
  Use built in structs and class as components
  ```Swift
  extension CGPoint: HKComponent {}
  public typealias PositionComponent = CGPoint
  
  extension CGVector: HKComponent {}
  public typealias VelocityComponent = CGVector
  ```
  
  Create a component system
  ```Swift
  struct MovementSystem: HKComponentSystem {
  
    // Pointer to engine
    weak let engine: HKEngine!
  
    // AddToEngine
    func didMoveToEngine(engine: HKEngine) {
      self.engine = engine
    }
  
    // Update
    func updateWithDeltaTime(seconds: NSTimeInterval) {
    
      engine.filter(VelocityComponent.self) {
        entity, velocity in
        
        guard let position: PositionComponent = engine.getComponent(forEntity: entity) else { return }
        
        let x = position.x + velocity.dx
        let y = position.y + velocity.dy
        
        update(PositionComponent(x: x, y: y), forEntity: entity)
      }
  }
    
    func willMoveFrom(engine: HKEngine) {
      self.engine = nil
    }
  }
```

Create an entity
```Swift
let entity = engine.createEntity("player", group: "userControlled")
```

Add components
```Swift
entity.addComponent(PositionComponent())
entity.addComponent(VelocityComponent())
```

Retrieve a component
```Swift
if let position: PositionComponent = entity.getComponent() {
  // Do something with position
}
```

Adjust a component
```Swift
entity.adjustComponent(PositionComponent.self) {
  $0.x = 0
  $0.y = 0
}
```

Remove a component
```Swift
entity.removeComponent(PositionComponent.self)
```

Remove an entity
```Swift
entity.destroy()
```

Update the engine
```Swift
override func update(currentTime: CFTimeInterval) {
  deltaTime = currentTime - timeSinceLastUpdate
  deltaTime = deltaTime > maxUpdateInterval ? maxUpdateInterval : deltaTime
  lastUpdateInterval = currentTime
  
  engine.updateWithDeltaTime(deltaTime)
}
```

Filter the entities
```Swift
let enemies = engine.getEntityGroup("enemies")
let player = engine.getEntity("player")
```

Filter the components
```Swift
engine.filter(PositionComponent.self) {
  entity, position in
}

engine.filter(PositionComponent.self, entityGroup: "enemies") {
  entity, position in
}
```

Filter the systems
```Swift
engine.filter(MovementSystem.self) {
  movementSystem in
}
```

Feel free to use this ECS as an alternative to the GameplayKit ECS

note: GKAgent can be made into a component using the HKComponent protocol. 
      The updateWithDeltaTime(seconds: ) method 
      will need to be called within your GKAgentComponentSystem
