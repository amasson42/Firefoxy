//
//  GameEventsView.swift
//  Firefox macOS
//
//  Created by Arthur Masson on 26/02/2018.
//  Copyright © 2018 Arthur Masson. All rights reserved.
//

import SceneKit

protocol GameEventsViewDelegate: class {
    func handleMouseDown(at point: CGPoint, keyMouse: Int)
    func handleMouseUp(at point: CGPoint, keyMouse: Int)
    func handleMouseMoved(to point: CGPoint)
    func handleKeyDown(keyCode: UInt16)
    func handleKeyUp(keyCode: UInt16)
}

class GameEventsView: SCNView {
    
    weak var eventDelegate: GameEventsViewDelegate?
    
    var mousePosition: CGPoint?
    var mouseClicked: Bool = false
    var mouseRightClicked: Bool = false
    var keysDown: Set<UInt16> = []
    
    override func updateTrackingAreas() {
        self.trackingAreas.forEach {self.removeTrackingArea($0)}
        let trackingOptions: NSTrackingArea.Options = [.mouseMoved, .activeInKeyWindow, .mouseEnteredAndExited]
        let newTrackingArea = NSTrackingArea(rect: self.frame,
                                          options: trackingOptions,
                                          owner: self,
                                          userInfo: nil)
        self.addTrackingArea(newTrackingArea)
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        self.mouseClicked = true
        self.mousePosition = self.convert(event.locationInWindow, from: nil)
        self.eventDelegate?.handleMouseDown(at: self.mousePosition!, keyMouse: event.buttonNumber)
    }
    
    override func rightMouseDown(with event: NSEvent) {
        super.rightMouseDown(with: event)
        self.mouseRightClicked = true
        self.mousePosition = self.convert(event.locationInWindow, from: nil)
        self.eventDelegate?.handleMouseDown(at: self.mousePosition!, keyMouse: event.buttonNumber)
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        self.mouseClicked = false
        self.mousePosition = self.convert(event.locationInWindow, from: nil)
        self.eventDelegate?.handleMouseUp(at: self.mousePosition!, keyMouse: event.buttonNumber)
    }
    
    override func rightMouseUp(with event: NSEvent) {
        super.rightMouseUp(with: event)
        self.mouseRightClicked = false
        self.mousePosition = self.convert(event.locationInWindow, from: nil)
        self.eventDelegate?.handleMouseUp(at: self.mousePosition!, keyMouse: event.buttonNumber)
    }
    
    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        self.mousePosition = self.convert(event.locationInWindow, from: nil)
        self.eventDelegate?.handleMouseMoved(to: self.mousePosition!)
    }
    
    override func rightMouseDragged(with event: NSEvent) {
        super.rightMouseDragged(with: event)
        self.mousePosition = self.convert(event.locationInWindow, from: nil)
        self.eventDelegate?.handleMouseMoved(to: self.mousePosition!)
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        self.mousePosition = self.convert(event.locationInWindow, from: nil)
    }
    
    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        self.mousePosition = self.convert(event.locationInWindow, from: nil)
        self.eventDelegate?.handleMouseMoved(to: self.mousePosition!)
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        self.mousePosition = nil
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        return true
    }
    
    override func keyDown(with event: NSEvent) {
        self.keysDown.insert(event.keyCode)
        self.eventDelegate?.handleKeyDown(keyCode: event.keyCode)
    }
    
    override func keyUp(with event: NSEvent) {
        self.keysDown.remove(event.keyCode)
        self.eventDelegate?.handleKeyUp(keyCode: event.keyCode)
    }
    
}
