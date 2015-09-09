//
//  Cell.swift
//  LifeGenSwift
//
//  Created by Gregory D. Stula on 9/9/15.
//  Copyright (c) 2015 Gregory D. Stula. All rights reserved.
//

import UIKit

// Abstract
class Cell: NSObject, Equatable {

     enum Action {
        case Idle
        case Spawn
        case Die
    }
    
    weak var currentGrid:GoLGrid?
    var isAlive:Bool = false
    var coordinates = (row:0, col:0)
    var numberOfNeighbors = 0
    
    var nextAction = Action.Idle
    
    required convenience init(grid:GoLGrid?) {
        self.init()
        currentGrid = grid
    }
    
    func calculateNextAction() {}
    func executeNextAction() {}
}


// Overloading the == operator as per the Equatable protocol
func ==(lhs: Cell, rhs: Cell) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}
