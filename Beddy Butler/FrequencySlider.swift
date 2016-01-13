//
//  FrequencySlider.swift
//  Beddy Butler
//
//  Copyright (c) 2015 Nell Watson Inc. All rights reserved.
//
//

import Cocoa

class FrequencySlider: NSSlider {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
    override func mouseDown(theEvent: NSEvent) {
        super.mouseDown(theEvent)
        // Notify the timer to recalculate
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationKeys.userPreferenceChanged.rawValue, object: self)
    }
    
}
