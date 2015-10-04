//
//  GOLGridController.swift
//  LifeGenSwift
//
//  Created by Gregory D. Stula on 8/30/15.
//  Copyright (c) 2015 Gregory D. Stula. All rights reserved.
//

import Foundation
import UIKit

final class GOLGrid {
    
    // MARK: Properties
    let rowMax:Int
    let colMax:Int
    
    var useColoredGOLCells:Bool = false
    var generationCount = 0
    private var cellsKnowTheirPosition:Bool = false
    
    let cellGrid:LiteMatrix<GOLCell>
    
    // Mark: Init
    init (rowSize:Int, columnSize colSize:Int) {
        rowMax = rowSize
        colMax = colSize
        cellGrid = LiteMatrix<GOLCell>(rows: rowSize, columns: colSize)
        
        for var i = 0; i < rowMax; i++ {
            for var j = 0; j < colMax; j++ {
                cellGrid[i,j] = GOLCell()
            }
        }
    }
    
    
    // MARK: Neighbor counting
    private func countNeighbors(cell:GOLCell) {
        cell.numberOfNeighbors = 0
        
        // Prevents index out of bounds for special case of row/col = 0.
        if cell.coordinates.row < 1 || cell.coordinates.col < 1 {
            return
        // Prevents index out of bounds for special case of *MAX - 1
        } else if cell.coordinates.row > rowMax - 2 || cell.coordinates.col > colMax - 2 {
            return
        }
        
        // Normal case
        for rowOffset in (-1...1) {
            for colOffset in (-1...1) {
                if (rowOffset != 0 || colOffset != 0) &&
                    (neighborAliveAt(cell, rowOffset, colOffset)) {
                        countNeighborByColor(cell, rowOffset, colOffset);
                        cell.numberOfNeighbors++
                }
            }
        }
    }
    
    
    // Helper Method for looking up alive status of Neighbors
    func neighborAliveAt(cell:GOLCell, _ rowOffset:Int, _ colOffset:Int) -> Bool {
        return cellGrid[cell.coordinates.row + rowOffset, cell.coordinates.col + colOffset].isAlive
    }
    
    
    // Helper method for counting color cells
    private func countNeighborByColor(cell:GOLCell, _ rowOffset:Int, _ colOffset:Int) {
    let neighbor = cellGrid[cell.coordinates.row + rowOffset, cell.coordinates.col + colOffset]
    
        if neighbor.currentColor == GOLCell.CellColor.blue {
            cell.blueNeighbors++
        } else if cell.currentColor == GOLCell.CellColor.red {
            cell.redNeighbors++
        }
    }


    // Mark: Cell Methods
    // Calculates the next action of a cell
    func calculateNextAction(cell:GOLCell) {
        countNeighbors(cell)
        
        if cell.isAlive {
            switch cell.numberOfNeighbors {
            case 0..<2:
                cell.nextAction = GOLCell.Action.Die
            case 2...3:
                cell.nextAction = GOLCell.Action.Idle
            default:
                cell.nextAction = GOLCell.Action.Die
            }
        } else {
            switch cell.numberOfNeighbors {
            case 3:
                if cell.redNeighbors > cell.blueNeighbors {
                    cell.currentColor = GOLCell.CellColor.red
                } else {
                    cell.currentColor = GOLCell.CellColor.blue
                }
                cell.nextAction = GOLCell.Action.Spawn
            default:
                cell.nextAction = GOLCell.Action.Idle
            }
        }
    }
    
    
    // Adjusts the cell's Alive status based on a previously calculated action
    func executeNextAction(cell:GOLCell) {
        switch cell.nextAction {
        case GOLCell.Action.Idle:
            break
        case GOLCell.Action.Spawn:
            cell.isAlive = true
        case GOLCell.Action.Die:
            cell.isAlive = false
        }
    }
    
    
    private func prepNextGeneration() {
        // GOLCells should know where they are mapped on the matrix
        if !self.cellsKnowTheirPosition {
            for var i = 0; i < rowMax; i++ {
                for var j = 0; j < colMax; j++ {
                    cellGrid[i,j].coordinates = (row:i, col:j)
                }
            }
            cellsKnowTheirPosition = true
        }
        
        for cell in cellGrid {
            calculateNextAction(cell)
        }
    }
    
    
    private func executeNextGeneration() {
        for cell in cellGrid {
            executeNextAction(cell)
        }
    }
    
    
    func prepareAndExecuteNextGeneration() {
        self.prepNextGeneration()
        self.executeNextGeneration()
        generationCount++
    }
    
}


// MARK: Console output
extension GOLGrid {

    func printGridToConsole() {
        for i in 0..<rowMax {
            for j in 0..<colMax {
                cellGrid[i, j].isAlive ? print(" \(cellGrid[i,j].numberOfNeighbors)", terminator: "") : print(" . ", terminator: "")
            }
            print("")
        }
        print("")
        print("")
    }
}