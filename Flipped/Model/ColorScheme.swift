//
//  ColorScheme.swift
//  Flipped
//
//  Created by Michael Skiles on 3/3/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import Foundation
import UIKit

protocol ColorScheme {
    var tileColors : [ TileKind: UIColor ] { get }
}
