//
//  GameViewController.swift
//  Firefox macOS
//
//  Created by Arthur Masson on 01/10/2017.
//  Copyright © 2017 Arthur Masson. All rights reserved.
//

import Cocoa
import SceneKit

class GameViewController: NSViewController {
    
    var gameView: SCNView {
        return self.view as! SCNView
    }
    
    var gameController: GameController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gameController = GameController(sceneRenderer: gameView)
        
        // Allow the user to manipulate the camera
        self.gameView.allowsCameraControl = true
        
        // Show statistics such as fps and timing information
        self.gameView.showsStatistics = true
        
        // Configure the view
        self.gameView.backgroundColor = NSColor.black
        
        let mouseGesture = NSClickGestureRecognizer(target: self, action: #selector(click(gesture:)))
        mouseGesture.buttonMask = 2
        gameView.addGestureRecognizer(mouseGesture)
    }
    
    override func keyDown(with event: NSEvent) {
        print(#function, event.keyCode)
        switch event.keyCode {
        default:
            self.gameController.buttonAction(key: event.keyCode)
        }
    }
    
    override func keyUp(with event: NSEvent) {
        switch event.keyCode {
        default:
            break
        }
    }
    
    @objc func click(gesture: NSClickGestureRecognizer) {
        gameController.touch(at: gesture.location(in: gameView))
    }
}
