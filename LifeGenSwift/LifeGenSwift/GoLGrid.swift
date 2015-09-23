//
//  GoLGridController.swift
//  LifeGenSwift
//
//  Created by Gregory D. Stula on 8/30/15.
//  Copyright (c) 2015 Gregory D. Stula. All rights reserved.
//

import Foundation
import UIKit

final class GoLGrid {
    
    // MARK: Properties
    let rowMax:Int
    let colMax:Int
    
    var useColoredCells:Bool = false
    var generationCount = 0
    private var cellsKnowTheirPosition:Bool = false
    
    let cellGrid:LiteMatrix<Cell>
    
    // Mark: Init
    init (useColor answer:Bool, rowSize:Int, columnSize colSize:Int) {
        rowMax = rowSize
        colMax = colSize
        cellGrid = LiteMatrix<Cell>(rows: rowSize, columns: colSize)
        useColoredCells = answer
        
        if useColoredCells {
            for var i = 0; i < rowMax; i++ {
                for var j = 0; j < colMax; j++ {
                    cellGrid[i,j] = GoLColorCell(grid: self)
                }
            }
        } else {
            for var i = 0; i < rowMax; i++ {
                for var j = 0; j < colMax; j++ {
                    cellGrid[i,j] = GoLCell(grid: self)
                }
            }
        }
    }

    
    // Mark: Generation handling
    private func prepNextGeneration() {
        // Cells should know where they are mapped on the matrix
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
    
    
    func calculateNextAction(cell:Cell) {
        cell.countNeighbors()
        
        if cell.isAlive {
            switch cell.numberOfNeighbors {
            case 0..<2:
                cell.nextAction = Cell.Action.Die
            case 2...3:
                cell.nextAction = Cell.Action.Idle
            default:
                cell.nextAction = Cell.Action.Die
            }
        } else {
            switch cell.numberOfNeighbors {
            case 3:
                if let colorCell = cell as? GoLColorCell {
                    if colorCell.redNeighbors > colorCell.blueNeighbors {
                        colorCell.currentColor = GoLColorCell.CellColor.red
                    } else {
                        colorCell.currentColor = GoLColorCell.CellColor.blue
                    }
                }
                cell.nextAction = Cell.Action.Spawn
            default:
                cell.nextAction = Cell.Action.Idle
            }
        }
    }
    
    
    func executeNextAction(cell:Cell) {
        switch cell.nextAction {
        case Cell.Action.Idle:
            break
        case Cell.Action.Spawn:
            cell.isAlive = true
        case Cell.Action.Die:
            cell.isAlive = false
        }
    }
    
}


// MARK: Console output
extension GoLGrid {

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