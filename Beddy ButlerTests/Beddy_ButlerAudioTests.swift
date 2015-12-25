//
//  Beddy_ButlerAudioTests.swift
//  Beddy Butler
//
//  Created by David Garces on 18/08/2015.
//  Copyright (c) 2015 David Garces. All rights reserved.
//

import XCTest
@testable import Beddy_Butler

class Beddy_ButlerAudioTests: XCTestCase {
    
    var player: AudioPlayer = AudioPlayer()
    var audioFile: AudioPlayer.AudioFiles?
    
    override func setUp() {
        audioFile = nil
    }
    
    override func tearDown() {
    }
    
    
    func testPlayerInitialises() {
        XCTAssertNotNil(player, "test player initialises")
    }
    
    func testInsistentAudioFileName() {
        audioFile = AudioPlayer.AudioFiles.Insistent
        XCTAssertEqual(audioFile!.description(), "Insistent", "test insistent audio file name")
    }
    
    func testShyAudioFileName() {
        audioFile = AudioPlayer.AudioFiles.Shy
        XCTAssertEqual(audioFile!.description(), "Shy", "test shy audio file name")
    }
    
    func testZombieAudioFileName() {
        audioFile = AudioPlayer.AudioFiles.Zombie
        XCTAssertEqual(audioFile!.description(), "Zombie", "test zombie audio file name")
    }
    
    func testInsistentAudioFileExistsandPlays() {
        player.playFile(AudioPlayer.AudioFiles.Insistent)
        // In Swift 2.0 you will be able to throw an error and test that error doesn't from from
    }
    
    func testShyAudioFileExistsandPlays() {
        player.playFile(AudioPlayer.AudioFiles.Shy)
        // In Swift 2.0 you will be able to throw an error and test that error doesn't from from
    }
    
    func testZombieAudioFileExistsandPlays() {
        player.playFile(AudioPlayer.AudioFiles.Zombie)
        // In Swift 2.0 you will be able to throw an error and test that error doesn't from from
    }
    
    func testEnumeratesAudioFiles() {
        let urls = NSBundle.mainBundle().URLsForResourcesWithExtension("mp3", subdirectory: nil)
        XCTAssert(urls?.count >= 50)
        
    }
    
    func testEnumerateZombieFiles() {
        let urls = NSBundle.mainBundle().URLsForResourcesWithExtension("mp3", subdirectory: nil)
        let zombieURLs = urls?.filter { $0.absoluteString.containsString("Zombie") }
        XCTAssert(zombieURLs?.count >= 50)
    }
    
    func testEnumerateShyFiles() {
        let urls = NSBundle.mainBundle().URLsForResourcesWithExtension("mp3", subdirectory: nil)
        let shyURLs = urls?.filter { $0.absoluteString.containsString("Shy") }
        XCTAssert(shyURLs?.count >= 15)
    }
    
    func testEnumerateInsistentFiles() {
        let urls = NSBundle.mainBundle().URLsForResourcesWithExtension("mp3", subdirectory: nil)
        let insistentURLs = urls?.filter { $0.absoluteString.containsString("Insistent") }
        XCTAssert(insistentURLs?.count >= 15)
    }

    
}

