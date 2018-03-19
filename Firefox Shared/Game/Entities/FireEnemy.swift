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
        super.init(name: "fireEnemy",
                   modelName: "fireEnemy",
                   loadingMode: .appleAsset)!
        self.sceneComponent.addPhysicalBody(radius: 0.2,
                                            elevation: 0.0,
                                            height: 0.5,
                                            category: GameCollisionCategory.unit,
                                            collision: GameCollisionCategory.spell,
                                            contactTest: GameCollisionCategory.spell)
        
        self.agentComponent.maxSpeed = 2
        self.agentComponent.maxAcceleration = 1000
        
        self.unitComponent = GameUnitCoreComponent()
        self.addComponent(self.unitComponent!)
        
        self.addComponent(AttackerOnSightComponent())
        self.addComponent(GameTourbilolComponent())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
