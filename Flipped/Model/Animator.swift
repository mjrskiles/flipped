//
//  Animator.swift
//  Flipped
//
//  Created by Michael Skiles on 3/6/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import Foundation
import UIKit

class Animator : AnimationDispatcher {
    var viewSize: CGSize
    var gridOffset: CGFloat
    var tileSize: CGFloat
    var gridSize: Int
    let gameBoard: GameBoard
    
    let strokeWidth = 2
    var grid: Drawable!
    
    var animationListener: ([Drawable]) -> Void
    var completionListener: () -> Void
    let animationDelay: Double = 1
    var isAnimating: Bool = false
    
    init(forBoard board: GameBoard, forViewSize viewSize: CGSize) {
        self.viewSize = viewSize
        gameBoard = board
        self.gridSize = board.gridSize
        tileSize = viewSize.width / CGFloat(gridSize)
        gridOffset = (viewSize.height - viewSize.width) / 2
        animationListener = { drawables in print("Animation listener: someone tried to call me without setting me first. Forshame!") }
        completionListener = { print("Completion listener: haven't you learned to set your callbacks by now?") }
    }
    
    func drawBoard(from gameBoard: GameBoard) -> [Drawable] {
        var frames: [Drawable] = []
        var ends: [Drawable] = [] //Store the end points separately so they're drawn last.
        let board = gameBoard //This class should never mutate the gameBoard
        let colorScheme = Settings.theInstance.colorScheme
        
        //Add the grid
        if grid == nil {
            grid = describeGrid()
        }
        frames.append(grid)
        
        for i in 0..<board.board.count {
            for j in 0..<board.board[i].count {
                //Make calculations outside the closure so unnecessary calculations aren't performed during rendering
                let isEndPoint = board.isEndPoint(Coordinate(i,j))
                let strokeColor = isEndPoint ? colorScheme.highlightColor.cgColor : UIColor.lightGray.cgColor
                let borderWidth = isEndPoint ? CGFloat(strokeWidth * 3) : CGFloat(strokeWidth)
                let tile: Tile = board.board[i][j]
                let xLoc = tileSize * CGFloat(i)
                let yLoc = tileSize * CGFloat(j) + gridOffset
           
                //Generate the closure that describes how to draw this tile
                let item = Drawable() { context in
                    context.setStrokeColor(strokeColor)
                    let fillColor = colorScheme.tileColors[tile.kind]?.cgColor
                    context.setLineWidth(borderWidth)
                    context.setFillColor(fillColor!)
                    let tileRect = CGRect(x: xLoc, y: yLoc, width: self.tileSize, height: self.tileSize)
                    context.fill(tileRect)
                    context.stroke(tileRect)
                    
                    //Draw an X for a blocker
                    if tile.kind == .Blocker {
                        context.setStrokeColor(UIColor.lightGray.cgColor)
                        
                        context.move(to: CGPoint(x: xLoc, y: yLoc))
                        context.addLine(to: CGPoint(x: (xLoc + self.tileSize), y: (yLoc + self.tileSize)))
                        context.strokePath()
                        
                        context.move(to: CGPoint(x: xLoc, y: (yLoc + self.tileSize)))
                        context.addLine(to: CGPoint(x: (xLoc + self.tileSize), y: yLoc))
                        context.strokePath()
                    }
                }
                isEndPoint ? ends.append(item) : frames.append(item)
            }
        }
        frames.append(contentsOf: ends)
        return frames
    }
    
    func animateTurn(_ turn: Turn) {
        isAnimating = true
        animateTurn(withStateIndex: 0, in: turn)
    }
    
    func animateTurn(withStateIndex index: Int, in turn: Turn) {
        if index < turn.states.count {
            let delay = (index == 0) ? 0.0 : animationDelay
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + delay) {
                let colorScheme = Settings.theInstance.colorScheme
                var intermediate = self.drawBoard(from: turn.boardSnapshot)
                //Draw the new tiles on top of the old board
                for i in 0...index {
                    let state = turn.states[i]
                    for transition in state.transitions {
                        let tile = transition.new
                        let x = transition.location.x
                        let y = transition.location.y
                        
                        let item = self.describeTile(tile, x, y, on: turn.boardSnapshot, with: colorScheme)
                        intermediate.append(item)
                    }
                }
                DispatchQueue.main.async {
                    self.animationListener(intermediate)
                }
                self.animateTurn(withStateIndex: (index + 1), in: turn)
            }
        }
        else {
            DispatchQueue.main.async {
                self.isAnimating = false;
                self.completionListener()
            }
        }
    }
    
    func describeTile(_ tile: Tile, _ x: Int, _ y: Int, on board: GameBoard, with colorScheme: ColorScheme) -> Drawable {
        let isEndPoint = self.gameBoard.isEndPoint(Coordinate(x,y))
        let strokeColor = isEndPoint ? colorScheme.highlightColor.cgColor : UIColor.lightGray.cgColor
        let fillColor = colorScheme.tileColors[tile.kind]?.cgColor
        let strokeWidth = isEndPoint ? CGFloat(self.strokeWidth * 3) : CGFloat(self.strokeWidth)
        let xLoc = tileSize * CGFloat(x)
        let yLoc = tileSize * CGFloat(y) + gridOffset
        
        let item = Drawable() { context in
            context.setStrokeColor(strokeColor)
            context.setLineWidth(strokeWidth)
            context.setFillColor(fillColor!)
            let tileRect = CGRect(x: xLoc, y: yLoc, width: self.tileSize, height: self.tileSize)
            context.fill(tileRect)
            context.stroke(tileRect)
        }
        
        return item
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
