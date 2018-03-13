//
//  Turn.swift
//  Flipped
//
//  Created by Michael Skiles on 3/6/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import Foundation

/*
 * This struct represents a discrete turn in the game.
 * Turns begin by placing a tile, and end when there are no more tiles to flip.
 * Each intermediate iteration is stored as a StateFrame
 */
struct Turn {
    let tile: Tile
    let location: Coordinate
    var states: [StateFrame] = []
    let boardSnapshot: GameBoard
    
    init(startedBy tile: Tile, at location: Coordinate, on board: GameBoard) {
        self.tile = tile
        self.location = location
        self.boardSnapshot = board
    }
    
    public var description: String {
        var str = "Turn:\n" +
                  "  tile: \(tile.description)\n" +
                  "  location: \(location.description)\n" +
                  "  states:\n"
        for state in states {
            str +=
                  "    \(state.description)"
        }
        return str
    }
}
