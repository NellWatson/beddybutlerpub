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
        
        let soundFileURL = NSBundle.mainBundle().URLForResource(file.description(),
            withExtension: "aiff")

        // play the file
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: soundFileURL!)
            audioPlayer?.play()
        } catch {
            NSLog("File could not be played")
        }
        
    }
    

    
}
