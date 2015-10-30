//
//  LoginItems.swift
//  Beddy Butler
//
//  Created by David Garces on 23/10/2015.
//  Copyright © 2015 David Garces. All rights reserved.
//

import Foundation
import Cocoa

class LoginItems: NSObject {
    
    //MARK: Variables
    let fileManager = NSFileManager()
    let bundleIdentifier = NSBundle.mainBundle().bundleIdentifier
    
    //MARK: Computed Variables
    
    private var plistPath: NSURL {
        
        //Create file manager instance
        let URLs = fileManager.URLsForDirectory(NSSearchPathDirectory.LibraryDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        // build file name
        let fileName = bundleIdentifier! + ".plist"
        
        let documentURL = URLs[0]
        let reviewedURL = documentURL.URLByAppendingPathComponent("LaunchAgents")
        let fileURL = reviewedURL.URLByAppendingPathComponent(fileName)
        
        return fileURL
        
    }
    
    private var appExecutePath: String {
        let bundlePath = NSBundle.mainBundle().bundleURL
        let appName = NSString(string: bundlePath.lastPathComponent!).stringByDeletingPathExtension
        return bundlePath.path! + "/Contents/MacOS/" + appName
       
    }
    
    //MARK: Public login handling methods
    
    func deleteLoginItem(){
        
        let sharedFileListLoginItems = kLSSharedFileListSessionLoginItems
        let bundlePath = NSBundle.mainBundle().bundleURL
        
        if let loginReference = LSSharedFileListCreate(kCFAllocatorDefault, sharedFileListLoginItems.takeUnretainedValue(), nil) {
            let loginListValue = loginReference.takeUnretainedValue()
            let beforeFirstLoginItem = kLSSharedFileListItemBeforeFirst.takeUnretainedValue()
            if let loginItem = LSSharedFileListInsertItemURL(loginListValue, beforeFirstLoginItem, "Beddy Butler" as CFStringRef, nil, bundlePath, nil, nil) {
                
                LSSharedFileListItemRemove(loginListValue, loginItem.takeUnretainedValue())
                
            }
        }
    }
    
    func createLoginItem() {
        
        let sharedFileListLoginItems = kLSSharedFileListSessionLoginItems
        let bundlePath = NSBundle.mainBundle().bundleURL
        
        if let loginReference = LSSharedFileListCreate(kCFAllocatorDefault,  sharedFileListLoginItems.takeUnretainedValue(), nil) {
            let loginListValue = loginReference.takeUnretainedValue()
            let beforeFirstLoginItem = kLSSharedFileListItemBeforeFirst.takeUnretainedValue()
            LSSharedFileListInsertItemURL(loginListValue, beforeFirstLoginItem, "Beddy Butler" as CFStringRef, nil, bundlePath, nil, nil)

        }
        
    }
    
    //MARK: Alternative login methods
    
    private func createPlistFile(data: NSData) {
        let theURL = plistPath
        deletePlistFile()
        fileManager.createFileAtPath(theURL.path!, contents: data, attributes: nil)
    }
    
    private func deletePlistFile() {
        do {
            let theURL = plistPath
            if fileManager.fileExistsAtPath(theURL.path!) {
                try fileManager.removeItemAtURL(theURL)
            }
        } catch {
            let resultMessage = "Error while deleting the plist file"
            NSLog(resultMessage)
        }
    }
    
    private func deleteLoginItemV2() {
        deletePlistFile()
    }

    
    private func createLoginItemV2() {
        
        // NSApplication.ur
        let bundlePath = NSBundle.mainBundle().bundleURL
        //let appName = NSString(string: bundlePath.lastPathComponent!).stringByDeletingPathExtension
        
        var plistDictionary: Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        // Create Key values
        let label = bundleIdentifier
        //let programArguments = ["/Applications/LaunchAtLoginExample.app/Contents/MacOS/LaunchAtLoginExample"]
        let programArguments = bundlePath.path! //+ "/Contents/MacOS/" + appName
        let processType = "Interactive"
        let runAtLoad = true
        let keepAlive = true // This key specifies whether your daemon launches on-demand or must always be running. It is recommended that you design your daemon to be launched on-demand.
        
        // Assign Key values to keys
        plistDictionary["Label"] = label
        plistDictionary["ProgramArguments"] = programArguments
        plistDictionary["ProcessType"] = processType
        plistDictionary["RunAtLoad"] = runAtLoad
        plistDictionary["KeepAlive"] = keepAlive
        
        do {
            let data = try NSPropertyListSerialization.dataWithPropertyList(plistDictionary, format: NSPropertyListFormat.XMLFormat_v1_0, options: NSPropertyListWriteOptions.init())
            
            createPlistFile(data)
            
        } catch {
            let resultMessage = "Error while creating agent file"
            
            NSLog(resultMessage)
        }
    }
    
}
