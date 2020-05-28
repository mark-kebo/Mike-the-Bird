//
//  SoundPlayer.swift
//  Bookaroo
//
//  Created by Dmitry Vorozhbicky on 12/7/18.
//  Copyright © 2018 Cogniteq. All rights reserved.
//

import UIKit
import AVFoundation

enum SoundAction {
    case dead
    case appBackground
    case pong
    case button

    var filepath: String? {
        switch self {
        case .dead:
            return Bundle.main.path(forResource: "boom", ofType: "mp3")
        case .appBackground:
            return Bundle.main.path(forResource: "main", ofType: "mp3")
        case .pong:
            return Bundle.main.path(forResource: "pong", ofType: "mp3")
        case .button:
            return Bundle.main.path(forResource: "button", ofType: "mp3")
        }
    }
}

public final class SoundPlayer: NSObject {
    private var player: AVAudioPlayer?
    private let soundPath: String?
    
    init(_ soundAction: SoundAction) {
        soundPath = soundAction.filepath
    }
    
    func play() {
        DispatchQueue.global(qos: .background).async {
            do {
                if let path = self.soundPath {
                    self.player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                    self.player?.prepareToPlay()
                    self.player?.play()
                }
            } catch {
                print("Couldn't load file")
            }
        }
    }
}

