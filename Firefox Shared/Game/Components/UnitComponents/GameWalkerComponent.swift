//
//  GameWalkerComponent.swift
//  Firefox
//
//  Created by Arthur Masson on 17/02/2018.
//  Copyright © 2018 Arthur Masson. All rights reserved.
//

import GameplayKit
import SceneKit

class GameWalkerComponent: GKComponent {
    
    var walkSpeed: CGFloat = 1.0
    
    var positionNode: SCNNode? {
        return self.entity?.component(ofType: GameSceneComponent.self)?.positionNode
    }
    var model: SCNNode? {
        return self.entity?.component(ofType: GameModelComponent.self)?.model
    }
    
    func orderWalk(to point: SCNVector3) {
        guard let positionNode = self.positionNode else {
            return
        }
        let distance = positionNode.position.distanceTo(point: point)
        let time = TimeInterval(CGFloat(distance) / self.walkSpeed)
        let moveVector = point - positionNode.position
        let rotateAction = SCNAction.rotateTo(x: 0,
                                              y: CGFloat(atan2(moveVector.x, moveVector.z)),
                                              z: 0,
                                              duration: TimeInterval(.pi / self.walkSpeed / 12),
                                              usesShortestUnitArc: true)
        let moveAction: SCNAction = .group([rotateAction, .move(to: point, duration: time)])
        
        guard let model = self.model else {
            positionNode.runAction(moveAction, forKey: "walk")
            return
        }
        let idler = model.animationPlayer(forKey: "idle")
        idler?.blendFactor = 0.0
        if let walker = model.animationPlayer(forKey: "walk") {
            if walker.paused {
                walker.play()
            }
            walker.speed = self.walkSpeed
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.2
            walker.blendFactor = 1.0
            SCNTransaction.commit()
            positionNode.runAction(moveAction, forKey: "walk") {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                walker.blendFactor = 0.0
                idler?.blendFactor = 1.0
                SCNTransaction.commit()
            }
        } else {
            positionNode.runAction(moveAction, forKey: "walk")
        }
    }
}
