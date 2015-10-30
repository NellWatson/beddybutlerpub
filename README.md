# Beddy Buttler

Beddy Buttler is a small menu bar app for OSX. It is designed to help you go to bed at a specified time. 

The utility will randomly play a sound sample at random times, between a period of time set by the user, i.e. when they would like to get in the habit of going to bed (e.g. 10:30-11:00).

The applet will nudge you to go to bed during a time frame. 

## Main features

Setup:
You can change the following settings:

- Set a timeframe for your desired time to prepare to go to bed (e.g. 10:30 - 11:00)
- Choose your applet behaviour from a set of butlers: Shy, Insistent and Zombie.
- You may also be able to preview each buttler.
- Configure whether you would like the applet to launch at login (this setting will be ON by default)


### Detailed description


The app main goal is to nudge one to go to bed at the proper time, rather than stay up late on the computer.

The utility will randomly play a sound sample at random times, between a period of time set by the user, i.e. when they would like to get in the habit of going to bed (e.g. 10:30-11:00).

The sound samples are of different 'butlers', kind of like how a butler might clear his throat to alert his master to a situation, but without being intrusive. (The app is currently playing fixed standard sounds from OSX while we work on recording the butler sounds, which will be available in days to come…)

The UX features an About, Preferences, and Quit. The Preferences shows compound slider bars for setting the time period for preparing for bed, and 3 radio buttons for 3 different butlers (Shy, Insistent, and Zombie), and a preview button for each. 

The app can auto-open on startup/login if the user activates this option.

## Requirements

This app was developed using the latest version of Swift 2.1 and Xcode 7.1. You may need to update your IDE to the latest version before you are able to open the solution. To run Beddy Butler you will need OS X 10.10 or later.

## Programmatically.

This app was created using Storyboards for Cocoa. The project is structured as follows:

#### Main.storyboard 

The only story board of the app, it has the full navigation of the App and UI windows.

#### Controllers

This group has the two controllers used for the main Windows: Preferences and About

#### Models

The main classes that handle the data of the app are here. ButlerTimer is the class that has the main logic to handle the timer that triggers playing the sound.

#### Views

This group contains custom views. The double slider was created because Apple currently doesn’t support NSSlider with more than one slider (or knob). Both sliders move within a range of 0 to 1 and have a minimum gap of around 0.08 between each other. ButlerTimer has a system to compensate for this so that it smoothly shows the correct range of time to the user between 00:00 and 23:59. See updateUserTimeValue(notification: NSNotification) for more details.

#### Assets

This group contains the sound files that are played to the user (pending updates with the correct assets.)

#### Beddy Butler Tests

This group has a set of classes to test features for beddy butler individually. 

### Other development notes.

- Build numbering: The project was set up with an additional build phase (Run Versioning Script), so that it always increases the build count in the info.plist file.

- Additional Test files: If you need to add new test cases, you can simply add a new XCTest class to /Beddy ButlerTests but make sure you import the following
	import XCTest
	@testable import Beddy_Butler

- Run at startup uses access to LSSharedFileListItems to add or remove the app from the list. If you need to look at this functionality you can access it in /Models/LoginItems.swift. We tried other run at startup alternatives like using a Helper App that ran Beddy Butler at the beginning, or using the SMLoginItemSetEnabled method, but none of these methods worked in OSX 10.11.

## Footnote

This app is freely available under the BSD license. Please feel free to contribute to enhance it and modify it.

This app is targeted primarily at OSX. However, in the future we may consider extending it to other platforms (Linux/Windows).

Many thanks for your interest and we welcome your contributions to this fun project!

