//
//  AppDelegate.swift
//  Beddy Butler
//
//  Created by David Garces on 10/08/2015.
//  Copyright (c) 2015 Nell Watson Inc. All rights reserved.
//

import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var butlerTimer: ButlerTimer?
    
    static  var statusItem: NSStatusItem?
    
    @IBOutlet weak var menu: NSMenu!
    
    var preferencesController: PreferencesViewController?
    
    var sharedUserDefaults: NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    func applicationDidBecomeActive(notification: NSNotification) {
        if let theButlerTimer = butlerTimer {
            theButlerTimer.calculateNewTimer()
        } else {
            butlerTimer = ButlerTimer()
        }
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Make a status bar that has variable length
        // (as opposed to being a standard square size)
        
        // -1 to indicate "variable length"
        AppDelegate.statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(20)
        
        // Set the text that appears in the menu bar
        //AppDelegate.statusItem!.title = "Beddy Butler"
        AppDelegate.statusItem?.image = NSImage(named: "AppIcon")
        AppDelegate.statusItem?.image?.size = NSSize(width: 18, height: 18)
        // image should be set as tempate so that it changes when the user sets the menu bar to a dark theme
        // TODO: feature disabled for now, this may possibly be the issue to why it is not showing in Nell's mac
        //AppDelegate.statusItem?.image?.setTemplate(true)
        
        // Set the menu that should appear when the item is clicked
        AppDelegate.statusItem!.menu = self.menu
        
        // Set if the item should ”
        //change color when clicked
        AppDelegate.statusItem!.highlightMode = true
        
        registerUserDefaultValues()
        
        //create a new ButlerTimer
        self.butlerTimer = ButlerTimer()
        
        //register for Notifications
        registerForNotitications()
        
        //determine if helper app is running
        var startedAtLogin = false
        let apps = NSWorkspace.sharedWorkspace().runningApplications
        for app in apps {
            if app.bundleIdentifier == "com.nellwatson.BeddyButlerHelperApp" {
                startedAtLogin = true
            }
        }
        
        if startedAtLogin {
            NSDistributedNotificationCenter.defaultCenter().postNotificationName("terminateApp", object: NSBundle.mainBundle().bundleIdentifier)
        }
        
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        self.butlerTimer = nil
        deRegisterFromNotifications()
    }
    
    @IBAction func quit(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(nil)
    }
    
    
    /// This method ensures that the user default values are set when the user opens the app for the first time
    /// Subsequent launches of the app will not reset these values
    func registerUserDefaultValues() {
        
        for key in UserDefaultKeys.allValues {
            
            let registerValue = ({ self.sharedUserDefaults.setObject($0, forKey: $1) })
            
            switch key {
            case .startTimeValue:
                   let theKey = sharedUserDefaults.objectForKey(key.rawValue) as? Double
                   if theKey == nil { registerValue(75000.00, key.rawValue) }
            case .bedTimeValue:
                let theKey = sharedUserDefaults.objectForKey(key.rawValue) as? Double
                if theKey == nil { registerValue(85000.00, key.rawValue) }
            case .selectedSound:
                let theKey = sharedUserDefaults.objectForKey(key.rawValue) as? String
                if theKey == nil { registerValue(AudioPlayer.AudioFiles.Shy.description(), key.rawValue) }
            case .runStartup:
                let theKey = sharedUserDefaults.objectForKey(key.rawValue) as? Bool
                if theKey == nil { registerValue(false, key.rawValue) }
            case .frequency:
                let theKey = sharedUserDefaults.objectForKey(key.rawValue) as? Double
                if theKey == nil { registerValue(5.00, key.rawValue) }
            case .isMuted:
                let theKey = sharedUserDefaults.objectForKey(key.rawValue) as? Double
                if theKey == nil { registerValue(false, key.rawValue) }
            }
        
        
        }
        
        
        
    }
    
    /// Beddy Butler should get notifified when it goes to sleep to handle the current timer
    func receiveSleepNotification(notification: NSNotification) {
        NSLog("Sleep nottification received: \(notification.name)")
        self.butlerTimer?.timer?.invalidate()
    }
    
    /// Beddy Butler should get notified when the PC wakes up from sleep so it can restart its timer
    func receiveWakeNotification(notification: NSNotification) {
        NSLog("Wake nottification received: \(notification.name)")
        self.butlerTimer?.calculateNewTimer()
    }
    
    func registerForNotitications() {
        //These notifications are filed on NSWorkspace's notification center, not the default
        // notification center. You will not receive sleep/wake notifications if you file
        //with the default notification center.
        NSWorkspace.sharedWorkspace().notificationCenter.addObserver(self, selector: "receiveSleepNotification:", name: NSWorkspaceWillSleepNotification, object: nil)
        NSWorkspace.sharedWorkspace().notificationCenter.addObserver(self, selector: "receiveWakeNotification:", name: NSWorkspaceDidWakeNotification, object: nil)
    }
    
    func deRegisterFromNotifications() {
        NSWorkspace.sharedWorkspace().notificationCenter.removeObserver(self)
    }
    
    
}

