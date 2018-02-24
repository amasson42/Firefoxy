//
//  FireEnemy.swift
//  Firefox
//
//  Created by Arthur Masson on 18/02/2018.
//  Copyright © 2018 Arthur Masson. All rights reserved.
//

import GameplayKit
import SceneKit

class FireEnemy: GameEntity {
    
    init() {
        super.init(modelName: "fireEnemy")!
        self.sceneComponent.addPhysicalBody(radius: 0.3, category: GameCollisionCategory.unit, collision: GameCollisionCategory.spell, contactTest: GameCollisionCategory.spell)
        
        self.unitComponent = GameUnitCoreComponent()
        self.addComponent(self.unitComponent!)
    }
    
    override func getBumpedFrom(entity: GameEntity) {
        if let agentComponent = entity.component(ofType: GKAgent2D.self) {
            let sp = self.agentComponent.position
            let ep = agentComponent.position
            let direction = vector_float2(sp.x - ep.x, sp.y - ep.y)
            let norme = sqrt(direction.x * direction.x + direction.y * direction.y)
            let normed = vector_float2(direction.x / norme, direction.y / norme)
            
            let moveAction = SCNAction.move(by: SCNVector3(normed.x, 0.0, normed.y), duration: 1.0)
            let jumpUpAction = SCNAction.move(by: SCNVector3(x: 0, y: 1.0, z: 0), duration: 0.5)
            jumpUpAction.timingMode = .easeOut
            let jumpDownAction = SCNAction.move(by: SCNVector3(x: 0, y: -1.0, z: 0), duration: 0.5)
            jumpDownAction.timingMode = .easeIn
            
            let bumpAction = SCNAction.group([moveAction, .sequence([jumpUpAction, jumpDownAction])])
            
            self.unitComponent?.state.enter(GameStunnedState.self)
            self.sceneComponent.positionNode.runAction(bumpAction, forKey: "bumped") {
                self.unitComponent?.state.enter(GameNormalState.self)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
