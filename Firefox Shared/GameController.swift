//
//  GameController.swift
//  Firefox Shared
//
//  Created by Arthur Masson on 01/10/2017.
//  Copyright © 2017 Arthur Masson. All rights reserved.
//

import SceneKit
import GameplayKit

#if os(macOS)
    typealias SCNColor = NSColor
#else
    typealias SCNColor = UIColor
#endif

protocol GameEntitiesManager {
    
    var entities: Set<GameEntity> {get}
    
    func entities(atPoint point: float2, withRange range: Float) -> [GameEntity]
    func entities(allyWith entity: GameEntity) -> [GameEntity]
    func entities(enemyWith entity: GameEntity) -> [GameEntity]
    
}

extension GameController: GameEntitiesManager {
    
    func entities(atPoint point: float2, withRange range: Float) -> [GameEntity] {
        let position = SCNVector3(point.x, 0, point.y)
        return self.entities.filter {
            $0.sceneComponent.positionNode.position.distanceTo(point: position) < SCNFloat(range)
        }
    }
    
    func entities(allyWith entity: GameEntity) -> [GameEntity] {
        return self.entities.filter {$0.unitComponent?.team == entity.unitComponent?.team}
    }
    
    func entities(enemyWith entity: GameEntity) -> [GameEntity] {
        return self.entities.filter {$0.unitComponent?.team != entity.unitComponent?.team}
    }
    
}

class GameController: NSObject, SCNSceneRendererDelegate {

    let scene: SCNScene
    let sceneRenderer: SCNSceneRenderer
    
    // characters
    var lightNode: SCNNode!
    var followCamera: SCNNode!
    var foxChar: GameEntity!
    var entities: Set<GameEntity> = []
    
    init(sceneRenderer renderer: SCNSceneRenderer) {
        sceneRenderer = renderer
        scene = SCNScene()
        
        super.init()
        
        sceneRenderer.delegate = self
        sceneRenderer.scene = scene
        
        sceneRenderer.scene?.physicsWorld.contactDelegate = self
        
        spawnGround()
        loadUnits()
    }
    
    func spawnGround() {
        let groundNode = SCNNode(geometry: SCNCylinder(radius: 10, height: 1.0))
        groundNode.name = "ground"
        groundNode.position.y = -0.5
        groundNode.geometry!.firstMaterial!.diffuse.contents = SCNColor.green
        scene.rootNode.addChildNode(groundNode)
        
        self.lightNode = SCNNode()
        self.lightNode.name = "lights"
        scene.rootNode.addChildNode(self.lightNode)
        let lightNode = SCNNode()
        lightNode.name = "lightNode"
        lightNode.light = SCNLight()
        lightNode.light!.intensity *= 0.5
        lightNode.light!.type = .spot
        lightNode.light!.spotInnerAngle *= 2
        lightNode.light!.spotOuterAngle *= 2
        lightNode.position = SCNVector3(x: 0, y: 6, z: 3)
        lightNode.eulerAngles.x = -.pi / 3
        lightNode.light!.castsShadow = true
        self.lightNode.addChildNode(lightNode)
        
        let cameraNode = SCNNode()
        cameraNode.name = "cameraNode"
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: -2, y: 6, z: 3)
        cameraNode.eulerAngles = SCNVector3(x: -.pi / 3, y: -.pi / 8, z: 0)
        let followCamera = SCNNode()
        followCamera.addChildNode(cameraNode)
        scene.rootNode.addChildNode(followCamera)
        sceneRenderer.pointOfView = cameraNode
        self.followCamera = followCamera
    }
    
    func add(entity: GameEntity) {
        self.entities.insert(entity)
        self.scene.rootNode.addChildNode(entity.sceneComponent.positionNode)
        entity.game = self
    }
    
    func remove(entity: GameEntity) {
        self.entities.remove(entity)
        entity.sceneComponent.positionNode.removeFromParentNode()
        entity.game = nil
    }
    
    func loadUnits() {
        self.foxChar = Fox()
        self.foxChar.unitComponent?.team = 1
        self.add(entity: self.foxChar)
        
        do {
            let enemy = FireEnemy()
            enemy.unitComponent?.team = 2
            let wanderGoal = GKGoal(toWander: 3)
            let speedGoal = GKGoal(toReachTargetSpeed: 2)
            let followGoal = GKGoal(toSeekAgent: self.foxChar.agentComponent)
            enemy.agentComponent.behavior = GKBehavior(goals: [wanderGoal, followGoal, speedGoal], andWeights: [0.5, 1, 0.2])
            self.add(entity: enemy)
        }
        
        for _ in 0...10 {
            let enemy = FireEnemy()
            enemy.unitComponent?.team = 2
            let wanderGoal = GKGoal(toWander: 5)
            enemy.agentComponent.behavior = GKBehavior(goal: wanderGoal, weight: 1.0)
            enemy.sceneComponent.positionNode.position = SCNVector3.random(inBounds: (
                min: SCNVector3(x: -10, y: 0, z: -10),
                max: SCNVector3(x: 10, y: 0, z: 10)
            ))
            self.add(entity: enemy)
        }
    }
    
    func eventTouch(at point: CGPoint) {
        let hitResults = self.sceneRenderer.hitTest(point, options: [:])
        guard var worldPoint = hitResults.first?.worldCoordinates else {
            return
        }
        worldPoint.y = 0
        self.foxChar.component(ofType: GameWalkerComponent.self)?.orderWalk(to: worldPoint)
    }
    
    func eventOverTouch(at point: CGPoint) {
        
    }
    
    func eventButtonAction(key: UInt16, at point: CGPoint) {
        let hitResults = self.sceneRenderer.hitTest(point, options: [:])
        guard var worldPoint = hitResults.first?.worldCoordinates else {
            return
        }
        worldPoint.y = 0
        let charDirection = worldPoint - self.foxChar.sceneComponent.positionNode.position
        
        switch key {
        case 12: // Q
            self.foxChar.component(ofType: GameFireballComponent.self)?.fireball(to: charDirection)
        case 13: // W
            self.foxChar.component(ofType: GameTourbilolComponent.self)?.tourbilol()
        case 14: // E
            self.foxChar.component(ofType: GameJumpComponent.self)?.jump(to: worldPoint)
        case 15: // R
            break
        default:
            break
        }
    }
    
    var lastTimeInterval: TimeInterval = 0.0
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let dt = lastTimeInterval == 0.0 ? 0.0 : time - lastTimeInterval
        lastTimeInterval = time
        
        if let positionNode = self.foxChar.component(ofType: GameSceneComponent.self)?.positionNode {
            self.lightNode.position = positionNode.position
        }
        
        for char in self.entities {
            char.update(deltaTime: dt)
        }
        
        self.followCamera.position = self.foxChar.sceneComponent.positionNode.position
    }
    
}

extension GameController: SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if let entityA = contact.nodeA.entity as? GameEntity,
            let entityB = contact.nodeB.entity as? GameEntity {
            entityA.contactWith(entity: entityB)
            entityB.contactWith(entity: entityA)
        }
    }
    
}
