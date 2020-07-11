//
//  GameViewController.swift
//  Mike the Bird
//
//  Created by Dmitry Vorozhbicki on 14/03/2020.
//  Copyright © 2020 Dmitry Vorozhbicki. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var scene: GameScene?
    var skView: SKView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        scene = GameScene(size: view.bounds.size)
        skView = view as? SKView
        skView?.showsFPS = false
        skView?.showsNodeCount = false
        skView?.ignoresSiblingOrder = false
        scene?.scaleMode = .resizeFill
        skView?.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scene?.restartScene()
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
