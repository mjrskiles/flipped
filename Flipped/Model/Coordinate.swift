//
//  Coordinate.swift
//  Flipped
//
//  Created by Michael Skiles on 3/9/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

struct Coordinate {
    enum Direction {
        case North
        case East
        case South
        case West
    }
    
    static let directions: [Direction] = [.North, .East, .South, .West]
    
    var x: Int
    var y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    var description: String { return "(\(x), \(y))"}
    
    func isValidIndex(x: Int, y: Int, arraySize: Int) -> Bool {
        let xValid = x >= 0 && x < arraySize
        let yValid = y >= 0 && y < arraySize
        return xValid && yValid
    }
    
    func neighbor(to direction: Direction, with gridSize: Int) -> Coordinate? {
        var neighbor: Coordinate?
        switch direction {
        case .North:
            if isValidIndex(x: x, y: (y - 1), arraySize: gridSize) {
                neighbor = Coordinate(x, (y - 1))
            }
        case .East:
            if isValidIndex(x: (x + 1), y: y, arraySize: gridSize) {
                neighbor = Coordinate((x + 1), y)
            }
        case .South:
            if isValidIndex(x: x, y: (y + 1), arraySize: gridSize) {
                neighbor = Coordinate(x, (y + 1))
            }
        case .West:
            if isValidIndex(x: (x - 1), y: y, arraySize: gridSize) {
                neighbor = Coordinate((x - 1), y)
            }
        }
        
        return neighbor
    }
    

}
