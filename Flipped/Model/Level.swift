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
    
    struct BankGroup : Codable {
        let kind: TileKind
        let amount: Int
    }
    
    let name: String
    let gridSize: Int
    let tiles: [TileGroup]
    let endPoint1: Location
    let endPoint2: Location
    let bank: [BankGroup]
    
    enum CodingKeys : String, CodingKey {
        case name
        case gridSize = "grid_size"
        case tiles
        case endPoint1 = "end_point_1"
        case endPoint2 = "end_point_2"
        case bank
    }
    
    func buildBankDictionary() -> [TileKind:Int]{
        var dict: [TileKind:Int] = [:]
        for group in bank {
            dict[group.kind] = group.amount
        }
        return dict
    }
}
