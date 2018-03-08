//
//  GameBoard.swift
//  Flipped
//
//  Created by Michael Skiles on 3/1/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import Foundation

class GameBoard {
    var gridSize: Int
    var board: [[Tile]]
    var endPoint1: (Int, Int)
    var endPoint2: (Int, Int)

    init(from level: Level) {
        gridSize = level.gridSize
        board = []
        for _ in 0..<gridSize {
            var temp: [Tile] = []
            for _ in 0..<gridSize {
                temp.append(Tile(kind: .Empty, moveable: false))
            }
            board.append(temp)
        }
        
        //extract the tiles
        let tileGroups = level.tiles
        for group in tileGroups {
            let kind = group.kind
            for loc in group.locations {
                let tile = Tile(kind: kind, moveable: false)
                board[loc.x][loc.y] = tile
            }
        }
        
        endPoint1 = (level.endPoint1.x, level.endPoint2.y)
        endPoint2 = (level.endPoint2.x, level.endPoint2.y)
    }
    
    func setTile(tile: Tile, x: Int, y: Int) {
        board[x][y] = tile
    }
    
    func isEndPoint(_ location: (Int, Int)) -> Bool {
        if location == (endPoint1) || location == (endPoint2) {
            return true
        }
        else {
            return false
        }
    }
}
