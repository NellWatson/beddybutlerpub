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

    @IBOutlet weak var iconImageView: NSImageView!

    var userSelectedSound: String? {
        return UserDefaults.standard.object(forKey: UserDefaultKeys.selectedSound.rawValue) as? String
    }

    //MARK: View Main Events

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //   loadDoubleSliderValues()
        loadDoubleSliderHandler()
        loadSelectedImage(currentValue: self.userSelectedSound!)
    }

    override func viewWillDisappear() {
        super.viewDidDisappear()
        // Removes self from all notifications that are observing
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.

        }
    }

    func loadDoubleSliderHandler() {


        let value = { (valueIn: CGFloat) -> CGFloat in return valueIn }
        let invertedValue = { (valueIn: CGFloat) -> CGFloat in return valueIn }

        let startSlider = NSImage(named: NSImage.Name(rawValue: SliderKeys.StartSlider.rawValue))
        let bedSlider = NSImage(named: NSImage.Name(rawValue: SliderKeys.BedSlider.rawValue))

        var userStartTime: Double? {
            return UserDefaults.standard.object(forKey: UserDefaultKeys.startTimeValue.rawValue) as? Double
        }

        var userBedTime: Double? {
            return UserDefaults.standard.object(forKey: UserDefaultKeys.bedTimeValue.rawValue) as? Double
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
        doubleSliderHandler.addHandle(name: SliderKeys.BedHandler.rawValue, image: bedSlider!, iniRatio: convertedBedValue, sliderValue: value,sliderValueChanged: invertedValue)

        doubleSliderHandler.addHandle(name: SliderKeys.StartHandler.rawValue, image: startSlider!, iniRatio: convertedStartValue, sliderValue: value,sliderValueChanged: invertedValue)
    }

    //MARK: View Controller Actions

    /// If the user clicks on any of the preview buttons, its audio file will play for them.
    @IBAction func previewAudio(sender: AnyObject) {

        if let button: NSButton = sender as? NSButton {

            if let identifier = button.identifier {
                switch identifier {
                case NSUserInterfaceItemIdentifier(rawValue: "Preview Shy"):
                    audioPlayer.playFile(file: AudioPlayer.AudioFiles.Shy)
                case NSUserInterfaceItemIdentifier(rawValue: "Preview Insistent"):
                    audioPlayer.playFile(file: AudioPlayer.AudioFiles.Insistent)
                case NSUserInterfaceItemIdentifier(rawValue: "Preview Zombie"):
                    audioPlayer.playFile(file: AudioPlayer.AudioFiles.Zombie)
                default:
                    break
                }
            }
        }
    }


    @IBAction func changedRadioSelection(sender: NSMatrix) {
        loadSelectedImage(currentValue: sender.selectedCell()!.title)
    }

    @IBAction func changedPreference(sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeys.userPreferenceChanged.rawValue), object: self)
    }

    @IBAction func changeRunStartup(sender: AnyObject) {

        if let theButton = sender as? NSButton {

            let runStartup = theButton.integerValue > 0
            let loginItems = LoginItems()
            // Turn on launch at login
            if runStartup {
                loginItems.createLoginItem()
            } else {
                loginItems.deleteLoginItem()
            }

        }
    }

    // MARK: Other methods

    func loadSelectedImage(currentValue: String) {
        var imageName = ""
        switch currentValue {
        case "Shy":
            imageName = "ShyIcon"
        case "Insistent":
            imageName = "InsistentIcon"
        case "Zombie":
            imageName =  "ZombieIcon"
        default:
            break
        }
        if !imageName.isEmpty {
            let nsImageName = NSImage.Name(rawValue: imageName)
            self.iconImageView.image = NSImage(named: nsImageName)
        }
    }

}

