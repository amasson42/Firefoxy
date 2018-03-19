//
//  GameFireballComponent.swift
//  Firefox
//
//  Created by Arthur Masson on 25/02/2018.
//  Copyright © 2018 Arthur Masson. All rights reserved.
//

import GameplayKit
import SceneKit

class GameFireballComponent: GKComponent {
    
    static let cooldown: TimeInterval = 0.5
    var currentCooldown: TimeInterval = 0.0
    
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
    
    func fireball(to direction: SCNVector3) {
        if self.currentCooldown <= 0.0
            && self.unit?.state.canThrowSpell != false {
            self.currentCooldown = GameFireballComponent.cooldown
            
            let jumper = self.model?.animationPlayer(forKey: "spin")
            jumper?.play()
            
            let fireballProjectile = FireballProjectile(castedBy: self.entity as? GameEntity, toDirection: direction)
            
            (self.entity as? GameEntity)?.game?.add(entity: fireballProjectile)
            
            fireballProjectile.sceneComponent.positionNode.runAction(.sequence([
                .wait(duration: 15.0),
                .run {
                    _ in
                    fireballProjectile.game?.remove(entity: fireballProjectile)
                }
                ]))
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if self.currentCooldown > 0.0 {
            self.currentCooldown -= seconds
        }
    }
}

