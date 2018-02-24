//
//  UnitStates.swift
//  Firefox
//
//  Created by Arthur Masson on 24/02/2018.
//  Copyright © 2018 Arthur Masson. All rights reserved.
//

import Foundation
import GameplayKit

extension GKStateMachine {
    
    convenience init(gameEntity: GameEntity) {
        self.init(states: [GameNormalState(entity: gameEntity), GameStunnedState(entity: gameEntity)])
        self.enter(GameNormalState.self)
    }
    
}

class GameNormalState: GKState {
    
    var entity: GameEntity
    
    init(entity: GameEntity) {
        self.entity = entity
    }
    
}

class GameStunnedState: GKState {
    
    var entity: GameEntity
    
    init(entity: GameEntity) {
        self.entity = entity
    }
    
}
