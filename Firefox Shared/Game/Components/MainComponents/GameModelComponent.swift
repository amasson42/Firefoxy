//
//  GameModelComponent.swift
//  Firefox iOS
//
//  Created by Arthur Masson on 17/02/2018.
//  Copyright © 2018 Arthur Masson. All rights reserved.
//

import GameplayKit
import SceneKit

class GameModelComponent: GKComponent {
    
    let name: String
    var model: SCNNode!
    var animationsNames: Set<String> = []
    
    enum LoadingMode {
        case appleAsset
    }
    
    init(withNode node: SCNNode) {
        self.name = node.name ?? "unamed"
        super.init()
        self.model = node
    }
    
    init?(withName name: String, loadingMode: LoadingMode) {
        self.name = name
        super.init()
        switch loadingMode {
        case .appleAsset:
            if self.loadModelAppleAsset(withName: name) == false {
                return nil
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadModelAppleAsset(withName name: String) -> Bool {
        guard let charScene = SCNScene(named: "Art.scnassets/\(name)/\(name).scn"),
            let charModel = charScene.rootNode.childNodes.first else {
                return false
        }
        charModel.name = "\(name)_model"
        self.model = charModel
        return true
    }
    
    @discardableResult
    func loadAnimation(named animationName: String, loadingMode: LoadingMode) -> Bool {
        switch loadingMode {
        case .appleAsset:
            return self.loadAnimationAppleAsset(named: animationName)
        }
    }
    
    func loadAnimationAppleAsset(named animationName: String) -> Bool {
        
        func loadAnimationPlayer(fromSceneNamed sceneName: String) -> SCNAnimationPlayer? {
            guard let scene = SCNScene(named: sceneName) else {
                return nil
            }
            var animationPlayer: SCNAnimationPlayer? = nil
            scene.rootNode.enumerateChildNodes {
                (child, stop) in
                if !child.animationKeys.isEmpty {
                    animationPlayer = child.animationPlayer(forKey: child.animationKeys[0])
                    stop.pointee = true
                }
            }
            return animationPlayer
        }
        
        guard !self.animationsNames.contains(animationName),
            let player = loadAnimationPlayer(fromSceneNamed: "Art.scnassets/\(self.name)/\(self.name)_\(animationName).scn") else {
                return false
        }
        self.model.addAnimationPlayer(player, forKey: animationName)
        self.animationsNames.insert(animationName)
        player.animation.isRemovedOnCompletion = false
        player.stop()
        return true
    }
}
