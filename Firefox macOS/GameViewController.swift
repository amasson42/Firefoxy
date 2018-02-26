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
    
    var gameView: GameEventsView {
        return self.view as! GameEventsView
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
        
        self.gameView.eventDelegate = self
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

extension GameViewController: GameEventsViewDelegate {
    
    func handleMouseDown(at point: CGPoint, keyMouse: Int) {
        print(#function, point, keyMouse)
        switch keyMouse {
        case 0: // left click
            break
        case 1: // right click
            self.gameController.touch(at: point)
        default:
            break
        }
    }
    
    func handleMouseUp(at point: CGPoint, keyMouse: Int) {
        print(#function, point, keyMouse)
        
    }
    
    func handleMouseMoved(to point: CGPoint) {
        print(#function, point)
        
    }
    
    func handleKeyDown(keyCode: UInt16) {
        print(#function, keyCode)
        self.gameController.buttonAction(key: keyCode)
        
    }
    
    func handleKeyUp(keyCode: UInt16) {
        print(#function, keyCode)
        
    }
    
}
