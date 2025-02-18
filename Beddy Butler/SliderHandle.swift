//
//  SliderHandle.swift
//  Beddy Butler
//
//  Created by David Garces on 21/09/2015.
//  Copyright (c) 2015-2025 Nell Watson Inc. All rights reserved.
//

import Cocoa

@MainActor
class SliderHandle {

    //MARK: Types
    typealias SliderValue = (_ value: CGFloat) -> CGFloat
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
                NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationKeys.startSliderChanged.rawValue), object: self._curRatio)
            } else {
                NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationKeys.endSliderChanged.rawValue), object: self._curRatio)
            }
        }
    }
    var curValue: CGFloat {
        get {
            var value = self._curRatio
            if let theCurrentValue = sliderValue {
                value = theCurrentValue(value)
            }
            return value
        }
        set {
            self._curRatio = newValue
        }

    }

    var handleView: NSView

    required init(name: String, image: NSImage, ratio: CGFloat, sliderValue: @escaping SliderValue, sliderValueChanged: @escaping SliderValue) {
        self.name = name
        self.handleImage = image
        self.sliderValue = sliderValue
        self.sliderValueChanged = sliderValueChanged
        //let offset: CGFloat = name == SliderKeys.StartHandler.rawValue ? 0.01 : -0.01
        self._curRatio = ratio
        self.handleView = NSView()
    }

    func ratioForValue(value: CGFloat) -> CGFloat {
        var ratio = value
        if let theChangedValue = self.sliderValueChanged {
            ratio = theChangedValue(ratio)
        }
        return ratio
    }
}
