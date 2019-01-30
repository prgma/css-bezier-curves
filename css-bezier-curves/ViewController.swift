//
//  ViewController.swift
//  css-bezier-curves
//
//  Created by Aaron Ross on 1/28/19.
//  Copyright © 2019 Aaron Ross. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSOutlineViewDelegate, NSOutlineViewDataSource {
    
    @IBOutlet weak var curveNameTextField: NSTextField?
    @IBOutlet weak var x1TextField: NSTextField?
    @IBOutlet weak var y1TextField: NSTextField?
    @IBOutlet weak var x2TextField: NSTextField?
    @IBOutlet weak var y2TextField: NSTextField?
    @IBOutlet weak var sourceListView: NSOutlineView?
    @IBOutlet weak var bezierView: BezierView?
    
    var curves = [BezierCurve]()

    override func viewDidLoad() {
        super.viewDidLoad()

        curves.append(BezierCurve(name: "Linear"))
        curves.append(BezierCurve(name: "Quadratic", bezier: Vec4(x1: 0.1, y1: -0.5, x2: 0.9, y2: 1.5)))
        sourceListView?.reloadData()
        
        sourceListView?.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
    }
    
    @IBAction func onSave(_ sender: NSButton) {
        print("clicked!")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return curves[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return curves.count
    }
    
    // NSOutlineViewDelegate
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        switch item {
        case let curve as BezierCurve:
            let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("DataCell"),
                                            owner: self) as! NSTableCellView
            if let textField = view.textField {
                textField.stringValue = curve.name
            }
            return view
            default:
                return nil
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        return false
    }

    func outlineViewSelectionDidChange(_ notification: Notification) {
        let object = notification.object as! NSOutlineView
        let selectedIndex = object.selectedRow
        let curve = object.item(atRow: selectedIndex) as! BezierCurve
        
        curveNameTextField?.stringValue = curve.name
        x1TextField?.stringValue = String(curve.bezier.x1)
        y1TextField?.stringValue = String(curve.bezier.y1)
        x2TextField?.stringValue = String(curve.bezier.x2)
        y2TextField?.stringValue = String(curve.bezier.y2)
        bezierView?.setBezier(curve.bezier)
        
        bezierView?.layer?.setNeedsDisplay()
    }

}

