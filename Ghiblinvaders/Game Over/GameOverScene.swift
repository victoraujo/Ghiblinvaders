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
    var filmLabel: SKLabelNode!
    var directorLabel: SKLabelNode!
    var dateLabel: SKLabelNode!
    var films: [Film] = []
    var char: String = ""
    var filmName: String = ""
    var selectedFilm: Film!
    var background: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        background = SKSpriteNode(imageNamed: "back2")
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -1
        self.addChild(background)
        gameOverLabel = self.childNode(withName: "gameOver") as! SKLabelNode
        scoreLabel = self.childNode(withName: "score") as! SKLabelNode
        filmLabel = self.childNode(withName: "filmLabel") as! SKLabelNode
        directorLabel = self.childNode(withName: "directorLabel") as! SKLabelNode
        dateLabel = self.childNode(withName: "dateLabel") as! SKLabelNode
        
        scoreLabel.text = "Score: \(score)"
        filmLabel.text = "Filme"
        directorLabel.text = "Diretor"
        dateLabel.text = "Data"
        
        if char == "kiki"{
            filmName = "Kiki's Delivery Service"
        }
        
        else if char == "totoro"{
                   filmName = "My Neighbor Totoro"
               }
        
        else if char == "haku"{
            filmName = "Spirited Away"
        }
        
        self.load()
            
        gameOverLabel.run(SKAction.move(to: CGPoint(x: 0, y: self.frame.size.height/2 + 430), duration: TimeInterval(10)))
        scoreLabel.run(SKAction.move(to: CGPoint(x: 0, y: self.frame.size.height/2 + 350), duration: TimeInterval(10)))
        filmLabel.run(SKAction.move(to: CGPoint(x: 0, y: self.frame.size.height/2 + 270), duration: TimeInterval(10)))
        directorLabel.run(SKAction.move(to: CGPoint(x: 0, y: self.frame.size.height/2 + 190), duration: TimeInterval(10)))
        dateLabel.run(SKAction.move(to: CGPoint(x: 0, y: self.frame.size.height/2 + 110), duration: TimeInterval(10)))
        
        
    }
    func load() {
        // TODO: Carregar dados do webservice
        let stringURL = "https://ghibliapi.herokuapp.com/films"
        let url = URL(string: stringURL)!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            do{
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Film].self, from: data!)
                self.films = jsonData
                print(self.films.count)
                
                for film in self.films{
                    if film.title == self.filmName{
                        self.selectedFilm = film
                    }
                }
                
                DispatchQueue.main.async {
                    
                    self.filmLabel.text = self.selectedFilm.title
                    self.directorLabel.text = self.selectedFilm.director
                    self.dateLabel.text = self.selectedFilm.releaseDate
                    
                    //self.label!.text = String(self.films[3].title)
                }
            } catch{
                print("JSON error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    
                }
            }
            
        }
        task.resume()
        
        
    }
    
    
    
    
}

struct Film: Decodable {
    // TODO: quais são as propriedades de Film?
    let id, title, filmDescription, director: String
    let producer, releaseDate, rtScore: String
    let people, species, locations, vehicles: [String]
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case filmDescription = "description"
        case director, producer
        case releaseDate = "release_date"
        case rtScore = "rt_score"
        case people, species, locations, vehicles, url
    }
}
