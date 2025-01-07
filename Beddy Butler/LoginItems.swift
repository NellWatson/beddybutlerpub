//
//  LoginItems.swift
//  Beddy Butler
//
//  Created by David Garces on 23/10/2015.
//  Copyright © 2015 David Garces. All rights reserved.
//

import Foundation
import Cocoa
import ServiceManagement

class LoginItems {
    //MARK: Variables
    let fileManager = FileManager()
    let bundleIdentifier = Bundle.main.bundleIdentifier

    //MARK: Computed Variables

    private var plistPath: URL {

        //Create file manager instance
        let URLs = fileManager.urls(for: FileManager.SearchPathDirectory.libraryDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)

        // build file name
        let fileName = bundleIdentifier! + ".plist"

        let documentURL = URLs[0]
        let reviewedURL = documentURL.appendingPathComponent("LaunchAgents")
        let fileURL = reviewedURL.appendingPathComponent(fileName)

        return fileURL

    }

    private var appExecutePath: String {
        let bundlePath = Bundle.main.bundleURL
        let appName = NSString(string: bundlePath.lastPathComponent).deletingPathExtension
        return bundlePath.path + "/Contents/MacOS/" + appName

    }

    //MARK: Public login handling methods

    func enableLoginItem(enabled: Bool){
        guard let bundleIdentifier = bundleIdentifier else { return }
        if #available(macOS 13.0, *) {
            print("enableLoginItem", bundleIdentifier, SMAppService.mainApp.status)
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("Failed to update login item status: \(error.localizedDescription)")
            }
        } else {
            // Fallback on earlier versions
            SMLoginItemSetEnabled(bundleIdentifier as CFString, enabled)
        }
    }

    //MARK: Alternative login methods

    private func createPlistFile(data: Data) {
        let theURL = plistPath
        deletePlistFile()
        fileManager.createFile(atPath: theURL.path, contents: data, attributes: nil)
    }

    private func deletePlistFile() {
        do {
            let theURL = plistPath
            if fileManager.fileExists(atPath: theURL.path) {
                try fileManager.removeItem(at: theURL)
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
        let bundlePath = Bundle.main.bundleURL
        //let appName = NSString(string: bundlePath.lastPathComponent!).stringByDeletingPathExtension

        var plistDictionary: Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()

        // Create Key values
        let label = bundleIdentifier
        //let programArguments = ["/Applications/LaunchAtLoginExample.app/Contents/MacOS/LaunchAtLoginExample"]
        let programArguments = bundlePath.path //+ "/Contents/MacOS/" + appName
        let processType = "Interactive"
        let runAtLoad = true
        let keepAlive = true // This key specifies whether your daemon launches on-demand or must always be running. It is recommended that you design your daemon to be launched on-demand.

        // Assign Key values to keys
        plistDictionary["Label"] = label as AnyObject?
        plistDictionary["ProgramArguments"] = programArguments as AnyObject?
        plistDictionary["ProcessType"] = processType as AnyObject?
        plistDictionary["RunAtLoad"] = runAtLoad as AnyObject?
        plistDictionary["KeepAlive"] = keepAlive as AnyObject?

        do {
            let data = try PropertyListSerialization.data(fromPropertyList: plistDictionary,
                                                          format: .xml,
                                                          options: 0)

            createPlistFile(data: data)

        } catch {
            let resultMessage = "Error while creating agent file"

            NSLog(resultMessage)
        }
    }

}
