//
//  DFSPathSolver.swift
//  Flipped
//
//  Created by Michael Skiles on 3/11/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import Foundation

class DFSPathSolver : PathSolver {
    func checkForConnectedPath(from p1: Coordinate, to p2: Coordinate, on board: GameBoard) -> Bool {
        let connected = DFS(p1, p2, board)
        return connected
    }
    
    private func DFS(_ start: Coordinate, _ target: Coordinate, _ board: GameBoard) -> Bool {
        var toCheck: [Coordinate] = []
        var visited: [Coordinate] = []
        toCheck.append(start)
        
        while !toCheck.isEmpty {
            let v = toCheck.removeLast()
            if !visited.contains(v) {
                visited.append(v)
                for direction in Coordinate.directions {
                    if let neighbor = v.neighbor(to: direction, with: board.gridSize) {
                        if board.getTile(at: neighbor).kind == board.getTile(at: v).kind {
                            if neighbor == target {
                                visited.append(neighbor)
                                printConnected(visited)
                                return true
                            }
                            toCheck.append(neighbor)
                        }
                    }
                }
            }
        }
        printConnected(visited)
        return false
    }
    
    func printConnected(_ visited: [Coordinate]) {
        var path = "Found connected component: "
        for c in visited {
            path += "\(c.description) "
        }
        print(path)
    }
}
