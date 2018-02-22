//
//  GameViewController.swift
//  Firefox iOS
//
//  Created by Arthur Masson on 01/10/2017.
//  Copyright © 2017 Arthur Masson. All rights reserved.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {
    
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
        self.gameView.backgroundColor = UIColor.black
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTouch(_:)))
        gameView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTouch(_ gesture: UIGestureRecognizer) {
        gameController.touch(at: gesture.location(in: gameView))
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
