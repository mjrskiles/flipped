//
//  Game.swift
//  Flipped
//
//  Created by Michael Skiles on 3/4/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import Foundation

class Game : Observable {
    var observers: [Observer]
    
    var level: Level
    let name: String
    let gameBoard: GameBoard
    
    init(name: String) {
        self.name = name
        observers = []
        level = LevelBuilder.parseLevel(name: name)
        LevelBuilder.printLevel(level)
        gameBoard = GameBoard(from: level)
    }
    
    func acceptTile(kind: TileKind, at location: Coordinate) -> Bool {
        if gameBoard.isOpenSpace(location) {
            gameBoard.setTile(Tile(kind: kind, moveable: true), x: location.x, y: location.y)
            return true
        }
        else {
            return false
        }
    }
    
    // Protocol methods
    
    func notify() {
        for obs in observers {
            obs.update()
        }
    }
    
    func addObserver(_ obs: Observer) {
        observers.append(obs)
    }
    
    func removeObserver(_ obs: Observer) {
        var i = 0
        while i < observers.count {
            if observers[i] === obs {
                observers.remove(at: i)
            }
            i += 1
        }
    }
    
}
