//
//  LevelBuilder.swift
//  Flipped
//
//  Created by Michael Skiles on 3/4/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import Foundation

class LevelBuilder {
    private init() { }
    
    static let levelList = LevelList(worlds: [
        LevelList.World(title: "World 1", levels: [
            "1-1",
            "1-2"])
        ])
    
    static func parseLevel(name: String) -> Level {
        let url = Bundle.main.url(forResource: name, withExtension: "plist")!
        let data = try! Data(contentsOf: url)
        let decoder = PropertyListDecoder()
        return try! decoder.decode(Level.self, from: data)
    }
    
    static func printLevel(_ level: Level) {
        var str = "Level:\n"
                + "  name: \(level.name)\n"
                + "  grid_size: \(level.gridSize)\n"
                + "  tiles:\n"
                + "  [\n"
        for i in 0..<level.tiles.count {
            str +=
                  "    {\n"
                + "      kind: \(level.tiles[i].kind)\n"
                + "      locations:\n"
                + "      [\n"
            for j in 0..<level.tiles[i].locations.count {
                str +=
                  "        \(level.tiles[i].locations[j].x), \(level.tiles[i].locations[j].y)\n"
            }
            str +=
                  "      ]\n"
                + "    }\n"
        }
        str +=    "  ]\n"
            +     "  end_point_1: \(level.endPoint1.x), \(level.endPoint1.y)\n"
            +     "  end_point_2: \(level.endPoint2.x), \(level.endPoint2.y)\n"
        print(str)
    }
    
    struct LevelList {
        var worlds: [World]
        
        struct World {
            var title: String
            var levels: [String]
        }
    }
}
