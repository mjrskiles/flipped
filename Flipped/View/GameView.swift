//
//  GameView.swift
//  Flipped
//
//  Created by Michael Skiles on 3/3/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import UIKit

class GameView: UIView {
    var display: [Drawable] = [] // The board state
    var queuedTiles: [Drawable] = [] // Tiles that have been placed but not animated yet
    
    //The bank tiles. These need to be set by the animator via the view controller
    var bankTiles: [BankTile] = []
    var currentlyDragging: BankTile?
    var draggedTileIndex: Int!
    
    //Touch related fields
    var first: CGPoint = CGPoint.zero
    var last : CGPoint = CGPoint.zero
    var touchListener: ((CGPoint, CGPoint, TileKind) -> (Void))!
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            for item in display {
                item.draw(context)
            }
            for tile in queuedTiles {
                tile.draw(context)
            }
            
            //Draw the bank tiles
            context.setStrokeColor(UIColor.lightGray.cgColor)
            context.setLineWidth(2)
            for tile in bankTiles {
                context.setFillColor(Settings.theInstance.colorScheme.tileColors[tile.kind]!.cgColor)
                if tile.dragging {
                    context.setAlpha(0.3)
                }
                context.fill(tile.rect)
                context.stroke(tile.rect)
                context.setAlpha(1.0)
            }
            
            if let tile = currentlyDragging {
                context.setFillColor(Settings.theInstance.colorScheme.tileColors[tile.kind]!.cgColor)
                context.fill(tile.rect)
                context.stroke(tile.rect)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            first = touch.location(in: self)
            last = first
            
            //Check if a tile is being dragged
            for i in 0..<bankTiles.count {
                if bankTiles[i].rect.contains(last) {
                    bankTiles[i].dragging = true
                    currentlyDragging = bankTiles[i]
                    draggedTileIndex = i
                }
            }
            
            setNeedsDisplay()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            last = touch.location(in: self)
            
            if currentlyDragging != nil {
                let halfWidth = currentlyDragging!.rect.size.width / 2
                let offsetX = last.x - halfWidth
                let offsetY = last.y - halfWidth
                currentlyDragging!.rect.origin = CGPoint(x: offsetX, y: offsetY)
            }
            
            setNeedsDisplay()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            last = touch.location(in: self)
            
            if currentlyDragging != nil {
                touchListener(first, last, currentlyDragging!.kind)
                bankTiles[draggedTileIndex].dragging = false
                currentlyDragging = nil
                draggedTileIndex = nil
                setNeedsDisplay()
            }
        }
    }
    
    
}
