//
//  SCNVector.swift
//  Firefox iOS
//
//  Created by Arthur Masson on 17/02/2018.
//  Copyright © 2018 Arthur Masson. All rights reserved.
//

import SceneKit

extension SCNVector3 {
    
    static func random(inBounds bounds: (min: SCNVector3, max: SCNVector3)) -> SCNVector3 {
        return SCNVector3(CGFloat.random(min: CGFloat(bounds.min.x), max: CGFloat(bounds.max.x)),
                          CGFloat.random(min: CGFloat(bounds.min.y), max: CGFloat(bounds.max.y)),
                          CGFloat.random(min: CGFloat(bounds.min.z), max: CGFloat(bounds.max.z)))
    }
    
    func distanceTo(point: SCNVector3) -> SCNFloat {
        return distanceBetweenPoints(self, point)
    }
    
    static func -(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
}

func distanceBetweenPoints(_ a: SCNVector3, _ b: SCNVector3) -> SCNFloat {
    return sqrt((a.x - b.x) * (a.x - b.x)
        + (a.y - b.y) * (a.y - b.y)
        + (a.z - b.z) * (a.z - b.z))
}
