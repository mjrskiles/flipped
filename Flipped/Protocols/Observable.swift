//
//  Observable.swift
//  Flipped
//
//  Created by Michael Skiles on 3/6/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import Foundation

protocol Observable {
    var observers: [Observer] { get set }
    
    func notify()
    
    func addObserver(_ obs: Observer)
    
    func removeObserver(_ obs: Observer)
}
