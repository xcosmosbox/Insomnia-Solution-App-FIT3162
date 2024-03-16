import UIKit
import AVFoundation

class ViewController: UIViewController {

    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the audio session
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error.localizedDescription)
        }
        
        // Set up the audio player
        if let soundFilePath = Bundle.main.path(forResource: "ocean-waves-112906", ofType: "mp3") {
            let soundFileURL = URL(fileURLWithPath: soundFilePath)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundFileURL)
                audioPlayer?.numberOfLoops = -1 // Set the number of loops, -1 means infinite loop
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("Sound file not found")
        }
    }
}


