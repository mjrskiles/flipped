//
//  BankTile.swift
//  Flipped
//
//  Created by Michael Skiles on 3/13/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import Foundation
import UIKit

struct BankTile {
    var rect: CGRect
    var homeLocation: CGPoint
    var labelLocation: CGPoint
    var labelSize: CGFloat
    var kind: TileKind
    var dragging: Bool
    
    init(rect: CGRect, homeLocation: CGPoint, labelLocation: CGPoint, labelSize: CGFloat, kind: TileKind) {
        self.rect = rect
        self.homeLocation = homeLocation
        self.labelLocation = labelLocation
        self.labelSize = labelSize
        self.kind = kind
        dragging = false
    }
}
