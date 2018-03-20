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
    //constants
    let animationDelay: Double = 0.3
    
    //view size dependent vars
    var viewSize: CGSize
    var tileBankWidth: CGFloat
    var tileBankHeight: CGFloat
    var tileBankPosition: CGPoint
    var strokeWidth = 2
    var gridOffset: CGFloat
    var tileSize: CGFloat
    
    var gridSize: Int
    let gameBoard: GameBoard
    
    var grid: Drawable!
    
    var animationListener: ([Drawable]) -> Void
    var completionListener: () -> Void
    var isAnimating: Bool = false
    
    init(forBoard board: GameBoard, forViewSize viewSize: CGSize) {
        self.viewSize = viewSize
        gameBoard = board
        self.gridSize = board.gridSize
        tileSize = viewSize.width / CGFloat(gridSize)
        gridOffset = (viewSize.height - viewSize.width) / 2
        tileBankWidth = tileSize * 4
        tileBankHeight = tileSize * 2
        tileBankPosition = CGPoint(x: (viewSize.width - tileBankWidth) / 2, y: gridOffset - tileBankHeight - 10)

        
        // Callbacks to be set after init
        animationListener = { drawables in print("Animation listener: someone tried to call me without setting me first. Forshame!") }
        completionListener = { print("Completion listener: haven't you learned to set your callbacks by now?") }
    }
    
    func viewSizeDidChange(to newSize: CGSize) {
        updateViewSizeDependents(with: newSize)
    }
    
    func updateViewSizeDependents(with newSize: CGSize) {
        viewSize = newSize
        tileSize = viewSize.width / CGFloat(gridSize)
        gridOffset = (viewSize.height - viewSize.width) / 2
        tileBankWidth = tileSize * 4
        tileBankHeight = tileSize * 2
        tileBankPosition = CGPoint(x: (viewSize.width - tileBankWidth) / 2, y: gridOffset - tileBankHeight - 10)
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
    
    // Animates a turn by asynchronously dispatching the next state frame to be drawn after the frame delay
    // And calling itself recursively until there are no more states to draw.
    func animateTurn(withStateIndex index: Int, in turn: Turn) {
        if index < turn.states.count {
            let delay = (index == 0) ? 0.0 : animationDelay
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + delay) {
                var intermediate = self.drawBoard(from: turn.boardSnapshot)
                //Draw the new tiles on top of the old board
                for i in 0...index {
                    let state = turn.states[i]
                    for transition in state.transitions {
                        let tile = transition.new
                        let x = transition.location.x
                        let y = transition.location.y
                        
                        let item = self.describeTile(tile, x, y, on: turn.boardSnapshot)
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
    
    func describeTile(_ tile: Tile, _ x: Int, _ y: Int, on board: GameBoard) -> Drawable {
        let colorScheme = Settings.theInstance.colorScheme
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
    
    
    //This function returns a Drawable that draws the dashed outline of the tile bank
    func describeTileBank() -> Drawable {
        let bank: Drawable = Drawable() { context in
            if let context = UIGraphicsGetCurrentContext() {
                // dashed lines
                let shortDash : [CGFloat] = [ 4, 4 ]
                context.setLineDash(phase: 0, lengths: shortDash)
                context.setStrokeColor(UIColor.darkGray.cgColor)
                context.setLineWidth(4)
                
                let rect = CGRect(origin: self.tileBankPosition, size: CGSize(width: self.tileBankWidth, height: self.tileBankHeight))
                let clipPath: CGPath = UIBezierPath(roundedRect: rect, cornerRadius: 10).cgPath
                
                context.addPath(clipPath)
                context.closePath()
                context.strokePath()

                context.setLineDash(phase: 0, lengths: [])
            }
        }
        return bank
    }
    
    func getBankTiles() -> [BankTile] {
        // Determine the rectangle sizes and locations
        var tiles: [BankTile] = []
        
        let bankTileY = CGFloat((tileBankPosition.y + (tileBankHeight - tileSize) / 3))
        let aTileX = CGFloat(tileBankPosition.x + (tileBankWidth / 4) - (tileSize / 2))
        let bTileX = CGFloat(aTileX + (tileBankWidth / 2))
        let rectAPoint = CGPoint(x: aTileX, y: bankTileY)
        let rectBPoint = CGPoint(x: bTileX, y: bankTileY)
        let rectSize = CGSize(width: tileSize, height: tileSize)
        
        let rectA = CGRect(origin: rectAPoint, size: rectSize)
        let rectB = CGRect(origin: rectBPoint, size: rectSize)
        
        let labelSize: CGFloat = tileSize / 2.0
        
        let labelOffset = (tileSize / 2) - (labelSize / 3)
        let labelLocationA = CGPoint(x: (aTileX + labelOffset), y: bankTileY + tileSize)
        let labelLocationB = CGPoint(x: (bTileX + labelOffset), y: bankTileY + tileSize)
        
        tiles.append(BankTile(rect: rectA, homeLocation: rectAPoint, labelLocation: labelLocationA, labelSize: labelSize, kind: .Color_A))
        tiles.append(BankTile(rect: rectB, homeLocation: rectBPoint, labelLocation: labelLocationB, labelSize: labelSize, kind: .Color_B))
        return tiles
    }
}
