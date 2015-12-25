//
//  UserDefaultKeys.swift
//  Beddy Butler
//
//  Created by David Garces on 21/08/2015.
//  Copyright (c) 2015 Nell Watson Inc. All rights reserved.
//

import Foundation

enum UserDefaultKeys: String {

    case bedTimeValue
    case startTimeValue
    case runStartup
    case selectedSound
    case frequency
    case isMuted
    // keep an array of all the values to iterate through them
    static let allValues = [bedTimeValue, startTimeValue, runStartup, selectedSound,frequency, isMuted]
}
