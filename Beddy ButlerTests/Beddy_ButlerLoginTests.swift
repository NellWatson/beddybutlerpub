//
//  Beddy_ButlerLoginTests.swift
//  Beddy Butler
//
//  Created by David Garces on 21/10/2015.
//  Copyright © 2015 David Garces. All rights reserved.
//

import XCTest

class Beddy_ButlerLoginTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testApplicationLocated() {
        let bundle = (NSBundle.mainBundle().bundleIdentifier! as NSString) as CFString
        let URLs = LSCopyApplicationURLsForBundleIdentifier( bundle, nil)
        //URLs?.retain()
        let x: CFArrayRef = (URLs?.takeUnretainedValue())! as CFArrayRef
        
        let value = CFArrayGetValueAtIndex(x, 0)
      //CFurlget
        
        XCTAssert(URLs != nil)
        XCTAssert(value != nil)
        
    
        
    }
    
    func testBundlerPath() {
        let path = NSString(string: NSBundle.mainBundle().bundlePath).stringByDeletingLastPathComponent
        let reviewedPath = NSString(string: path).stringByDeletingLastPathComponent
        let reviewedPath2 = NSString(string: reviewedPath).stringByDeletingLastPathComponent
        let reviewedPath3 = NSString(string: reviewedPath2).stringByDeletingLastPathComponent
        let reviewedPath4 = NSString(string: reviewedPath3).stringByAppendingPathComponent("MacOs")
        let reviewedPath5 = NSString(string: reviewedPath4).stringByAppendingPathComponent("Beddy Butler")
        NSLog(reviewedPath5)
        NSWorkspace.sharedWorkspace().launchApplication(reviewedPath3)
        
    }
    
    func testBundlePath3() {
        
        // NSApplication.ur
        let bundlePath = NSBundle.mainBundle().bundleURL
        let appName = NSString(string: bundlePath.lastPathComponent!).stringByDeletingPathExtension
     
      
        //let programArguments = ["/Applications/LaunchAtLoginExample.app/Contents/MacOS/LaunchAtLoginExample"]
        let programArguments = bundlePath.path! + "/Contents/MacOS/" + appName
        
        NSLog("arguments: \(programArguments)")
    }
    
    func testBundlePath2() {
        let path = NSString(string: NSBundle.mainBundle().bundlePath).stringByDeletingLastPathComponent
        let reviewedPath = NSString(string: path).stringByDeletingLastPathComponent
        let reviewedPath2 = NSString(string: reviewedPath).stringByDeletingLastPathComponent
        let reviewedPath3 = NSString(string: reviewedPath2).stringByDeletingLastPathComponent
        let reviewedPath4 = NSString(string: reviewedPath3).stringByAppendingPathComponent("Contents")
        let reviewedPath5 = NSString(string: reviewedPath4).stringByAppendingPathComponent("MacOs")
        let reviewedPath6 = NSString(string: reviewedPath5).stringByAppendingPathComponent("Beddy Butler")
        NSLog(reviewedPath6)
        
    }
    
    func testButlerPlist() {
        
        //Create file manager instance
        let fileManager = NSFileManager()
        
        let URLs = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        
        let documentURL = URLs[0]
        let fileURL = documentURL.URLByAppendingPathComponent("com.nellwatson.Beddy-Butler.plist")
        
        // NSApplication.ur
        
        var plistDictionary: Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        // Create Key values
        let label = "com.nellwatson.Beddy-Butler"
        let programArguments = ["/Applications/EverydayTasks.app/Contents/MacOS/EverydayTasks"]
        let processType = "Interactive"
        let runAtLoad = true
        let keepAlive = false // This key specifies whether your daemon launches on-demand or must always be running. It is recommended that you design your daemon to be launched on-demand.
        
        // Assign Key values to keys
        plistDictionary["Label"] = label
        plistDictionary["ProgramArguments"] = programArguments
        plistDictionary["ProcessType"] = processType
        plistDictionary["RunAtLoad"] = runAtLoad
        plistDictionary["KeepAlive"] = keepAlive
        
        do {
            let data = try NSPropertyListSerialization.dataWithPropertyList(plistDictionary, format: NSPropertyListFormat.XMLFormat_v1_0, options: NSPropertyListWriteOptions.init())
            XCTAssert(data.length > 0)
            fileManager.createFileAtPath(fileURL.path!, contents: data, attributes: nil)
            
        } catch {
            NSLog("Error while creating agent file")
        }
        
        
        
    }
    
    func testLSharedList() {
        let x = kCFAllocatorDefault
        let y = kLSSharedFileListSessionLoginItems
        let z = y.takeUnretainedValue()
        
        let loginReference = LSSharedFileListCreate(x, z, nil)
        XCTAssert(loginReference != nil)
    }


    
    

}
