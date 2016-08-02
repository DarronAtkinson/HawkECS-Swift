# HawkECS-Swift
A protocol oriented entity component system written in Swift

Inspired by https://github.com/adamgit/Entity-System--RDBMS-Inspired--Objective-C

## Protocols
### HKType
 - A protocol providing are type property that return the DynamicType as a String

### HKUpdatable
  - A protocol declaring one function: updateWithDeltaTime(seconds: )

### HKComponent
  - Conforms to HKType and HKUpdatable
  - Provides a default implementation of HKUpdatable
  - Can be used to turn anything in your code into a component. e.g SKPhysicsBody, CGPoint
  - Immutable structs are prefered for components

### HKComponentSystem
  - Conforms to HKType and HKUpdatable
  - Declares one property, var engine: HKEngine!
  - Use updateWithDeltaTime(seconds: ) to update components in your engine
  - You can loop over the required component using: 
        engine.components.all(componentType: ) -> [EntityID: HKComponent]
  - You can define your component system as a struct or a class
  - Components can be updated using: 
        update(component: , forEntity: )


## Structs
Structs are favoured where possible
### HKEntity
  - This is a simple struct allowing your code to be more readable
  - It has three properties: 
        name: String
        ID: Int
        engine: HKEngine

### HKComponentDictionary
  - The component dictionary is the heart of the engine
  - It stores all of the components in your game
  - Components are organised by type
  - Each type is further organised by entity id


## Classes
### HKEngine
  - Conforms to HKUpdatable
  - Manages creating and maintaining entities
  - Holds HKComponentSystems and sequentially updates them when updateWithDeltaTime(seconds: ) is called


Feel free to use this ECS as an alternative to the GameplayKit ECS

note: GKAgent can be made into a component using the HKComponent protocol. 
      The updateWithDeltaTime(seconds: ) method 
      will need to be called within your GKAgentComponentSystem

  
  
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
  
    // Initialization
    init() {}
  
    // Update
    func updateWithDeltaTime(seconds: NSTimeInterval) {
    
      for (entity, velocity) in engine.components.all(VelocityComponent.self) {
      
        guard let position: PositionComponent = engine.components.get(forEntity: entity) else { continue }
      
        let x = position.x + velocity.dx
        let y = position.y + velocity.dy
      
        update(PositionComponent(x: x, y: y), forEntity: entity)
      }
    }
  }
```

Create an entity
```Swift
let entity = engine.addEntity()
```

Add components
```Swift
entity.addComponent(PositionComponent())
entity.addComponent(VelocityCompenent())
```

Retrieve a component
```Swift
if let position: PositionComponent = entity.getComponent() {
  // Do something with position
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
