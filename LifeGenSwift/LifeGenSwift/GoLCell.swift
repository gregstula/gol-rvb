//  GoLCell.swift
//  LifeGenSwift
//
//  Created by Gregory D. Stula on 8/30/15.
//  Copyright (c) 2015 Gregory D. Stula. All rights reserved.
//

class GoLCell: Cell {


    // MARK: Properties
//    override weak var currentGrid:GoLGrid? {
//        get {
//            return super.currentGrid
//        }
//        set {
//            super.currentGrid = newValue
//        }
//    }
//
//    
//    override var coordinates:(row:Int, col:Int) {
//        get {
//            return super.coordinates
//        }
//        set {
//            super.coordinates = newValue
//        }
//    }
//    
//    
//    override var isAlive:Bool {
//        get {
//            return super.isAlive
//        }
//        set {
//            super.isAlive = newValue
//        }
//    }


    var gridRowMax:Int {
        if currentGrid != nil {
            return currentGrid!.rowMax
        } else {
            return 0
        }
    }
    
    var gridColMax:Int {
        if currentGrid != nil {
            return currentGrid!.colMax
        } else {
            return 0
        }
    }

    // Mark: Inits
    
    override init() {
        super.init()
    }
    
    
    required convenience init(grid:GoLGrid?) {
        self.init()
        currentGrid = grid
    }
    

    // MARK: Neighbor Counting
    // Method for counting the number of live neighbors
    func countNeighbors() {
        numberOfNeighbors = 0
        
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
                        numberOfNeighbors++
                }
            }
        }
    }
    
    
    // Method for looking up alive status of Neighbors
    func neighborAliveAt(rowOffset:Int, _ colOffset:Int) -> Bool {
        return currentGrid != nil ? currentGrid!.cellGrid[coordinates.row + rowOffset, coordinates.col + colOffset].isAlive : false
    }
    
    
    // Helper functions for staying inbounds when a cell 
    // on the edge of the grid is counting neighbors.
//    internal func specialCaseZero() {
//        for rowOffset in (0...1) {
//            for colOffset in (0...1) {
//                if (rowOffset != 0 || colOffset != 0) &&
//                    (neighborAliveAt(rowOffset, colOffset)) {
//                        numberOfNeighbors++
//                }
//            }
//        }
//    }
//    
//    internal func specialCaseMax() {
//        for rowOffset in (-1...0) {
//            for colOffset in (-1...0) {
//                if (rowOffset != 0 || colOffset != 0) &&
//                    (neighborAliveAt(rowOffset, colOffset)) {
//                        numberOfNeighbors++
//                }
//            }
//        }
//    }
    
    
    // MARK: Cell Action Methods
    // The cell computes it's next action
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
                //case 2: fallthrough
                case 3:
                    nextAction = Action.Spawn
                default:
                    nextAction = Action.Idle
            }
        }
    }
    
    
    override func executeNextAction() {
        switch nextAction {
            case .Idle:
                break
            case .Spawn:
                isAlive = true
            case .Die:
                isAlive = false
        }
    }
}

