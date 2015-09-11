//  GoLCell.swift
//  LifeGenSwift
//
//  Created by Gregory D. Stula on 8/30/15.
//  Copyright (c) 2015 Gregory D. Stula. All rights reserved.
//

class GoLCell: Cell {

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
    override func countNeighbors() {
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
}
