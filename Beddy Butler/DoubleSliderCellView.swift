////
////  DoubleSliderCellView.swift
////  Beddy Butler
////
////  Created by David Garces on 16/09/2015.
////  Copyright © 2015 David Garces. All rights reserved.
////
//
//import Cocoa
//
//class DoubleSliderCellView: NSSliderCell {
//    
//    //MARK: Properties
//    
//    var startValue: Double = 0.0
//    var storeValue: Double = 0.0
//    var trackingStartKnob: Bool {
//        set {
//            if self.sliderCellFlags.isTrackingStartKnob != newValue {
//                (self.controlView as! NSControl).updateCell(self)
//            }
//        } get {
//            return self.sliderCellFlags.isTrackingStartKnob
//        }
//    }
//    var lockedSliders: Bool {
//        set {
//            if self.sliderCellFlags.lockedSliders != newValue {
//                self.sliderCellFlags.lockedSliders = newValue
//            }
//            if newValue {
//                self.doubleStartValue = self.doubleBedValue
//            }
//            
//            (self.controlView as! NSControl).updateCell(self)
//            
//        } get {
//            return self.sliderCellFlags.lockedSliders
//        }
//    }
//    var sliderCellFlags: __sliderCellFlags
//    
//    //MARK: Carried from DoubleSliderView properties
//    var stringStartValue: String {
//        set {
//            self.doubleStartValue = NSString(string: newValue).doubleValue
//        }
//        get {
//            return String(format: "%g", arguments: [self.doubleStartValue])
//        }
//    }
//    //@NSCopying var attributedStringStartValue: NSAttributedString
//    var objectStartValue: AnyObject? /* id<NSCopying> */
//        {
//        set {
//            switch newValue {
//            case is Double:
//                self.doubleStartValue = newValue as! Double
//            case is Float:
//                self.floatStartValue = newValue as! Float
//            case is Int32:
//                self.intStartValue = newValue as! Int32
//            case is Int:
//                self.integerStartValue = newValue as! Int
//            case is String:
//                self.stringStartValue = newValue as! String
//            default:
//                self.doubleStartValue = 0.0
//            }
//
//        }
//        get {
//            return NSNumber(double: self.doubleStartValue)
//        }
//    }
//    var intStartValue: Int32 {
//        set {
//            self.doubleStartValue = Double(newValue)
//        }
//        get {
//            return Int32(self.doubleStartValue)
//        }
//    }
//    var integerStartValue: Int {
//        set {
//            self.doubleStartValue = Double(newValue)
//        }
//        get {
//            return Int(self.doubleStartValue)
//        }
//    }
//    var floatStartValue: Float {
//        set {
//            self.doubleStartValue = Double(newValue)
//        }
//        get {
//            return Float(self.doubleStartValue)
//        }
//    }
//    var doubleStartValue: Double {
//        set {
//            // limit to be at least minimum of start value
//            var theNewValue: Double = newValue
//            if newValue > self.doubleBedValue {
//                theNewValue = self.doubleBedValue
//            }
//            if newValue < self.minValue {
//                theNewValue = self.minValue
//            }
//            
//            if self.sliderCellFlags.mouseTrackingSwapped {
//               super.doubleValue = theNewValue
//            } else {
//                self.storeValue = theNewValue
//                (self.controlView as! NSControl).updateCell(self)
//            }
//        }
//        get {
//            if self.sliderCellFlags.mouseTrackingSwapped {
//                return self.doubleValue
//            } else {
//                return self.startValue
//            }
//        }
//    }
//    
//    var stringBedValue: String {
//        set {
//            self.doubleBedValue = NSString(string: newValue).doubleValue
//        }
//        get {
//            return String(format: "%g", arguments: [self.doubleBedValue])
//        }
//    }
//    //@NSCopying var attributedStringBedValue: NSAttributedString
//    var objectBedValue: AnyObject? { /* id<NSCopying> */
//        set {
//            switch newValue {
//            case is Double:
//                self.doubleBedValue = newValue as! Double
//            case is Float:
//                self.floatBedValue = newValue as! Float
//            case is Int32:
//                self.intBedValue = newValue as! Int32
//            case is Int:
//                self.integerBedValue = newValue as! Int
//            case is String:
//                self.stringBedValue = newValue as! String
//            default:
//                self.doubleBedValue = 0.0
//            }
//        }
//        get {
//            return NSNumber(double: self.doubleBedValue)
//        }
//    }
//    var intBedValue: Int32 {
//        set {
//                self.doubleBedValue = Double(newValue)
//        }
//        get {
//            return Int32(self.doubleBedValue)
//        }
//    }
//    var integerBedValue: Int {
//        set {
//            self.doubleBedValue = Double(newValue)
//        }
//        get {
//            return Int(self.doubleBedValue)
//        }
//    }
//    var floatBedValue: Float {
//        set {
//            self.doubleBedValue = Double(newValue)
//        }
//        get {
//            return Float(self.doubleBedValue)
//        }
//    }
//    var doubleBedValue: Double {
//        set {
//            // limit to be at least minimum of start value
//            var theNewValue: Double = newValue
//            if newValue < self.doubleStartValue {
//                theNewValue = self.doubleBedValue
//            }
//            if newValue > self.maxValue {
//                theNewValue = self.maxValue
//            }
//            
//            if self.sliderCellFlags.mouseTrackingSwapped {
//                self.storeValue = theNewValue
//                (self.controlView as! NSControl).updateCell(self)
//            } else {
//                super.doubleValue = theNewValue
//            }
//            
//        }
//        get {
//            if self.sliderCellFlags.mouseTrackingSwapped {
//                return self.storeValue
//            } else {
//                return super.doubleValue
//            }
//        }
//        
//    }
//    
//    // MARK: Knob properties
//    
//    var startKnobRect: NSRect {
//        var knobRect: NSRect
//        var storeValue: Double
//        
//        storeValue = self.doubleValue
//        self.doubleValue = self.startValue
//        
//        knobRect = self.knobRectFlipped((self.controlView?.flipped)!)
//        self.doubleValue = storeValue
//        
//        return knobRect
//    }
//    
//    //MARK: Overriden properties
//    
//    override var minValue: Double {
//        set {
//            if self.doubleStartValue < newValue {
//                self.doubleStartValue = newValue
//            }
//            if self.doubleBedValue < newValue {
//                self.doubleBedValue = newValue
//            }
//            super.minValue = newValue
//
//        } get {
//            return super.minValue
//        }
//    }
//    
//    
//    override var maxValue: Double {
//        set {
//            if self.doubleStartValue > newValue {
//                self.doubleStartValue = newValue
//            }
//            if self.doubleBedValue > newValue {
//                self.doubleBedValue = newValue
//            }
//            super.maxValue = newValue
//            
//        } get {
//            return super.maxValue
//        }
//    }
//    
//    override var stringValue: String {
//        set {
//            if self.trackingStartKnob {
//                self.stringStartValue = newValue
//            } else {
//                self.stringBedValue = newValue
//            }
//        }
//        get {
//            if self.trackingStartKnob {
//                return self.stringStartValue
//            } else {
//                return self.stringBedValue
//            }
//        }
//    }
//    
//    override var objectValue: AnyObject? {
//        set {
//            if self.trackingStartKnob {
//                self.objectStartValue = newValue
//            } else {
//                self.objectBedValue = newValue
//            }
//        }
//        get {
//            if self.trackingStartKnob {
//                return self.objectStartValue
//            } else {
//                return self.objectBedValue
//            }
//        }
//    }
//    
//    override var intValue: Int32 {
//        set {
//            if self.trackingStartKnob {
//                self.intStartValue = newValue
//            } else {
//                self.intBedValue = newValue
//            }
//        }
//        get {
//            if self.trackingStartKnob {
//                return self.intStartValue
//            } else {
//                return self.intBedValue
//            }
//        }
//    }
//    
//    override var integerValue: Int {
//        set {
//            if self.trackingStartKnob {
//                self.integerStartValue = newValue
//            } else {
//                self.integerBedValue = newValue
//            }
//        }
//        get {
//            if self.trackingStartKnob {
//                return self.integerStartValue
//            } else {
//                return self.integerBedValue
//            }
//        }
//    }
//    
//    override var floatValue: Float {
//        set {
//            if self.trackingStartKnob {
//                self.floatStartValue = newValue
//            } else {
//                self.floatBedValue = newValue
//            }
//        }
//        get {
//            if self.trackingStartKnob {
//                return self.floatStartValue
//            } else {
//                return self.floatBedValue
//            }
//        }
//    }
//    
//    override var doubleValue: Double {
//        set {
//            if self.trackingStartKnob {
//                self.doubleStartValue = newValue
//            } else {
//                self.doubleBedValue = newValue
//            }
//
//        }
//        get {
//            if self.trackingStartKnob {
//                return self.doubleStartValue
//            } else {
//                return self.doubleBedValue
//            }
//        }
//    }
//    
//    
//    
//
//
//    //var doubleValue
//    
//    //MARK: Flags
//    
//    struct __sliderCellFlags {
//        var lockedSliders: Bool = false
//        var isTrackingStartKnob: Bool = false
//        var mouseTrackingSwapped: Bool = false
//        var removeFocusRingStyle: Bool = false
//    }
//    
//    //MARK: Initialisers
//    required init?(coder aDecoder: NSCoder) {
//        // initialise the flags
//        var decoderLockedSliders: Bool?
//        sliderCellFlags = __sliderCellFlags()
//        super.init(coder: aDecoder)
//      
//        
//        if aDecoder.allowsKeyedCoding {
//            self.startValue = aDecoder.decodeDoubleForKey("startValue")
//            decoderLockedSliders = aDecoder.decodeBoolForKey("lockedSliders")
//        } else
//        {
//            //TO DO: complete decoding when does not allow key coding.
//           // aDecoder.decodeValueOfObjCType(@encode(Double), at: self.startValue)
//        }
//        
//        sliderCellFlags.lockedSliders = decoderLockedSliders != nil ? (decoderLockedSliders?.boolValue)! : true
//        sliderCellFlags.isTrackingStartKnob = true
//        
//        // values should be between min and max
//        if self.minValue > self.startValue {
//            self.startValue = self.minValue
//        }
//        if self.maxValue < self.startValue {
//            self.startValue = self.maxValue
//        }
//        
//    }
//    
//    //MARK: Drawing
//    
//    override func drawKnob() {
//        var startKnob: NSRect
//        let toStoreValue = super.doubleValue
//        let savePressed = false //????
//        
//        // Draw the start knob
//        
//        if !sliderCellFlags.mouseTrackingSwapped {
//            // tracking on the start know means that we already have the start knob value, if not, we need to assign it
//            self.doubleValue = self.startValue
//        }
//        
//        // focus ring style and pressed state of start knob
//        self.sliderCellFlags.removeFocusRingStyle = self.showsFirstResponder && !self.trackingStartKnob
//        self.isPressed =  savePressed && self.trackingStartKnob
//        
//        startKnob = self.knobRectFlipped((self.controlView?.flipped)!)
//        self.drawKnob(startKnob)
//        
//        // draw the bed knob
//        if sliderCellFlags.mouseTrackingSwapped {
//            // tracking the knob means we alreay have a value to save
//            self.doubleValue = self.storeValue
//        } else {
//            // restore position of bed knob
//            self.doubleValue = toStoreValue
//        }
//        
//        // focus ring style
//        self.sliderCellFlags.removeFocusRingStyle = self.showsFirstResponder && self.trackingStartKnob
//        self.isPressed = savePressed && !self.trackingStartKnob
//        
//        super.drawKnob()
//        
//        // reset values
//        self.doubleValue = toStoreValue
//        
//        self.isPressed = savePressed
//        self.sliderCellFlags.removeFocusRingStyle = false
//        
//    }
//    
//    override func drawKnob(knobRect: NSRect) {
//        var focusRingType: NSFocusRingType = NSFocusRingType.None
//        
//        if self.sliderCellFlags.removeFocusRingStyle {
//            
//            if self.respondsToSelector("focusRingType:") {
//                focusRingType = self.focusRingType
//                self.focusRingType = NSFocusRingType.None
//            }
//            
//            NSGraphicsContext.currentContext()?.restoreGraphicsState()
//            
//        }
//        
//        super.drawKnob(knobRect)
//        
//        if self.sliderCellFlags.removeFocusRingStyle {
//            
//            if self.respondsToSelector("focusRingType:") {
//                self.focusRingType = focusRingType
//            }
//            
//            NSGraphicsContext.currentContext()?.saveGraphicsState()
//            NSSetFocusRingStyle(NSFocusRingPlacement.Above)
//        }
//    }
//    
//    override func startTrackingAt(startPoint: NSPoint, inView controlView: NSView) -> Bool {
//        var theStartKnobRect: NSRect
//        
//        // are we tracking the start or the bed knob?
//        theStartKnobRect = self.startKnobRect
//        
//        if self.vertical  == 1 {
//            if controlView.flipped {
//                self.trackingStartKnob = startPoint.y > theStartKnobRect.origin.y
//            } else {
//                self.trackingStartKnob = startPoint.y < theStartKnobRect.origin.y + theStartKnobRect.size.height
//            }
//        }
//        
//        // stop user from dragging start and bed knobs to minimum
//        if self.trackingStartKnob && NSEqualRects(theStartKnobRect, self.knobRectFlipped(controlView.flipped)) {
//            self.trackingStartKnob = self.startValue > self.minValue
//        }
//        
//        // start knob should be redisplayed the first time
//        if self.trackingStartKnob {
//            controlView.setNeedsDisplayInRect(startKnobRect)
//        }
//        
//        // save bed value
//        self.storeValue = self.doubleValue
//        
//        // if user is tracking start knob revert back to the value of the start knob
//        self.sliderCellFlags.mouseTrackingSwapped = self.trackingStartKnob
//        
//        if self.sliderCellFlags.mouseTrackingSwapped {
//            self.doubleValue = self.startValue
//        }
//        
//        return super.startTrackingAt(startPoint, inView: controlView)
//        
//    }
//    
//    override func continueTracking(lastPoint: NSPoint, at currentPoint: NSPoint, inView controlView: NSView) -> Bool {
//        var trackingResult: Bool
//        
//        trackingResult = super.continueTracking(lastPoint, at: currentPoint, inView: controlView)
//        
//        if self.sliderCellFlags.mouseTrackingSwapped {
//            // limit to maximum of bed value
//            if self.doubleValue > self.storeValue {
//                self.doubleValue = self.storeValue
//            }
//            
//            if self.continuous {
//                //(controlView as! DoubleSliderView).updateBoundControllerStartValue(self.doubleValue)
//                (self.controlView as! DoubleSliderView).doubleStartValue = self.doubleValue
//            }
//        } else {
//            
//            // limit to minimum of start value
//            if self.doubleValue < self.startValue {
//                self.doubleValue = self.startValue
//            }
//            
//            if self.continuous {
//                //(controlView as! DoubleSliderView).updateBoundControllerBedValue(self.doubleValue)
//                (self.controlView as! DoubleSliderView).doubleBedValue = self.doubleValue
//            }
//            
//        }
//        
//        return trackingResult
//    }
//    
//    override func stopTracking(lastPoint: NSPoint, at stopPoint: NSPoint, inView controlView: NSView, mouseIsUp flag: Bool) {
//        if self.sliderCellFlags.mouseTrackingSwapped {
//            
//            // tracking start knob, so we will update values for that one
//            self.startValue = self.doubleValue
//            self.doubleValue = self.storeValue
//            self.sliderCellFlags.mouseTrackingSwapped = false
//            controlView.setNeedsDisplayInRect(self.startKnobRect)
//            
//            // always update controller
//            //(controlView as! DoubleSliderView).updateBoundControllerStartValue(self.startValue)
//            (self.controlView as! DoubleSliderView).doubleStartValue = self.startValue
//            
//        } else {
//            //(controlView as! DoubleSliderView).updateBoundControllerBedValue(self.doubleValue)
//            (self.controlView as! DoubleSliderView).doubleBedValue = self.doubleValue
//            
//        }
//        
//        super.stopTracking(lastPoint, at: stopPoint, inView: controlView, mouseIsUp: flag)
//    }
//
//}
