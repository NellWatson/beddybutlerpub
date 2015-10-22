//
//  ViewController.swift
//  Beddy Butler
//
//  Created by David Garces on 10/08/2015.
//  Copyright (c) 2015 Nell Watson Inc. All rights reserved.
//

import Cocoa
import ServiceManagement

class PreferencesViewController: NSViewController, NSTextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet var userDefaults: NSUserDefaultsController!
    
    var audioPlayer: AudioPlayer = AudioPlayer()

    @IBOutlet weak var startTimeTextValue: NSTextField!
    
    @IBOutlet weak var endTimeTextValue: NSTextField!
  
    
    @IBOutlet weak var doubleSliderHandler: DoubleSliderHandler!
    
    //MARK: View Main Events
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     //   loadDoubleSliderValues()
        loadDoubleSliderHandler()
    }
    
    override func viewWillDisappear() {
        super.viewDidDisappear()
        // Removes self from all notifications that are observing
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
            
        }
    }
    
    func loadDoubleSliderHandler() {
        
        
        let value = { (valueIn: CGFloat) -> CGFloat in return valueIn }
        let invertedValue = { (valueIn: CGFloat) -> CGFloat in return valueIn }
        
        let startSlider = NSImage(named: SliderKeys.StartSlider.rawValue)
        let bedSlider = NSImage(named: SliderKeys.BedSlider.rawValue)
        bedSlider
        
        var userStartTime: Double? {
            return NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.startTimeValue.rawValue) as? Double
        }
        
        var userBedTime: Double? {
            return NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultKeys.bedTimeValue.rawValue) as? Double
        }
        
        //let startconvertedValue = newValue < 0.5 ? newValue * 86400 : (newValue + 0.080) * 86400

        //let bedconvertedValue = newValue > 0.5 ? newValue * 86400 : (newValue - 0.080) * 86400
       
        
        let initialBedRatio = CGFloat(userBedTime!*0.92/86400)
        let initialStartRadio = CGFloat(userStartTime!*0.92/86400)
        
        //let convertedStartValue = initialStartRadio < 0.5 ? initialStartRadio : (initialStartRadio - 0.080)
        //let convertedBedValue = initialBedRatio > 0.5 ? initialBedRatio : (initialBedRatio + 0.080)

        let convertedStartValue = initialStartRadio
        let convertedBedValue = initialBedRatio + 0.080

        
        // Do any additional setup after loading the view.
        doubleSliderHandler.addHandle(SliderKeys.BedHandler.rawValue, image: bedSlider!, iniRatio: convertedBedValue, sliderValue: value,sliderValueChanged: invertedValue)
        
        doubleSliderHandler.addHandle(SliderKeys.StartHandler.rawValue, image: startSlider!, iniRatio: convertedStartValue, sliderValue: value,sliderValueChanged: invertedValue)
    }
    
    //MARK: View Controller Actions
    
    /// If the user clicks on any of the preview buttons, its audio file will play for them.
    @IBAction func previewAudio(sender: AnyObject) {
        
        if let button: NSButton = sender as? NSButton {
            
            if let identifier = button.identifier {
                switch identifier {
                case "Preview Shy":
                    audioPlayer.playFile(AudioPlayer.AudioFiles.Shy)
                case "Preview Insistent":
                    audioPlayer.playFile(AudioPlayer.AudioFiles.Insistent)
                case "Preview Zombie":
                    audioPlayer.playFile(AudioPlayer.AudioFiles.Zombie)
                default:
                    break
                }
            }
        }
    }
    
    
    @IBAction func changedPreference(sender: AnyObject) {
         NSNotificationCenter.defaultCenter().postNotificationName(NotificationKeys.userPreferenceChanged.rawValue, object: self)
    }
    
    @IBAction func changeRunStartup(sender: AnyObject) {
        
        if let theButton = sender as? NSButton {
            let runStartup = Bool(theButton.integerValue)
                    // Turn on launch at login
                    SMLoginItemSetEnabled("com.nellwatson.BeddyButlerHelperApp" as CFString, runStartup)
                    
        }
    }
    
}

