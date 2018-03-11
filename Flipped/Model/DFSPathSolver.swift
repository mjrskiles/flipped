//
//  DFSPathSolver.swift
//  Flipped
//
//  Created by Michael Skiles on 3/11/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import Foundation

/*
 * I chose to implement the solver first as a DFS algorithm under the assumption that the most
 * common scenario will involve a single path between endpoints.
 */

class DFSPathSolver : PathSolver {

    //Returns true if there is a path of the same color between the two endpoints on the game board.
    func checkForConnectedPath(on board: GameBoard) -> Bool {
        let p1 = board.endPoint1
        let p2 = board.endPoint2
        let connected = DFS(p1, p2, board)
        return connected
    }
    
    //This algorithm treats tiles of the same color as vertices in a graph and
    //returns true if there is a path from start to target.
    private func DFS(_ start: Coordinate, _ target: Coordinate, _ board: GameBoard) -> Bool {
        var toCheck: [Coordinate] = []
        var visited: [Coordinate] = []
        toCheck.append(start)
        
        while !toCheck.isEmpty {
            let v = toCheck.removeLast()
            if !visited.contains(v) {
                visited.append(v)
                
                //Add any neighbors of the same color to the stack to check.
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
