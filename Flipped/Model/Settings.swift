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
    
    var infiniteTiles: Bool {
        didSet {
            Settings.saveSettings()
        }
    }
    private var colorBlindMode: Bool {
        didSet {
            Settings.saveSettings()
        }
    }
    var colorScheme: ColorScheme
    
    private init() {
        let savedConfig = Settings.parseSettings()
        colorBlindMode = savedConfig.colorBlindMode
        colorScheme = savedConfig.colorBlindMode ? ColorBlindFriendlyColorScheme() : DefaultColorScheme()
        infiniteTiles = savedConfig.infiniteTileMode
    }
    
    func setColorBlindMode(_ value: Bool) {
        colorBlindMode = value
        colorScheme = colorBlindMode ? ColorBlindFriendlyColorScheme() : DefaultColorScheme()
    }
    
    func getColorBlindMode() -> Bool {
        return colorBlindMode
    }
    
    static func parseSettings() -> AppConfiguration {
        let url = Bundle.main.url(forResource: "settings", withExtension: "plist")!
        let data = try! Data(contentsOf: url)
        let decoder = PropertyListDecoder()
        return try! decoder.decode(AppConfiguration.self, from: data)
    }
    
    static func saveSettings() {
        let appSettings = AppConfiguration(infiniteTileMode: theInstance.infiniteTiles, colorBlindMode: theInstance.colorBlindMode )
        let encoder = PropertyListEncoder()
        guard let data = try? encoder.encode(appSettings) else {
            print("Settings data could not be encoded!")
            return
        }
        
        let url = Bundle.main.url(forResource: "settings", withExtension: "plist")!
        try! data.write(to: url)
    }
    
    struct AppConfiguration : Codable {
        var infiniteTileMode: Bool
        var colorBlindMode: Bool
        
        enum CodingKeys : String, CodingKey {
            case infiniteTileMode = "infinite_tile_mode"
            case colorBlindMode = "color_blind_mode"
        }
    }
}
