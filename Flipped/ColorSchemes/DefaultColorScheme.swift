//
//  DefaultColorScheme.swift
//  Flipped
//
//  Created by Michael Skiles on 3/3/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import Foundation
import UIKit

struct DefaultColorScheme : ColorScheme {
    var tileColors: [TileKind : UIColor] = [
        TileKind.Color_A : UIColor(hue: 0.975, saturation: 0.73, brightness: 0.86, alpha: 1.0), //pink
        TileKind.Color_B : UIColor(hue: 0.758, saturation: 0.51, brightness: 0.41, alpha: 1.0), //purple
        TileKind.Blocker : UIColor.darkGray,
        TileKind.Empty   : UIColor.white
    ]
    
    var highlightColor: UIColor = UIColor.orange
}
