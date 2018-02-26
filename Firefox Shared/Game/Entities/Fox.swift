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
    
    init() {
        super.init(modelName: "fox", modelAnimations: ["walk", "idle", "jump", "spin"], loadingMode: .appleAsset)!
        self.addComponent(self.walkComponent)
        self.addComponent(self.tourbilolComponent)
        self.addComponent(self.fireballComponent)
        
        self.unitComponent = GameUnitCoreComponent()
        self.addComponent(self.unitComponent!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
