//
//  GameScene.swift
//  LifeGenSwift
//
//  Created by Gregory D. Stula on 9/8/15.
//  Copyright (c) 2015 Gregory D. Stula. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    // MARK: Properties
    let cellSize:CGFloat = 20.0
    // let buttonSize = (height:CGFloat(50.0), width:CGFloat(30))
    let timeBetweenGenerations:Double = 0.5
    
    let grid = GoLGrid(useColor:true, rowSize: 40, columnSize: 40)
    
    var previousTimeRecorded:CFTimeInterval?
    // Also indicates intial startup time
    var timeSinceLastGeneration:Double = -3
    
    
    override func didMoveToView(view: SKView) {
    }
    
    
    /* Called when a touch begins */
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            let coords = convertPixelsToCoordinates(location)
            
            if !grid.cellGrid[coords.row, coords.col].isAlive {
                grid.cellGrid[coords.row, coords.col].isAlive = true
                self.renderCell(coords)
            }
        }
    }
    
    /* Called when a touch is dragged */
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            let coords = convertPixelsToCoordinates(location)
            
            if !grid.cellGrid[coords.row, coords.col].isAlive {
                grid.cellGrid[coords.row, coords.col].isAlive = true
                self.renderCell(coords)
            }
            
        }
    }


    /* Called before each frame is rendered */
    override func update(currentTime: CFTimeInterval) {
        let qos = Int(QOS_CLASS_USER_INTERACTIVE.value)
        
        if (previousTimeRecorded != nil && !paused) {
           timeSinceLastGeneration += (currentTime - previousTimeRecorded!)
        }
        
        self.previousTimeRecorded = currentTime;
        
        if (timeSinceLastGeneration > timeBetweenGenerations) {
            timeSinceLastGeneration = 0
            dispatch_async(dispatch_get_global_queue(qos, 0)) {
                // grid.printGridToConsole()
                // println("\(self.grid.generationCount)")
                self.grid.prepareAndExecuteNextGeneration()
                dispatch_async(dispatch_get_main_queue()) {
                    //grid.printGridToConsole()
                    self.removeAllChildren()
                    self.drawGrid()
                }
            }
        }
    }


    // MARK: Drawing GoL objects to scene
    func drawGrid() {
        for cell in grid.cellGrid {
            if cell.isAlive {
                let coords = cell.coordinates
                self.renderCell(coords)
            }
        }
    }


    private func renderCell(coordinates:(Int, Int)) -> SKSpriteNode {
        let sprite = SKSpriteNode()
        sprite.color = determineCellColor(coordinates)
        sprite.size = CGSizeMake(cellSize, cellSize)
        sprite.position = convertCoordinatesToPixels(coordinates)
        self.addChild(sprite)
        return sprite
    }
    
    
    private func determineCellColor(coords:(row: Int, col: Int)) -> UIColor {
        if let cell:GoLColorCell = grid.cellGrid[coords.row, coords.col] as? GoLColorCell {
            return cell.spawnColor
        } else if let cell = grid.cellGrid[coords.row, coords.col] as? GoLCell {
            return UIColor.blackColor()
        } else {
            return UIColor.purpleColor()
        }
    }
    
    
    // MARK: Conversions
    func convertCoordinatesToPixels(coords:(row: Int, col: Int)) -> CGPoint{
        return CGPointMake(CGFloat(coords.row) * cellSize, CGFloat(coords.col) * cellSize)
    }
    
    
    func convertPixelsToCoordinates(pixel: CGPoint) -> (row: Int, col: Int) {
        var row = Int(floor(pixel.x / cellSize)), col = Int(floor(pixel.y / cellSize))
        return (row, col)
    }
   
}
