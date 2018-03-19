//
//  AttackerOnSightComponent.swift
//  Firefox
//
//  Created by Arthur Masson on 18/03/2018.
//  Copyright © 2018 Arthur Masson. All rights reserved.
//

import GameplayKit

class AttackerOnSightComponent: GKComponent {
    
    static let orderCooldown: TimeInterval = 5.0
    var currentOrderCooldown: TimeInterval = 0.0
    
    var gameEntity: GameEntity? {
        return self.entity as? GameEntity
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        if self.currentOrderCooldown > 0 {
            
            self.currentOrderCooldown -= seconds
            
        } else {
            
            if let gameEntity = self.gameEntity,
                let game = gameEntity.game,
                let tourbilol = gameEntity.component(ofType: GameTourbilolComponent.self) {
                
                let position = gameEntity.sceneComponent.positionNode.position
                
                if !(game.entities(atPoint: float2(Float(position.x), Float(position.z)), withRange: GameTourbilolComponent.range).filter {$0.unitComponent?.team != gameEntity.unitComponent?.team}.isEmpty) {
                    
                    DispatchQueue.main.async {
                        tourbilol.tourbilol()
                    }
                    
                    self.currentOrderCooldown = AttackerOnSightComponent.orderCooldown
                }
                
            }
            
        }
        
    }
    
}
