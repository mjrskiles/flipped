//
//  GameView.swift
//  Flipped
//
//  Created by Michael Skiles on 3/3/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import UIKit

class GameView: UIView {
    var observers: [Observer] = []
    var gameFrame: [Drawable] = []
    let gridSize = 9
    
    //Touch related fields
    var first: CGPoint = CGPoint.zero
    var last : CGPoint = CGPoint.zero
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            for item in gameFrame {
                item.draw(context)
            }

            // Drawing text
            let text1 = "Touch Started: \(first.x), \(first.y)"
            let text2 = "Dragged to: \(last.x), \(last.y)"
            
            let textAttr : [NSAttributedStringKey : Any] = [
                .foregroundColor : UIColor.magenta,
                .font : UIFont.systemFont(ofSize: 16)
            ]
            let textY = CGFloat(40)
            text1.draw(at: CGPoint(x: 20, y: textY), withAttributes: textAttr)
            text2.draw(at: CGPoint(x: 20, y: textY + 20), withAttributes: textAttr)
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
            setNeedsDisplay()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}
