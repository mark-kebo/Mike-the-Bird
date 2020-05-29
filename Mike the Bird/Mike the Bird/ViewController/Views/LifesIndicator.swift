//
//  LifesIndicator.swift
//  Mike the Bird
//
//  Created by Dmitry Vorozhbicki on 29/05/2020.
//  Copyright © 2020 Dmitry Vorozhbicki. All rights reserved.
//

import SpriteKit

class LifesIndicator: SKNode {
    
    init(lifes: Int, position: CGPoint) {
        super.init()
        guard lifes - 1 > 0 else {
            return
        }
        self.position = position
        for index in 0...lifes - 1 {
            self.addChild(createLive(position: CGPoint(x: index * 30, y: 0)))
        }
        self.zPosition = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func deleteLife() {
        if let last = self.children.last {
            self.removeChildren(in: [last])
        }
    }
    
    private func createLive(position: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "life")
        node.size = CGSize(width: 30, height: 30)
        node.position = position
        node.color = SKColor.blue
        node.zPosition = 5
        node.alpha = 0.8
        return node
    }
    
    
}
