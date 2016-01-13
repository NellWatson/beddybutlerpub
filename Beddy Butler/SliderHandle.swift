//
//  SliderHandle.swift
//  Beddy Butler
//
//  Created by David Garces on 21/09/2015.
//  Copyright (c) 2015 Nell Watson Inc. All rights reserved.
//

import Cocoa

class SliderHandle: NSObject {
    
    //MARK: Types
    typealias SliderValue = (value: CGFloat) -> CGFloat
    typealias SliderValueChanged  = [String: CGFloat]
    
    //MARK: Properties
    var multipliedValue: Double {
        return 0
    }

    var sliderValue: SliderValue?
    var sliderValueChanged: SliderValue?
    var name: String
    var handleImage: NSImage
    
    // TODO: need to fix curRatio vs slidervalue -
    var _curRatio: CGFloat {
        didSet {
            if self.name == SliderKeys.StartHandler.rawValue {
                //TODO: Move variables
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationKeys.startSliderChanged.rawValue, object: self._curRatio)
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName(NotificationKeys.endSliderChanged.rawValue, object: self._curRatio)
            }
        }
    }
    var curValue: CGFloat {
        get {
            var value = self._curRatio
            if let theCurrentValue = sliderValue {
                value = theCurrentValue(value: value)
            }
            return value
        }
        set {
            self._curRatio = newValue
        }
        
    }

    var handleView: NSView
        
    required init(name: String, image: NSImage, ratio: CGFloat, sliderValue: SliderValue, sliderValueChanged: SliderValue) {
            self.name = name
            self.handleImage = image
            self.sliderValue = sliderValue
            self.sliderValueChanged = sliderValueChanged
            self.handleView = NSView()
            //let offset: CGFloat = name == SliderKeys.StartHandler.rawValue ? 0.01 : -0.01
            self._curRatio = ratio
 
        }
    
    
//    func ratioForDoubleValue(value: Double) -> CGFloat {
//        
//        let offset: CGFloat = 0.02
//        let isStartSlider = name == SliderKeys.StartHandler.rawValue
//        
//        //First calculate plain value
//        let theValue = CGFloat ( value / sliderRange)
//        
//        if isStartSlider {
//            let theNewValue = theValue  + offset
//            if theNewValue <= offset || theNewValue >= (1 - offset) { return theValue } else {
//                return theNewValue
//            }
//            
//        } else {
//            let theNewValue = theValue  - offset
//            if theNewValue <= offset || theNewValue >= (1 - offset) { return theValue } else {
//                return theNewValue
//            }
//        }
//        
//    }
    
    func ratioForValue(value: CGFloat) -> CGFloat {
        var ratio = value
        if let theChangedValue = self.sliderValueChanged {
            ratio = theChangedValue(value: ratio)
        }
        return ratio
    }
    

}
