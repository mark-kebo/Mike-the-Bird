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
        bird.size = CGSize(width: 32 * elementScale, height: 32 * elementScale)
        bird.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2 - (elementScale * 2))
        bird.physicsBody?.linearDamping = 1.1
        bird.physicsBody?.restitution = 0
        bird.physicsBody?.categoryBitMask = CollisionBitMask.birdCategory
        bird.physicsBody?.collisionBitMask = CollisionBitMask.groundCategory
        bird.physicsBody?.contactTestBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.flowerCategory | CollisionBitMask.groundCategory
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = true
        
        return bird
    }
    
    func createRestartBtn(position: CGPoint?) {
        restartBtn = SKSpriteNode(imageNamed: "restart")
        restartBtn.size = CGSize(width:80, height:80)
        restartBtn.position = position ?? CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func createPauseBtn() {
        pauseBtn = SKSpriteNode(imageNamed: "pause")
        pauseBtn.size = CGSize(width: 40, height: 40)
        pauseBtn.position = CGPoint(x: 30, y: 30)
        pauseBtn.zPosition = 6
        pauseBtn.alpha = 0.5
        self.addChild(pauseBtn)
    }
    
    func createScoreLabel() -> SKLabelNode {
        let scoreLbl = SKLabelNode()
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.6)
        scoreLbl.text = "\(score)"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 25
        scoreLbl.fontName = "BitPotion"
        
        let scoreBg = SKShapeNode()
        scoreBg.position = CGPoint(x: 0, y: 0)
        scoreBg.path = CGPath(roundedRect: CGRect(x: CGFloat(-25), y: CGFloat(-17.5), width: CGFloat(50), height: CGFloat(50)), cornerWidth: 50, cornerHeight: 50, transform: nil)
        let scoreBgColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(0.2))
        scoreBg.strokeColor = UIColor.clear
        scoreBg.fillColor = scoreBgColor
        scoreBg.zPosition = -1
        scoreLbl.addChild(scoreBg)
        return scoreLbl
    }
    
    func createHighscoreLabel() -> SKLabelNode {
        let highscoreLbl = SKLabelNode()
        highscoreLbl.position = CGPoint(x: self.frame.width - 80, y: self.frame.height / 2 + self.frame.height / 2.4)
        if let highestScore = UserDefaults.standard.object(forKey: "highestScore"){
            highscoreLbl.text = "Highest Score: \(highestScore)"
        } else {
            highscoreLbl.text = "Highest Score: 0"
        }
        highscoreLbl.zPosition = 5
        highscoreLbl.fontSize = 25
        highscoreLbl.fontName = "BitPotion"
        return highscoreLbl
    }
    
    func createLogo() {
        logoImg = SKSpriteNode()
        logoImg = SKSpriteNode(imageNamed: "logo")
        logoImg.size.width = logoImg.frame.width * 0.6 * elementScale
        logoImg.size.height = logoImg.frame.height * 0.6 * elementScale
        logoImg.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 50 * elementScale)
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
        taptoplayLbl.fontSize = 30
        taptoplayLbl.fontName = "BitPotion"
        return taptoplayLbl
    }
    
    func createFinishLine() -> SKNode {
        let finish = SKSpriteNode(imageNamed: "finish")
        finish.name = "finish"
        let pointXBais = (256 - 64) * elementScale
        finish.position = CGPoint(x: self.frame.width + pointXBais, y: self.frame.height / 2)
        finish.size = CGSize(width: elementScale * 32, height: elementScale * 320)
        finish.alpha = 0.95
        finish.physicsBody = SKPhysicsBody(rectangleOf: finish.size)
        finish.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        finish.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        finish.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        finish.physicsBody?.isDynamic = false
        finish.physicsBody?.affectedByGravity = false
        finish.run(moveAndRemove)

        return finish
    }
    
    func createFinishMessage(count: Int) -> SKLabelNode {
        createRestartBtn(position: CGPoint(x: self.frame.midX, y: self.frame.midY - 50))
        let label = SKLabelNode()
        label.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 10 * elementScale)
        label.zPosition = 5
        label.numberOfLines = 0
        let string = "Victory!\nYou collected \(count) flowers!"
        let attrString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: string.count)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont(name: "BitPotion", size: 30 * elementScale)], range: range)
        label.attributedText = attrString
        return label
    }
  
    func createWalls() -> SKNode {
        walls = SKNode()
        walls.name = "wallPair"

        let pointY = self.frame.height / 2
        let pointXBais = (256 - 64) * elementScale
        
        let index = randomObstacle(numberOfObstacles: 3, lastObstacle: lastIndex)
        lastIndex = index
        
        var wall: SKSpriteNode
        var randomeFlowerPositionY: CGFloat
        
        switch index {
        case 1:
            wall = createTopWall(position: CGPoint(x: self.frame.width + pointXBais, y: pointY + 80 * elementScale))
            randomeFlowerPositionY = random(min: 20 * elementScale, max: wall.position.y - wall.size.height / 2 - 20 * elementScale)
        case 2:
            wall = createBtmWall(position: CGPoint(x: self.frame.width + pointXBais, y: pointY - 80 * elementScale))
            randomeFlowerPositionY = random(min: self.frame.height - 20 * elementScale, max: wall.position.y + wall.size.height / 2 + 20 * elementScale)
        default:
            wall = createWall(position: CGPoint(x: self.frame.width + pointXBais, y: pointY))
            if Bool.random() {
            randomeFlowerPositionY = random(min: self.frame.height - 20 * elementScale, max: wall.position.y + wall.size.height / 2 + 20 * elementScale)
            } else {
                randomeFlowerPositionY = random(min: 20 * elementScale, max: wall.position.y - wall.size.height / 2 - 20 * elementScale)
            }
        }
        walls.addChild(wall)
        let randomeFlowerPositionX: CGFloat = random(min: wall.position.x - 20 * elementScale, max: wall.position.x + 20 * elementScale)
        let flowerPosition = CGPoint(x: random(min: wall.position.x - wall.size.width, max: wall.position.x - wall.size.width * 2), y: random(min: 20 * elementScale, max: self.frame.height - 20 * elementScale))
        let randomeFlowerPosition = CGPoint(x: randomeFlowerPositionX, y: randomeFlowerPositionY)

        walls.addChild(createFlower(position: Bool.random() ? randomeFlowerPosition : flowerPosition))

        walls.zPosition = 1
        let randomPosition2 = random(min: -15, max: 15)
        walls.position.y = walls.position.y +  randomPosition2
        walls.run(moveAndRemove)
        
        return walls

    }

    func createFlower(position: CGPoint) -> SKSpriteNode {
        let flowerNode = SKSpriteNode(imageNamed: "flower")
        flowerNode.size = CGSize(width: 20 * elementScale, height: 20 * elementScale)
        flowerNode.position = position
        flowerNode.physicsBody = SKPhysicsBody(rectangleOf: flowerNode.size)
        flowerNode.physicsBody?.affectedByGravity = false
        flowerNode.physicsBody?.isDynamic = false
        flowerNode.physicsBody?.categoryBitMask = CollisionBitMask.flowerCategory
        flowerNode.physicsBody?.collisionBitMask = 0
        flowerNode.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        flowerNode.color = SKColor.blue
        flowerNode.zPosition = -1
        return flowerNode
    }
    
    func createTopWall(position: CGPoint) -> SKSpriteNode {
        let wall = SKSpriteNode(imageNamed: "tiles1")
        
        wall.position = position
        wall.size = CGSize(width: elementScale * 64, height: self.frame.height / 2)
        wall.alpha = 0.95
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        wall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        wall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.affectedByGravity = false
        
        wall.zRotation = CGFloat(M_PI)
        return wall
    }
    
    func createWall(position: CGPoint) -> SKSpriteNode {
        let wall = SKSpriteNode(imageNamed: "tiles3")
        
        wall.position = position
        wall.size = CGSize(width: 64 * elementScale, height: 64 * elementScale)
        wall.alpha = 0.95
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        wall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        wall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.affectedByGravity = false

        return wall
    }
    
    func createBtmWall(position: CGPoint) -> SKSpriteNode {
        let wall = SKSpriteNode(imageNamed: "tiles1")
        
        wall.position = position
        wall.size = CGSize(width: elementScale * 64, height: self.frame.height / 2)
        wall.alpha = 0.95
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        wall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        wall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.affectedByGravity = false
                
        return wall
    }
}
 
extension GameScene {
    func randomObstacle(numberOfObstacles: Int, lastObstacle: Int) -> Int {
        let temp = Int.random(in: 1 ..< numberOfObstacles)
        if (temp < lastObstacle) {
            return temp
        } else {
            return temp + 1
        }
    }
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min : CGFloat, max : CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
}
