//
//  File.swift
//  LifeGenSwift
//
//  Created by Gregory D. Stula on 10/4/15.
//  Copyright © 2015 Gregory D. Stula. All rights reserved.
//

import Foundation

extension GOLGrid {
    
    func insertGlideGunWithCenter(row:Int, col:Int) {
        
       cellGrid[row, col].isAlive = true;
        
        cellGrid[row - 1, col].isAlive = true
        cellGrid[row + 1, col].isAlive = true
        cellGrid[row, col + 1].isAlive = true
        
        cellGrid[row - 2, col - 1].isAlive = true
        cellGrid[row + 2, col - 1].isAlive = true
        cellGrid[row, col - 2].isAlive = true
        
        var newColPoint = col - 6
        
        cellGrid[row, newColPoint].isAlive = (true);
        cellGrid[row + 1, newColPoint].isAlive = (true);
        cellGrid[row - 1, newColPoint].isAlive = (true);
        cellGrid[row - 2, newColPoint + 1].isAlive = (true);
        cellGrid[row + 2, newColPoint + 1].isAlive = (true);
        
        cellGrid[row - 3, newColPoint + 2].isAlive = (true);
        cellGrid[row + 3, newColPoint + 2].isAlive = (true);
        cellGrid[row - 3, newColPoint + 3].isAlive = (true);
        cellGrid[row + 3, newColPoint + 3].isAlive = (true);
        
        newColPoint = newColPoint - 9;
        
        cellGrid[row , newColPoint].isAlive = (true);
        cellGrid[row - 1 , newColPoint].isAlive = (true);
        cellGrid[row, newColPoint - 1].isAlive = (true);
        cellGrid[row - 1, newColPoint - 1].isAlive = (true);
        
        let newRowPoint = row - 2;
        newColPoint = newColPoint + 19;
        
        cellGrid[newRowPoint, newColPoint].isAlive = (true);
        cellGrid[newRowPoint - 1, newColPoint].isAlive = (true);
        cellGrid[newRowPoint + 1, newColPoint].isAlive = (true);
        cellGrid[newRowPoint, newColPoint + 1].isAlive = (true);
        cellGrid[newRowPoint + 1, newColPoint + 1].isAlive = (true);
        cellGrid[newRowPoint - 1, newColPoint + 1].isAlive = (true);
        
        cellGrid[newRowPoint - 2, newColPoint + 2].isAlive = (true);
        cellGrid[newRowPoint + 2, newColPoint + 2].isAlive = (true);
        
        cellGrid[newRowPoint - 2, newColPoint + 4].isAlive = (true);
        cellGrid[newRowPoint + 2, newColPoint + 4].isAlive = (true);
        cellGrid[newRowPoint + 3, newColPoint + 4].isAlive = (true);
        cellGrid[newRowPoint - 3, newColPoint + 4].isAlive = (true);
        
        newColPoint = newColPoint + 14;
        cellGrid[newRowPoint, newColPoint].isAlive = (true);
        cellGrid[newRowPoint - 1, newColPoint].isAlive = (true);
        cellGrid[newRowPoint, newColPoint + 1].isAlive = (true);
        cellGrid[newRowPoint - 1, newColPoint + 1].isAlive = (true);

    }
}