//
//  Drawable.swift
//  Flipped
//
//  Created by Michael Skiles on 3/6/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import Foundation
import UIKit

class Drawable {
    /*
     * This var should be bound as a closure describing how to draw something using Core Graphics.
     * It is meant to be called in a UIView derived class to draw something in that view.
     */
    var draw = { (context: CGContext) -> Void in print("I was never assigned a new closure. Shame!") }
    
    init(with description: @escaping (_: CGContext) -> Void) {
        self.draw = description
    }
}
