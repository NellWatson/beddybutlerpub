//
//  AboutViewController.swift
//  Beddy Butler
//
//  Created by David Garces on 08/10/2015.
//  Copyright © 2015 David Garces. All rights reserved.
//

import Cocoa

class AboutViewController: NSViewController {

    @IBOutlet weak var versionTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        versionTextField.stringValue = "Version \(versionInfo)"
    }
    
    var versionInfo: String {
        let dictionary = NSBundle.mainBundle().infoDictionary
        if let version = dictionary!["CFBundleShortVersionString"] as? String {
            if let build = dictionary!["CFBundleVersion"] as? String {
                return "\(version) (Build \(build))"
            } else {
                return "\(version)"
            }
        } else {
            return ""
        }
    }
    
}
