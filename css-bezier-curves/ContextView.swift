//
//  ContextView.swift
//  css-bezier-curves
//
//  Created by Aaron Ross on 1/30/19.
//  Copyright © 2019 Aaron Ross. All rights reserved.
//

import Cocoa

class ContextView: NSView {
    var currentContext: CGContext? {
        get {
            if #available(OSX 10.10, *) {
                return NSGraphicsContext.current?.cgContext
            } else if let graphicsPort = NSGraphicsContext.current?.graphicsPort {
                // FIXME: this may not work properly
                return (graphicsPort as! CGContext)
            }
            
            return nil
        }
    }
    
    func saveGState(performDrawing: (_ ctx: CGContext) -> ()) -> () {
        if let context = self.currentContext {
            context.saveGState()
            performDrawing(context)
            context.restoreGState()
        }
    }
}
