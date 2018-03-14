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
    var bankTiles: [BankTileDescription] = []
    
    //Touch related fields
    var first: CGPoint = CGPoint.zero
    var last : CGPoint = CGPoint.zero
    var touchListener: ((CGPoint, CGPoint) -> (Void))!
    
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
                context.fill(tile.rect)
                context.stroke(tile.rect)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            first = touch.location(in: self)
            last = first
            setNeedsDisplay()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            last = touch.location(in: self)
            setNeedsDisplay()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            last = touch.location(in: self)
            touchListener(first, last)
            setNeedsDisplay()
        }
    }
    
    
}
