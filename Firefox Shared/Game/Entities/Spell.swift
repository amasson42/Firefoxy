//
//  Spell.swift
//  Firefox
//
//  Created by Arthur Masson on 18/02/2018.
//  Copyright © 2018 Arthur Masson. All rights reserved.
//

import GameplayKit
import SceneKit

#if os(macOS)
    typealias UIColor = NSColor
#endif

class SpellArea: GameEntity {
    
    weak var caster: GameEntity?
    var hits: [GameEntity] = []
    
    override func contactWith(entity: GameEntity) {
        if self.hits.contains(entity) {
            return
        }
        self.hits.append(entity)
        self.applyTo(entity: entity)
    }
    
    func applyTo(entity: GameEntity) {
        
    }
}

class TourbilolArea: SpellArea {
    
    init(castedBy caster: GameEntity?, forDuration duration: TimeInterval) {
        
        let modelNode = SCNNode(geometry: SCNCylinder(radius: 0.65, height: 1.0))
        modelNode.opacity = 0.3
        modelNode.geometry?.materials.first?.diffuse.contents = UIColor.red
        
        super.init(model: modelNode)
        
        self.caster = caster
        
        self.sceneComponent.addPhysicalBody(radius: 0.65, category: GameCollisionCategory.spell, collision: GameCollisionCategory.unit, contactTest: GameCollisionCategory.unit)
        
        caster?.sceneComponent.positionNode.addChildNode(self.sceneComponent.positionNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func applyTo(entity: GameEntity) {
        if let caster = self.caster,
            caster !== entity {
            entity.getBumpedFrom(entity: caster)
        }
    }
}
