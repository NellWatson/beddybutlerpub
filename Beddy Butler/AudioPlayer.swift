//
//  AudioFile.swift
//  Beddy Butler
//
//  Created by David Garces on 18/08/2015.
//  Copyright (c) 2015 Nell Watson Inc. All rights reserved.
//
import AVFoundation

class AudioPlayer {
    
    
    var audioPlayer: AVAudioPlayer?
    var soundFileURL: NSURL?
    let urls = NSBundle.mainBundle().URLsForResourcesWithExtension("mp3", subdirectory: nil)
    
    
    enum AudioFiles {
        case Insistent, Shy, Zombie
        
        init (stringValue: String) {
            switch stringValue {
                case "Insistent":
                    self = .Insistent
                case "Shy":
                    self = .Shy
                case "Zombie":
                    self = .Zombie
            default:
                    self = .Shy
            }
        }
        
        func description() -> String {
            switch self  {
            case .Insistent:
                return "Insistent"
            case .Shy:
                return "Shy"
            case .Zombie:
                return "Zombie"
            }
        }
    }
    
    /// Plays the audio file for the given file name: AudioFiles.Shy, AudioFiles.Insistent or AudioFiles.Zombie
    func playFile(file: AudioFiles) {
        
        let filteredURLs = urls?.filter { $0.absoluteString.containsString(file.description()) }
        
        // Select a random file from the list
        let randomIndex = Int(arc4random_uniform(UInt32(filteredURLs!.count)))

        // play the file
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: filteredURLs![randomIndex])
            audioPlayer?.play()
        } catch {
            NSLog("File could not be played")
        }
        
    }
    

    
}
