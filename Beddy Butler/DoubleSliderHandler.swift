//
//  DoubleSliderHandler.swift
//  Double Slider Test
//
//  Created by David Garces on 21/09/2015.
//  Copyright (c) 2015 Nell Watson Inc. All rights reserved.
//

import Cocoa

class DoubleSliderHandler: NSView {
    
    //MARK: Types
    typealias SliderValue = (value: CGFloat) -> CGFloat
    //typealias SliderValueChanged  = (handle: [String:CGFloat]) -> Void
    typealias SliderValueChanged  = [String:CGFloat]
    
    //MARK: Properties
    var activeHandle: SliderHandle?
    var activeHandleView: NSView?
    var activeBoundary: [CGFloat]?
    var handles = [String: SliderHandle]()
    var values = [String: CGFloat]()
    var lastValue: CGFloat?
    var sliderValueChanged: SliderValueChanged?
    
    //MARK: Slider Bar specific properties
    let sliderHandleWidth = CGFloat(20)
    let sliderHandleHeight = CGFloat(40)
    let sliderBarHeight = CGFloat(2)
    let sliderBarColor = NSColor.lightGrayColor()
    let dynamicViewTag = 102
    let staticViewTag = 101
    
    //MARK: Images
    var sliderBarImage: NSImage {
        
        let slidabeWidth = self.bounds.size.width - sliderHandleWidth
        
        let barImage = NSImage(size: NSMakeSize(slidabeWidth, sliderBarHeight))
        barImage.lockFocus()
        
        sliderBarColor.set()
        
        NSRectFill(NSMakeRect(0, 0, barImage.size.width, barImage.size.height))
        
        barImage.unlockFocus()
        
        return barImage
        
    }
    
    //MARK: Observer Properties
//    private var doubleSliderContext = 0
//    dynamic var startValue: Double {
//        get {
//            return Double(self.values["Low"]!)
//        }
//        set {
//            //TO DO: retrieve the correct value rather than hard-coding "Low"
//            self.values["Low"] = CGFloat(startValue)
//        }
//    }
//    
//    dynamic var bedValue: Double {
//        get {
//            return Double(self.values["High"]!)
//        }
//        set {
//            //TO DO: retrieve the correct value rather than hard-coding "High"
//            self.values["High"] = CGFloat(startValue)
//        }
//    }
    
    //MARK: Initialisers
    
    ///Initialises the view from a storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let sliderBarImage = self.sliderBarImage
        
        let startX = (frame.size.width - sliderBarImage.size.width) * 0.5
        let starY = (frame.size.height - sliderBarImage.size.height) * 0.5
        let imageView = NSImageView(frame: NSMakeRect(startX, starY, sliderBarImage.size.width, sliderBarImage.size.height))
        imageView.image = sliderBarImage
        imageView.tag = 0
        self.addSubview(imageView)
        

    }
    
    ///Initialises the view from code
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        
        let sliderBarImage = self.sliderBarImage
        
        let startX = (frame.size.width - sliderBarImage.size.width) * 0.5
        let starY = (frame.size.height - sliderBarImage.size.height) * 0.5
        let imageView = NSImageView(frame: NSMakeRect(startX, starY, sliderBarImage.size.width, sliderBarImage.size.height))
        imageView.image = sliderBarImage
        imageView.tag = 0
        self.addSubview(imageView)
        
    }
    
    //MARK: Handle methods
    
    func addHandle(name: String, image: NSImage, iniRatio: CGFloat, sliderValue: SliderValue, sliderValueChanged: SliderValue) {
        
        let sliderHandle: SliderHandle = SliderHandle(name: name, image: image, ratio: iniRatio, sliderValue: sliderValue, sliderValueChanged: sliderValueChanged)
        
        self.handles[name] = sliderHandle
        self.values[name] = sliderHandle.curValue
        
        //TO DO: Add observer for key values.name?
        //self.addObserver(self, forKeyPath: "values."+name, options: .New, context: &doubleSliderContext)
        
        let slidableWidth = self.bounds.size.width - sliderHandleWidth
        
        let midY = NSMidY(self.bounds)
        
        let handleRect = NSMakeRect(slidableWidth * CGFloat(sliderHandle._curRatio), midY - sliderHandleHeight * 0.5, sliderHandleWidth, sliderHandleHeight)
        
        let imageView = NSImageView(frame: NSMakeRect(0, 0, sliderHandleWidth, sliderHandleHeight))
        
        imageView.image = sliderHandle.handleImage
        imageView.tag = dynamicViewTag
        self.addSubview(imageView)
        imageView.frame = handleRect
        
        sliderHandle.handleView = imageView
        
        self.needsDisplay = true
        
    }
    
    //MARK: Mouse Events
    override func mouseDown(theEvent: NSEvent) {
        let mouseDownPoint =  self.convertPoint(theEvent.locationInWindow, fromView: nil)
        
        for view in self.subviews {
            if view.tag == dynamicViewTag {
                if NSPointInRect(mouseDownPoint, view.frame) {
                    self.activeHandleView = view
                
                
               
                for key in self.handles {
                        
                    let value = key.1
                    if value.handleView == view {
                        self.activeHandle = value
                        break
                    }
                        
                }
                
                self.activeBoundary = self.boundaryForView(self.activeHandleView!)
                self.lastValue = self.activeHandle?.curValue
                break
                    
                }
            }
        }
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        if self.activeHandleView == nil {
            return super.mouseDragged(theEvent)
        }
        
        let mouseDownPoint =  self.convertPoint(theEvent.locationInWindow, fromView: nil)
        
        let left = self.activeBoundary![0]
        let right = self.activeBoundary![1]
        
        var newX = mouseDownPoint.x
        let halfWidth = (self.activeHandleView?.frame.size.width)! * 0.5
        
        if newX - halfWidth < left {
            newX = left + halfWidth
            Swift.print("half width used: \(newX)")
        }
        if newX + halfWidth > right {
            newX = right - halfWidth
            Swift.print("half width used: \(newX)")
        }
        
        self.activeHandleView?.frame = NSMakeRect(newX - self.activeHandleView!.frame.size.width * 0.5, self.activeHandleView!.frame.origin.y, self.activeHandleView!.frame.size.width, self.activeHandleView!.frame.size.height)
        
        let slidableWidth = self.bounds.size.width - self.sliderHandleWidth
        
        let ratio = (newX - halfWidth) / slidableWidth
        self.activeHandle?.curValue = ratio
        let difference = abs((self.activeHandle?.curValue)! - self.lastValue!)
        //TO DO: slidervaluechanged check
        if Float(difference) > FLT_EPSILON && self.sliderValueChanged != nil {
            self.lastValue = self.activeHandle?.curValue
            
            for key in self.handles {
                let handle = key
                let oldValue = self.values[key.0]
                let curValue = handle.1.curValue
                
                if Float(abs(curValue - oldValue!)) > FLT_EPSILON {
                    // VALUE CHANGED
                    self.values[handle.0] = handle.1.curValue
                }
            }
            
            sliderValueChanged = self.values
        }
        
        
    }
    
    override func mouseUp(theEvent: NSEvent) {
        self.activeHandle = nil
        self.activeHandleView = nil
        self.activeBoundary = nil
    }
    
    //MARK: Other methods
    
    func boundaryForView(view: NSView) -> [CGFloat] {
        var boundary = [CGFloat]()
        
        var min: CGFloat = 0
        var max: CGFloat = self.frame.size.width
        let viewLeftBoundary = view.frame.origin.x
        let viewRightBoundary = view.frame.origin.x + view.frame.size.width
        
        for subview in (view.superview?.subviews)! {
            if subview != view && subview.tag == self.dynamicViewTag {
                let leftBoundary = subview.frame.origin.x
                let rightBoundary = subview.frame.origin.x + subview.frame.size.width
                
                if rightBoundary <= viewLeftBoundary && rightBoundary > min {
                    min = rightBoundary
                }
                
                if leftBoundary >= viewRightBoundary && leftBoundary < max {
                    max = leftBoundary
                }
                
            }
        }
        
        boundary.insert(min, atIndex: 0)
        boundary.insert(max, atIndex: 1)
        
        return boundary
    
    }
    
    //MARK: notification update
    func updateValues(notification: NSNotification) {
        if let updateObject = notification.object as? (String, CGFloat) {
            
            let key = updateObject.0
            
            let handle = self.handles[key]
            
            
            let newValue = updateObject.1
            var ratio = handle?.ratioForValue(newValue)
            let slidableWidth = self.bounds.size.width - self.sliderHandleWidth
            let boundary = self.boundaryForView((handle?.handleView)!)
            let halfWidth = self.sliderHandleWidth * 0.5
            let left = boundary[0]
            let right = boundary[0]
            let minRatio = (left + halfWidth) / slidableWidth
            let maxRatio = (right - halfWidth) / slidableWidth
            
            ratio = max(ratio!,minRatio)
            ratio = min(ratio!, maxRatio)
            
            if Float(abs(ratio! - (handle?.curValue)!)) > FLT_EPSILON {
                handle?.curValue = ratio!
                let newX = slidableWidth * ratio!
                 handle?.handleView.frame = NSMakeRect(newX - handle!.handleView.frame.size.width * 0.5, handle!.handleView.frame.origin.y, handle!.handleView.frame.size.width, handle!.handleView.frame.size.height)
                
                self.values[key] = handle?.curValue
                
                //TO DO: Value changed block?
                //if ValueChangedBlock != nil {
                  //  ValueChangedBlock(self.values)
                //}
                
            }
        }
    }
    
}


//MARK: KVO

//class MyObserver: NSObject {
//
//        override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//
//            if context == &self.doubleSliderContext {
//
//                if let newValue = change?[NSKeyValueChangeNewKey] {
//                    Swift.print("Date changed: \(newValue)")
//
//                    if keyPath!.hasPrefix("values."){
//                        let key = keyPath?.componentsSeparatedByString(".")[1]
//                        let handle = self.handles[key!]
//
//                        var ratio = handle?.ratioForValue(CGFloat(newValue as! NSNumber))
//                        let slidableWidth = self.bounds.size.width - sliderHandleWidth;
//                        let boundary = self.boundaryForView(handle!.handleView)
//                        let halfWidth = sliderHandleWidth * 0.5
//                        let left = boundary[0]
//                        let right = boundary[1]
//                        let minRatio = (left + halfWidth) / slidableWidth
//                        let maxRatio = (right - halfWidth) / slidableWidth
//
//                        ratio = max(ratio!, minRatio)
//                        ratio = min(ratio!, maxRatio)
//
//                        if Float(abs(ratio! - (handle?.curValue)!)) > FLT_EPSILON {
//                            handle!.curValue = ratio!
//                            let newX = slidableWidth * ratio!
//                            handle!.handleView.frame = NSMakeRect(newX - handle!.handleView.frame.size.width * 0.5, handle!.handleView.frame.origin.y, handle!.handleView.frame.size.width, handle!.handleView.frame.size.height)
//
//                            self.willChangeValueForKey(keyPath!)
//                            self.values[key!] = handle?.curValue
//                            self.didChangeValueForKey(keyPath!)
//
//                        }
//
//                    }
//
//                }
//            } else {
//                super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
//            }
//
//    }
//
//      //  }
