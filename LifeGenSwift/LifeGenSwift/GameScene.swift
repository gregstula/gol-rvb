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
    let pixelSize:CGFloat = 20.0
    let timeBetweenGenerations:Double = 0.5
    
    let grid = GoLGrid(rowSize: 40, columnSize: 40)
    let colorButton = SKLabelNode(fontNamed: "Monaco")
    
    var previousTimeRecorded:CFTimeInterval?
    // Also indicates intial startup time
    var timeSinceLastGeneration:Double = -3
    
    
    override func didMoveToView(view: SKView) {
            colorButton.position = CGPoint(x:CGRectGetMinX(self.frame), y:CGRectGetMinY(self.frame));
            colorButton.fontColor = UIColor.blueColor()
            colorButton.text = "Change color"
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            if location == colorButton.position {
                
                colorButton.fontColor = UIColor.redColor()
            }
            
            let coords = convertPixelsToCoordinates(location)
            
            if !grid.cellGrid[coords.row, coords.col].isAlive {
                grid.cellGrid[coords.row, coords.col].isAlive = true
                self.renderCell(coords)
            }
            
        }
    }
    
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            let coords = convertPixelsToCoordinates(location)
            
            if !grid.cellGrid[coords.row, coords.col].isAlive {
                grid.cellGrid[coords.row, coords.col].isAlive = true
                self.renderCell(coords)
            }
            
        }
    }


    override func update(currentTime: CFTimeInterval) {
      /* Called before each frame is rendered */
    if (previousTimeRecorded != nil){
       timeSinceLastGeneration += (currentTime - previousTimeRecorded!)
    }
        self.previousTimeRecorded = currentTime;
        
        if (timeSinceLastGeneration > timeBetweenGenerations) {
            timeSinceLastGeneration = 0
            grid.prepareAndExecuteNextGeneration()
            //grid.printGridToConsole()
            self.removeAllChildren()
            self.drawGrid()
            println("\(grid.generationCount)")
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


    private func renderCell(coordinates:(Int, Int)) -> SKSpriteNode{
        let sprite = SKSpriteNode()
        sprite.color = UIColor.blackColor()
        sprite.size = CGSizeMake(pixelSize, pixelSize)
        sprite.position = convertCoordinatesToPixels(coordinates)
        self.addChild(sprite)
        return sprite
    }
    
    
// MARK: Conversions
    func convertCoordinatesToPixels(coords:(row: Int, col: Int)) -> CGPoint{
        return CGPointMake(CGFloat(coords.row) * pixelSize, CGFloat(coords.col) * pixelSize)
    }
    
    
    func convertPixelsToCoordinates(pixel: CGPoint) -> (row: Int, col: Int) {
        var row = Int(floor(pixel.x / pixelSize)), col = Int(floor(pixel.y / pixelSize))
        return (row, col)
    }
   
}
