//
//  GameScene.swift
//  Mike the Bird
//
//  Created by Dmitry Vorozhbicki on 14/03/2020.
//  Copyright © 2020 Dmitry Vorozhbicki. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var gameStarted = Bool(false)
    var died = Bool(false)

    var score = Int(0)
    var scoreLbl = SKLabelNode()
    var livesIndicator: LivesIndicator?
    var highscoreLbl = SKLabelNode()
    var taptoplayLbl = SKLabelNode()
    var restartBtn = SKSpriteNode()
    var pauseBtn = SKSpriteNode()
    var logoImg = SKSpriteNode()
    var walls = SKNode()
    var moveAndRemove = SKAction()
    
    //CREATE THE BIRD ATLAS FOR ANIMATION
    let birdAtlas = SKTextureAtlas(named:"player")
    var birdSprites = Array<SKTexture>()
    var bird = SKSpriteNode()
    var repeatActionbird = SKAction()
    
    var elementScale: CGFloat = 1
    var lastIndex = 0
    
    private let soundDead = SoundPlayer(.dead)
    private let soundPong = SoundPlayer(.pong)
    private let soundButton = SoundPlayer(.button)
    private let soundCrash = SoundPlayer(.crash)

    var lives = Int(3)
    var isCrash = false
    
    override func didMove(to view: SKView) {
        createScene()
        NotificationCenter.default.addObserver(self, selector: #selector(foregroundNotificationHandler), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func foregroundNotificationHandler() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.pause()
        }
    }
    
    func createScene() {
        elementScale = (self.frame.height / 2)/128
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "bg")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        
        //SET UP THE BIRD SPRITES FOR ANIMATION
        birdSprites.append(birdAtlas.textureNamed("sultan_flight1"))
        birdSprites.append(birdAtlas.textureNamed("sultan_flight2"))
        birdSprites.append(birdAtlas.textureNamed("sultan_flight3"))
        birdSprites.append(birdAtlas.textureNamed("sultan_flight4"))
        birdSprites.append(birdAtlas.textureNamed("sultan_flight5"))
        birdSprites.append(birdAtlas.textureNamed("sultan_flight6"))
        birdSprites.append(birdAtlas.textureNamed("sultan_flight7"))
        birdSprites.append(birdAtlas.textureNamed("sultan_flight8"))
        
        self.bird = createBird()
        self.addChild(bird)
        
        //ANIMATE THE BIRD AND REPEAT THE ANIMATION FOREVER
        let animatebird = SKAction.animate(with: self.birdSprites, timePerFrame: 0.1)
        self.repeatActionbird = SKAction.repeatForever(animatebird)
        
        scoreLbl = createScoreLabel()
        self.addChild(scoreLbl)
        
        highscoreLbl = createHighscoreLabel()
        self.addChild(highscoreLbl)
        
        createLogo()
        taptoplayLbl = createTaptoplayLabel()
        self.addChild(taptoplayLbl)
        livesIndicator = LivesIndicator(lives: lives, position: CGPoint(x: 30, y: self.frame.height / 2 + self.frame.height / 2.4))
        self.addChild(livesIndicator!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false {
            runBackgroundMusic()
            gameStarted =  true
            lastIndex = 0
            bird.physicsBody?.affectedByGravity = true
            physicsWorld.gravity = CGVector(dx: 0, dy: -7 * elementScale)
            let negDelta = CGVector(dx: -self.frame.midX / 2, dy: 0)
            let action = SKAction.move(by: negDelta, duration: 2)
            bird.run(action)
            createPauseBtn()
            logoImg.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
                self.logoImg.removeFromParent()
            })
            taptoplayLbl.removeFromParent()
            self.bird.run(repeatActionbird)
            let spawn = SKAction.run({
                () in
                self.walls = self.createWalls()
                self.addChild(self.walls)
            })
            
            let delay = SKAction.wait(forDuration: TimeInterval(1.3))
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width * 3)
            let movePipes = SKAction.moveBy(x: -distance - 50, y: 0, duration: TimeInterval(0.006 / elementScale * distance))
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes, removePipes])
            
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: bird.size.height / 4 * elementScale * elementScale * 0.8)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: bird.size.height / 4 * elementScale * elementScale * 0.8))
            print(elementScale)
        } else {
            if died == false {
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: bird.size.height / 4 * elementScale * elementScale * 0.8)
                bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: bird.size.height / 4 * elementScale * elementScale * 0.8))
                print(elementScale)
            }
        }
        
        for touch in touches{
            let location = touch.location(in: self)
            if died == true {
                if restartBtn.contains(location){
                    soundButton.play(vibration: true)
                    if UserDefaults.standard.object(forKey: "highestScore") != nil {
                        let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                        if hscore < Int(scoreLbl.text!)!{
                            UserDefaults.standard.set(scoreLbl.text, forKey: "highestScore")
                        }
                    } else {
                        UserDefaults.standard.set(0, forKey: "highestScore")
                    }
                    restartScene()
                }
            } else {
                if pauseBtn.contains(location){
                    soundButton.play(vibration: true)
                    if self.isPaused == false {
                        pause()
                    } else {
                        start()
                    }
                }
            }
        }
    }
    
    private func pause() {
        stopBackgroundMusic()
        self.isPaused = true
        pauseBtn.texture = SKTexture(imageNamed: "play")
    }
    
    private func start() {
        runBackgroundMusic()
        self.isPaused = false
        pauseBtn.texture = SKTexture(imageNamed: "pause")
    }
    
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        score = 0
        lives = 3
        createScene()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB

        if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.groundCategory || firstBody.categoryBitMask == CollisionBitMask.groundCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            collision()
        } else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.pillarCategory || firstBody.categoryBitMask == CollisionBitMask.pillarCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            collision()
        } else if firstBody.categoryBitMask == CollisionBitMask.birdCategory && secondBody.categoryBitMask == CollisionBitMask.flowerCategory {
            soundPong.play(vibration: false)
            score += 1
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent()
        } else if firstBody.categoryBitMask == CollisionBitMask.flowerCategory && secondBody.categoryBitMask == CollisionBitMask.birdCategory {
            soundPong.play(vibration: false)
            score += 1
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()
        }
    }
    
    func collision() {
        if !isCrash {
            isCrash = true
            self.lives = self.lives - 1
            livesIndicator?.deleteLive()
            if self.lives < 0 {
                self.enumerateChildNodes(withName: "wallPair", using: ({
                    (node, error) in
                    node.speed = 0
                    self.removeAllActions()
                }))
                if self.died == false{
                    stopBackgroundMusic()
                    self.died = true
                    self.createRestartBtn()
                    self.pauseBtn.removeFromParent()
                    self.bird.removeAllActions()
                    self.soundDead.play(vibration: true)
                }
            } else {
                self.soundCrash.play(vibration: true)
                let fadeOut = SKAction.fadeAlpha(to: 0, duration: 0.2)
                let fadeIn = SKAction.fadeAlpha(to: 1, duration: 0.2)
                self.bird.run(SKAction.repeat(SKAction.sequence([fadeOut, fadeIn]), count: 2))
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.isCrash = false
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if gameStarted == true {
            if died == false {
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    let bg = node as! SKSpriteNode
                    bg.position = CGPoint(x: bg.position.x - 2.5, y: bg.position.y)
                    if bg.position.x <= -bg.size.width {
                        bg.position = CGPoint(x:bg.position.x + bg.size.width * 2, y:bg.position.y)
                    }
                }))
            }
        }
    }
}
