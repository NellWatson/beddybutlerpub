//
//  ButlerTimer.swift
//  Beddy Butler
//
//  Created by David Garces on 19/08/2015.
//  Copyright (c) 2015-2025 Nell Watson Inc. All rights reserved.
//

import Foundation
import Cocoa

class ButlerTimer {

    //MARK: Properties

    var numberOfRepeats = 5
    var timer: Timer?
    /// the audio player that will be used in the play sound action
    var audioPlayer: AudioPlayer
    let butlerImage = NSImage(named: NSImage.Name("Butler"))

    //MARK: Computed properties

    //MARK: User Properties
    var userStartTime: Double? {
        get {
            return UserDefaults.standard.object(forKey: UserDefaultKeys.startTimeValue.rawValue) as? Double
        }
        set {
            UserDefaults.standard.set(newValue!, forKey: UserDefaultKeys.startTimeValue.rawValue)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationKeys.userPreferenceChanged.rawValue), object: self)
        }
    }

    var userBedTime: Double? {
        get {
            return UserDefaults.standard.object(forKey: UserDefaultKeys.bedTimeValue.rawValue) as? Double
        }
        set {
            UserDefaults.standard.set(newValue!, forKey: UserDefaultKeys.bedTimeValue.rawValue)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationKeys.userPreferenceChanged.rawValue), object: self)
        }
    }

    var userMuteSound: Bool? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKeys.isMuted.rawValue)
        }
        get {
            return UserDefaults.standard.object(forKey: UserDefaultKeys.isMuted.rawValue) as? Bool
        }
    }

    ///TODO: Delete Temporary frequency variable
    var userSelectedFrequency: Double? {
        return UserDefaults.standard.object(forKey: UserDefaultKeys.frequency.rawValue) as? Double
    }

    var userSelectedSound: AudioPlayer.AudioFiles {
        if let audioFile = UserDefaults.standard.object(forKey: UserDefaultKeys.selectedSound.rawValue) as? String {
            return AudioPlayer.AudioFiles(stringValue: audioFile)

        } else {
            return AudioPlayer.AudioFiles(stringValue: String())
        }
    }

    /// Calculates the start date based on the current user value
    var startDate: Date {
        guard let userStartTime = self.userStartTime else { return Date()}
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: self.currentDate)
        // Convert seconds to int, we are sure we will not exceed max int value as we only have 86,000 seconds or less
        let seconds = Int(userStartTime) + TimeZone.current.secondsFromGMT()
        return calendar.date(byAdding: .second, value: seconds, to: startOfDay)!
    }

    /// Gets today's date
    var currentDate: Date {
        let currentLocalTime = Date()

        let localTimeZone = TimeZone.current
        let secondsFromGTM = TimeInterval.init(localTimeZone.secondsFromGMT())
        let resultDate = Date(timeInterval: secondsFromGTM, since: currentLocalTime)

        return resultDate
    }

    /// Calculates the end date based on the current user value
    var bedDate: Date {
        guard let userBedTime = self.userBedTime else { return Date()}
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: self.currentDate)
        // Convert seconds to int, we are sure we will not exceed max int value as we only have 86,000 seconds or less
        let seconds = Int(userBedTime) + TimeZone.current.secondsFromGMT()
        return calendar.date(byAdding: .second, value: seconds, to: startOfDay)!

    }

    //MARK: Initialisers and deinitialisers

    init() {
        self.audioPlayer = AudioPlayer()

        // Not to be called directly...
        calculateNewTimer()

        // Register observers to recalculate the timer
        NotificationCenter.default.addObserver(self, selector: #selector(self.calculateNewTimer), name: Notification.Name(NotificationKeys.userPreferenceChanged.rawValue), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.validateUserTimeValue), name: UserDefaults.didChangeNotification , object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUserTimeValue), name: Notification.Name(NotificationKeys.startSliderChanged.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUserTimeValue), name: Notification.Name(NotificationKeys.endSliderChanged.rawValue), object: nil)

    }

    deinit {
        timer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Timer methods

    /// Play sound should invalidate the current timer and schedule the next timer
    @objc func playSound() {
        //let previousImage = AppDelegate.statusItem?.image
        var result: String

        //AppDelegate.statusItem?.image = butlerImage
        if !userMuteSound! {
            audioPlayer.playFile(file: userSelectedSound)
            // TO DO: Remove temporary log
            result = "Sound played: \(userSelectedSound), Current time is: \(currentDate), Set Start Date: \(startDate), Set Bed Date: \(bedDate), Time between plays (frequency): \(userSelectedFrequency!) \n"

        } else {
            // TO DO: Remove temporary log
            result = "Muted by user: \(userSelectedSound), Current time is: \(currentDate), Set Start Date: \(startDate), Set Bed Date: \(bedDate), Time between plays (frequency): \(userSelectedFrequency!) \n"

        }
        writeToLogFile(message: result)
        NSLog(result)

        calculateNewTimer()
        //AppDelegate.statusItem?.image = previousImage
    }

    @objc func calculateNewTimer() {
        //Invalidate curent timer
        if let theTimer = timer {
            theTimer.invalidate()
        }

        var newInterval = randomInterval
        let dateAfterInterval = Date(timeInterval: randomInterval, since: self.currentDate)
        //Analyse interval:
        // 1. If Now + interval or Now alone are before start time (date), create interval from now until after start date + (5-20min)
        if self.startDate > dateAfterInterval {
            newInterval = self.startDate.timeIntervalSince(self.currentDate) + newInterval
            setNewTimer(timeInterval: newInterval)
        } else if dateAfterInterval > self.startDate && self.bedDate > dateAfterInterval {
            setNewTimer(timeInterval: newInterval)
        } else {
            //the date will be after the interval so we calculate a new interval for tomorrow
            let calendar = Calendar.current
            var components = DateComponents()
            components.day = 1
            components.second = Int(newInterval)

            let theNewDate = calendar.date(byAdding: components, to: self.startDate)
            newInterval = theNewDate!.timeIntervalSince(self.currentDate)
            setNewTimer(timeInterval: newInterval)
            // finally we make sure that the sound is not muted anymore
            self.userMuteSound = false
        }
    }

    /// Invalidates the current timer and sets a new timer using the specified interval
    func setNewTimer(timeInterval: TimeInterval) {
        // Shcedule timer with the initial value
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.playSound), userInfo: nil, repeats: false)
        RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.common)
        //TODO: Remove log entry
        NSLog("Timer created for interval: \(timeInterval)")
    }

    /**
     Create a random number of seconds from the range of 5 to 20 minutes (i.e. 300 to 1200 secs) arc4random_uniform(upper_bound) will return a uniformly distributed random number less than upper_bound. arc4random_uniform() is recommended over constructions like ``arc4random() % upper_bound'' as it avoids "modulo bias" when the upper bound is not a power of two.

     - Returns: If the user has selected a frequency, a random number in that frequency, otherwise a random number between 5 and 20 minutes.

     ref: http://stackoverflow.com/questions/3420581/how-to-select-range-of-values-when-using-arc4random
     ref: https://en.wikipedia.org/wiki/Fisher–Yates_shuffle#Modulo_bias
     */
    var randomInterval: TimeInterval {

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
        return TimeInterval(source + randomStart) // adding 300 will ensure that it will always be from 300 to 1200

    }

    //MARK: Ratio handling
    @objc func updateUserTimeValue(notification: NSNotification) {
        if let newValue = notification.object as? Double {
            switch notification.name {
            case Notification.Name(rawValue: NotificationKeys.startSliderChanged.rawValue):
                //let convertedValue = newValue < 0.5 ? newValue * 86400 : (newValue + 0.080) * 86400
                let convertedValue = newValue * 86400 / 0.92
                self.userStartTime = convertedValue
            case Notification.Name(rawValue: NotificationKeys.endSliderChanged.rawValue):
                //let convertedValue = newValue > 0.5 ? newValue * 86400 : (newValue - 0.080) * 86400
                let convertedValue = (newValue - 0.080) * 86400 / 0.92
                self.userBedTime = convertedValue
            default:
                break;
            }
        }
    }

    @objc func validateUserTimeValue() {
        let timeGap = 7200.00
        let maxTime = 86400.00
        if let userBedTime, let userStartTime, userBedTime < userStartTime {
            if userStartTime + timeGap > maxTime {
                self.userStartTime = userBedTime - timeGap
            } else {
                self.userBedTime = userStartTime + timeGap
            }
        }
    }

    // TODO: Remove test interval -
    var testInteval: TimeInterval {
        return TimeInterval(arc4random_uniform(100))
    }

    //TODO: Remove log file and logging functionality -
    func writeToLogFile(message: String){
        //Create file manager instance
        let fileManager = FileManager()

        let URLs = fileManager.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        let documentURL = URLs[0]
        let fileURL = documentURL.appendingPathComponent("BeddyButlerLog.txt")

        let data = message.data(using: .utf8)

        //if !fileManager.fileExistsAtPath(fileURL) {
        do {
            if !fileManager.fileExists(atPath: fileURL.path) {

                if !fileManager.createFile(atPath: fileURL.path, contents: data , attributes: nil) {
                    NSLog("File not created: \(fileURL.absoluteString)")
                }
            }

            let handle: FileHandle = try FileHandle(forWritingTo: fileURL)
            handle.truncateFile(atOffset: handle.seekToEndOfFile())
            handle.write(data!)
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
        let randomInterval = minimum + TimeInterval(randomOffset)
        return NSDate(timeIntervalSince1970: randomInterval)
    }
}
