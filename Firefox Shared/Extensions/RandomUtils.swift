//
//  RandomUtils.swift
//  Firefox
//
//  Created by Arthur Masson on 15/03/2018.
//  Copyright © 2018 Arthur Masson. All rights reserved.
//

import Foundation
import CoreGraphics

public extension Int {
    public static func random(min: Int, max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max - min + 1))) + min
    }
}

public extension Float {
    public static func random(min: Float, max: Float) -> Float {
        let r32 = Float(arc4random()) / Float(UInt32.max)
        return (r32 * (max - min)) + min
    }
}

public extension Double {
    public static func random(_ min: Double, max: Double) -> Double {
        let r64 = Double(arc4random()) / Double(UInt64.max)
        return (r64 * (max - min)) + min
    }
}

public extension CGFloat {
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        let r32 = CGFloat(arc4random()) / CGFloat(UInt32.max)
        return (r32 * (max - min)) + min
    }
}
