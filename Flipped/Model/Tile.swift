//
//  Tile.swift
//  Flipped
//
//  Created by Michael Skiles on 3/1/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import Foundation

class Tile {
    var kind: TileKind
    var moveable: Bool
    
    init(kind: TileKind, moveable: Bool) {
        self.kind = kind
        self.moveable = moveable
    }
    
    func shouldFlip(_ tile: Tile) -> Bool {
        if (kind == .Color_A && tile.kind == .Color_B) ||
           (kind == .Color_B && tile.kind == .Color_A) {
            return true
        }
        return false
    }
    
    var description: String {
        return String(describing: kind)
    }
}
