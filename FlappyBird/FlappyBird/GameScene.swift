//
//  GameScene.swift
//  FlappyBird
//
//  Created by Suhas V Kumar on 10/9/16.
//  Copyright © 2016 UIowa. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    
    var bg = SKSpriteNode()
    
    var scoreLabel = SKLabelNode()
    
    var score  = 0
    
    var gameOverLabel = SKLabelNode()
    
    var timer = Timer()
    
    enum ColliderType: UInt32 {
        
        case Bird = 1
        case Object = 2 //Object is pipe or Ground
        case Gap = 4
        
    }
    
    
    
    var gameOver = false
    
    func makePipes() {
        
        let movePipes = SKAction.move(by: CGVector(dx: -2 * self.frame.width, dy: 0), duration: TimeInterval (self.frame.width / 100))
        
        let removePipes = SKAction.removeFromParent()
        
        let moveAndRemovePipes = SKAction.sequence([movePipes,removePipes])
        
        let gapHeight = bird.size.height * 4
        
        let movementAmount = arc4random() %  UInt32(self.frame.height / 2)
        
        let pipeOffset = CGFloat (movementAmount) - self.frame.height / 4
        
        let pipeTexture = SKTexture(imageNamed: "pipe1.png")
        
        let pipe1 = SKSpriteNode(texture: pipeTexture)
        
        pipe1.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeTexture.size().height / 2 + gapHeight / 2 + pipeOffset )
        
        pipe1.run(moveAndRemovePipes)
        
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        
        pipe1.physicsBody!.isDynamic = false
        
        pipe1.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        
        pipe1.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        
        pipe1.physicsBody!.collisionBitMask = ColliderType.Object.rawValue //wheather 2 objects allows us to pass through.
        
        pipe1.zPosition = -1 // to make game over lable appear above
        
        self.addChild(pipe1)
        
        
        let pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        let pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - pipe2Texture.size().height / 2  - gapHeight / 2 + pipeOffset)
        
        pipe2.run(moveAndRemovePipes)
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        
        pipe2.physicsBody!.isDynamic = false
        
        pipe2.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        
        pipe2.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        
        pipe2.physicsBody!.collisionBitMask = ColliderType.Object.rawValue //wheather 2 objects allows us to pass through.
        
        pipe2.zPosition = -1 // to make game over lable appear above
        
        
        self.addChild(pipe2)
        
        
        
        //scoring --
        
        let gap = SKNode()
        
        gap.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeOffset)
        
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeTexture.size().width, height: gapHeight) )
        
        gap.physicsBody!.isDynamic = false
        
        gap.run(moveAndRemovePipes)
        
        gap.physicsBody!.contactTestBitMask = ColliderType.Bird.rawValue
        
        gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue
        
        gap.physicsBody!.collisionBitMask = ColliderType.Gap.rawValue //wheather 2 objects allows us to pass through.
        
        self.addChild(gap)
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if gameOver == false {
            
            if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
                
                print(" add 1 to score ")
                
                score += 1
                
                scoreLabel.text = String (score)
            }
                
            else {
                print("We have contact")
                
                self.speed = 0
                
                gameOver = true
                
                timer.invalidate()
                
                gameOverLabel.fontName = "Helvativca"
                gameOverLabel.fontSize = 30
                gameOverLabel.text = "Game Over !!!   Tap to play Again"
                gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                self.addChild(gameOverLabel)
                
            }
        }
        
    }
    
    
    //like view did load method. Scene has appeared on view controller
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        print("view loaded, 1st time")
        self.view!.isPaused = true
        setupGame()
        
    }
    
    
    func setupGame()
    {
        self.view!.isPaused = true
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.makePipes), userInfo: nil, repeats: true)
        
        
        let bgTexture = SKTexture(imageNamed: "bg.png")
        
        let moveBGAnimation = SKAction.move(by: CGVector(dx: -bgTexture.size().width, dy: 0), duration: 7) //move entire bg Texture to left for every 5 seconds, only once
        let shiftBGAnimation = SKAction.move(by: CGVector(dx: bgTexture.size().width, dy: 0), duration: 0) //shift the screen again by jumping back to start of the image
        
        let moveBGForever = SKAction.repeatForever(SKAction.sequence([moveBGAnimation, shiftBGAnimation])) //moving animation forever ... We will get black screen when bg screen runs out
        
        
        
        var i: CGFloat = 0
        while  i < 3 {
            
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width * i, y: self.frame.midY) //align the left hand egde with the edge of the background texture ... width /2
            bg.size.height = self.frame.height
            bg.run(moveBGForever)
            
            bg.zPosition = -2 // to make bg always behind the bird
            
            self.addChild(bg)
            i += 1
            
            
            
        }
        
        
        let birdTexture = SKTexture(imageNamed: "flappy1.png") //we have got bird texture
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png") // this texture is used to make bird flap
        
        let animation = SKAction.animate(with: [birdTexture, birdTexture2], timePerFrame: 0.1) //creating animation, Action is generally some kind of action or movement, animate between those 2 images, time is 0.1
        let makebirdFlap = SKAction.repeatForever(animation)//creating instrution forever
        
        
        bird = SKSpriteNode(texture: birdTexture) //applying texture to bird
        
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY) // positioning the bird, middle of the screen
        
        bird.run(makebirdFlap) // make bird flap
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 2)
        
        bird.physicsBody!.isDynamic = false
        
        bird.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        
        bird.physicsBody!.categoryBitMask = ColliderType.Bird.rawValue
        
        bird.physicsBody!.collisionBitMask = ColliderType.Bird.rawValue //wheather 2 objects allows us to pass through.
        
        self.addChild(bird) //adding object or node to view controller
        
        
        
        
        let ground = SKNode() //invisible object, making bird falling to ground
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        ground.physicsBody!.isDynamic = false
        
        ground.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        
        ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        
        ground.physicsBody!.collisionBitMask = ColliderType.Object.rawValue //wheather 2 objects allows us to pass through.
        
        self.addChild(ground)
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = " Tap to Play"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 70) //-70 coz of padding
        self.addChild(scoreLabel)
    }
    
    //When the user touches the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view!.isPaused = false
        if gameOver == false {
            
            bird.physicsBody!.isDynamic = true //gravity will apply ... will fall down
            bird.physicsBody!.velocity = (CGVector(dx: 0, dy: 0))
            bird.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 71))
            
        }
        else {
            
            gameOver = false
            score = 0
            self.speed = 1
            self.removeAllChildren()
            setupGame()
            
        }
        
        
    }
    
    
    
    
    
    //called several times a second. allows us to do things like check for collision, move items on game scene and do anything to happen continually throught the game
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
}
