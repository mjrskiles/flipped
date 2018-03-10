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
    var turnQueue: [Turn] = []
    
    init(name: String) {
        self.name = name
        observers = []
        level = LevelBuilder.parseLevel(name: name)
        LevelBuilder.printLevel(level)
        gameBoard = GameBoard(from: level)
    }
    
    func acceptTile(kind: TileKind, at location: Coordinate) -> Bool {
        if gameBoard.isOpenSpace(location) {
            let newTile = Tile(kind: kind, moveable: true)
            gameBoard.setTile(newTile, x: location.x, y: location.y)
            let turn = solveTurn(startedBy: newTile, at: location)
            turnQueue.append(turn)
            notify()
            return true
        }
        else {
            return false
        }
    }
    
    func solveTurn(startedBy tile: Tile, at location: Coordinate) -> Turn {
        var turn = Turn(startedBy: tile, at: location)
        
        var nextState = StateFrame()
        for direction in Coordinate.directions {
            if let neighbor = location.neighbor(to: direction, with: gameBoard.gridSize) {
                let oldTile = gameBoard.getTile(x: neighbor.x, y: neighbor.y)
                if tile.shouldFlip(oldTile) {
                    let newTile = Tile(kind: tile.kind, moveable: false)
                    gameBoard.setTile(newTile, x: neighbor.x, y: neighbor.y)
                    let transition = StateFrame.Transition(at: neighbor, from: oldTile, to: newTile)
                    nextState.transitions.append(transition)
                }
            }
        }
        
        turn.states.append(nextState)
        return turn
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
