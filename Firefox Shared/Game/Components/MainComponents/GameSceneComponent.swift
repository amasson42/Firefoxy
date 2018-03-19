//
//  GameSceneComponent.swift
//  Firefox
//
//  Created by Arthur Masson on 17/02/2018.
//  Copyright © 2018 Arthur Masson. All rights reserved.
//

import GameplayKit

struct GameCollisionCategory {
    private init() {}
    static let none: Int = 0
    static let unit: Int = 1
    static let spell: Int = 2
}

class GameSceneComponent: GKComponent, GKAgentDelegate {
    
    var gameEntity: GameEntity? {
        return self.entity as? GameEntity
    }
    
    var modelComponent: GameModelComponent? {
        return self.gameEntity?.modelComponent
    }
    
    var agentComponent: GKAgent2D? {
        return self.gameEntity?.agentComponent
    }
    
    var positionNode: SCNNode = SCNNode()
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        if let model = self.modelComponent {
            self.positionNode.addChildNode(model.model)
        }
        self.agentComponent?.delegate = self
        if let name = self.gameEntity?.name {
            self.positionNode.name = "\(name)_positionNode"
        }
    }
    
    func agentWillUpdate(_ agent: GKAgent) {
        if let agent2D = agent as? GKAgent2D {
            agent2D.position.x = Float(self.positionNode.position.x)
            agent2D.position.y = Float(self.positionNode.position.z)
            agent2D.rotation = -Float(self.positionNode.eulerAngles.y) + .pi / 2
        }
    }
    
    func agentDidUpdate(_ agent: GKAgent) {
        if let agent2D = agent as? GKAgent2D,
            self.gameEntity?.unitComponent?.state is GameNormalState {
            self.positionNode.position.x = SCNFloat(agent2D.position.x)
            self.positionNode.position.z = SCNFloat(agent2D.position.y)
            self.positionNode.eulerAngles.y = SCNFloat(-agent2D.rotation) + .pi / 2
        }
    }
    
    @discardableResult
    func addPhysicalBody(radius: CGFloat,
                         elevation: CGFloat,
                         height: CGFloat,
                         type: SCNPhysicsBodyType = .kinematic,
                         category: Int,
                         collision: Int,
                         contactTest: Int) -> SCNPhysicsBody {
        let physicsBody = SCNPhysicsBody(type: type,
                                         shape: SCNPhysicsShape(geometry: SCNCylinder(radius: radius,
                                                                                      height: height),
                                                                options: nil))
        self.positionNode.physicsBody = physicsBody
        physicsBody.categoryBitMask = category
        physicsBody.collisionBitMask = collision
        physicsBody.contactTestBitMask = contactTest
        self.positionNode.entity = self.entity
        return physicsBody
    }
    
}
