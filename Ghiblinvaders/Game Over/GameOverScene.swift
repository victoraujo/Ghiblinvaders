//
//  GameOverScene.swift
//  Ghiblinvaders
//
//  Created by Victor Vieira on 03/09/20.
//  Copyright © 2020 Victor Vieira. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {

    var gameOverLabel: SKLabelNode!
    var score:Int = 0
    var scoreLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        gameOverLabel = self.childNode(withName: "gameOver") as! SKLabelNode
        scoreLabel = self.childNode(withName: "score") as! SKLabelNode
        
        scoreLabel.text = "Score: \(score)"
        
        
        
        
    }
    
    
}
