//  GoLCell.swift
//  LifeGenSwift
//
//  Created by Gregory D. Stula on 8/30/15.
//  Copyright (c) 2015 Gregory D. Stula. All rights reserved.
//

class GoLCell: NSObject, Equatable {


    // MARK: Properties
    weak var currentGrid:GoLGrid?
    
    var coordinates = (row:0, col:0)
    
    var numberOfNeighbors = 0
    var nextAction = Action.Idle
    
    var isAlive:Bool = false


   // MARK: Calculated properties
    enum Action {
        case Idle
        case Spawn
        case Die
    }
    
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


    convenience init(grid:GoLGrid?) {
        self.init()
        currentGrid = grid
    }

    // Method for looking up alive status of Neighbors
    private func cellAliveAt(rowOffset:Int, _ colOffset:Int) -> Bool {
        return currentGrid != nil ? currentGrid!.cellGrid[coordinates.row + rowOffset, coordinates.col + colOffset].isAlive : false
    }
    
     
    // Function to count the amount of live neighbors
    private func countNeighbors() {
        numberOfNeighbors = 0
        
        if coordinates.row < 2 || coordinates.row > gridRowMax - 2 {
            return;
        } else if coordinates.col < 2 || coordinates.col > gridColMax - 2 {
            return;
        } else {
            for rowSearch in (-1...1){
                for colSearch in (-1...1){
                    if (rowSearch != 0 || colSearch != 0) &&
                        (cellAliveAt(rowSearch, colSearch)) {
                            numberOfNeighbors++
                        }
                }
            }
        }
    }

    // The cell computes it's next action
     func calculateNextAction() {
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
    
    
    func executeNextAction() {
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


// Overloading the == operator as per the Equatable protocol
func ==(lhs: GoLCell, rhs: GoLCell) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}
