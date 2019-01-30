//
//  BezierView.swift
//  css-bezier-curves
//
//  Created by Aaron Ross on 1/29/19.
//  Copyright © 2019 Aaron Ross. All rights reserved.
//

import Cocoa

// TODO: provide a public interface for updating control handles
// TODO: provide a public interface for responding to control handle value changes
// TODO: scale input/output to 0.0 -> 1.0
class BezierView: GridView {
    
    private var bezier = Vec4(x1: 0.0, y1: 0.0, x2: 1.0, y2: 1.0)

    let fgColor     = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
    let transparent = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
    
    var start: CGPoint?
    var end: CGPoint?
    var c1Handle: CurveHandle?
    var c2Handle: CurveHandle?
    
    var shape: CAShapeLayer? = nil
    var c1ConnectorShape: CAShapeLayer? = nil
    var c2ConnectorShape: CAShapeLayer? = nil
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        c1Handle = CurveHandle(with: super.scalePoint(x: bezier.x1, y: bezier.y1))
        c2Handle = CurveHandle(with: super.scalePoint(x: bezier.x2, y: bezier.y2))
        c2Handle!.color = CurveHandle.endColor
        start = super.scalePoint(x: 0.0, y: 0.0)
        end = super.scalePoint(x: 1.0, y: 1.0)
        c1Handle?.setOnMove(redraw)
        c2Handle?.setOnMove(redraw)
    }
    
    private func redraw() {
        layer?.setNeedsDisplay()
    }
    
    func setBezier(_ bezier: Vec4) {
        self.bezier = bezier
        c1Handle?.setPoint(super.scalePoint(x: bezier.x1, y: bezier.y1))
        c2Handle?.setPoint(super.scalePoint(x: bezier.x2, y: bezier.y2))
        redraw()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let c1 = c1Handle!.point
        let c2 = c2Handle!.point
        
        shape?.removeFromSuperlayer()
        c1ConnectorShape?.removeFromSuperlayer()
        c2ConnectorShape?.removeFromSuperlayer()
        
        // draw curve
        let curve = CGMutablePath()
        curve.move(to: start!)
        curve.addCurve(to: end!, control1: c1, control2: c2)
        
        // color curve
        shape = CAShapeLayer()
        shape?.path = curve
        shape?.lineWidth = 2.0
        shape?.strokeColor = fgColor
        shape?.fillColor = transparent
        
        // draw left connector
        let c1Connector = CGMutablePath()
        c1Connector.move(to: c1)
        c1Connector.addLine(to: start!)
        
        // color left connector
        c1ConnectorShape = CAShapeLayer()
        c1ConnectorShape?.path = c1Connector
        c1ConnectorShape?.lineWidth = 2.0
        c1ConnectorShape?.strokeColor = super.gridColor.cgColor
        c1ConnectorShape?.fillColor = transparent
        
        // draw right connector
        let c2Connector = CGMutablePath()
        c2Connector.move(to: c2)
        c2Connector.addLine(to: end!)
        
        // color right connector
        c2ConnectorShape = CAShapeLayer()
        c2ConnectorShape?.path = c2Connector
        c2ConnectorShape?.lineWidth = 2.0
        c2ConnectorShape?.strokeColor = super.gridColor.cgColor
        c2ConnectorShape?.fillColor = transparent
        
        // render to layer
        layer?.addSublayer(shape!)
        layer?.addSublayer(c1ConnectorShape!)
        layer?.addSublayer(c2ConnectorShape!)
        
        addSubview(c1Handle!)
        addSubview(c2Handle!)
    }
}
