
//
//  AppBackgroundMusicPalyer.swift
//  Bookaroo
//
//  Created by Alex Habrusevich on 1/30/19.
//  Copyright © 2019 Cogniteq. All rights reserved.
//

import Foundation
import AVFoundation

private class AppBackgroundMusicPlayer {
    private var player: AVAudioPlayer?
    
    static let shared = AppBackgroundMusicPlayer.init()
    
    private init() {
        do {
            if let path = SoundAction.appBackground.filepath {
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                player?.numberOfLoops = -1
                player?.volume = 0.5
                player?.prepareToPlay()
                player?.play()
            }
        } catch {
            print("Couldn't load file")
        }
    }
    
    func play() {
        DispatchQueue.global(qos: .background).async {
            self.player?.play()
        }
    }
    
    func pause() {
        DispatchQueue.global(qos: .background).async {
            self.player?.pause()
        }
    }
}

func runBackgroundMusic() {
    AppBackgroundMusicPlayer.shared.play()
}

func stopBackgroundMusic() {
    AppBackgroundMusicPlayer.shared.pause()
}
