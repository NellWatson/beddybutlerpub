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

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValueforNonExistingKey() {
        let value: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("testKey")
        XCTAssertNil(value, "value for testKey should always be nil because it does not exist")
    }

    func testValueForKeyBedTimeValue() {
        let value = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.bedTimeValue.rawValue) as? Double
        NSLog("The value is: \(value)")
        XCTAssert(value > 0, "User stored preference for bed time value can be accessed")
    }
    
    func testValueForKeyStartTimeValue() {
        let value = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.startTimeValue.rawValue) as? Double
        NSLog("The value is: \(value)")
        XCTAssert(value > 0, "User stored preference for start time value can be accessed")
    }
    
    func testValueForKeyrunStartupValue() {
        let value: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.runStartup.rawValue)
        XCTAssert(value is Bool, "User stored preference for run at startup value can be accessed")
         NSLog("The value is: \(value as! Bool)")
    }
    
    func testValueForKeySelectedSound() {
        
        let value = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.selectedSound.rawValue) as? String
        
        NSLog("The value is: \(value)")
        XCTAssertNotEqual(value!,String(), "User stored preference for selected sound value can be accessed")
    }
    
    func testValueForKeyStartTimeCanBeConvertedToDate() {
        let value = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.startTimeValue.rawValue) as? Double
        let date = NSDate(timeIntervalSince1970: value!)
        NSLog("The date value is: \(date)")
        XCTAssertNotNil(value, "Start date can be converted to date")
    }
    
    

}
