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
    
    var key = ""
    
    
    var scoreValue = [Int]()
    
    var highlabel = SKLabelNode()
    
    var label1 = SKLabelNode()
    var label2 = SKLabelNode()
    var label3 = SKLabelNode()
    var label4 = SKLabelNode()
    var label5 = SKLabelNode()
    
    
    
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
                
                
                print ("Current score is \(score)")
                
                scoreLabel.text = String ("Current Score : \(score)")
                
                
                
                
            }
                
            else {
                print("We have contact")
                
                for i in 0...4  {
                    key = "highscore" + String(i)
                    UserDefaults.standard.set(score, forKey:key)
                    
                }
                
                
                self.speed = 0
                
                gameOver = true
                
                timer.invalidate()
                
                gameOverLabel.fontName = "Helvativca"
                gameOverLabel.fontSize = 40
                gameOverLabel.text = "Game Over !!!   Tap to play Again"
                gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                self.addChild(gameOverLabel)
                
                
                label1.fontName = "Helvativca"
                label1.fontSize = 35
                label1.text = "0"
                label1.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 150)
                
                label2.fontName = "Helvativca"
                label2.fontSize = 35
                label2.text = "0"
                label2.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 170)
                
                label3.fontName = "Helvativca"
                label3.fontSize = 35
                label3.text = "0"
                label3.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 190)
                
                label4.fontName = "Helvativca"
                label4.fontSize = 35
                label4.text = "0"
                label4.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 210)
                
                label5.fontName = "Helvativca"
                label5.fontSize = 35
                label5.text = "0"
                label5.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 230)
                
                
                highlabel.fontName = "Helvativca"
                highlabel.fontSize = 35
                highlabel.text = "Game Over !!!   Tap to play Again"
                highlabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 120)
                highlabel.text = "Highest Scores are :"
                
                for i in 0...4  {
                    key = "highscore" + String(i)
                    scoreValue.append(UserDefaults.standard.object(forKey:key) as! Int)
                }
                
                
                // print(uniqueVals)
                var uniqueVals = uniq(source: scoreValue)
                print("\(scoreValue)")
                
                print ("Unique array")
                print("\(uniqueVals)")
                
                
                
                
                uniqueVals = uniqueVals.sorted()
                uniqueVals = uniqueVals.reversed()
                print ("sorted array in reverse order")
                print("\(uniqueVals)")
                print("\(uniqueVals.count)")
                
                let count = uniqueVals.count
                
                if( count == 1)
                {
                    
                    print ("count is 1")
                    if("\(uniqueVals[0])" == "0")
                    {
                        label1.text = "No high scores yet"
                    }
                    
                    print("first value \(uniqueVals[0])")
                    label1.text = String ("1st Score : \(uniqueVals[0])")
                    label2.isHidden = true
                    label3.isHidden = true
                    label4.isHidden = true
                    label5.isHidden = true
                    
                    
                }
                
                
                if( count == 2)
                {
                    label2.isHidden = false
                    
                    if("\(uniqueVals[1])" == "0")
                    {
                        label2.isHidden = true
                    }
                    
                    label1.text = String ("1st Score : \(uniqueVals[0])")
                    label2.text = String ("2nd Score : \(uniqueVals[1])")
                    label1.isHidden = false
                    
                    label3.isHidden = true
                    label4.isHidden = true
                    label5.isHidden = true
                    print("first value \(uniqueVals[0])")
                    print("2nd value \(uniqueVals[1])")
                    
                
                    
                }
                
                
                if( count == 3)
                {
                    
                    
                    
                    label1.isHidden = false
                    label2.isHidden = false
                    label3.isHidden = false
                    
                    if("\(uniqueVals[2])" == "0")
                    {
                        label3.isHidden = true
                    }
                    
                    
                    label1.text = String ("1st Score : \(uniqueVals[0])")
                    label2.text = String ("2nd Score : \(uniqueVals[1])")
                    label3.text = String ("3rd Score : \(uniqueVals[2])")
                    
                    
                    label4.isHidden = true
                    label5.isHidden = true
                    
                    print("first value \(uniqueVals[0])")
                    print("2nd value \(uniqueVals[1])")
                    print("3rd value\(uniqueVals[2])")
                    
                    
                }
                
                
                if( count == 4)
                {
                    
                    label1.isHidden = false
                    label2.isHidden = false
                    label3.isHidden = false
                    label4.isHidden = false
                    
                    if("\(uniqueVals[3])" == "0")
                    {
                        label4.isHidden = true
                    }
                    
                    label1.text = String ("1st Score : \(uniqueVals[0])")
                    label2.text = String ("2nd Score : \(uniqueVals[1])")
                    label3.text = String ("3rd Score : \(uniqueVals[2])")
                    label4.text = String ("4th Score : \(uniqueVals[3])")
                
                    label5.isHidden = true
                    
                    print("first value \(uniqueVals[0])")
                    print("2nd value \(uniqueVals[1])")
                    print("3rd value \(uniqueVals[2])")
                    print("4th value\(uniqueVals[3])")
                    
                    
                }
                
                
                if( count == 5)
                {
                    label1.isHidden = false
                    label2.isHidden = false
                    label3.isHidden = false
                    label4.isHidden = false
                    label5.isHidden = false
                    
                    if("\(uniqueVals[4])" == "0")
                    {
                        print("5th value in array \(uniqueVals[4])")
                        label5.isHidden = true
                    }
                    
                    
                    
                    label1.text = String ("1st Score : \(uniqueVals[0])")
                    label2.text = String ("2nd Score : \(uniqueVals[1])")
                    label3.text = String ("3rd Score : \(uniqueVals[2])")
                    label4.text = String ("4th Score : \(uniqueVals[3])")
                    label5.text = String ("5th Score : \(uniqueVals[4])")
                    
                    print("first value \(uniqueVals[0])")
                    print("2nd value \(uniqueVals[1])")
                    print("3rd value\(uniqueVals[2])")
                    print("4th value\(uniqueVals[3])")
                    print("5th value\(uniqueVals[4])")
                }
                
                
                if( count > 5)
                {
                    label1.isHidden = false
                    label2.isHidden = false
                    label3.isHidden = false
                    label4.isHidden = false
                    label5.isHidden = false
                    
                    
                    print("count greater than 5")
                    label1.text = String ("1st Score : \(uniqueVals[0])")
                    label2.text = String ("2nd Score : \(uniqueVals[1])")
                    label3.text = String ("3rd Score : \(uniqueVals[2])")
                    label4.text = String ("4th Score : \(uniqueVals[3])")
                    label5.text = String ("5th Score : \(uniqueVals[4])")
                    
                    print("1st value \(uniqueVals[0])")
                    print("2nd value \(uniqueVals[1])")
                    print("3rd value\(uniqueVals[2])")
                    print("4th value\(uniqueVals[3])")
                    print("5th value\(uniqueVals[4])")
                    
                }
                
                
                
                
                self.addChild(highlabel)
                self.addChild(label1)
                self.addChild(label2)
                self.addChild(label3)
                self.addChild(label4)
                self.addChild(label5)
                
                
            }
        }
        
    }
    
    
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
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
