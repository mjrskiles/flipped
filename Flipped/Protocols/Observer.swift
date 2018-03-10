//
//  Observer.swift
//  Flipped
//
//  Created by Michael Skiles on 3/6/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import Foundation

protocol Observer : AnyObject {
    func update()
}

//Inheriting from AnyObject allows comparison for reference equality (===)
//When deciding what type of collection to use as a list of Observers in the Observable
//protocol, I needed to decide between Array and Set.
//A set would be ideal, but then I would need to implement the Hashable protocol on Observers.
//Checking for reference equality is useful in the removeObserver method in Observable.
