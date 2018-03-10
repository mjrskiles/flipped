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
    var viewSize: CGSize
    var gridOffset: CGFloat = 0
    var tileSize: CGFloat
    var colorScheme: ColorScheme
    
    var gridSize = 9
    let strokeWidth = 2
    var grid: Drawable!
    
    init(forSize viewSize: CGSize) {
        self.viewSize = viewSize
        tileSize = viewSize.width / CGFloat(gridSize)
        gridOffset = (viewSize.height - viewSize.width) / 2
        colorScheme = DefaultColorScheme()
    }
    
    convenience init(forSize viewSize: CGSize, withColors colorScheme: ColorScheme) {
        self.init(forSize: viewSize)
        self.colorScheme = colorScheme
    }
    
    func drawBoard(from gameBoard: GameBoard, tileSize: CGFloat) -> [Drawable] {
        var frames: [Drawable] = []
        var ends: [Drawable] = [] //Store the end points separately so they're drawn last.
        let board = gameBoard //This class should never mutate the gameBoard
        
        //Add the grid
        if grid == nil {
            grid = describeGrid()
        }
        frames.append(grid)
        
        for i in 0..<board.board.count {
            for j in 0..<board.board[i].count {
                //Make calculations outside the closure so unnecessary calculations aren't performed during rendering
                let isEndPoint = board.isEndPoint((i,j))
                let strokeColor = isEndPoint ? UIColor.orange.cgColor : UIColor.lightGray.cgColor
                let borderWidth = isEndPoint ? CGFloat(strokeWidth * 3) : CGFloat(strokeWidth)
                let tile: Tile = board.board[i][j]
                let xLoc = tileSize * CGFloat(i)
                let yLoc = tileSize * CGFloat(j) + gridOffset
           
                //Generate the closure that describes how to draw this tile
                let item = Drawable() { context in
                    context.setStrokeColor(strokeColor)
                    let fillColor = self.colorScheme.tileColors[tile.kind]?.cgColor
                    context.setLineWidth(borderWidth)
                    context.setFillColor(fillColor!)
                    let tileRect = CGRect(x: xLoc, y: yLoc, width: tileSize, height: tileSize)
                    context.fill(tileRect)
                    context.stroke(tileRect)
                    
                    //Draw an X for a blocker
                    if tile.kind == .Blocker {
                        context.setStrokeColor(UIColor.lightGray.cgColor)
                        
                        context.move(to: CGPoint(x: xLoc, y: yLoc))
                        context.addLine(to: CGPoint(x: (xLoc + tileSize), y: (yLoc + tileSize)))
                        context.strokePath()
                        
                        context.move(to: CGPoint(x: xLoc, y: (yLoc + tileSize)))
                        context.addLine(to: CGPoint(x: (xLoc + tileSize), y: yLoc))
                        context.strokePath()
                    }
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
    
    func describeGrid() -> Drawable {
        let grid: Drawable = Drawable() { context in
            if let context = UIGraphicsGetCurrentContext() {
                for i in 0...self.gridSize {
                    let lineOffset = (self.tileSize * CGFloat(i)) + self.gridOffset
                    //draw horizontal lines
                    context.move(to: CGPoint(x: 0, y: lineOffset))
                    context.addLine(to: CGPoint(x: self.viewSize.width, y: lineOffset))
                    context.strokePath()
                    //draw vertical
                    context.move(to: CGPoint(x: lineOffset, y: self.gridOffset))
                    context.addLine(to: CGPoint(x: lineOffset, y: self.viewSize.width + self.gridOffset))
                    context.strokePath()
                }
            }
        }
        return grid
    }
}
