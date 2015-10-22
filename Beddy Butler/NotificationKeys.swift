//
//  ObserverKeys.swift
//  Beddy Butler
//
//  Created by David Garces on 06/09/2015.
//  Copyright (c) 2015 Nell Watson Inc. All rights reserved.
//

import Foundation


enum NotificationKeys: String {
    
    case userPreferenceChanged // Used to notify the ButlerTimer that it should recalculate a timer
    case startSliderChanged // Used to notify the end slider that it should change to a valid position
    case endSliderChanged // Used to notify the start slider that it should changed to a valid position
}
