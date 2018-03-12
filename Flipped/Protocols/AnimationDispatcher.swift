//
//  File.swift
//  Flipped
//
//  Created by Michael Skiles on 3/11/18.
//  Copyright © 2018 Michael Skiles. All rights reserved.
//

import Foundation

protocol AnimationDispatcher {
    var animationListener: ([Drawable]) -> Void { get set }
    var completionListener: () -> Void { get set }
}
