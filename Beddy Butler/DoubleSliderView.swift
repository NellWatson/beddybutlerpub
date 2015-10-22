////
////  DoubleSlider.swift
////  Beddy Butler
////
////  Created by David Garces on 09/09/2015.
////  Copyright © 2015 David Garces. All rights reserved.
////
//
//import Cocoa
//
//class DoubleSliderView: NSSlider, NSCopying {
//    
//    // MARK: Properties
//    var doubleSliderCell: DoubleSliderCellView {
//        return self.cell as! DoubleSliderCellView
//    }
//    
//    var stringStartValue: String {
//        get {
//            return self.doubleSliderCell.stringStartValue
//        }
//        set {
//            self.doubleSliderCell.stringStartValue = newValue
//        }
//    }
//    //@NSCopying var attributedStringStartValue: NSAttributedString
//    //@NSCopying 
//    var objectStartValue: AnyObject? /* id<NSCopying> */
//        {
//        get {
//            return self.doubleSliderCell.objectStartValue
//        }
//        set {
//            if newValue != nil && NSIsControllerMarker(newValue) {
//                self.enabled = true
//                self.doubleSliderCell.objectStartValue = newValue
//            } else {
//                self.enabled = false
//                self.doubleSliderCell.objectStartValue = nil
//            }
//
//        }
//    }
//    var intStartValue: Int32 {
//        get {
//            return self.doubleSliderCell.intStartValue
//        }
//        set {
//            self.doubleSliderCell.intStartValue = newValue
//        }
//    }
//    var integerStartValue: Int {
//        get {
//            return self.doubleSliderCell.integerStartValue
//        }
//        set {
//            self.doubleSliderCell.integerStartValue = newValue
//        }
//    }
//    var floatStartValue: Float {
//        get {
//            return self.doubleSliderCell.floatStartValue
//        }
//        set {
//            self.doubleSliderCell.floatStartValue = newValue
//        }
//    }
//    var doubleStartValue: Double {
//        get {
//            return self.doubleSliderCell.doubleStartValue
//        }
//        set {
//            self.doubleSliderCell.doubleStartValue = newValue
//        }
//    }
//    
//    var stringBedValue: String {
//        set {
//            self.doubleSliderCell.stringBedValue = newValue
//        }
//        get {
//            return self.doubleSliderCell.stringBedValue
//        }
//    }
//    //@NSCopying var attributedStringBedValue: NSAttributedString
//    //@NSCopying 
//    var objectBedValue: AnyObject? /* id<NSCopying> */
//        {
//        set {
//            if newValue != nil && NSIsControllerMarker(newValue) {
//                self.enabled = true
//                self.doubleSliderCell.objectBedValue = newValue
//            } else {
//                self.enabled = false
//                self.doubleSliderCell.objectBedValue = nil
//            }
//        }
//        get {
//            return self.doubleSliderCell.objectBedValue
//    
//        }
//    }
//    var intBedValue: Int32 {
//        get{
//            return self.doubleSliderCell.intBedValue
//        }
//        set {
//            self.doubleSliderCell.intBedValue = newValue
//        }
//    }
//    var integerBedValue: Int {
//        get {
//            return self.doubleSliderCell.integerBedValue
//        }
//        set {
//            self.doubleSliderCell.integerBedValue = newValue
//        }
//    }
//    var floatBedValue: Float {
//        get {
//            return self.doubleSliderCell.floatBedValue
//        }
//        set {
//            self.doubleSliderCell.floatBedValue = newValue
//        }
//    }
//    var doubleBedValue: Double {
//        get {
//            return self.doubleSliderCell.doubleBedValue
//        }
//        set {
//            self.doubleSliderCell.doubleBedValue = newValue
//        }
//    }
//    
//    //MARK: Cell Properties
//    var trackingStartKnob: Bool {
//        set{
//           self.doubleSliderCell.trackingStartKnob = newValue
//        }
//        get {
//            return self.doubleSliderCell.trackingStartKnob
//        }
//    }
//    
//    var lockedSliders: Bool {
//        set {
//            self.doubleSliderCell.lockedSliders = newValue
//        }
//        get {
//            return self.doubleSliderCell.lockedSliders
//        }
//    }
//    
//    //MARK: Overriden methods
//
//    override func keyDown(theEvent: NSEvent) {
//        self.interpretKeyEvents([theEvent])
//    }
//
//    func copyWithZone(zone: NSZone) -> AnyObject {
//        return self
//    }
//    
//    override func insertTab(sender: AnyObject?) {
//        if self.doubleSliderCell.trackingStartKnob {
//            self.doubleSliderCell.trackingStartKnob = false
//        } else {
//            self.doubleSliderCell.trackingStartKnob = true
//            self.window?.selectNextKeyView(self)
//        }
//        self.needsDisplay = true
//    }
//    
//    override func insertBacktab(sender: AnyObject?) {
//        if !self.doubleSliderCell.trackingStartKnob {
//            self.doubleSliderCell.trackingStartKnob = true
//        } else {
//            self.needsDisplay = true
//        }
//    }
//    
//    override func becomeFirstResponder() -> Bool {
//        let result = super.becomeFirstResponder()
//        
//        if result && self.window?.keyViewSelectionDirection != NSSelectionDirection.DirectSelection {
//            self.trackingStartKnob = self.window?.keyViewSelectionDirection == NSSelectionDirection.SelectingNext
//            
//        }
//        return result
//    }
//
//    override func drawRect(dirtyRect: NSRect) {
//        super.drawRect(dirtyRect)
//
//        // Drawing code here.
//    }
//    
//    override func mouseDown(theEvent: NSEvent) {
//        //NSLog("Mouse down in slider! current values are lo: \(self.doubleLoValue()) and hi: \(self.doubleHiValue())")
//        super.mouseDown(theEvent)
//    }
//    
//    override func mouseUp(theEvent: NSEvent) {
//        // every time the user changes any knob, the system should recalculate the timer
//        NSNotificationCenter.defaultCenter().postNotificationName(NotificationKeys.userPreferenceChanged.rawValue, object: self)
//        
//        super.mouseUp(theEvent)
//        
//    }
//    
//    
//    
//
//    
//    
//}
