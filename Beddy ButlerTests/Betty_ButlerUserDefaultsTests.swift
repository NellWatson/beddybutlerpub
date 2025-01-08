//
//  Betty_ButlerUserDefaultsTests.swift
//
//
//  Created by David Garces on 18/08/2015.
//
//

import Cocoa
import XCTest
@testable import Beddy_Butler

class Betty_ButlerUserDefaultsTests: XCTestCase {

    func registerUserDefaultValues() {
        let sharedUserDefaults = UserDefaults.standard
        for key in UserDefaultKeys.allValues {
            switch key {
            case .startTimeValue:
                let theKey = sharedUserDefaults.object(forKey: key.rawValue) as? Double
                if theKey == nil {
                    sharedUserDefaults.set(75000.00, forKey: key.rawValue)
                }
            case .bedTimeValue:
                let theKey = sharedUserDefaults.object(forKey: key.rawValue) as? Double
                if theKey == nil {
                    sharedUserDefaults.set(85000.00, forKey: key.rawValue)
                }
            case .selectedSound:
                let theKey = sharedUserDefaults.object(forKey: key.rawValue) as? String
                if theKey == nil {
                    sharedUserDefaults.set(AudioPlayer.AudioFiles.Shy.description(), forKey: key.rawValue)
                }
            case .runStartup:
                let theKey = sharedUserDefaults.object(forKey: key.rawValue) as? Bool
                if theKey == nil {
                    sharedUserDefaults.set(false, forKey: key.rawValue)
                }
            case .frequency:
                let theKey = sharedUserDefaults.object(forKey: key.rawValue) as? Double
                if theKey == nil {
                    sharedUserDefaults.set(5.00, forKey: key.rawValue)
                }
            case .isMuted:
                let theKey = sharedUserDefaults.object(forKey: key.rawValue) as? Double
                if theKey == nil {
                    sharedUserDefaults.set(false, forKey: key.rawValue)
                }
            }
        }
    }

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        registerUserDefaultValues()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testValueforNonExistingKey() {
        let value: Any = UserDefaults.standard.object(forKey: "testKey") as Any
        XCTAssertNil(value, "value for testKey should always be nil because it does not exist")
    }

    func testValueForKeyBedTimeValue() {
        let value = UserDefaults.standard.object(forKey: UserDefaultKeys.bedTimeValue.rawValue) as? Double
        XCTAssertNotNil(value)
        guard let value else { return }
        XCTAssert(value > 0, "User stored preference for bed time value can be accessed")
    }

    func testValueForKeyStartTimeValue() {
        let value = UserDefaults.standard.object(forKey: UserDefaultKeys.startTimeValue.rawValue) as? Double
        guard let value else { return }
        XCTAssert(value > 0, "User stored preference for start time value can be accessed")
    }

    func testValueForKeyrunStartupValue() {
        let value: AnyObject? = UserDefaults.standard.object(forKey: UserDefaultKeys.runStartup.rawValue) as AnyObject

        XCTAssertNotNil(value)
        guard let value else { return }
        XCTAssert(value is Bool, "User stored preference for run at startup value can be accessed")
    }

    func testValueForKeySelectedSound() {
        let value = UserDefaults.standard.object(forKey: UserDefaultKeys.selectedSound.rawValue) as? String
        XCTAssertNotNil(value)
        guard let value else { return }
        XCTAssertNotEqual(value, String(), "User stored preference for selected sound value can be accessed")
    }

    func testValueForKeyStartTimeCanBeConvertedToDate() {
        let value = UserDefaults.standard.object(forKey: UserDefaultKeys.startTimeValue.rawValue) as? Double
        XCTAssertNotNil(value)

        let date = NSDate(timeIntervalSince1970: value!)
        XCTAssertNotNil(value, "Start date can be converted to date")
    }



}
