//
//  GridView.swift
//  css-bezier-curves
//
//  Created by Aaron Ross on 1/29/19.
//  Copyright © 2019 Aaron Ross. All rights reserved.
//

import Cocoa

class GridView: ContextView {
    
    @IBInspectable var highlightColor: NSColor = NSColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 1)
    @IBInspectable var shadowColor: NSColor = NSColor(red: 0x22/255, green: 0x22/255, blue: 0x22/255, alpha: 1)
    
    let gridColor = NSColor(red: 0xee/255, green: 0xee/255, blue: 0xee/255, alpha: 0.4)
    
    let rangeOver = CGFloat(100.0)
    var gridFrame: NSRect?
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.gridFrame = NSRect(
            origin: CGPoint(x: 10.0, y: 10.0),
            size: CGSize(width: frame.width - 20.0, height: frame.height - 20.0)
        )
    }
    
    func scalePoint(x: Float32, y: Float32) -> CGPoint {
        return scalePoint(from: CGPoint(x: CGFloat(x), y: CGFloat(y)))
    }
    
    func scalePoint(from point: CGPoint) -> CGPoint {
        if let grid = gridFrame {
            let rangeHeight = grid.height - 2 * rangeOver
            return CGPoint(x: point.x * grid.width + grid.minX,
                           y: point.y * rangeHeight + grid.minY + rangeOver)
        }
        
        return CGPoint.zero
    }
    
    func unscalePoint(from point: CGPoint) -> Vec2 {
        if let grid = gridFrame {
            let rangeHeight = grid.height - 2 * rangeOver
            return Vec2(x: Float32((point.x - grid.minX) / grid.minX),
                        y: Float32((point.y - grid.minY - rangeOver) / rangeHeight))
        }
        
        return Vec2.zero
    }
    
    override func draw(_ dirtyRect: NSRect) {
        if let grid = gridFrame {
            
            // set background gradient
            saveGState { ctx in
                let colors = [highlightColor.cgColor, shadowColor.cgColor]
                let colorLocations = [CGFloat(0.0), CGFloat(0.5)]
                let gradient = CGGradient(colorsSpace: CGColorSpace(name: CGColorSpace.sRGB),
                                          colors: colors as CFArray,
                                          locations: colorLocations)!
                let center = CGPoint(x: grid.minX + grid.width / 2, y: grid.minY + grid.height / 2)
                ctx.drawRadialGradient(gradient,
                                       startCenter: center,
                                       startRadius: 0,
                                       endCenter: center,
                                       endRadius: grid.width,
                                       options: [])
            }
        
            // draw major axes
            gridColor.setFill()
            CGRect(x: grid.minX + 2.0, y: grid.minY + grid.height - rangeOver, width: grid.width, height: 2.0).fill()
            CGRect(x: grid.minX + 2.0, y: grid.minY + rangeOver, width: grid.width, height: 2.0).fill()
            CGRect(x: grid.minX, y: grid.minY, width: 2.0, height: grid.height).fill()
            
        }
    }
}
