//
//  GameScene.swift
//  Pong
//
//  Created by Harrison Heeb on 7/13/17.
//  Copyright © 2017 Harrison Heeb. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{

    

    
    var going = true
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var main = SKSpriteNode()
    var middle = SKSpriteNode()
    var prizeDia = SKSpriteNode()
    var prizeCoin = SKSpriteNode()
    var obstacles = [SKSpriteNode]()
    var prizeCash = SKSpriteNode()
    var topLbl = SKLabelNode()
    var topLbl2 = SKLabelNode()
    var scoreLbl = SKLabelNode()
    var scoreLbl2 = SKLabelNode()
    var scoreLbl3 = SKLabelNode()
    var instructLbl = SKLabelNode()

    var highScoreLbl = SKLabelNode()

    var overLbl = SKLabelNode()
    var overBack = SKShapeNode()
    var exclamations = [SKSpriteNode]()
    var ballPosition = 1
    var triedPrize = false
    var fastTime = 0
    var randNum = 0
    var numObstacles = 0
    var diaPlaced = false
    var coinPlaced = false
    var cashPlaced = false
    var difficutly = 0
    var obsPresent = 0
    var redHue = 102.0
    
    var timeCounter = 0
    
    var topCounted = false
    var botCounted = false
    var counterTop = 0
    var counterBot = 0
    
    var touchX = 0.0
    var touchY = 0.0
    var swiped = false
    
    
    var justSwipedUp = false
    var justSwipedDown = false
    
    
    let ObstacleCategory  : UInt32 = 0x1 << 1
    let BallCategory: UInt32 = 0x1 << 2
    let LineCategory: UInt32 = 0x1 << 3
    
    
    var score = 0
    var highScore = 0
    
   
    
    
    
    
    let shockWaveAction: SKAction = {
        let growAndFadeAction = SKAction.group([SKAction.scale(to: 100, duration: 1.5), SKAction.fadeOut(withDuration: 1.5)])
        
        let sequence = SKAction.sequence([growAndFadeAction,
                                          SKAction.removeFromParent()])
        
        return sequence
    }()
    
    let fadeAction: SKAction = {
        
        
        let sequence = SKAction.sequence([SKAction.fadeOut(withDuration: 0.0),
                                          SKAction.fadeIn(withDuration: 1.0)])
        
        return sequence
    }()
    let shakeAction: SKAction = {
        
        
        let sequence = SKAction.sequence([SKAction.moveBy(x: 0, y: -10.0, duration: 0.05), SKAction.moveBy(x: 0, y: 10.0, duration: 0.05)])
        
        return sequence
    }()
    
    
    let trailerAction: SKAction = {
        let growAndFadeAction = SKAction.group([SKAction.fadeOut(withDuration: 1.5)])
        
        let sequence = SKAction.sequence([growAndFadeAction,
                                          SKAction.removeFromParent()])
        
        return sequence
    }()
    
    override func didMove(to view: SKView) {
     
        
        
        let HighscoreDefault = UserDefaults.standard
        
        if(HighscoreDefault.value(forKey: "highScore") != nil){
            highScore = HighscoreDefault.value(forKey: "highScore") as! NSInteger!
        }
        
        if(102.0 + Double(highScore)/4 < 256){
            redHue = 102.0 + Double(highScore)/4
        }
        
        topLbl = self.childNode(withName: "topLabel") as! SKLabelNode
        topLbl2 = self.childNode(withName: "topLabel2") as! SKLabelNode
        scoreLbl = self.childNode(withName: "scoreLabel") as! SKLabelNode
        scoreLbl.position = CGPoint(x: -self.frame.width, y: 0)
        scoreLbl2 = self.childNode(withName: "scoreLabel2") as! SKLabelNode
        scoreLbl2.position = CGPoint(x: -self.frame.width, y: 0)
        scoreLbl3 = self.childNode(withName: "scoreLabel3") as! SKLabelNode
        scoreLbl3.position = CGPoint(x: 0, y: -self.frame.height)
        instructLbl = self.childNode(withName: "instructionLabel") as! SKLabelNode
        instructLbl.position = CGPoint(x: 0, y: -5)
        highScoreLbl = self.childNode(withName: "highScoreLabel") as! SKLabelNode
        highScoreLbl.position = CGPoint(x: -self.frame.width, y: 0)

        
        overLbl = self.childNode(withName: "GameOver") as! SKLabelNode
        overLbl.position = CGPoint(x: 0, y: self.frame.height)
        overBack = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 300, height: 400), cornerRadius: 20.0)
        overBack.strokeColor = UIColor.black
        overBack.lineWidth = 4.0
        overBack.fillColor = UIColor.init(red: 153/256.0, green: 102/256.0, blue: 51/256.0, alpha: 1.0)
        self.addChild(overBack)
        overBack.position = CGPoint(x: -150, y: self.frame.height)


        
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        ball.size = CGSize(width: 20, height: 20)
        ball.physicsBody?.categoryBitMask = BallCategory
        ball.physicsBody?.collisionBitMask = ObstacleCategory | LineCategory
        ball.physicsBody?.restitution = 1.0
        
        
        enemy = SKSpriteNode(texture: SKTexture(imageNamed: "box"))
        enemy.position.y = (self.frame.height / 4)
        enemy.size = CGSize(width: self.frame.width, height: 20)
        self.addChild(enemy)
        
        
        main = SKSpriteNode(texture: SKTexture(imageNamed: "box"))
        main.position.y = -(self.frame.height / 4)
        main.size = CGSize(width: self.frame.width, height: 20)
        self.addChild(main)
        
        
        middle = SKSpriteNode(texture: SKTexture(imageNamed: "box"))
        middle.position.y = 0
        middle.size = CGSize(width: self.frame.width, height: 20)
        self.addChild(middle)
        
 
        
        
        
        prizeDia = SKSpriteNode(texture: SKTexture(imageNamed: "diamond"))
        self.addChild(prizeDia)
        prizeDia.size.width = 25
        prizeDia.size.height = 25
        prizeDia.name = "prize"
        
        prizeCoin = SKSpriteNode(texture: SKTexture(imageNamed: "coin"))
        self.addChild(prizeCoin)
        prizeCoin.size.width = 209/10.0
        prizeCoin.size.height = 228/10.0
        prizeCoin.name = "prize"
        
        prizeCash = SKSpriteNode(texture: SKTexture(imageNamed: "cash"))
        self.addChild(prizeCash)

        
        prizeCash.size.width = 25
        prizeCash.size.height = 25
        prizeCash.name = "prize"
        
        for i in 0...5{
            exclamations.append(SKSpriteNode(imageNamed: "warning"))
            
            if (i < 3){
                exclamations[i].position = CGPoint(x: -Int(self.frame.width/2 ) + 20, y:30 +  i*Int(self.frame.height / 4) - Int(self.frame.height / 4))
            } else {
                exclamations[i].position = CGPoint(x: Int(self.frame.width/2 ) - 20, y:30 +  (i - 3)*Int(self.frame.height / 4) - Int(self.frame.height / 4))
            }
            exclamations[i].size.width = 20
            exclamations[i].size.height = 20
            exclamations[i].name = "exclamation"
            exclamations[i].run(SKAction.fadeOut(withDuration: 0.1))
            exclamations[i].zPosition = 6
            self.addChild(exclamations[i])
        }

        for i in 0...5{
            addObstacle()
            obstacles[i].zPosition = 5
        }
        
   
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -20)

        overLbl.zPosition = 20
        topLbl.zPosition = 21
        topLbl2.zPosition = 21
        scoreLbl.zPosition = 21
        scoreLbl2.zPosition = 21
        scoreLbl3.zPosition = 21
        instructLbl.zPosition = 8
        highScoreLbl.zPosition = 21
        
        overBack.zPosition = 10
        ball.zPosition = 9
        prizeDia.zPosition = 8
        prizeCash.zPosition = 8
        prizeCoin.zPosition = 8
        main.zPosition = 7
        middle.zPosition = 7
        enemy.zPosition = 7
        
        
        topLbl.position = CGPoint(x: 0, y: Int(self.frame.height*3/8))
        topLbl2.position = CGPoint(x: self.frame.width, y: 0)

        


        
        
        
        startGame()
        
        
    }
    

    
    
    func startGame() {
        topCounted = false
        botCounted = false
        ball.physicsBody?.affectedByGravity = false
        justSwipedUp = false
        justSwipedDown = false
        going = true
        score = 0
        difficutly = 20
        obsPresent = 0
        ballPosition = 1
        counterTop = 0
        overLbl.run(SKAction.move(to: CGPoint(x: 0, y: self.frame.height), duration: 1.0))
        topLbl.run(SKAction.move(to: CGPoint(x: 0, y: Int(self.frame.height*3/8)), duration: 1.0))
        topLbl2.run(SKAction.move(to: CGPoint(x: self.frame.width, y: 0), duration: 1.0))

        scoreLbl.run(SKAction.move(to: CGPoint(x: -self.frame.width, y: -70), duration: 1.0))
        scoreLbl2.run(SKAction.move(to: CGPoint(x: -self.frame.width, y: 0), duration: 1.0))
        scoreLbl3.run(SKAction.move(to: CGPoint(x: 0, y: -self.frame.height), duration: 1.0))
        instructLbl.run(SKAction.fadeIn(withDuration: 1.0))
        highScoreLbl.run(SKAction.move(to: CGPoint(x: -self.frame.width, y: -30), duration: 1.0))

        
        overBack.run(SKAction.move(to: CGPoint(x: -150, y: self.frame.height), duration: 1.0))
        
        
        
        prizeDia.position = CGPoint(x: 0, y: self.frame.height)
        
        prizeCoin.position = CGPoint(x: 0, y: self.frame.height)
        
        prizeCash.position = CGPoint(x: 0, y: self.frame.height)
        
        diaPlaced = false
        coinPlaced = false
        cashPlaced = false
        
        for i in 0...5 {
            obstacles[i].physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            if(i < 3){
                obstacles[i].position = CGPoint(x: -Int(self.frame.width), y:10 +  i*Int(self.frame.height / 4) - Int(self.frame.height / 4))
            } else {
                obstacles[i].position = CGPoint(x: Int(self.frame.width), y:10 +  (i - 3)*Int(self.frame.height / 4) - Int(self.frame.height / 4))
            }
            exclamations[i].run(SKAction.fadeOut(withDuration: 0.01))
        }
        
        
        topLbl.text = "\(score)"
        ball.position = CGPoint(x: 0, y: 30)
        ball.physicsBody?.velocity = CGVector(dx: 350, dy: 0)
        
        
    }
   
    
    
    func swipeDown(){
        if (justSwipedDown == true && ballPosition == 2){
            ballPosition = 1
        }
       
        
        
        
        if (going && ball.physicsBody?.velocity.dy == 0){
            
            
            if (ballPosition == 1){
                ball.physicsBody?.affectedByGravity = true
                justSwipedDown = true
                
                
            }else if(ballPosition == 2){
                ball.physicsBody?.affectedByGravity = true
                justSwipedDown = true
                
            } else {
                
            }
            
            
            
            
        }
    }
    
    func swipeUp(){
        if (going && ball.physicsBody?.velocity.dy == 0){
            
            
            if (ballPosition == 1){
                ball.physicsBody?.affectedByGravity = true
                ball.physicsBody?.velocity.dy = 1170
                justSwipedUp = true
            }else if(ballPosition == 2){
                
            } else {
                ball.physicsBody?.affectedByGravity = true
                ball.physicsBody?.velocity.dy = 1170
                justSwipedUp = true
            }
            
            
            
            
        }
        
    }
    
    func addObstacle(){
        
        obstacles.append(SKSpriteNode(imageNamed: "weapon"))
        let yValue = numObstacles*Int(self.frame.height / 4) - Int(self.frame.height / 4) - 50
        if(numObstacles < 3){
            obstacles[numObstacles].position = CGPoint(x: -Int(self.frame.width) - 300, y: yValue)
        } else {
            obstacles[numObstacles].position = CGPoint(x: Int(self.frame.width) + 300, y: yValue)
        }
        obstacles[numObstacles].size.width = 100
        obstacles[numObstacles].size.height = 100
        obstacles[numObstacles].physicsBody = SKPhysicsBody(circleOfRadius: 50)
        obstacles[numObstacles].physicsBody?.isDynamic = true
        obstacles[numObstacles].physicsBody?.affectedByGravity = false
        obstacles[numObstacles].physicsBody?.linearDamping = 0.0
        obstacles[numObstacles].physicsBody?.restitution = 0.01
        obstacles[numObstacles].name = "weapon"
        
        obstacles[numObstacles].physicsBody?.categoryBitMask = ObstacleCategory
        obstacles[numObstacles].physicsBody?.collisionBitMask = BallCategory
        
        obstacles[numObstacles].physicsBody!.contactTestBitMask = obstacles[numObstacles].physicsBody!.collisionBitMask
        
        
        self.addChild(obstacles[numObstacles])
       
        physicsWorld.contactDelegate = self
        
        numObstacles = numObstacles + 1
        
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "ball" &&  contact.bodyB.node?.name == "prize"){
            contact.bodyB.node!.removeFromParent()
            score = score + 1
        }
        
        if (contact.bodyA.node?.name == "prize" && contact.bodyB.node?.name == "ball"){
            contact.bodyA.node!.removeFromParent()
            score = score + 1
            
        }
        if (contact.bodyA.node?.name == "weapon" && contact.bodyB.node?.name == "ball"){
            let shockwave = SKShapeNode(circleOfRadius: 1)
            
            shockwave.position = contact.contactPoint
            scene!.addChild(shockwave)
            
            shockwave.run(shockWaveAction)
            endGame()
            
        }
        if (contact.bodyA.node?.name == "ball" && contact.bodyB.node?.name == "weapon"){
            let shockwave = SKShapeNode(circleOfRadius: 1)
            
            shockwave.position = contact.contactPoint
            scene!.addChild(shockwave)
            
            shockwave.run(shockWaveAction)
            endGame()
            
        }
        
        
    }
    
    func shootObstacle(){
        if(obsPresent < 2){
            randNum = Int(arc4random_uniform(6))
            if(obstacles[randNum].physicsBody?.velocity.dx == 0){
                if(randNum > 2){
                    obstacles[randNum].physicsBody?.velocity = CGVector(dx: -210, dy: 0)

                } else {
                    obstacles[randNum].physicsBody?.velocity = CGVector(dx: 210, dy: 0)
                }
                exclamations[randNum].run(SKAction.fadeIn(withDuration: 0.3))
                obsPresent = obsPresent + 1
                
            }
        }

    }
    func addPrize(){
        randNum = Int(arc4random_uniform(3))
        if(randNum == 0){
            if (diaPlaced == false){
                randNum = Int(arc4random_uniform(UInt32(self.frame.width)))
                randNum = Int(self.frame.width/2) - randNum
                randNum = randNum*4/5
            
                prizeDia.position.x = CGFloat(randNum)
            
                randNum = Int(arc4random_uniform(3))
                prizeDia.position.y = 30 + CGFloat(randNum)*self.frame.height / 4.0 - self.frame.height / 4.0
            
                prizeDia.run(fadeAction)
                diaPlaced = true
            }
        } else if (randNum == 1){
            if (coinPlaced == false){
                randNum = Int(arc4random_uniform(UInt32(self.frame.width)))
                randNum = Int(self.frame.width/2) - randNum
                randNum = randNum*4/5
            
                prizeCoin.position.x = CGFloat(randNum)
            
                randNum = Int(arc4random_uniform(3))
                prizeCoin.position.y = 30 + CGFloat(randNum)*self.frame.height / 4.0 - self.frame.height / 4.0
            
                prizeCoin.run(fadeAction)
                coinPlaced = true
           }
        } else if (randNum == 2){
            if (cashPlaced == false){
                randNum = Int(arc4random_uniform(UInt32(self.frame.width)))
                randNum = Int(self.frame.width/2) - randNum
                randNum = randNum*4/5
            
                prizeCash.position.x = CGFloat(randNum)
            
                randNum = Int(arc4random_uniform(3))
                prizeCash.position.y = 30 + CGFloat(randNum)*self.frame.height / 4.0 - self.frame.height / 4.0
            
                prizeCash.run(fadeAction)
                cashPlaced = true
            }
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch in touches {
            let location = touch.location(in: self)
            
            touchX = Double(location.x)
            touchY = Double(location.y)
            if(going){
                instructLbl.run(SKAction.fadeOut(withDuration: 1.0))
            }
          
            
            if (!going){
                if(overLbl.position.y < 200){
                    startGame()
                    going = true
                }
            }
            
        }
          
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch in touches {
            let location = touch.location(in: self)
            if(swiped == false){
                if(Double(location.y) > touchY){
                    swipeUp()
                } else if (Double(location.y) < touchY){
                    swipeDown()
                }
                swiped = true
            }
        }
           
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
       

            swiped = false
        
        
        
    }
    
    func endGame(){
        going = false
        for obstacle in obstacles {
            obstacle.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        overLbl.run(SKAction.move(to: CGPoint(x: 0, y: 150), duration: 2.0))
        overBack.run(SKAction.move(to: CGPoint(x: -150, y: -200), duration: 2.0))
        topLbl.run(SKAction.move(to: CGPoint(x: 90, y: 50), duration: 2.0))
        topLbl2.run(SKAction.move(to: CGPoint(x: 90, y: -50), duration: 2.0))
        scoreLbl.run(SKAction.move(to: CGPoint(x: -40, y: 50), duration: 2.0))
        scoreLbl2.run(SKAction.move(to: CGPoint(x: -40, y: -50), duration: 2.0))
        scoreLbl3.run(SKAction.move(to: CGPoint(x: 0, y: -140), duration: 2.0))
        highScoreLbl.run(SKAction.move(to: CGPoint(x: -40, y: -25), duration: 2.0))
        instructLbl.run(SKAction.fadeOut(withDuration: 1.0))
        if(score > highScore){
            highScore = score
            topLbl2.text = "\(highScore)"
        }

    }
    
    
    func addScore(){
        score = score + 1
        topLbl.run(shakeAction)
        if(score > highScore){
            highScore = score
            if(102.0 + Double(highScore)/4 < 256){
                redHue = 102.0 + Double(highScore)/4
            }
            
            let HighscoreDefault = UserDefaults.standard
            HighscoreDefault.setValue(highScore, forKey: "highScore")
            HighscoreDefault.synchronize()
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if(going){
            
            
            
          let slider = self.frame.height/4 + 30
            if(justSwipedUp && ballPosition == 1){
                if(ball.position.y < slider + 10 &&  topCounted == false){
                    counterTop = counterTop + 1
                    topCounted = true
                }
                if(ball.position.y > slider + 10 ){
                    topCounted = false
                }
            
                if (counterTop == 2){
                    ball.position.y = slider
                    ball.physicsBody?.affectedByGravity = false
                    ball.physicsBody?.velocity.dy = 0.0
                    ballPosition = 2
                    counterTop = 0
                    topCounted = false
                    justSwipedUp = false
                    enemy.run(shakeAction)
                }
            }
            if(justSwipedUp && ballPosition == 0){
                if(ball.position.y < 40 &&  topCounted == false){
                    counterTop = counterTop + 1
                    topCounted = true
                }
                if(ball.position.y > 40){
                    topCounted = false
                }
                
                if (counterTop == 2){
                    ball.position.y = 30
                    ball.physicsBody?.affectedByGravity = false
                    ball.physicsBody?.velocity.dy = 0.0
                    ballPosition = 1
                    counterTop = 0
                    topCounted = false
                    justSwipedUp = false
                    middle.run(shakeAction)
                }
            }
            
            
            if(justSwipedDown && ballPosition == 2){
                if (ball.position.y < 40){
                    ball.position.y = 30
                    ball.physicsBody?.affectedByGravity = false
                    ball.physicsBody?.velocity.dy = 0.0
                    ballPosition = 1
                    justSwipedDown = false
                    middle.run(shakeAction)
                }
            }
            if(justSwipedDown && ballPosition == 1){
                if (ball.position.y < -slider + 70){
                    ball.position.y = -slider + 60
                    ball.physicsBody?.affectedByGravity = false
                    ball.physicsBody?.velocity.dy = 0.0
                    ballPosition = 0
                    justSwipedDown = false
                    main.run(shakeAction)
                }
            }
            
            
            
            
            
            if(102.0 + Double(highScore)/4 < 256){
                redHue = 102.0 + Double(highScore)/4
            }
            
            scene?.backgroundColor = UIColor(displayP3Red: CGFloat(Double(redHue)/256.0), green: CGFloat(196.0/256), blue: CGFloat(232.0/256), alpha: CGFloat(1.0))
            
            
            
            
            prizeDia.size = CGSize(width: prizeDia.size.width + CGFloat(sin(currentTime*7)/5), height: prizeDia.size.height + CGFloat(sin(currentTime*7)/5))
        prizeCoin.size = CGSize(width: prizeCoin.size.width + CGFloat(sin(currentTime*7)/5), height: prizeCoin.size.height + CGFloat(sin(currentTime*7)/5))
            prizeCash.size = CGSize(width: prizeCash.size.width + CGFloat(sin(currentTime*7 + 0.15)/5), height: prizeCash.size.height + CGFloat(sin(currentTime*7 + 0.245)/5))
        
        if (ball.position.x > self.frame.width/2 - 20){
            ball.physicsBody?.velocity.dx = -350
            ball.run(SKAction.scaleX(to: 1.0, y: 1.0, duration: 0.01))
        }
        if (ball.position.x < -self.frame.width/2 + 20){
            ball.physicsBody?.velocity.dx = 350
            ball.run(SKAction.scaleX(to: -1.0, y: 1.0, duration: 0.01))
        }
        
        
        
            
            
        fastTime = Int(currentTime * 20)
            
            
            
            
            
        if (fastTime % 10 < 5 && triedPrize == false){
            
            timeCounter = timeCounter + 1
            if(timeCounter == 3){
                if (arc4random_uniform(UInt32(Double(difficutly)/5.0)) == 0){
                         shootObstacle()
                    }
                timeCounter = 0
            }
            
            randNum = Int(arc4random_uniform(4))
            if (randNum == 2){
                addPrize()
            }
            
            if(difficutly != 0){
                difficutly = difficutly - 1
            }
        
            triedPrize = true
        }
        
        if(fastTime % 10 > 5){
            triedPrize = false
        }
            
            
                
        
        
        
            
        for i in 0...5 {
            if(i < 3){
                if (obstacles[i].position.x > self.frame.width/2 + 50){
                    obstacles[i].position.x = -self.frame.width - 150
                    obstacles[i].physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                }
            
                if (obstacles[i].position.x > -self.frame.width/2){
                    exclamations[i].run(SKAction.fadeOut(withDuration: 0.1))
                    obsPresent = obsPresent - 1

                }
            
            } else {
                if (obstacles[i].position.x < -(self.frame.width/2 + 50)){
                    obstacles[i].position.x = self.frame.width + 150
                    obstacles[i].physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                }
                
                if (obstacles[i].position.x < self.frame.width/2){
                    exclamations[i].run(SKAction.fadeOut(withDuration: 0.1))
                    obsPresent = obsPresent - 1
                }
                
            }
            
            obstacles[i].position.y = obstacles[i].position.y + CGFloat(sin(currentTime*4 + 1.345 * Double(i))/5)
            
        }
            
        
        
        if(abs(ball.position.x - prizeDia.position.x) < 10){
            if (abs(ball.position.y - prizeDia.position.y) < 10){
                prizeDia.position.y = self.frame.height
                diaPlaced = false
                addScore()
            }
        }
        if(abs(ball.position.x - prizeCoin.position.x) < 10){
            if (abs(ball.position.y - prizeCoin.position.y) < 10){
                prizeCoin.position.y = self.frame.height
                coinPlaced = false
                addScore()
            }
        }
        if(abs(ball.position.x - prizeCash.position.x) < 10){
            if (abs(ball.position.y - prizeCash.position.y) < 10){
                prizeCash.position.y = self.frame.height
                cashPlaced = false
                addScore()
            }
        }
        topLbl.text = "\(score)"
        topLbl2.text = "\(highScore)"
        
        }
    }
}
