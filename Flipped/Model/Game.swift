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
    
    var won: Bool = false
    let gameBoard: GameBoard
    var pathSolver: PathSolver
    var tileBank: [TileKind:Int] = [:]
    var turnQueue: [Turn] = []
    var undoStack: [Turn] = []
    
    init(levelName: String) {
        self.name = levelName
        observers = []
        level = LevelBuilder.parseLevel(name: levelName)
//        LevelBuilder.printLevel(level)
        gameBoard = GameBoard(from: level)
        pathSolver = DFSPathSolver()
        tileBank = level.buildBankDictionary()
    }
    
    //Attempts to place a tile on the board at the specified location.
    //Returns true if the tile was accepted.
    func acceptTile(kind: TileKind, at location: Coordinate) -> Bool {
        if !tileLimitIsReached(for: kind) && gameBoard.isOpenSpace(location) {
            let newTile = Tile(kind: kind, moveable: true)
            gameBoard.setTile(newTile, x: location.x, y: location.y)
            
            //Store the turn to animate and maintain game state
            let turn = solveTurn(startedBy: newTile, at: location)
            turnQueue.append(turn)
            undoStack.append(turn)
            
            //Subtract from the tile counter
            if tileBank[newTile.kind] != nil {
                tileBank[newTile.kind]! -= 1
            }
            
            //Check if this turn completes the level.
            won = pathSolver.checkForConnectedPath(on: gameBoard)
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
    
    //returns true if the tile limit has been reached for the specified tile kind
    func tileLimitIsReached(for kind: TileKind) -> Bool {
        if Settings.theInstance.infiniteTiles {
            return false
        }
        else {
            return remainingBankAmount(for: kind) <= 0
        }
    }
    
    func remainingBankAmount(for kind: TileKind) -> Int {
        return tileBank[kind] ?? 0
    }
    
    // Iterates the game board after a tile is placed.
    // Returns a Turn object, which is a bundle of the intermediate board states.
    func solveTurn(startedBy tile: Tile, at location: Coordinate) -> Turn {
        //Instantiate a Turn and add the user-placed tile as the first state transition.
        var turn = Turn(startedBy: tile, at: location, on: gameBoard.copy())
        var initialState = StateFrame()
        initialState.transitions.append(StateFrame.Transition(at: location, from: Tile(kind: .Empty, moveable: false), to: tile))
        turn.states.append(initialState)
        
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
//        print(turn.description)
        return turn
    }
    
    func undoTurn() {
        if !undoStack.isEmpty {
            let lastTurn = undoStack.removeLast()
            for state in lastTurn.states {
                for transition in state.transitions {
                    gameBoard.setTile(transition.old, location: transition.location)
                }
            }
            tileBank[lastTurn.tile.kind]! += 1
            gameBoard.setTile(Tile(kind: .Empty, moveable: false), location: lastTurn.location)
            notify()
        }
    }
    
    func dequeueTurn() -> Turn? {
        var turn: Turn?
        
        if !turnQueue.isEmpty {
            turn = turnQueue.remove(at: 0)
        }
        return turn
    }
    
    // Observable protocol methods
    
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
