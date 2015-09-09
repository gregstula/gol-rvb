//
//  GoLColorCell.swift
//  LifeGenSwift
//
//  Created by Gregory D. Stula on 9/8/15.
//  Copyright (c) 2015 Gregory D. Stula. All rights reserved.
//

import UIKit

class GoLColorCell: GoLCell {

    // MARK: Properties
    weak var currentColorGrid:GoLColorGrid?

    var currentColor:UIColor = UIColor.blueColor()
    var spawnColor:UIColor = UIColor.blueColor()
    
    var colorOfNeighbors = (red: Int blue: Int)
    
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
