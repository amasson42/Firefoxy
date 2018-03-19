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
        self.gameView.allowsCameraControl = false
        
        // Show statistics such as fps and timing information
        self.gameView.showsStatistics = true
        
        // Configure the view
        self.gameView.backgroundColor = NSColor.black
        
        self.gameView.eventDelegate = self
    }
    
}

extension GameViewController: GameEventsViewDelegate {
    
    func handleMouseDown(at point: CGPoint, keyMouse: Int) {
        print(#function, point, keyMouse)
        switch keyMouse {
        case 0: // left click
            break
        case 1: // right click
            self.gameController.eventTouch(at: point)
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
        guard let position = self.gameView.mousePosition else {
            return
        }
        self.gameController.eventButtonAction(key: keyCode, at: position)
    }
    
    func handleKeyUp(keyCode: UInt16) {
        print(#function, keyCode)
    }
    
}
