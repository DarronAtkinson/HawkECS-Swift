# HawkECS-Swift
A protocol oriented entity component system written in Swift

Inspired by other ECS such as Artemis and Ash

HawkECS utilises Swift protocols throughout:
  - HKType
  - HKUpdatable
  - HKComponent
  - HKComponentSystem

Structs are favoured over Classes where possible:
  - HKEntity
  - HKComponentDictionary

The only required class is:
  - HKEngine


# HKType
 - A protocol providing are type property that return the DynamicType as a String

# HKUpdatable
  - A protocol declaring one function: updateWithDeltaTime(seconds: )

# HKComponent
  - Conforms to HKType and HKUpdatable
  - Provides a default implementation of HKUpdatable
  - Can be used to turn anything in your code into a component. e.g SKPhysicsBody, CGPoint
  - Immutable structs are prefered for components

# HKComponentSystem
  - Conforms to HKType and HKUpdatable
  - Declares one property, var engine: HKEngine!
  - Use updateWithDeltaTime(seconds: ) to update components in your engine
  - You can loop over the required component using: 
        engine.components.all(componentType: ) -> [EntityID: HKComponent]
  - You can define your component system as a struct or a class
  - Components can be updated using: 
        update(component: , forEntity: )

# HKEntity
  - This is a simple struct allowing your code to be more readable
  - It has three properties: 
        name: String
        ID: Int
        engine: HKEngine

# HKComponentDictionary
  - The component dictionary is the heart of the engine
  - It stores all of the components in your game
  - Components are organised by type
  - Each type is further organised by entity id

# HKEngine
  - Conforms to HKUpdatable
  - Manages creating and maintaining entities
  - Holds HKComponentSystems and sequentially updates them when updateWithDeltaTime(seconds: ) is called


Feel free to use this ECS as an alternative to the GameplayKit ECS

note: GKAgent can be made into a component using the HKComponent protocol. 
      The updateWithDeltaTime(seconds: ) method 
      will need to be called within your GKAgentComponentSystem

  
