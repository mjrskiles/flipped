//
//  ColorBlindFriendlyColorScheme.swift
//  Flipped
//
//  Created by Michael Skiles on 3/10/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import Foundation
import UIKit

struct ColorBlindFriendlyColorScheme : ColorScheme {
    var tileColors: [TileKind : UIColor] = [
        TileKind.Color_A : UIColor(hue: 0.1, saturation: 0.89, brightness: 0.98, alpha: 1.0), //orange
        TileKind.Color_B : UIColor(hue: 0.539, saturation: 0.98, brightness: 0.93, alpha: 1.0), //blue
        TileKind.Blocker : UIColor.darkGray,
        TileKind.Empty   : UIColor.white
    ]
    
    var highlightColor: UIColor = UIColor(hue: 0.889, saturation: 0.90, brightness: 0.96, alpha: 1.0)
}
