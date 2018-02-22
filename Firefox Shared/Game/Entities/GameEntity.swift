//
//  GameEntity.swift
//  Firefox
//
//  Created by Arthur Masson on 18/02/2018.
//  Copyright © 2018 Arthur Masson. All rights reserved.
//

import GameplayKit

struct GameCollisionCategory {
    private init() {}
    static let none: Int = 0
    static let unit: Int = 1
    static let spell: Int = 2
}

class GameEntity: GKEntity {
    
    weak var game: GameController?
    
    func contactWith(entity: GameEntity) {
        
    }
    
    func getBumpedFrom(entity: GameEntity) {
        
    }
}
