//
//  SoundManager.swift
//  Insomnia-Solution-App-FIT3162
//
//  Created by Ching Yee Selina Wong on 16/3/2024.
//

import AVFoundation

class SoundManager: NSObject, AVAudioPlayerDelegate {
    var audioPlayer: AVAudioPlayer?

    func playSound(soundFileName: String, fileType: String) {
        print("Attempting to play sound file: \(soundFileName).\(fileType)")
        
        guard let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: fileType) else {
            print("Could not find the file \(soundFileName).\(fileType) in the main bundle.")
            return
        }
        
        let soundURL = URL(fileURLWithPath: bundlePath)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            
            if audioPlayer?.play() ?? false {
                print("Playback started successfully for \(soundFileName).\(fileType)")
            } else {
                print("Playback failed to start for \(soundFileName).\(fileType)")
            }
        } catch {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("Playback finished successfully.")
        } else {
            print("Playback finished unsuccessfully.")
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio player decode error occurred: \(error.localizedDescription)")
        }
    }
}
