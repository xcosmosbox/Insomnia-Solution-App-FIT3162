//
//  SoundManager.swift
//  Insomnia-Solution-App-FIT3162
//
//  Created by Ching Yee Selina Wong on 16/3/2024.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static var audioPlayer: AVAudioPlayer?
    
    static func playSound(soundFileName: String) {
        // Set up the audio session
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error.localizedDescription)
        }
        
        // Set up the audio player
        if let soundFilePath = Bundle.main.path(forResource: soundFileName, ofType: "mp3") {
            let soundFileURL = URL(fileURLWithPath: soundFilePath)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundFileURL)
                audioPlayer?.numberOfLoops = -1 // Set the number of loops, -1 means infinite loop
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                print("playing music")
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("Sound file not found")
        }
    }
}
