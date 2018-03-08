//
//  Animator.swift
//  Flipped
//
//  Created by Michael Skiles on 3/6/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import Foundation
import UIKit

class Animator {
    var colorScheme: ColorScheme
    var gridSize = 9
    let strokeWidth = 2
    
    init() {
        colorScheme = DefaultColorScheme()
    }
    
    init(withColors colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
    }
    
    func setColorScheme(to newScheme: ColorScheme) {
        self.colorScheme = newScheme
    }
    
    func drawBoard(from gameBoard: GameBoard, tileSize: CGFloat) -> [Drawable] {
        var frames: [Drawable] = []
        var ends: [Drawable] = [] //Store the end points separately so they're drawn last.
        let board = gameBoard //This class should never mutate the gameBoard
        for i in 0..<board.board.count {
            for j in 0..<board.board[i].count {
                //Make calculations outside the closure so unnecessary calculations aren't performed during rendering
                let isEndPoint = board.isEndPoint((i,j))
                let strokeColor = isEndPoint ? UIColor.orange.cgColor : UIColor.lightGray.cgColor
                let borderWidth = isEndPoint ? CGFloat(strokeWidth * 2) : CGFloat(strokeWidth)
                let tile: Tile = board.board[i][j]
                let xLoc = tileSize * CGFloat(i)
                let yLoc = tileSize * CGFloat(j)
           
                //Generate the closure that describes how to draw this tile
                let item = Drawable() { context in
                    context.setStrokeColor(strokeColor)
                    let fillColor = self.colorScheme.tileColors[tile.kind]?.cgColor
                    context.setLineWidth(borderWidth)
                    context.setFillColor(fillColor!)
                    let tileRect = CGRect(x: xLoc, y: yLoc, width: tileSize, height: tileSize)
                    context.fill(tileRect)
                    context.stroke(tileRect)
                }
                isEndPoint ? ends.append(item) : frames.append(item)
            }
        }
        frames.append(contentsOf: ends)
        return frames
    }
    
    func animateTurn(_ turn: Turn) -> [Drawable] {
        return []
    }
    
    func testAnimation(tileSize: CGFloat) -> [Drawable] {
        var frames: [Drawable] = []
        let test1 = Drawable() { context in
            context.setStrokeColor(UIColor.darkGray.cgColor)
            let color_a = self.colorScheme.tileColors[.Color_A]?.cgColor
            context.setLineWidth(2)
            context.setFillColor(color_a!)
            let tile_a = CGRect(x: tileSize, y: (tileSize * 3), width: tileSize, height: tileSize)
            context.fill(tile_a)
            context.stroke(tile_a)
        }
        
        let test2 = Drawable() { context in
            context.setStrokeColor(UIColor.darkGray.cgColor)
            let color_b = self.colorScheme.tileColors[.Color_B]?.cgColor
            context.setLineWidth(2)
            context.setFillColor(color_b!)
            let tile_b = CGRect(x: (tileSize * 2), y: (tileSize * 4), width: tileSize, height: tileSize)
            context.fill(tile_b)
            context.stroke(tile_b)
        }
        frames.append(test1)
        frames.append(test2)
        return frames
    }
}
