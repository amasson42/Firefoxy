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
    
    let name: String
    let modelComponent: GameModelComponent
    let agentComponent: GKAgent2D
    let sceneComponent: GameSceneComponent
    
    var unitComponent: GameUnitCoreComponent?
    
    init?(name: String,
          modelName: String,
          modelAnimations: [String] = [],
          loadingMode: GameModelComponent.LoadingMode) {
        self.name = name
        if let model = GameModelComponent(withName: modelName, loadingMode: loadingMode) {
            self.modelComponent = model
            for modelAnimation in modelAnimations {
                model.loadAnimation(named: modelAnimation, loadingMode: loadingMode)
            }
        } else {
            return nil
        }
        self.agentComponent = GKAgent2D()
        self.sceneComponent = GameSceneComponent()
        super.init()
        self.postInit()
    }
    
    init(name: String, model: SCNNode) {
        self.name = name
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
            
            self.unitComponent?.stateMachine.enter(GameStunnedState.self)
            self.sceneComponent.positionNode.runAction(bumpAction) {
                self.unitComponent?.stateMachine.enter(GameNormalState.self)
            }
        }
    }
    
}

