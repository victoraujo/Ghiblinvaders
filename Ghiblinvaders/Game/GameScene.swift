//
//  GameScene.swift
//  Ghiblinvaders
//
//  Created by Victor Vieira on 02/09/20.
//  Copyright © 2020 Victor Vieira. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var starfield = SKSpriteNode(imageNamed: "back2")
    var player: SKSpriteNode!
    var gameTimer: Timer!
    var tiroTimer: Timer!
    var livesArray:[SKSpriteNode]!
    
    var score: Int = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
            if score == 50 {
                velocidade = 5
            }
            if score == 75 {
                velocidade = 4
            }
            if score == 100 {
                velocidade = 4
            }
            if score == 125 {
                velocidade = 3
            }
            if score == 150 {
                velocidade = 2.5
            }
            if score == 200 {
                velocidade = 2
            }
            if score == 250 {
                velocidade = 1.5
            }
            if score == 300 {
                velocidade = 1
            }
        
        }
    }
    
    var velocidade = 6.0
    
    let enemyCategory: UInt32 = 0x1 << 1
    let torpedoCategory: UInt32 = 0x1 << 0
    
    
    override func didMove(to view: SKView) {
        //starfield = SKEmitterNode(fileNamed: "back1")
//        starfield.position = CGPoint(x: 0, y: 0)
//        //starfield.setScale(2.0)
//        self.addChild(starfield)
//        starfield.zPosition = -1
        createBG()
        addLives()
        
        
        player = SKSpriteNode(imageNamed: "kiki")
        player.position = CGPoint(x: 0, y: -350)
        self.addChild(player)
        self.physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 80 - self.frame.width/2, y: self.frame.height/2 - 70)
        scoreLabel.fontSize = 28
        scoreLabel.fontColor = .white
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        self.addChild(scoreLabel)
        
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addEnemy), userInfo: nil, repeats: true)
        
        tiroTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(fireTorpedo), userInfo: nil, repeats: true)
    }
    
    @objc func addEnemy(){
        let enemy = SKSpriteNode(imageNamed: "enemy2")
        let randomEnemyPosition = GKRandomDistribution(lowestValue: -200, highestValue: 200)
        let position = CGFloat(randomEnemyPosition.nextInt())
        
        enemy.position = CGPoint(x: position, y: self.frame.size.height/2 + enemy.size.height)
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = true
        
        enemy.physicsBody?.categoryBitMask = enemyCategory
        enemy.physicsBody?.contactTestBitMask = torpedoCategory
        enemy.physicsBody?.collisionBitMask = 0
        
        self.addChild(enemy)
        
        let animationDuration = velocidade
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -enemy.size.height - 448), duration: TimeInterval(animationDuration)))
        
        actionArray.append(SKAction.run {
            if self.livesArray.count > 0  {
                let liveNode = self.livesArray.first
                liveNode?.removeFromParent()
                self.livesArray.removeFirst()
                
                if self.livesArray.count == 0 {
                    let transition = SKTransition.fade(withDuration: 0.5)
                    let gameScene = GameOverScene(fileNamed: "GameOverScene")!
                    gameScene.score = self.score
                    self.view?.presentScene(gameScene, transition: transition)
                }
            }
        })
        
        actionArray.append(SKAction.removeFromParent())
        
        enemy.run(SKAction.sequence(actionArray))
        
        
    }
    
    func addLives(){
        livesArray = [SKSpriteNode]()
        for lives in 1...3{
            let liveNode = SKSpriteNode(imageNamed: "live")
            liveNode.position = CGPoint(x: 30 + self.frame.size.width/2 - CGFloat(4 - lives)*liveNode.size.width, y: self.frame.size.height/2 - 60)
            self.addChild(liveNode)
            livesArray.append(liveNode)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        player.position = location
        player.run(.move(to: location, duration: 0.1))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        player.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //fireTorpedo()
    }
    
    
    @objc func fireTorpedo(){
        
//        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))

        let torpedoNode = SKSpriteNode(imageNamed: "tiro")
        torpedoNode.position = player.position
        torpedoNode.position.y += 20
        torpedoNode.setScale(0.5)

        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.height/2)
        torpedoNode.physicsBody?.isDynamic = true

        torpedoNode.physicsBody?.categoryBitMask = torpedoCategory
        torpedoNode.physicsBody?.contactTestBitMask = enemyCategory
        torpedoNode.physicsBody?.collisionBitMask = 0
        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true

        self.addChild(torpedoNode)

        let animationDuration:TimeInterval = 0.4

        var actionArray = [SKAction]()

        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height/2 + torpedoNode.size.height), duration: TimeInterval(animationDuration)))
        actionArray.append(SKAction.removeFromParent())

        torpedoNode.run(SKAction.sequence(actionArray))



    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & torpedoCategory) != 0 && (secondBody.categoryBitMask & enemyCategory) != 0 {
            torpedoDidCollideWithAlien(torpedoNode: firstBody.node as! SKSpriteNode, enemyNode: secondBody.node as! SKSpriteNode)
        }
        
    }
    
    func torpedoDidCollideWithAlien(torpedoNode: SKSpriteNode, enemyNode: SKSpriteNode){
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = enemyNode.position
        self.addChild(explosion)
        torpedoNode.removeFromParent()
        enemyNode.removeFromParent()
        score += 5
    }
    
    
    func createBG(){
        for i in 0...2{
            let bg = SKSpriteNode(imageNamed: "back2")
            bg.zPosition = -1
            bg.name = "BG"
            bg.position = CGPoint(x: 0, y: CGFloat(i)*bg.frame.height )
            addChild(bg)
        }
    }
    
    func moveBG(){
        enumerateChildNodes(withName: "BG") {(node, _) in
            let node = node as! SKSpriteNode
            node.position.y -= 2.5
            
            if node.position.y < -self.frame.height{
                node.position.y += self.frame.height*2 + self.frame.height/2
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        moveBG()
    }
}
