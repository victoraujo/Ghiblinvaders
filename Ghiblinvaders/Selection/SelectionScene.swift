//
//  SelectionScene.swift
//  Ghiblinvaders
//
//  Created by Victor Vieira on 03/09/20.
//  Copyright © 2020 Victor Vieira. All rights reserved.
//

import SpriteKit

class SelectionScene: SKScene {

    var totoroNode:SKSpriteNode!
    var kikiNode:SKSpriteNode!
    var hakuNode:SKSpriteNode!
    
    override func didMove(to view: SKView) {
        createBG()
        totoroNode = childNode(withName: "totoro") as! SKSpriteNode
        kikiNode = childNode(withName: "kiki") as! SKSpriteNode
        hakuNode = childNode(withName: "haku") as! SKSpriteNode
    }
    
    func createBG(){
        for i in 0...2{
            let bg = SKSpriteNode(imageNamed: "back2")
            bg.zPosition = -2
            bg.name = "BG"
            bg.position = CGPoint(x: 0, y: CGFloat(i)*bg.frame.height )
            addChild(bg)
        }
    }
    
    func moveBG(){
        enumerateChildNodes(withName: "BG") {(node, _) in
            let node = node as! SKSpriteNode
            node.position.y -= 1.5
            
            if node.position.y < -self.frame.height{
                node.position.y += self.frame.height*2 + self.frame.height/2
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveBG()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            let touch = touches.first
            if let location = touch?.location(in: self){
                let nodesArray = self.nodes(at: location)
                if nodesArray.first?.name == "totoro" {
                    let transition = SKTransition.fade(withDuration: 0.5)
                    let gameScene = GameScene(fileNamed: "GameScene")!
                    gameScene.char = "totoro"
                    //                gameScene.position = CGPoint(x: 320, y: 0)
                    self.view?.presentScene(gameScene, transition: transition)
                }
                else if nodesArray.first?.name == "kiki" {
                    let transition = SKTransition.fade(withDuration: 0.5)
                    let gameScene = GameScene(fileNamed: "GameScene")!
                    gameScene.char = "kiki"
                    //                gameScene.position = CGPoint(x: 320, y: 0)
                    self.view?.presentScene(gameScene, transition: transition)
                }
                else if nodesArray.first?.name == "haku" {
                    let transition = SKTransition.fade(withDuration: 0.5)
                    let gameScene = GameScene(fileNamed: "GameScene")!
                    gameScene.char = "haku"
                    //                gameScene.position = CGPoint(x: 320, y: 0)
                    self.view?.presentScene(gameScene, transition: transition)
                }
                
            }
        }

}
