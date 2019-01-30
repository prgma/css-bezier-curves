//
//  Model.swift
//  css-bezier-curves
//
//  Created by Aaron Ross on 1/29/19.
//  Copyright © 2019 Aaron Ross. All rights reserved.
//

import Cocoa

class Vec2: NSObject {
    var x: Float32
    var y: Float32

    static let zero: Vec2 = Vec2()
    
    init(x: Float32 = 0.0, y: Float32 = 0.0) {
        self.x = x
        self.y = y
    }
}

class Vec4: NSObject {
    var x1: Float32
    var y1: Float32
    var x2: Float32
    var y2: Float32
    
    init(x1: Float32 = 0.0, y1: Float32 = 0.0, x2: Float32 = 1.0, y2: Float32 = 1.0) {
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
    }
    
    init(from vec4: Vec4) {
        self.x1 = vec4.x1
        self.y1 = vec4.y1
        self.x2 = vec4.x2
        self.y2 = vec4.y2
    }
}

class BezierCurve: NSObject {
    var name: String
    var bezier: Vec4
    
    init(name: String, bezier: Vec4 = Vec4()) {
        self.name = name
        self.bezier = bezier
    }
}
