//
//  GameElements.swift
//  Mike the Bird
//
//  Created by Dmitry Vorozhbicki on 14/03/2020.
//  Copyright © 2020 Dmitry Vorozhbicki. All rights reserved.
//

import SpriteKit

struct CollisionBitMask {
    static let birdCategory:UInt32 = 0x1 << 0
    static let pillarCategory:UInt32 = 0x1 << 1
    static let flowerCategory:UInt32 = 0x1 << 2
    static let groundCategory:UInt32 = 0x1 << 3
}

extension GameScene{
    func createBird() -> SKSpriteNode {
        let bird = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("sultan_flight1"))
        bird.size = CGSize(width: 50, height: 50)
        bird.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2)
        bird.physicsBody?.linearDamping = 1.1
        bird.physicsBody?.restitution = 0
        bird.physicsBody?.categoryBitMask = CollisionBitMask.birdCategory
        bird.physicsBody?.collisionBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory
        bird.physicsBody?.contactTestBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.flowerCategory | CollisionBitMask.groundCategory
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = true
        
        return bird
    }
    
    func createRestartBtn() {
        restartBtn = SKSpriteNode(imageNamed: "restart")
        restartBtn.size = CGSize(width:100, height:100)
        restartBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func createPauseBtn() {
        pauseBtn = SKSpriteNode(imageNamed: "pause")
        pauseBtn.size = CGSize(width:blockSize, height:blockSize)
        pauseBtn.position = CGPoint(x: self.frame.width - 30, y: 30)
        pauseBtn.zPosition = 6
        self.addChild(pauseBtn)
    }
    
    func createScoreLabel() -> SKLabelNode {
        let scoreLbl = SKLabelNode()
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.6)
        scoreLbl.text = "\(score)"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 25
        scoreLbl.fontName = "HelveticaNeue-Bold"
        
        let scoreBg = SKShapeNode()
        scoreBg.position = CGPoint(x: 0, y: 0)
        scoreBg.path = CGPath(roundedRect: CGRect(x: CGFloat(-25), y: CGFloat(-15), width: CGFloat(50), height: CGFloat(50)), cornerWidth: 50, cornerHeight: 50, transform: nil)
        let scoreBgColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(0.2))
        scoreBg.strokeColor = UIColor.clear
        scoreBg.fillColor = scoreBgColor
        scoreBg.zPosition = -1
        scoreLbl.addChild(scoreBg)
        return scoreLbl
    }
    
    func createHighscoreLabel() -> SKLabelNode {
        let highscoreLbl = SKLabelNode()
        highscoreLbl.position = CGPoint(x: self.frame.width - 80, y: self.frame.height - 22)
        if let highestScore = UserDefaults.standard.object(forKey: "highestScore"){
            highscoreLbl.text = "Highest Score: \(highestScore)"
        } else {
            highscoreLbl.text = "Highest Score: 0"
        }
        highscoreLbl.zPosition = 5
        highscoreLbl.fontSize = 15
        highscoreLbl.fontName = "Helvetica-Bold"
        return highscoreLbl
    }
    
    func createLogo() {
        logoImg = SKSpriteNode()
        logoImg = SKSpriteNode(imageNamed: "logo")
        logoImg.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 100)
        logoImg.setScale(0.5)
        self.addChild(logoImg)
        logoImg.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func createTaptoplayLabel() -> SKLabelNode {
        let taptoplayLbl = SKLabelNode()
        taptoplayLbl.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 80)
        taptoplayLbl.text = "Tap anywhere to play"
        taptoplayLbl.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
        taptoplayLbl.zPosition = 5
        taptoplayLbl.fontSize = 20
        taptoplayLbl.fontName = "HelveticaNeue"
        return taptoplayLbl
    }
    
    func createWalls() -> SKNode  {
        let flowerNode = SKSpriteNode(imageNamed: "flower")
        flowerNode.size = CGSize(width: blockSize / 2, height: blockSize / 2)
        flowerNode.position = CGPoint(x: random(min: self.frame.width, max: self.frame.width * 2), y: random(min: 0, max: self.frame.height))
        flowerNode.physicsBody = SKPhysicsBody(rectangleOf: flowerNode.size)
        flowerNode.physicsBody?.affectedByGravity = false
        flowerNode.physicsBody?.isDynamic = false
        flowerNode.physicsBody?.categoryBitMask = CollisionBitMask.flowerCategory
        flowerNode.physicsBody?.collisionBitMask = 0
        flowerNode.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        flowerNode.color = SKColor.blue
        flowerNode.zPosition = -1
        
        wallPair = SKNode()
        wallPair.name = "wallPair"
        wallPair.addChild(flowerNode)

        let pointY = self.frame.height / 2
        let pointXBais = (256 - 64) * elementScale
        
        let index = randomObstacle(numberOfObstacles: 3, lastObstacle: lastIndex)
        lastIndex = index
        switch index {
        case 1:
            createTopWall(position: CGPoint(x: self.frame.width + pointXBais, y: pointY + 120))
        case 2:
            createBtmWall(position: CGPoint(x: self.frame.width + pointXBais, y: pointY - 120))
        case 3:
            createWall(position:    CGPoint(x: self.frame.width + pointXBais, y: pointY))
        default:
            createTopWall(position: CGPoint(x: self.frame.width + pointXBais, y: pointY + 120))
        }

        wallPair.zPosition = 1
        let randomPosition2 = random(min: -15, max: 15)
        wallPair.position.y = wallPair.position.y +  randomPosition2
        wallPair.run(moveAndRemove)
        
        return wallPair

    }

    func randomObstacle(numberOfObstacles: Int, lastObstacle: Int) -> Int {
        let temp = Int.random(in: 1 ..< numberOfObstacles)
        if (temp < lastObstacle) {
            return temp
        } else {
            return temp + 1
        }
    }
    
    
    func createTopWall(position: CGPoint) {
        let topWall = SKSpriteNode(imageNamed: "tiles1")
        
        topWall.position = position
        topWall.size = CGSize(width: elementScale * 64, height: self.frame.height / 2)
                
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        topWall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        topWall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        topWall.zRotation = CGFloat(M_PI)
        
        wallPair.addChild(topWall)
    }
    
    func createWall(position: CGPoint) {
        let topWall = SKSpriteNode(imageNamed: "tiles3")
        
        topWall.position = position
        topWall.size = CGSize(width: 64 * elementScale, height: 96 * elementScale)
                
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        topWall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        topWall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        topWall.zRotation = CGFloat(M_PI)
        
        wallPair.addChild(topWall)
    }
    
    func createBtmWall(position: CGPoint) {
        let btmWall = SKSpriteNode(imageNamed: "tiles1")
        
        btmWall.position = position
        btmWall.size = CGSize(width: elementScale * 64, height: self.frame.height / 2)

        btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        btmWall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        btmWall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        btmWall.physicsBody?.isDynamic = false
        btmWall.physicsBody?.affectedByGravity = false
                
        wallPair.addChild(btmWall)
    }
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min : CGFloat, max : CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }

}
