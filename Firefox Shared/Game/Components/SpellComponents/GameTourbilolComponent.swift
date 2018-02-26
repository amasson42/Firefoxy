//
//  GameTourbilolComponent.swift
//  Firefox
//
//  Created by Arthur Masson on 17/02/2018.
//  Copyright © 2018 Arthur Masson. All rights reserved.
//

import GameplayKit
import SceneKit

class GameTourbilolComponent: GKComponent {
    
    static let cooldown: TimeInterval = 2.0
    var currentCooldown: TimeInterval = 0.0
    
    var model: SCNNode? {
        return self.entity?.component(ofType: GameModelComponent.self)?.model
    }
    
    var positionNode: SCNNode? {
        return self.entity?.component(ofType: GameSceneComponent.self)?.positionNode
    }
    
    var unit: GameUnitCoreComponent? {
        return self.entity?.component(ofType: GameUnitCoreComponent.self)
    }
    
    func tourbilol() {
        if self.currentCooldown <= 0.0
            && self.unit?.state.canThrowSpell != false {
            self.currentCooldown = GameTourbilolComponent.cooldown
            self.entity?.component(ofType: GameWalkerComponent.self)?.interruptWalk()
            let spiner = self.model?.animationPlayer(forKey: "spin")
            spiner?.play()
            
            if let positionNode = self.positionNode {
                let duration = spiner?.animation.duration ?? 1.0
                let tourbilolArea = TourbilolArea(castedBy: self.entity as? GameEntity, forDuration: duration)
                
                (self.entity as? GameEntity)?.game?.add(entity: tourbilolArea)
                positionNode.addChildNode(tourbilolArea.sceneComponent.positionNode)
                
                tourbilolArea.sceneComponent.positionNode.runAction(.sequence([.wait(duration: spiner?.animation.duration ?? 1.0), .removeFromParentNode()]))
            }
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if self.currentCooldown > 0.0 {
            self.currentCooldown -= seconds
        }
    }
}
