//  GoLGoLCell.swift
//  LifeGenSwift
//
//  Created by Gregory D. Stula on 8/30/15.
//  Copyright (c) 2015 Gregory D. Stula. All rights reserved.
//

import UIKit

final class GoLCell: NSObject {

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

    enum CellColor {
        case blue
        case red
    }

    var currentColor = CellColor.blue

    var spawnColor:UIColor {
        return self.currentColor == CellColor.blue ? UIColor.blueColor() : UIColor.redColor()
    }
}

// Overloading the == operator as per the Equatable protocol
func ==(lhs: GoLCell, rhs: GoLCell) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}
