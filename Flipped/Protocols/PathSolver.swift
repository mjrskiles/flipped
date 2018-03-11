//
//  PathSolver.swift
//  Flipped
//
//  Created by Michael Skiles on 3/10/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import Foundation

protocol PathSolver {
    func checkForConnectedPath(from p1: Coordinate, to p2: Coordinate, on board: GameBoard) -> Bool
}
