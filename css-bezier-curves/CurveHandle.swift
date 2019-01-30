//
//  CurveHandle.swift
//  css-bezier-curves
//
//  Created by Aaron Ross on 1/29/19.
//  Copyright © 2019 Aaron Ross. All rights reserved.
//

import Cocoa

let handleSize = CGSize(width: 20.0, height: 20.0)
let activeHandleSize = CGSize(width: 24.0, height: 24.0)

func noop() {}

func rectForControlPoint(_ p: CGPoint) -> NSRect {
    return NSRect(origin: CGPoint(x: p.x - activeHandleSize.width / 2.0, y: p.y - activeHandleSize.height / 2.0), size: activeHandleSize)
}

// TODO: add outline and drop shadow to handle
class CurveHandle: ContextView {
    
    static let startColor = CGColor(red: 0.184, green: 0.443, blue: 0.969, alpha: 1)
    static let endColor = CGColor(red: 1.0, green: 0.306, blue: 0.827, alpha: 1)
    
    var active: Bool = false
    var point: CGPoint
    var color: CGColor = CurveHandle.startColor
    var onMove: () -> Void

    init(with point: CGPoint) {
        self.point = point
        self.onMove = noop
        super.init(frame: rectForControlPoint(point))
    }
    
    required init?(coder decoder: NSCoder) {
        self.point = CGPoint(x: 0.0, y: 0.0)
        self.onMove = noop
        super.init(coder: decoder)
    }

    func setPoint(_ point: CGPoint) {
        self.point = point
        setFrameOrigin(rectForControlPoint(point).origin)
    }
    
    func setOnMove(_ handler: @escaping () -> Void) {
        self.onMove = handler
    }

    override func mouseDown(with event: NSEvent) {
        active = true
        layer?.setNeedsDisplay()
    }
    
    override func mouseUp(with event: NSEvent) {
        active = false
        layer?.setNeedsDisplay()
    }
    
    override func mouseDragged(with event: NSEvent) {
        let parentFrame = superview?.frame
        let mousePosition = event.locationInWindow
        
        let x = mousePosition.x - (parentFrame?.minX)!
        let y = mousePosition.y - (parentFrame?.minY)!
        
        point.x = x
        point.y = y
        setFrameOrigin(NSPoint(x: x - activeHandleSize.width / 2, y: y - activeHandleSize.height / 2))
        onMove()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        saveGState { ctx in
            ctx.setFillColor(color)
            ctx.fillEllipse(in: CGRect(origin: CGPoint(x: 2.0, y: 2.0), size: handleSize))
            if active {
                ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 0.4))
                ctx.fillEllipse(in: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: activeHandleSize))
            }
        }
    }
}
