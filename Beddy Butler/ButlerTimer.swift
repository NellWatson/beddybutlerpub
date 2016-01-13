//
//  ButlerTimer.swift
//  Beddy Butler
//
//  Created by David Garces on 19/08/2015.
//  Copyright (c) 2015 Nell Watson Inc. All rights reserved.
//

import Foundation
import Cocoa

class ButlerTimer: NSObject {
    
    //MARK: Properties
    
    var numberOfRepeats = 5
    var timer: NSTimer?
    /// the audio player that will be used in the play sound action
    var audioPlayer: AudioPlayer
    let butlerImage = NSImage(named: "Butler")
    
    //MARK: Computed properties
    
    //MARK: User Properties
    var userStartTime: Double? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.startTimeValue.rawValue) as? Double
        }
        set {
            NSUserDefaults.standardUserDefaults().setDouble(newValue!, forKey: UserDefaultKeys.startTimeValue.rawValue)
            NSUserDefaults.standardUserDefaults().synchronize()
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationKeys.userPreferenceChanged.rawValue, object: self)
        }
    }
    
    var userBedTime: Double? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.bedTimeValue.rawValue) as? Double
        }
        set {
            NSUserDefaults.standardUserDefaults().setDouble(newValue!, forKey: UserDefaultKeys.bedTimeValue.rawValue)
            NSUserDefaults.standardUserDefaults().synchronize()
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationKeys.userPreferenceChanged.rawValue, object: self)
        }
    }
    
    var userMuteSound: Bool? {
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: UserDefaultKeys.isMuted.rawValue)
        }
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.isMuted.rawValue) as? Bool
        }
    }
    
    ///TODO: Delete Temporary frequency variable
    var userSelectedFrequency: Double? {
        return NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.frequency.rawValue) as? Double
    }
    
    var userSelectedSound: AudioPlayer.AudioFiles {
        if let audioFile = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.selectedSound.rawValue) as? String {
            return AudioPlayer.AudioFiles(stringValue: audioFile)
        
        } else {
            return AudioPlayer.AudioFiles(stringValue: String())
        }
    }
    
    /// Calculates the start date based on the current user value
    var startDate: NSDate {
        
        let calendar = NSCalendar.currentCalendar()
        let startOfDay = calendar.startOfDayForDate(self.currentDate)
        // Convert seconds to int, we are sure we will not exceed max int value as we only have 86,000 seconds or less
        let seconds = Int(self.userStartTime!) + NSTimeZone.systemTimeZone().secondsFromGMT
        return calendar.dateByAddingUnit(NSCalendarUnit.Second, value: seconds, toDate: startOfDay, options: NSCalendarOptions.MatchFirst)!
    }
    
    /// Gets today's date
    var currentDate: NSDate {
        let currentLocalTime = NSDate()
        
        let localTimeZone = NSTimeZone.systemTimeZone()
        let secondsFromGTM = NSTimeInterval.init(localTimeZone.secondsFromGMT)
        let resultDate = NSDate(timeInterval: secondsFromGTM, sinceDate: currentLocalTime)
        
        return resultDate
    }
    
    /// Calculates the end date based on the current user value
    var bedDate: NSDate {
        let calendar = NSCalendar.currentCalendar()
        let startOfDay = calendar.startOfDayForDate(self.currentDate)
        // Convert seconds to int, we are sure we will not exceed max int value as we only have 86,000 seconds or less
        let seconds = Int(self.userBedTime!) + NSTimeZone.systemTimeZone().secondsFromGMT
        return calendar.dateByAddingUnit(NSCalendarUnit.Second, value: seconds, toDate: startOfDay, options: NSCalendarOptions.MatchFirst)!
        
    }
    
    //MARK: Initialisers and deinitialisers
    
    override init() {
        self.audioPlayer = AudioPlayer()
        super.init()
        
        // Not to be called directly...
        calculateNewTimer()
        
        // Register observers to recalculate the timer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "calculateNewTimer", name: NotificationKeys.userPreferenceChanged.rawValue , object: nil)
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "validateUserTimeValue", name: NSUserDefaultsDidChangeNotification , object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateUserTimeValue:", name: NotificationKeys.startSliderChanged.rawValue , object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateUserTimeValue:", name: NotificationKeys.endSliderChanged.rawValue , object: nil)
        
       
    }
    
    deinit {
        timer?.invalidate()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: Timer methods
    
    /// Play sound should invalidate the current timer and schedule the next timer
    func playSound() {
        //let previousImage = AppDelegate.statusItem?.image
        var result: String
        
        //AppDelegate.statusItem?.image = butlerImage
        if !userMuteSound! {
            audioPlayer.playFile(userSelectedSound)
            // TO DO: Remove temporary log
            result = "Sound played: \(userSelectedSound), Current time is: \(currentDate), Set Start Date: \(startDate), Set Bed Date: \(bedDate), Time between plays (frequency): \(userSelectedFrequency!) \n"
           
        } else {
            // TO DO: Remove temporary log
            result = "Muted by user: \(userSelectedSound), Current time is: \(currentDate), Set Start Date: \(startDate), Set Bed Date: \(bedDate), Time between plays (frequency): \(userSelectedFrequency!) \n"
           
        }
        writeToLogFile(result)
        NSLog(result)
        
        calculateNewTimer()
        //AppDelegate.statusItem?.image = previousImage
    }
    
    func calculateNewTimer() {
        //Invalidate curent timer
        if let theTimer = timer {
            theTimer.invalidate()
        }
        
        var newInterval = randomInterval
        let dateAfterInterval = NSDate(timeInterval: randomInterval, sinceDate: self.currentDate)
        //Analyse interval:
        // 1. If Now + interval or Now alone are before start time (date), create interval from now until after start date + (5-20min)
        if self.startDate.isGreaterThan(dateAfterInterval) {
            newInterval = self.startDate.timeIntervalSinceDate(self.currentDate) + newInterval
            setNewTimer(newInterval)
        } else if dateAfterInterval.isGreaterThan(self.startDate) && self.bedDate.isGreaterThan(dateAfterInterval) {
            setNewTimer(newInterval)
        } else {
            //the date will be after the interval so we calculate a new interval for tomorrow
            let calendar = NSCalendar.currentCalendar()
            let components = NSDateComponents()
            components.day = 1
            components.second = Int(newInterval)
            let theNewDate = calendar.dateByAddingComponents(components, toDate: self.startDate, options: NSCalendarOptions.MatchFirst)
            newInterval = theNewDate!.timeIntervalSinceDate(self.currentDate)
            setNewTimer(newInterval)
            // finally we make sure that the sound is not muted anymore
            self.userMuteSound = false
        }
    }
    
    /// Invalidates the current timer and sets a new timer using the specified interval
    func setNewTimer(timeInterval: NSTimeInterval) {
        // Shcedule timer with the initial value
        self.timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: "playSound", userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        //TODO: Remove log entry
        NSLog("Timer created for interval: \(timeInterval)")
    }

    /**
        Create a random number of seconds from the range of 5 to 20 minutes (i.e. 300 to 1200 secs) arc4random_uniform(upper_bound) will return a uniformly distributed random number less than upper_bound. arc4random_uniform() is recommended over constructions like ``arc4random() % upper_bound'' as it avoids "modulo bias" when the upper bound is not a power of two.
     
     - Returns: If the user has selected a frequency, a random number in that frequency, otherwise a random number between 5 and 20 minutes.
     
     ref: http://stackoverflow.com/questions/3420581/how-to-select-range-of-values-when-using-arc4random
     ref: https://en.wikipedia.org/wiki/Fisher–Yates_shuffle#Modulo_bias
     */
    var randomInterval: NSTimeInterval {
        
        var randomStart: UInt32
        var randomEnd: UInt32
        
        if let theKey = userSelectedFrequency {
            randomStart = UInt32(theKey * 60)
            randomEnd = UInt32( ( (theKey * 0.7) + theKey) * 60 )
        } else {
            randomStart = 300
            randomEnd = 901
        }
        
        let source = arc4random_uniform(randomEnd) // should return a random number between 0 and 900
        return NSTimeInterval(source + randomStart) // adding 300 will ensure that it will always be from 300 to 1200

    }
    
    //MARK: Ratio handling
    func updateUserTimeValue(notification: NSNotification) {
        if let newValue = notification.object as? Double {
        switch notification.name {
        case NotificationKeys.startSliderChanged.rawValue:
            //let convertedValue = newValue < 0.5 ? newValue * 86400 : (newValue + 0.080) * 86400
            let convertedValue = newValue * 86400 / 0.92
            self.userStartTime = convertedValue
        case NotificationKeys.endSliderChanged.rawValue:
            //let convertedValue = newValue > 0.5 ? newValue * 86400 : (newValue - 0.080) * 86400
            let convertedValue = (newValue - 0.080) * 86400 / 0.92
            self.userBedTime = convertedValue
        default:
            break;
            }
        }
    }
    
    func validateUserTimeValue() {
        let timeGap = 7200.00
        let maxTime = 86400.00
        if userBedTime < userStartTime {
            if userStartTime! + timeGap > maxTime {
                userStartTime = userBedTime! - timeGap
            } else {
                userBedTime! = userStartTime! + timeGap
            }
        }
    }
    
    // TODO: Remove test interval -
    var testInteval: NSTimeInterval {
        return NSTimeInterval(arc4random_uniform(100))
    }
    
    //TODO: Remove log file and logging functionality -
    func writeToLogFile(message: String){
        //Create file manager instance
        let fileManager = NSFileManager()
        
        let URLs = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        
        let documentURL = URLs[0]
        let fileURL = documentURL.URLByAppendingPathComponent("BeddyButlerLog.txt")
        
        let data = message.dataUsingEncoding(NSUTF8StringEncoding)

        //if !fileManager.fileExistsAtPath(fileURL) {
        do {
            if !fileManager.fileExistsAtPath(fileURL.path!) {
                
                if !fileManager.createFileAtPath(fileURL.path!, contents: data , attributes: nil) {
                    NSLog("File not created: \(fileURL.absoluteString)")
                }
            }
            
            let handle: NSFileHandle = try NSFileHandle(forWritingToURL: fileURL)
            handle.truncateFileAtOffset(handle.seekToEndOfFile())
            handle.writeData(data!)
            handle.closeFile()
            
        }
        catch {
            NSLog("Error writing to file: \(error)")
        }

    }
    
        
}

extension NSDate {
    class func randomTimeBetweenDates(lhs: NSDate, _ rhs: NSDate) -> NSDate {
        let lhsInterval = lhs.timeIntervalSince1970
        let rhsInterval = rhs.timeIntervalSince1970
        let difference = fabs(rhsInterval - lhsInterval)
        let randomOffset = arc4random_uniform(UInt32(difference))
        let minimum = min(lhsInterval, rhsInterval)
        let randomInterval = minimum + NSTimeInterval(randomOffset)
        return NSDate(timeIntervalSince1970: randomInterval)
    }
}
