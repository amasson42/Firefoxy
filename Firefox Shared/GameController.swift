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

class GameController: NSObject, SCNSceneRendererDelegate {

    let scene: SCNScene
    let sceneRenderer: SCNSceneRenderer
    
    // characters
    var lightNode: SCNNode!
    var foxChar: GameEntity!
    var activesCharacters: Set<GameEntity> = []
    
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
        let groundNode = SCNNode(geometry: SCNCylinder(radius: 5, height: 1.0))
        groundNode.position.y = -0.5
        groundNode.geometry!.firstMaterial!.diffuse.contents = SCNColor.green
        scene.rootNode.addChildNode(groundNode)
        
        self.lightNode = SCNNode()
        scene.rootNode.addChildNode(self.lightNode)
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.intensity *= 0.5
        lightNode.light!.type = .spot
        lightNode.position = SCNVector3(x: 0, y: 6, z: 3)
        lightNode.eulerAngles.x = -.pi / 3
        lightNode.light!.castsShadow = true
        self.lightNode.addChildNode(lightNode)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: -2, y: 6, z: 3)
        cameraNode.eulerAngles = SCNVector3(x: -.pi / 3, y: -.pi / 8, z: 0)
        scene.rootNode.addChildNode(cameraNode)
        sceneRenderer.pointOfView = cameraNode
    }
    
    func add(entity: GameEntity) {
        self.activesCharacters.insert(entity)
        self.scene.rootNode.addChildNode(entity.sceneComponent.positionNode)
        entity.game = self
    }
    
    func loadUnits() {
        let fox = Fox()
        self.foxChar = fox
        self.add(entity: self.foxChar)
        fox.modelComponent.model.animationPlayer(forKey: "idle")?.play()
        
        let enemy = FireEnemy()
        let wanderGoal = GKGoal(toWander: 3)
        let speedGoal = GKGoal(toReachTargetSpeed: 2)
        let followGoal = GKGoal(toSeekAgent: fox.agentComponent)
        enemy.agentComponent.maxSpeed = 2
        enemy.agentComponent.maxAcceleration = 1000
        enemy.agentComponent.behavior = GKBehavior(goals: [wanderGoal, followGoal, speedGoal], andWeights: [0.5, 1, 0.2])
        self.add(entity: enemy)
    }
    
    func touch(at point: CGPoint) {
        let hitResults = self.sceneRenderer.hitTest(point, options: [:])
        guard var worldPoint = hitResults.first?.worldCoordinates else {
            return
        }
        worldPoint.y = 0
        self.foxChar.component(ofType: GameWalkerComponent.self)?.orderWalk(to: worldPoint)
    }
    
    func buttonAction(key: UInt16) {
        switch key {
        case 12: // Q
            self.foxChar.component(ofType: GameFireballComponent.self)?.fireball(to: SCNVector3(0, 0, 0))
        case 13:
            self.foxChar.component(ofType: GameTourbilolComponent.self)?.tourbilol()
        default:
            break
        }
    }
    
    var lastTimeInterval: TimeInterval = 0.0
    
    lazy var renderFunc: (SCNSceneRenderer, TimeInterval) -> () = firstTimeRendering
    
    func firstTimeRendering(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        self.lastTimeInterval = time
        self.renderFunc = usualTimeRendering
    }
    
    func usualTimeRendering(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let dt = time - lastTimeInterval
        lastTimeInterval = time
        
        if let positionNode = self.foxChar.component(ofType: GameSceneComponent.self)?.positionNode {
            self.lightNode.position = positionNode.position
        }
        
        for char in self.activesCharacters {
            char.update(deltaTime: dt)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        self.renderFunc(renderer, time)
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
