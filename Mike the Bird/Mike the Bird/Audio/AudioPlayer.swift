//
//  AudioPlayer.swift
//  Bookaroo
//
//  Created by Dmitry Vorozhbicky on 10/22/18.
//  Copyright © 2018 Cogniteq. All rights reserved.
//

import UIKit
import AVFoundation

public final class AudioPlayer: NSObject {
    private var sound: AVAudioPlayer?
    private let audioPath: URL
    
    init(audioPath: URL) {
        self.audioPath = audioPath
    }
    
    func play() {
        do {
            sound = try AVAudioPlayer(contentsOf: audioPath)
            sound?.play()
        } catch {
            print("Couldn't load file")
        }
    }
    
    func stop() {
        sound?.stop()
        sound = nil
    }
}

