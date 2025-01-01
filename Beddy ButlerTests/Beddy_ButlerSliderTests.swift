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
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        
        preferencesViewController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "Preferences Storyboard")) as? PreferencesViewController
        let _ = preferencesViewController?.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        doubleSliderHandler = nil
    }
    
    func testStartSliderSetsValue() {
        doubleSliderHandler?.handles[SliderKeys.StartHandler.rawValue]?.curValue = 0.1
        let value = doubleSliderHandler?.handles[SliderKeys.StartHandler.rawValue]?.curValue
        XCTAssertNotNil(value)
        guard let value else { return }
        XCTAssertTrue( value > 0, "Start Slider can set value")
    }
    
    func testBedSliderSetsValue() {
        doubleSliderHandler?.handles[SliderKeys.BedHandler.rawValue]?.curValue = 0.5
        let value = doubleSliderHandler?.handles[SliderKeys.BedHandler.rawValue]?.curValue
        XCTAssertNotNil(value)
        guard let value else { return }
        XCTAssertTrue(value > 0, "Bed Slider can set value")
    }
    
    func testStartSliderChanges2() {
        doubleSliderHandler?.handles[SliderKeys.StartHandler.rawValue]?.curValue = 0.7
        doubleSliderHandler?.handles[SliderKeys.BedHandler.rawValue]?.curValue = 0.9

        let value = doubleSliderHandler?.handles[SliderKeys.StartHandler.rawValue]?.curValue
        XCTAssertNotNil(value)
        guard let value else { return }

        XCTAssertTrue(value < 10, "start time updates to < than end time if we set end time < than start time")
    }
    
    /// Actually possible only in UI Tests (restrictions to start or low value only happen during dragging
    func testStartSliderChange3() {
        doubleSliderHandler?.handles[SliderKeys.StartHandler.rawValue]?.curValue = 0.9
        doubleSliderHandler?.handles[SliderKeys.BedHandler.rawValue]?.curValue = 0.7

        let value = doubleSliderHandler?.handles[SliderKeys.BedHandler.rawValue]?.curValue
        XCTAssertNotNil(value)
        guard let value else { return }


        Swift.print(value)
        XCTAssertTrue(value == ( (0.9 - 0.7)/2 + 0.9 ), "start time updates to < than end time if we set end time < than start time")
    }
    
}
