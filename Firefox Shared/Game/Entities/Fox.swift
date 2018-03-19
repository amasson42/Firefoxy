//
//  Fox.swift
//  Firefox
//
//  Created by Arthur Masson on 18/02/2018.
//  Copyright © 2018 Arthur Masson. All rights reserved.
//

import GameplayKit
import SceneKit

class Fox: GameEntity {
    
    // Game Actions
    var walkComponent: GameWalkerComponent = GameWalkerComponent()
    var tourbilolComponent: GameTourbilolComponent = GameTourbilolComponent()
    var fireballComponent: GameFireballComponent = GameFireballComponent()
    var jumpComponent: GameJumpComponent = GameJumpComponent()
    
    init() {
        super.init(name: "fox",
                   modelName: "fox",
                   modelAnimations: ["walk", "idle", "jump", "spin"],
                   loadingMode: .appleAsset)!
        self.sceneComponent.addPhysicalBody(radius: 0.2,
                                            elevation: 0.0,
                                            height: 0.5,
                                            category: GameCollisionCategory.unit,
                                            collision: GameCollisionCategory.spell,
                                            contactTest: GameCollisionCategory.spell)
        self.modelComponent.model.animationPlayer(forKey: "idle")?.play()
        self.addComponent(self.walkComponent)
        self.addComponent(self.tourbilolComponent)
        self.addComponent(self.fireballComponent)
        self.addComponent(self.jumpComponent)
        
        self.unitComponent = GameUnitCoreComponent()
        self.addComponent(self.unitComponent!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
