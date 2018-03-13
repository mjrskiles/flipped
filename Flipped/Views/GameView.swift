//
//  GameView.swift
//  Flipped
//
//  Created by Michael Skiles on 3/3/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import UIKit

class GameView: UIView {
    var display: [Drawable] = []
    var queuedTiles: [Drawable] = []
    
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
            
            // dashed lines
            let shortDash : [CGFloat] = [ 4, 4 ]
            context.setLineDash(phase: 0, lengths: shortDash)
            context.move(to: CGPoint(x: 370, y: 40))
            context.addLine(to: CGPoint(x: 400, y: 500))
            context.strokePath()
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
