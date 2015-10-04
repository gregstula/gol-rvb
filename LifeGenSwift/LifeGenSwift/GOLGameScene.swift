//
//  GameScene.swift
//  LifeGenSwift
//
//  Created by Gregory D. Stula on 9/8/15.
//  Copyright (c) 2015 Gregory D. Stula. All rights reserved.
//

import SpriteKit

class GOLGameScene: SKScene {
    

    // MARK: Properties
    let grid = GOLGrid(rowSize: 40, columnSize: 40)
    
    
    /* Called when user moves to view */
    override func didMoveToView(view: SKView)
    {
        //showHud()
    }
    
    // MARK: Cell Color Properties
    typealias CellColor = GOLCell.CellColor
    var colorSetting:CellColor = CellColor.blue
    
    /* Called when a touch begins */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            let coords = convertPixelsToCoordinates(location)
            
            let cell = grid.cellGrid[coords.row, coords.col]
            if !cell.isAlive {
                cell.isAlive = true
                cell.currentColor = colorSetting
                self.renderGOLCell(coords)
            }
        }
    }
    
    
    /* Called when a touch is dragged */
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            let coords = convertPixelsToCoordinates(location)
            
            let cell = grid.cellGrid[coords.row, coords.col]
            if !cell.isAlive {
                cell.isAlive = true
                cell.currentColor = colorSetting
                self.renderGOLCell(coords)
            }
            
        }
    }
    
    
    // MARK: Timing Properties
    let cellSpriteSize:CGFloat = 20.0
    let timeBetweenGenerations:Double = 0.3
    var previousTimeRecorded:CFTimeInterval?
    
    /* Also indicates intial startup time in seconds */
    var timeSinceLastGeneration:Double = -3
    
    /* Called before each frame is rendered */
    override func update(currentTime: CFTimeInterval)
    {
        
        if previousTimeRecorded != nil && !paused {
            timeSinceLastGeneration += (currentTime - previousTimeRecorded!)
        }
        
        self.previousTimeRecorded = currentTime;
        
        if timeSinceLastGeneration > timeBetweenGenerations {
            timeSinceLastGeneration = 0
            
            /* Calculates cell positions for next gen on a seperate thread */
            guard !paused else {
                return
            }
            
            let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
            
            dispatch_async(dispatch_get_global_queue(qos, 0)) {
                self.grid.prepareAndExecuteNextGeneration()
                
                /* Updates UI elements on the main therad */
                dispatch_async(dispatch_get_main_queue()) {
                    self.removeAllChildren()
                    self.renderGrid()
                }
            }
        }
    }


    // MARK: Drawing
    func renderGrid()
    {
        for cell in grid.cellGrid {
            let coords = cell.coordinates
            if cell.isAlive {
                renderGOLCell(coords)
            }
        }
    }
    

    private func renderGOLCell(coordinates:(Int, Int)) -> SKSpriteNode
    {
        let sprite = SKSpriteNode()
        sprite.color = determineGOLCellColor(coordinates)
        sprite.size = CGSizeMake(cellSpriteSize, cellSpriteSize)
        sprite.position = convertCoordinatesToPixels(coordinates)
        self.addChild(sprite)
        return sprite
    }
    
    
    private func determineGOLCellColor(coords:(row:Int, col:Int)) -> UIColor
    {
        return grid.cellGrid[coords.row, coords.col].spawnColor
    }
    
    
    // MARK: Conversions
    func convertCoordinatesToPixels(coords:(row:Int, col:Int)) -> CGPoint
    {
        return CGPointMake(CGFloat(coords.row) * cellSpriteSize,
                            CGFloat(coords.col) * cellSpriteSize)
    }
    
    
    func convertPixelsToCoordinates(pixel:CGPoint) -> (row:Int, col:Int)
    {
        let row = Int(pixel.x / cellSpriteSize)
        let col = Int(pixel.y / cellSpriteSize)
        return (row, col)
    }
    
    
   // MARK: UI Elements
    func showHud()
    {
        let hud = GOLHud(frame:CGRect(x: 0, y: 0, width: 35, height: 35))
        
        self.view?.addSubview(hud)
    }
   
}