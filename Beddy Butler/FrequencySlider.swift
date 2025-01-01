//
//  FrequencySlider.swift
//  Beddy Butler
//
//  Copyright (c) 2015 Nell Watson Inc. All rights reserved.
//
//

import Cocoa

class FrequencySlider: NSSlider {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        super.mouseDown(with: theEvent)
        // Notify the timer to recalculate
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeys.userPreferenceChanged.rawValue), object: self)
    }
}
