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
    
    var modelComponent: GameModelComponent!
    var sceneComponent: GameSceneComponent!
    var agentComponent: GKAgent2D!
    
    override init() {
        super.init()
        if let model = GameModelComponent(withName: "fireEnemy") {
            self.modelComponent = model
            self.addComponent(self.modelComponent)
        }
        self.agentComponent = GKAgent2D()
        self.addComponent(self.agentComponent)
        
        self.sceneComponent = GameSceneComponent()
        self.addComponent(self.sceneComponent)
        self.sceneComponent.addPhysicalBody(radius: 0.3, category: GameCollisionCategory.unit, collision: GameCollisionCategory.spell, contactTest: GameCollisionCategory.spell)
    }
    
    override func contactWith(entity: GameEntity) {
        
    }
    
    override func getBumpedFrom(entity: GameEntity) {
        print("get bumped")
        if let agentComponent = entity.component(ofType: GKAgent2D.self) {
            let sp = self.agentComponent.position
            let ep = agentComponent.position
            self.agentComponent.rotation = atan2(sp.y - ep.y, sp.x - ep.x)
            self.agentComponent.update(deltaTime: 1.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
