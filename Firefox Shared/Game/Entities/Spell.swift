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
        
        let modelNode = SCNNode(geometry: SCNCylinder(radius: 0.65, height: 0.5))
        modelNode.position.y = 0.25
        modelNode.opacity = 0.3
        modelNode.geometry?.materials.first?.diffuse.contents = UIColor.red
        
        super.init(model: modelNode)
        
        self.sceneComponent.positionNode.name = "spell_tourbilol"
        
        self.caster = caster
        
        self.sceneComponent.addPhysicalBody(radius: 0.65,
                                            category: GameCollisionCategory.spell,
                                            collision: GameCollisionCategory.unit,
                                            contactTest: GameCollisionCategory.unit)
        
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

class FireballProjectile: SpellArea {
    
    init(castedBy caster: GameEntity?, toDirection direction: SCNVector3) {
        
        let modelNode = SCNNode(geometry: SCNSphere(radius: 0.1))
        modelNode.position.y = 0.25
        modelNode.geometry?.materials.first?.diffuse.contents = UIColor.red
        
        super.init(model: modelNode)
        
        self.sceneComponent.positionNode.name = "spell_fireball"
        
        self.caster = caster
        
        let physicsBody = self.sceneComponent.addPhysicalBody(radius: 0.1,
                                                             type: .dynamic,
                                                             category: GameCollisionCategory.spell,
                                                             collision: GameCollisionCategory.unit,
                                                             contactTest: GameCollisionCategory.unit)
        
        if let caster = self.caster {
            self.sceneComponent.positionNode.position = caster.sceneComponent.positionNode.position
            caster.game?.add(entity: self)
            physicsBody.isAffectedByGravity = false
            physicsBody.applyForce(direction, asImpulse: false)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func applyTo(entity: GameEntity) {
        if let caster = self.caster,
            caster !== entity {
            entity.getBumpedFrom(entity: self)
            self.sceneComponent.positionNode.removeFromParentNode()
        }
    }
}
