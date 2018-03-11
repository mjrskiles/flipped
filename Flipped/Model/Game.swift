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
    var pathSolver: PathSolver
    var turnQueue: [Turn] = []
    
    init(name: String) {
        self.name = name
        observers = []
        level = LevelBuilder.parseLevel(name: name)
        LevelBuilder.printLevel(level)
        gameBoard = GameBoard(from: level)
        pathSolver = DFSPathSolver()
    }
    
    //Attempts to place a tile on the board at the specified location.
    //Returns true if the tile was accepted.
    func acceptTile(kind: TileKind, at location: Coordinate) -> Bool {
        if gameBoard.isOpenSpace(location) {
            let newTile = Tile(kind: kind, moveable: true)
            gameBoard.setTile(newTile, x: location.x, y: location.y)
            
            //Store the turn to animate and maintain game state
            let turn = solveTurn(startedBy: newTile, at: location)
            turnQueue.append(turn)
            
            //Check if this turn completes the level.
            let won = pathSolver.checkForConnectedPath(on: gameBoard)
            if won {
                print("Level complete!!")
            }
            
            notify()
            return true
        }
        else {
            return false
        }
    }
    
    // Iterates the game board after a tile is placed.
    // Returns a Turn object, which is a bundle of the intermediate board states.
    func solveTurn(startedBy tile: Tile, at location: Coordinate) -> Turn {
        var turn = Turn(startedBy: tile, at: location)
        var modifiedEnteringThisFrame: [(Tile, Coordinate)] = [(tile, location)]
        var modifiedDuringThisFrame: [(Tile, Coordinate)] = []
        
        //Continue until there are no changes during the last iteration
        while !modifiedEnteringThisFrame.isEmpty {
            var nextState = StateFrame()
            
            for (currentTile, currentLocation) in modifiedEnteringThisFrame {
                //Check the tiles touching current tile
                for direction in Coordinate.directions {
                    if let neighbor = currentLocation.neighbor(to: direction, with: gameBoard.gridSize) {
                        let oldTile = gameBoard.getTile(x: neighbor.x, y: neighbor.y)
                        if currentTile.shouldFlip(oldTile) {
                            let newTile = Tile(kind: currentTile.kind, moveable: false)
                            gameBoard.setTile(newTile, x: neighbor.x, y: neighbor.y)
                            let transition = StateFrame.Transition(at: neighbor, from: oldTile, to: newTile)
                            nextState.transitions.append(transition)
                            modifiedDuringThisFrame.append((newTile, neighbor))
                        }
                    }
                }
            }
            
            modifiedEnteringThisFrame = modifiedDuringThisFrame
            modifiedDuringThisFrame = []
            turn.states.append(nextState)
        }
        print(turn.description)
        return turn
    }
    
    func undoTurn() {
        if !turnQueue.isEmpty {
            let lastTurn = turnQueue.removeLast()
            for state in lastTurn.states {
                for transition in state.transitions {
                    gameBoard.setTile(transition.old, location: transition.location)
                }
            }
            gameBoard.setTile(Tile(kind: .Empty, moveable: false), location: lastTurn.location)
            notify()
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
