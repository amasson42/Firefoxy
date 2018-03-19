//
//  GameJumpComponent.swift
//  Firefox
//
//  Created by Arthur Masson on 01/03/2018.
//  Copyright © 2018 Arthur Masson. All rights reserved.
//

import GameplayKit
import SceneKit


class GameJumpComponent: GKComponent {
    
    static let cooldown: TimeInterval = 3.0
    var currentCooldown: TimeInterval = 0.0
    var jumpHeight: SCNFloat = 1.0
    var jumpTime: TimeInterval = 0.6
    
    var gameEntity: GameEntity?
    
    var model: SCNNode? {
        return self.gameEntity?.modelComponent.model
    }
    
    var positionNode: SCNNode? {
        return self.gameEntity?.sceneComponent.positionNode
    }
    
    var unit: GameUnitCoreComponent? {
        return self.gameEntity?.unitComponent
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
        self.gameEntity = self.entity as? GameEntity
    }
    
    override func willRemoveFromEntity() {
        super.willRemoveFromEntity()
        self.gameEntity = nil
    }
    
    func jump(to position: SCNVector3) {
        if self.currentCooldown <= 0.0
            && self.unit?.state.canThrowSpell != false
            && self.unit?.state.canWalk != false {
            self.currentCooldown = GameJumpComponent.cooldown
            
            guard let positionNode = self.positionNode else {
                return
            }
            
            
            self.gameEntity?.component(ofType: GameWalkerComponent.self)?.interruptWalk()
            let jumper = self.model?.animationPlayer(forKey: "jump")
            jumper?.play()
            self.unit?.stateMachine.enter(GameStunnedState.self)
            
            let moveVector = position - positionNode.position
            let rotateAction = SCNAction.rotateTo(x: 0,
                                                  y: CGFloat(atan2(moveVector.x, moveVector.z)),
                                                  z: 0,
                                                  duration: jumpTime / 3,
                                                  usesShortestUnitArc: true)
            
            let jumpUpAction = SCNAction.move(by: SCNVector3(x: 0, y: jumpHeight, z: 0), duration: jumpTime / 2)
            jumpUpAction.timingMode = .easeOut
            let jumpDownAction = SCNAction.move(by: SCNVector3(x: 0, y: -jumpHeight, z: 0), duration: jumpTime / 2)
            jumpDownAction.timingMode = .easeIn
            
            positionNode.runAction(
                .group([
                    .sequence([jumpUpAction, jumpDownAction]),
                    .move(by: moveVector, duration: jumpTime),
                    rotateAction
                    ])) {
                        jumper?.stop()
                        self.unit?.stateMachine.enter(GameNormalState.self)
            }
            
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if self.currentCooldown > 0.0 {
            self.currentCooldown -= seconds
        }
    }
}
