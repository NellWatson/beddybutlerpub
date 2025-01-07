//
//  AppDelegate.swift
//  Beddy Butler
//
//  Created by David Garces on 10/08/2015.
//  Copyright (c) 2015-2025 Nell Watson Inc. All rights reserved.
//

import Cocoa
import ServiceManagement

@main
@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {

    var butlerTimer: ButlerTimer?

    var statusBar: NSStatusBar!
    var statusBarItem: NSStatusItem!

    @IBOutlet weak var menu: NSMenu!

    func setStatusItem() {
        statusBar = NSStatusBar()
        statusBarItem = statusBar.statusItem(withLength: 22)

        statusBarItem.button?.image = NSImage(named: NSImage.Name("AppIcon_monochrome"))
        statusBarItem.button?.image?.size = NSSize(width: 18, height: 18)

        // Set the menu that should appear when the item is clicked + color should changed automatically
        statusBarItem?.menu = self.menu

        // TODO: add highlight
        statusBarItem.button?.target = self
        statusBarItem.button?.action = #selector(statusBarButtonClicked)
    }

    @objc func statusBarButtonClicked() {
        print("statusBarButtonClicked")
        if let button = statusBarItem.button {
            // Highlight the image when the menu is about to be opened
            button.highlight(true)

            // Display the menu manually
            statusBarItem.menu?.popUp(positioning: nil, at: NSPoint(x: 0, y: button.frame.height), in: button)

            // Reset the highlight after the menu closes
            button.highlight(false)
        }
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSLog("Calling function", #function)

        setStatusItem()

        registerUserDefaultValues()

        //create a new ButlerTimer
        self.butlerTimer = ButlerTimer()

        //register for Notifications
        registerForNotifications()

        //determine if helper app is running
        var startedAtLogin = false
        let apps = NSWorkspace.shared.runningApplications
        for app in apps {
            if app.bundleIdentifier == "com.nellwatson.BeddyButlerHelperApp" {
                startedAtLogin = true
            }
        }

        if startedAtLogin {
            DistributedNotificationCenter.default().postNotificationName(Notification.Name(rawValue: "terminateApp"),
                                                                         object: Bundle.main.bundleIdentifier)
        }
    }

    @IBAction func quit(sender: AnyObject) {
        NSApplication.shared.terminate(nil)
    }

    /// This method ensures that the user default values are set when the user opens the app for the first time
    /// Subsequent launches of the app will not reset these values
    func registerUserDefaultValues() {
        var sharedUserDefaults = UserDefaults.standard

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
}

extension AppDelegate {
    func applicationDidBecomeActive(_ notification: Notification) {
        NSLog("Calling function", #function)
        if let theButlerTimer = butlerTimer {
            theButlerTimer.calculateNewTimer()
        } else {
            butlerTimer = ButlerTimer()
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        NSLog("Calling function", #function)
        // Insert code here to tear down your application
        self.butlerTimer = nil
        unregisterFromNotifications()
    }
}

// MARK: - Notifications

extension AppDelegate {
    /// Beddy Butler should get notifified when it goes to sleep to handle the current timer
    @objc func receiveSleepNotification(notification: Notification) {
        NSLog("Sleep notification received: \(notification.name)")
        self.butlerTimer?.timer?.invalidate()
    }

    /// Beddy Butler should get notified when the PC wakes up from sleep so it can restart its timer
    @objc func receiveWakeNotification(notification: Notification) {
        NSLog("Wake notification received: \(notification.name)")
        self.butlerTimer?.calculateNewTimer()
    }

    private func registerForNotifications() {
        //These notifications are filed on NSWorkspace's notification center, not the default
        // notification center. You will not receive sleep/wake notifications if you file
        //with the default notification center.

        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(self.receiveSleepNotification), name: NSWorkspace.willSleepNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(self.receiveWakeNotification), name: NSWorkspace.didWakeNotification, object: nil)
    }

    private func unregisterFromNotifications() {
        NSWorkspace.shared.notificationCenter.removeObserver(self)
    }
}
