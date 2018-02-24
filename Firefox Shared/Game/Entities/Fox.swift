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
    var walkComponent: GameWalkerComponent
    var tourbilolComponent: GameTourbilolComponent
    
    init() {
        self.walkComponent = GameWalkerComponent()
        self.tourbilolComponent = GameTourbilolComponent()
        super.init(modelName: "fox", modelAnimations: ["walk", "idle", "jump", "spin"])!
        self.addComponent(self.walkComponent)
        self.addComponent(self.tourbilolComponent)
        
        self.unitComponent = GameUnitCoreComponent()
        self.addComponent(self.unitComponent!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
