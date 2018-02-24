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
    
    var currentGameState: GameState? {
        return self.currentState as? GameState
    }
    
    convenience init(gameEntity: GameEntity) {
        self.init(states: [GameNormalState(entity: gameEntity), GameStunnedState(entity: gameEntity)])
        self.enter(GameNormalState.self)
    }
    
}

class GameState: GKState {
    
    var entity: GameEntity
    
    init(entity: GameEntity) {
        self.entity = entity
    }
    
    var canWalk: Bool {
        return true
    }
    
    var canAttack: Bool {
        return true
    }
    
    var canThrowSpell: Bool {
        return true
    }
    
}

class GameNormalState: GameState {
    
}

class GameStunnedState: GameState {
    
    override var canWalk: Bool {return false}
    override var canAttack: Bool {return false}
    override var canThrowSpell: Bool {return false}
    
}

class GameSilencedState: GameState {
    
    override var canThrowSpell: Bool {return false}
    
}
