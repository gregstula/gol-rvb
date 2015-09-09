//
//  GoLColorCell.swift
//  LifeGenSwift
//
//  Created by Gregory D. Stula on 9/8/15.
//  Copyright (c) 2015 Gregory D. Stula. All rights reserved.
//

import UIKit

class GoLColorCell: GoLCell {

    // MARK: Color Properties
    private var redNeighbors = 0
    private var blueNeighbors = 0
    
    enum CellColor {
        case blue
        case red
    }

    var currentColor = CellColor.blue
    
    var spawnColor:UIColor {
        return self.currentColor == CellColor.blue ? UIColor.blueColor() : UIColor.redColor()
    }
    
    
    override init() {
        super.init()
    }
    
    
    required convenience init(grid:GoLGrid?) {
        self.init()
        currentGrid = grid
    }

    // MARK: Color Counting
    // Function to count the amount of live neighbors
    override func countNeighbors() {
        // Prevents index out of bounds for special case of row/col = 0.
        if coordinates.row < 1 || coordinates.col < 1 {
            return
            
        // Prevents index out of bounds for special case of *MAX - 1
        } else if coordinates.row > gridRowMax - 2 || coordinates.col > gridColMax - 2 {
            return
        }

        // Normal case
        for rowOffset in (-1...1){
            for colOffset in (-1...1){
                if (rowOffset != 0 || colOffset != 0) &&
                    (neighborAliveAt(rowOffset, colOffset)) {
                    self.countNeighborByColor(rowOffset, colOffset)
                    numberOfNeighbors++
                }
            }
        }
    }
    
   
    internal func countNeighborByColor(rowOffset:Int, _ colOffset:Int) {
        if currentGrid != nil {
            var cell = currentGrid!.cellGrid[coordinates.row + rowOffset, coordinates.col + colOffset] as? GoLColorCell
            
            if cell != nil {
                if cell!.currentColor == CellColor.blue {
                    blueNeighbors++
                } else if cell!.currentColor == CellColor.red {
                    redNeighbors++
                }
            }
        }
    }
    
    
    // MARK: calculateNextAction w.r.t Color
    override func calculateNextAction() {
        self.countNeighbors()
        
        if isAlive {
            switch numberOfNeighbors {
            case 0..<2:
                nextAction = Action.Die
            case 2...3:
                nextAction = Action.Idle
            default:
                nextAction = Action.Die
            }
        } else {
            switch numberOfNeighbors {
            case 3:
                if redNeighbors > blueNeighbors {
                    currentColor = CellColor.red
                } else {
                    currentColor = CellColor.blue
                }
                nextAction = Action.Spawn
            default:
                nextAction = Action.Idle
            }
        }
    }
}
