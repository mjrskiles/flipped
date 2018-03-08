//
//  Level.swift
//  Flipped
//
//  Created by Michael Skiles on 3/4/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import Foundation

struct Level : Codable {
    struct Location : Codable {
        let x: Int
        let y: Int
    }
    
    struct TileGroup : Codable {
        let kind: TileKind
        let locations: [Location]
    }
    
    let name: String
    let gridSize: Int
    let tiles: [TileGroup]
    let endPoint1: Location
    let endPoint2: Location
    
    enum CodingKeys : String, CodingKey {
        case name
        case gridSize = "grid_size"
        case tiles
        case endPoint1 = "end_point_1"
        case endPoint2 = "end_point_2"
    }
}
