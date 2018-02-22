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
    
    var modelComponent: GameModelComponent!
    var sceneComponent: GameSceneComponent!
    var agentComponent: GKAgent2D!
    
    // Game Actions
    var walkComponent: GameWalkerComponent!
    var tourbilolComponent: GameTourbilolComponent!
    
    override init() {
        super.init()
        if let model = GameModelComponent(withName: "fox") {
            self.modelComponent = model
            self.addComponent(self.modelComponent)
            model.loadAnimation(named: "walk")
            model.loadAnimation(named: "idle")
            model.loadAnimation(named: "jump")
            model.loadAnimation(named: "spin")
            print(modelComponent.animationsNames)
        }
        self.agentComponent = GKAgent2D()
        self.addComponent(self.agentComponent)
        
        self.sceneComponent = GameSceneComponent()
        self.addComponent(self.sceneComponent)
        
        self.walkComponent = GameWalkerComponent()
        self.addComponent(self.walkComponent)
        
        self.tourbilolComponent = GameTourbilolComponent()
        self.addComponent(self.tourbilolComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
