//
//  MediaCollectionViewCell.swift
//  Insomnia-Solution-App-FIT3162
//
//  Created by Yuxiang Feng on 19/3/2024.
//

import UIKit
import AVFoundation

class MediaCollectionViewCell: UICollectionViewCell {
    
    var coverImageView: UIImageView!
    var musicPlayer: AVAudioPlayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCoverImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCoverImageView() {
        coverImageView = UIImageView(frame: bounds)
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        addSubview(coverImageView)
    }
    
    func configureCell(with image: UIImage, musicURL: URL) {
        coverImageView.image = image
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: musicURL)
            musicPlayer?.prepareToPlay()
        } catch {
            print("Error initializing music player: \(error.localizedDescription)")
        }
    }
    
    func playMusic() {
        musicPlayer?.play()
    }
}
