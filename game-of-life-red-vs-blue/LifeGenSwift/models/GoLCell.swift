//  GOLGOLCell.swift
//  LifeGenSwift
//
//  Created by Gregory D. Stula on 8/30/15.
//  Copyright (c) 2015 Gregory D. Stula. All rights reserved.
//

import UIKit
import LiteMatrix

final class GOLCell: NSObject {

    var isAlive:Bool = false
    var coordinates = (row:0, col:0)
    var numberOfNeighbors = 0
    
    var nextAction = Action.Idle


    enum Action {
        case Idle
        case Spawn
        case Die
    }
    
    // MARK: Color Properties
    var redNeighbors = 0
    var blueNeighbors = 0
    var spawnColor = CellColor.dead

    enum CellColor {
        case blue
        case red
        case dead
    }
    
    
    func resetNeighborColorCount()
    {
        redNeighbors = 0
        blueNeighbors = 0
    }
}

// Overloading the == operator as per the Equatable protocol
func ==(lhs: GOLCell, rhs: GOLCell) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}
