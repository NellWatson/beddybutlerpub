//
//  Beddy_ButlerTests.swift
//  Beddy ButlerTests
//
//  Created by David Garces on 10/08/2015.
//  Copyright (c) 2015 David Garces. All rights reserved.
//

import Cocoa
import XCTest
@testable import Beddy_Butler

class Beddy_ButlerSliderTests: XCTestCase {
    
    var preferencesViewController: PreferencesViewController?
    var doubleSliderHandler: DoubleSliderHandler? {
        get {
            return preferencesViewController?.doubleSliderHandler
        }
        set {
            preferencesViewController?.doubleSliderHandler = newValue
        }
        
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        
       
        preferencesViewController = storyboard.instantiateControllerWithIdentifier("Preferences Storyboard") as? PreferencesViewController
        let _ = preferencesViewController?.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        doubleSliderHandler = nil
    }
    
    func testStartSliderSetsValue() {
        doubleSliderHandler?.handles[SliderKeys.StartHandler.rawValue]?.curValue = 0.1
        XCTAssertTrue(doubleSliderHandler?.handles[SliderKeys.StartHandler.rawValue]?.curValue > 0, "Start Slider can set value")
    }
    
    func testBedSliderSetsValue() {
        doubleSliderHandler?.handles[SliderKeys.BedHandler.rawValue]?.curValue = 0.5
        XCTAssertTrue(doubleSliderHandler?.handles[SliderKeys.BedHandler.rawValue]?.curValue > 0, "Bed Slider can set value")
    }
//    
//    func testStartSliderChanges1() {
//        
//       //preferencesViewController?.startSliderView = StartSliderView()
//        //preferencesViewController?.doubleSlider.setDoubleLoValue(30000)
//        //XCTAssertTrue(doubleSlider?.doubleLoValue() == 30000, "start time remains unchanged before setting end time > start time")
//         //doubleSlider?.setDoubleLoValue(20000)
//        //XCTAssertTrue(startSlider?.doubleValue == 10, "start time remains unchanged after setting end time > start time")
//    }
//    
    func testStartSliderChanges2() {
        doubleSliderHandler?.handles[SliderKeys.StartHandler.rawValue]?.curValue = 0.7
        doubleSliderHandler?.handles[SliderKeys.BedHandler.rawValue]?.curValue = 0.9
        XCTAssertTrue(doubleSliderHandler?.handles[SliderKeys.StartHandler.rawValue]?.curValue < 10, "start time updates to < than end time if we set end time < than start time")
    }
    
    /// Actually possible only in UI Tests (restrictions to start or low value only happen during dragging
    func testStartSliderChange3() {
        doubleSliderHandler?.handles[SliderKeys.StartHandler.rawValue]?.curValue = 0.9
        doubleSliderHandler?.handles[SliderKeys.BedHandler.rawValue]?.curValue = 0.7
        Swift.print(doubleSliderHandler?.handles[SliderKeys.BedHandler.rawValue]?.curValue)
        XCTAssertTrue(doubleSliderHandler?.handles[SliderKeys.BedHandler.rawValue]?.curValue == ( (0.9 - 0.7)/2 + 0.9 ), "start time updates to < than end time if we set end time < than start time")
    }
//
//    func testStartSliderChanges3() {
//        doubleSlider?.setDoubleLoValue(100.0)
//        doubleSlider?.setDoubleHiValue(90.0)
//        XCTAssertTrue(doubleSlider?.doubleLoValue() == (90 - 30), "start time updates to (end time - 30) if we set end time < start time ")
//    }
//    
//    func testEndSliderChanges1() {
//        doubleSlider?.setDoubleLoValue(100.0)
//        doubleSlider?.setDoubleHiValue(200.0)
//        doubleSlider?.setDoubleLoValue(130.0)
//        XCTAssertTrue(doubleSlider?.doubleHiValue() == 200, "end time remains unchanged after setting start time < end time")
//    }
//    
//    func testEndSliderChanges2() {
//        doubleSlider?.setDoubleLoValue(100.0)
//        doubleSlider?.setDoubleHiValue(200.0)
//        doubleSlider?.setDoubleHiValue(300.0)
//        XCTAssertTrue(doubleSlider?.doubleHiValue() > 300, "end time  updates to > than start time if we set start time > than end time")
//    }
//    
//    func testEndSliderChanges3() {
//        doubleSlider?.setDoubleLoValue(100.0)
//        doubleSlider?.setDoubleHiValue(200.0)
//        doubleSlider?.setDoubleHiValue(300.0)
//        XCTAssertTrue(doubleSlider?.doubleHiValue()  == (300 + 30), "end time  updates to (start time + 30) if we set start time > than end time")
//    }
//    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
