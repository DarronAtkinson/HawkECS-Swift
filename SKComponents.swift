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

import SpriteKit

/* A list of default HKComponents for using SpriteKit with an instances of HKEngine.
 * Conformance to HKComponent automatically transforms anything into a usable component.
 *
 * typealias is used to add readability to your code.
 * The RenderComponent typealias is current the only required component, however the type
 * it refers to can be changed. e.g. RenderComponent = SCNNode when using SceneKit
 * 
 * Add all renderable components as children to the RenderComponent
 */

// Allows all subclasses of SKNode to be a HKComponent
extension SKNode: HKComponent {}

// MARK: Render component
public typealias RenderComponent = SKNode

// MARK: Sprite component
public typealias SpriteComponent = SKSpriteNode

// MARK: Label component
public typealias LabelComponent = SKLabelNode

// MARK: Light component
public typealias LightComponent = SKLightNode

// MARK: Particle emitter component
public typealias EmitterComponent = SKEmitterNode

// MARK: Physics component
extension SKPhysicsBody: HKComponent {}

public typealias PhysicsComponent = SKPhysicsBody

// MARK: Position component
extension CGPoint: HKComponent {}

public typealias PositionComponent = CGPoint

// MARK: Velocity Component
extension CGVector: HKComponent {}

public typealias VelocityComponent = CGVector