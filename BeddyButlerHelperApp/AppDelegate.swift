//
//  AppDelegate.swift
//  BeddyButlerHelperApp
//
//  Created by David Garces on 20/09/2015.
//  Copyright © 2015 David Garces. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        // Check if main app is already running; if yes, do nothing and terminate helper app
       // var isAlreadyRunning = false
        //var isActive = false
        /*
        let running = NSWorkspace.sharedWorkspace().runningApplications
        
        for app in running {
            if app.bundleIdentifier == "com.nellwatson.Beddy-Butler" {
                isAlreadyRunning = true
                //isActive = NSApp.active
            }
            
        }
        

        if !isAlreadyRunning {//|| !isActive {

*/
            let path = NSString(string: NSBundle.mainBundle().bundlePath).stringByDeletingLastPathComponent
            let reviewedPath = NSString(string: path).stringByDeletingLastPathComponent
            let reviewedPath2 = NSString(string: reviewedPath).stringByDeletingLastPathComponent
            let reviewedPath3 = NSString(string: reviewedPath2).stringByDeletingLastPathComponent
            let reviewedPath4 = NSString(string: reviewedPath3).stringByAppendingPathComponent("MacOS")
            let reviewedPath5 = NSString(string: reviewedPath4).stringByAppendingPathComponent("Beddy Butler")
            NSWorkspace.sharedWorkspace().launchApplication(reviewedPath5)
        
            NSLog("Run at startup executed")
            
       // }
        
        NSApp.terminate(nil)
        
        
        
            // if (!alreadyRunning) {
            //NSString *path = [[NSBundle mainBundle] bundlePath];
            //NSArray *p = [path pathComponents];
            //NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:p];
            //[pathComponents removeLastObject];
            //[pathComponents removeLastObject];
            //[pathComponents removeLastObject];
            //[pathComponents addObject:@"MacOS"];
            //[pathComponents addObject:@"LaunchAtLoginApp"];
            //NSString *newPath = [NSString pathWithComponents:pathComponents];
            //[[NSWorkspace sharedWorkspace] launchApplication:newPath];
        //}
        //[NSApp terminate:nil];
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

