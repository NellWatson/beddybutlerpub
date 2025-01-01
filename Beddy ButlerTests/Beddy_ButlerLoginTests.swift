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
        let bundle = (Bundle.main.bundleIdentifier! as NSString) as CFString
        let URLs = LSCopyApplicationURLsForBundleIdentifier( bundle, nil)
        //URLs?.retain()
        let x: CFArray = (URLs?.takeUnretainedValue())! as CFArray
        
        let value = CFArrayGetValueAtIndex(x, 0)
      //CFurlget
        
        XCTAssert(URLs != nil)
        XCTAssert(value != nil)
    }
    
    func testBundlerPath() {
        let path = NSString(string: Bundle.main.bundlePath).deletingLastPathComponent
        let reviewedPath = NSString(string: path).deletingLastPathComponent
        let reviewedPath2 = NSString(string: reviewedPath).deletingLastPathComponent
        let reviewedPath3 = NSString(string: reviewedPath2).deletingLastPathComponent
        let reviewedPath4 = NSString(string: reviewedPath3).appendingPathComponent("MacOs")
        let reviewedPath5 = NSString(string: reviewedPath4).appendingPathComponent("Beddy Butler")
        NSLog(reviewedPath5)
        NSWorkspace.shared.launchApplication(reviewedPath3)
        
    }
    
    func testBundlePath3() {
        
        // NSApplication.ur
        let bundlePath = Bundle.main.bundleURL
        let appName = NSString(string: bundlePath.lastPathComponent).deletingLastPathComponent

      
        //let programArguments = ["/Applications/LaunchAtLoginExample.app/Contents/MacOS/LaunchAtLoginExample"]
        let programArguments = bundlePath.path + "/Contents/MacOS/" + appName
        
        NSLog("arguments: \(programArguments)")
    }
    
    func testBundlePath2() {
        let path = NSString(string: Bundle.main.bundlePath).deletingLastPathComponent
        let reviewedPath = NSString(string: path).deletingLastPathComponent
        let reviewedPath2 = NSString(string: reviewedPath).deletingLastPathComponent
        let reviewedPath3 = NSString(string: reviewedPath2).deletingLastPathComponent
        let reviewedPath4 = NSString(string: reviewedPath3).appendingPathComponent("Contents")
        let reviewedPath5 = NSString(string: reviewedPath4).appendingPathComponent("MacOs")
        let reviewedPath6 = NSString(string: reviewedPath5).appendingPathComponent("Beddy Butler")
        NSLog(reviewedPath6)
        
    }
    
    func testButlerPlist() {
        
        //Create file manager instance
        let fileManager = FileManager()
        
        let URLs = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        
        
        let documentURL = URLs[0]
        let fileURL = documentURL.appendingPathComponent("com.nellwatson.Beddy-Butler.plist")

        // NSApplication.ur
        
        var plistDictionary: Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        // Create Key values
        let label = "com.nellwatson.Beddy-Butler"
        let programArguments = ["/Applications/EverydayTasks.app/Contents/MacOS/EverydayTasks"]
        let processType = "Interactive"
        let runAtLoad = true
        let keepAlive = false // This key specifies whether your daemon launches on-demand or must always be running. It is recommended that you design your daemon to be launched on-demand.

        // Assign Key values to keys
        plistDictionary["Label"] = label as AnyObject?
        plistDictionary["ProgramArguments"] = programArguments as AnyObject?
        plistDictionary["ProcessType"] = processType as AnyObject?
        plistDictionary["RunAtLoad"] = runAtLoad as AnyObject?
        plistDictionary["KeepAlive"] = keepAlive as AnyObject?

        do {
            let data = try PropertyListSerialization.data(fromPropertyList: plistDictionary, format: .xml, options: 0)
            XCTAssert(data.count > 0)
            fileManager.createFile(atPath: fileURL.path, contents: data, attributes: nil)
            
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
