//
//  RandomnessFormatter.swift
//  Beddy Butler
//
//  Copyright (c) 2015 Nell Watson Inc. All rights reserved.
//
//

import Cocoa

class RandomnessFormatter: Formatter {

    override func string(for obj: Any?) -> String? {

        let number = obj as! Double
        let secondNumber = (number * 0.7) + number

        //var numberEndIndex = number < 10 ? 3 : 4
        //var secondNumberEndIndex = secondNumber < 10 ? 3 : 4


        let firstStringNumber = String(format:"%.2f", number)
        let secondStringNumber = String(format:"%.2f", secondNumber)

        var stringForm: String = firstStringNumber

        stringForm = stringForm + " - "
        stringForm = stringForm + secondStringNumber + " min."

        return stringForm

    }


    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {

        //var intResult: Int
        //var scanner: NSScanner
        //var returnValue: Bool

        var returnString = String()

        for char in string {
            if char != "-" {
                returnString = returnString + String(char)
            } else
            {
                break
            }
        }


        if let _ = Int(returnString) {
            return true
        } else
        {
            return false
        }
    }

}
