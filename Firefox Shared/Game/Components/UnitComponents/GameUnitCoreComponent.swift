//
//  GameUnitCoreComponent.swift
//  Firefox
//
//  Created by Arthur Masson on 24/02/2018.
//  Copyright © 2018 Arthur Masson. All rights reserved.
//

import GameplayKit

class GameUnitCoreComponent: GKComponent {
    
    var stateMachine: GKStateMachine!
    var state: GameState {
        return self.stateMachine.currentGameState!
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        guard let entity = self.entity as? GameEntity else {
            return
        }
        self.stateMachine = GKStateMachine(gameEntity: entity)
    }
    
    override func willRemoveFromEntity() {
        self.stateMachine = nil
    }
}
