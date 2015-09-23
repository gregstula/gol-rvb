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
    let cellSpriteSize:CGFloat = 20.0
    let timeBetweenGenerations:Double = 0.3
    var previousTimeRecorded:CFTimeInterval?
    
    /* Also indicates intial startup time in seconds */
    var timeSinceLastGeneration:Double = -3
    
    let grid = GoLGrid(useColor:true, rowSize: 40, columnSize: 40)
    
    // MARK: Background Properties
    var backgroundImage:UIImage! = UIImage(contentsOfFile: "GridImage")
    let backgroundCoverageSize = CGSizeMake(2000, 2000)
    let backgroundTile:CGRect = CGRectMake(0,0,360, 360)
    
    let buttonSize:CGFloat = 40
    lazy var colorButton:SKSpriteNode = { () -> SKSpriteNode in
            var node = SKSpriteNode()
            node.position = CGPointMake(15,100);
            node.name = "colorButton"
            node.zPosition = 1.0;
            return node;
        }()
    
   
    /* Called when user moves to view */
    override func didMoveToView(view: SKView) {
    }
    
    
    /* Called when a touch begins */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            let coords = convertPixelsToCoordinates(location)
            
            if !grid.cellGrid[coords.row, coords.col].isAlive {
                grid.cellGrid[coords.row, coords.col].isAlive = true
                self.renderGoLCell(coords)
            }
        }
    }
    
    
    /* Called when a touch is dragged */
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            let coords = convertPixelsToCoordinates(location)
            
            if !grid.cellGrid[coords.row, coords.col].isAlive {
                grid.cellGrid[coords.row, coords.col].isAlive = true
                renderGoLCell(coords)
            }
            
        }
    }


    /* Called before each frame is rendered */
    override func update(currentTime: CFTimeInterval) {
        
        if previousTimeRecorded != nil && !paused {
            timeSinceLastGeneration += (currentTime - previousTimeRecorded!)
        }
        
        self.previousTimeRecorded = currentTime;
        
        if timeSinceLastGeneration > timeBetweenGenerations {
            timeSinceLastGeneration = 0
            
            /* Calculates cell positions for next gen on a seperate thread */
            let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
            
            dispatch_async(dispatch_get_global_queue(qos, 0)) {
                self.grid.prepareAndExecuteNextGeneration()
                
                /* Updates UI elements on the main therad */
                dispatch_async(dispatch_get_main_queue()) {
                    self.removeAllChildren()
                    self.drawGrid()
                }
            }
        }
    }


    // MARK: Drawing GoL objects to scene
    func drawGrid() {
        for cell in grid.cellGrid {
            let coords = cell.coordinates
            if cell.isAlive {
                renderGoLCell(coords)
            }
        }
    }
    

    private func renderGoLCell(coordinates:(Int, Int)) -> SKSpriteNode {
        let sprite = SKSpriteNode()
        sprite.color = determineGoLCellColor(coordinates)
        sprite.size = CGSizeMake(cellSpriteSize, cellSpriteSize)
        sprite.position = convertCoordinatesToPixels(coordinates)
        self.addChild(sprite)
        return sprite
    }
    
    
    private func determineGoLCellColor(coords:(row: Int, col: Int)) -> UIColor {
        if let cell:GoLColorGoLCell = grid.cellGrid[coords.row, coords.col] as? GoLColorGoLCell {
            return cell.spawnColor
        } else if let _ = grid.cellGrid[coords.row, coords.col] as? GoLGoLCell {
            return UIColor.blackColor()
        } else {
            return UIColor.purpleColor()
        }
    }
    
    
    // MARK: Conversions
    func convertCoordinatesToPixels(coords:(row: Int, col: Int)) -> CGPoint{
        return CGPointMake(CGFloat(coords.row) * cellSpriteSize, CGFloat(coords.col) * cellSpriteSize)
    }
    
    
    func convertPixelsToCoordinates(pixel: CGPoint) -> (row: Int, col: Int) {
        let row = Int(floor(pixel.x / cellSpriteSize))
        let col = Int(floor(pixel.y / cellSpriteSize))
        return (row, col)
    }
   
}