//
//  Settings.swift
//  Flipped
//
//  Created by Michael Skiles on 3/9/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import Foundation

// Settings is a singleton class
class Settings {
    static let theInstance = Settings()
    
    var colorScheme: ColorScheme
    var infiniteTiles: Bool
    
    private init() {
        colorScheme = DefaultColorScheme()
        infiniteTiles = false
    }
}
