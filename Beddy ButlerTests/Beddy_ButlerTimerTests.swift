//
//  Beddy_ButlerTimerTests.swift
//
//
//  Created by David Garces on 21/08/2015.
//
//

import Cocoa
import XCTest
@testable import Beddy_Butler

class Beddy_ButlerTimerTests: XCTestCase {

    var butlerTimer = ButlerTimer()

    let calendar = Calendar.current
    var startOfDay: Date {
        return calendar.startOfDay(for: Date())
    }

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTimeZone(){
        let currentLocalTime = Date()

        let sourceTimeZone = TimeZone(abbreviation: "UTC")
        let triggerTimeZone = TimeZone.current

        let sourceGTMOffset = sourceTimeZone?.secondsFromGMT(for: currentLocalTime)
        let triggerGTMOffset = triggerTimeZone.secondsFromGMT(for: currentLocalTime)

        let interval = triggerGTMOffset - sourceGTMOffset!

        let finalDate = Date(timeInterval: TimeInterval.init(interval), since: currentLocalTime)

        Swift.print("Current local time: \(currentLocalTime)")
        Swift.print("Source Time Zone (GTM): \(sourceTimeZone)")
        Swift.print("Trigger Time Zone (System Time Zone): \(triggerTimeZone)")
        Swift.print("Source GTM Offset: \(sourceGTMOffset)")
        Swift.print("Trigger GTM Offset: \(triggerGTMOffset)")
        Swift.print("Interval (Source - Trigger Offsets): \(interval)")
        Swift.print("Final Date (Current + interval): \(finalDate)")
    }

    func testDate() {

        let localTimeZone = TimeZone.current
        let secondsFromGTM = TimeInterval.init(localTimeZone.secondsFromGMT())
        let resultDate = Date(timeInterval: secondsFromGTM, since: Date())

        Swift.print("Original: \(Date()), New: \(resultDate)")
    }

    func testInterval() {
        let theDate = Date()
        NSLog("Interval: \(theDate)")
        XCTAssertTrue(theDate.timeIntervalSince1970 > 1, "test")
    }

    func testStartDateInitialises() {
        let theDate = butlerTimer.startDate
        NSLog("Now: \(startOfDay)")
        NSLog("The date: \(theDate)")
        XCTAssertTrue(theDate.timeIntervalSince(startOfDay) > 0, "the start date should be around now")
    }

    func testEndDateInitialises() {
        let theDate = butlerTimer.bedDate
        NSLog("Now: \(startOfDay)")
        NSLog("The date: \(theDate)")
        XCTAssertTrue(theDate.timeIntervalSince(startOfDay) > 0, "the start date should be around now")
    }

    func testRandomIntervalGeneratesCorrectValues() {
        // "randomInterval should generate values between 300 and 1200"
        for x in 0...20 {
            let result = butlerTimer.randomInterval
            NSLog("Randomly generated number \(x): \(result)")
            XCTAssertTrue((result > 300) && (result < 1200) , "randomInterval should generate values between 300 and 1200")
        }
    }

    func testRandomTestIntervalGeneratesCorrectValues() {
        // "randomInterval should generate values between 300 and 1200"
        for x in 0...20 {
            let result = butlerTimer.testInteval
            NSLog("Randomly generated number \(x): \(result)")
            XCTAssertTrue((result > 0) && (result < 100) , "random testInterval should generate values between 0 and 100")
        }
    }

    /// Butler timer should update start time after user updates start time
    func testUpdateStartTime() {
        // Initially change the user setting so that it's different that what we will use for testing
        UserDefaults.standard.setValue(50000, forKey: UserDefaultKeys.startTimeValue.rawValue)
        let newButlerTimer = ButlerTimer()
        // read the current value from ButlerTimer
        let currentStartDate = newButlerTimer.startDate
        // emulate a new value set by the user
        UserDefaults.standard.setValue(65000, forKey: UserDefaultKeys.startTimeValue.rawValue)
        //TO DO: do we need to send a notification for start slider changed?
        //NotificationCenter.default.postNotificationName(NotificationKeys.startSliderChanged.rawValue, object: StartSliderView())
        NSLog("previous date: \(currentStartDate) new date: \(newButlerTimer.startDate)")
        // Assert
        XCTAssertNotEqual(currentStartDate, self.butlerTimer.startDate, "Butler timer should update start time after user updates start time")


    }

    /// Butler timer should update end time after user updates end time
    func testUpdateEndTime() {
        // Initially change the user setting so that it's different that what we will use for testing
        UserDefaults.standard.setValue(67000, forKey: UserDefaultKeys.bedTimeValue.rawValue)
        let newButlerTimer = ButlerTimer()
        // read the current value from ButlerTimer
        let currentEndDate = newButlerTimer.bedDate
        // emulate a new value set by the user
        UserDefaults.standard.setValue(72000, forKey: UserDefaultKeys.bedTimeValue.rawValue)
        //TO DO: do we need to send a notification for end slider changed?
        //NotificationCenter.default.postNotificationName(NotificationKeys.endSliderChanged.rawValue, object: StartSliderView())
        NSLog("previous date: \(currentEndDate) new date: \(newButlerTimer.bedDate)")
        // Assert
        XCTAssertNotEqual(currentEndDate, self.butlerTimer.bedDate, "Butler timer should update end time after user updates end time")


    }

    func testTimerCalculates() {
        //Test 1: first set the user values for the test. Check the current time, run the app and change preferences so that you set the start timer about one hour AFTER now, and the end timer about two or three hours AFTER now.

        //Test 2: Check the current time, run the app and change preferences so that you set the start timer about one hour BEFORE now, and the end timer about one or two hours AFTER now.

        //Test 3: Check the current time, run the app and change preferences so that you set the start timer about two hours BEFORE now, and the end timer about one hours BEFORE now.

        let theButlerTimer = ButlerTimer()

        //Make a date before the current start date
        let calendar = Calendar.current
        _ = calendar.startOfDay(for: Date())

        let currentDate = Date()

        theButlerTimer.calculateNewTimer()

        let dateAfterInterval = theButlerTimer.timer?.fireDate
        NSLog("Timer interval: \(theButlerTimer.timer!.fireDate.timeIntervalSince(currentDate))")
        NSLog("Simulated current date: \(currentDate)")
        NSLog("date after Inverval: \(dateAfterInterval)")
        NSLog("start date: \(theButlerTimer.startDate)")
        XCTAssertTrue(dateAfterInterval! > theButlerTimer.startDate, "When calculating timer before startDate, timer should execute after startDate")

        if theButlerTimer.bedDate > currentDate {
            XCTAssertTrue(theButlerTimer.bedDate > dateAfterInterval!, "When calculating timer before endDate, timer should execute before endDate")
        } else
        {
            XCTAssertTrue(dateAfterInterval! > theButlerTimer.bedDate, "When calculating timer after startDate, timer should execute after today's bedDate")
            var components = DateComponents()
            components.day = 1
            let tomorrowsStartDate = calendar.date(byAdding: components, to: theButlerTimer.startDate)
            let tomorrowsEndDate = calendar.date(byAdding: components, to: theButlerTimer.bedDate)
            XCTAssertTrue(dateAfterInterval! > tomorrowsStartDate!, "When calculating timer after startDate, timer should execute after startDate of next day and before enddate of next day")
            XCTAssertTrue(tomorrowsEndDate! > dateAfterInterval!, "When calculating timer after startDate, timer should execute after startDate of next day and before enddate of next day")
        }
    }

    func testTimer1Initialises() {
        NSLog("The timer 1 is: \(butlerTimer.timer)")
        XCTAssertTrue(butlerTimer.timer!.timeInterval > 0, "Timer1 should be initialized")
    }

    func testButlerText() {
        //Create file manager instance
        let fileManager = FileManager()

        let URLs = fileManager.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)


        let documentURL = URLs[0]
        let fileURL = documentURL.appendingPathComponent("textFile.txt")

        // NSApplication.ur

        let data = "hola 2".data(using: .utf8)

        //let data = try NSPropertyListSerialization.dataWithPropertyList(plistDictionary, format: NSPropertyListFormat.XMLFormat_v1_0, options: NSPropertyListWriteOptions.init())
        XCTAssert(data!.count > 0)
        fileManager.createFile(atPath: fileURL.path, contents: data, attributes: nil)

    }

    func testButlerActive() {
        // Check if main app is already running; if yes, do nothing and terminate helper app
        var isAlreadyRunning = false
        var isActive = false

        let running = NSWorkspace.shared.runningApplications

        for app in running {
            if app.bundleIdentifier == "com.nellwatson.Beddy-Butler" {
                isAlreadyRunning = true
                isActive = NSApp.isActive
            }

        }

        XCTAssert(isActive)
        XCTAssert(isAlreadyRunning)

    }

    //TODO: Remove log file and logging functionality -
    func testWriteLogInternal(){

        let message = "Hi"

        //Create file manager instance
        let fileManager = FileManager()

        let path = NSString(string: Bundle.main.bundlePath).deletingLastPathComponent
        let reviewedPath = NSString(string: path).deletingLastPathComponent
        let reviewedPath2 = NSString(string: reviewedPath).deletingLastPathComponent
        let reviewedPath3 = NSString(string: reviewedPath2).deletingLastPathComponent
        let reviewedPath4 = NSString(string: reviewedPath3).appendingPathComponent("Resources")

        let newURL = NSURL(string: reviewedPath4)

        let fileURL = newURL!.appendingPathComponent("BeddyButlerLog.txt")

        let data = message.data(using: .utf8)

        XCTAssertNotNil(fileURL)
        guard let fileURL else { return }
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
