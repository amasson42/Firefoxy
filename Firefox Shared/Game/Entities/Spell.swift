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
    
    weak var caster: GKEntity?
    
    override func contactWith(entity: GameEntity) {
        if let caster = self.caster as? GameEntity,
            entity !== caster {
            entity.getBumpedFrom(entity: caster)
        }
    }
}

class TourbilolArea: SpellArea {
    
    var modelComponent: GameModelComponent!
    var sceneComponent: GameSceneComponent!
    
    init(castedBy caster: GKEntity?, forDuration duration: TimeInterval) {
        super.init()
        self.caster = caster
        
        let modelNode = SCNNode(geometry: SCNCylinder(radius: 0.65, height: 1.0))
        modelNode.opacity = 0.3
        modelNode.geometry?.materials.first?.diffuse.contents = UIColor.red
        self.modelComponent = GameModelComponent(withNode: modelNode)
        self.addComponent(self.modelComponent)
        
        self.sceneComponent = GameSceneComponent()
        self.addComponent(self.sceneComponent)
        self.sceneComponent.addPhysicalBody(radius: 0.65, category: GameCollisionCategory.spell, collision: GameCollisionCategory.unit, contactTest: GameCollisionCategory.unit)
        
        caster?.component(ofType: GameSceneComponent.self)?.positionNode.addChildNode(self.sceneComponent.positionNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
