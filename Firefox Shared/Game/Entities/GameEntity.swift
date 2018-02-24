//
//  GameEntity.swift
//  Firefox
//
//  Created by Arthur Masson on 18/02/2018.
//  Copyright © 2018 Arthur Masson. All rights reserved.
//

import GameplayKit

class GameEntity: GKEntity {
    
    weak var game: GameController?
    
    let modelComponent: GameModelComponent
    let agentComponent: GKAgent2D
    let sceneComponent: GameSceneComponent
    
    var unitComponent: GameUnitCoreComponent?
    
    init?(modelName: String, modelAnimations: [String] = []) {
        if let model = GameModelComponent(withName: modelName) {
            self.modelComponent = model
            for modelAnimation in modelAnimations {
                model.loadAnimation(named: modelAnimation)
            }
        } else {
            return nil
        }
        self.agentComponent = GKAgent2D()
        self.sceneComponent = GameSceneComponent()
        super.init()
        self.postInit()
    }
    
    init(model: SCNNode) {
        self.modelComponent = GameModelComponent(withNode: model)
        self.agentComponent = GKAgent2D()
        self.sceneComponent = GameSceneComponent()
        super.init()
        self.postInit()
    }
    
    private func postInit() {
        self.addComponent(self.modelComponent)
        self.addComponent(self.agentComponent)
        self.addComponent(self.sceneComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func contactWith(entity: GameEntity) {
        
    }
    
    func getBumpedFrom(entity: GameEntity) {
        
    }
    
}

