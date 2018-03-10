//
//  StateFrame.swift
//  Flipped
//
//  Created by Michael Skiles on 3/9/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import Foundation

struct StateFrame {
    struct Transition {
        let location: Coordinate
        let old: Tile
        let new: Tile
        
        init(at location: Coordinate, from old: Tile, to new: Tile) {
            self.location = location
            self.old = old
            self.new = new
        }
        
        var description: String {
            return "Transition: at: \(location.description) from: \(old.description) to: \(new.description)"
        }
    }
    
    var transitions: [Transition] = []
    
    var description: String {
        var str = "StateFrame: \n"
        for t in transitions {
            str +=
                  "  \(t.description)\n"
        }
        return str
    }
}
