//
//  GameView.swift
//  Flipped
//
//  Created by Michael Skiles on 3/3/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import UIKit

class GameView: UIView {
    var gameFrame: [Drawable]?
    
    override func draw(_ rect: CGRect) {
        let width: CGFloat = self.bounds.size.width
        let height: CGFloat = self.bounds.size.height
//        let colors: ColorScheme = DefaultColorScheme()
        let gridSize = 9
        let tileSize = width / CGFloat(gridSize)
        
        
        
        if let context = UIGraphicsGetCurrentContext() {
            let grid: Drawable = Drawable() { context in
                if let context = UIGraphicsGetCurrentContext() {
                    for i in 0...gridSize {
                        let offset = (tileSize * CGFloat(i))
                        //draw horizontal lines
                        context.move(to: CGPoint(x: 0, y: offset))
                        context.addLine(to: CGPoint(x: width, y: offset))
                        context.strokePath()
                        //draw vertical
                        context.move(to: CGPoint(x: offset, y: 0))
                        context.addLine(to: CGPoint(x: offset, y: width))
                        context.strokePath()
                    }
                }
            }
            grid.draw(context)
            if let rs = gameFrame {
                for d in rs {
                    d.draw(context)
                }
            }

            // Drawing text
            let widthText = "w: \(width)"
            let heightText = "h: \(height)"
            
            let textAttr : [NSAttributedStringKey : Any] = [
                .foregroundColor : UIColor.magenta,
                .font : UIFont.systemFont(ofSize: 16)
            ]
            widthText.draw(at: CGPoint(x: 20, y: 20), withAttributes: textAttr)
            heightText.draw(at: CGPoint(x: 20, y: 40), withAttributes: textAttr)
        }
    }
}
