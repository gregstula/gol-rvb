//
//  GameViewController.swift
//  LifeGenSwift
//
//  Created by Gregory D. Stula on 9/8/15.
//  Copyright (c) 2015 Gregory D. Stula. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {

    class func unarchiveFromFile(file : String) -> SKNode?
    {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GOLGameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}


class GameViewController: UIViewController {

    var scene:GOLGameScene!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        scene = GOLGameScene.unarchiveFromFile("GOLGameScene") as? GOLGameScene
        if scene != nil {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.connection = self
            
            skView.presentScene(scene)
            scene.paused = true
        }
    }
    
    @IBOutlet weak var gameTitle: UINavigationItem!
    
    @IBAction func playButtonPress(sender: UIBarButtonItem)
    {
        if sender.title == "▶︎" {
            sender.title = "■"
            scene.paused = false
        } else {
            sender.title = "▶︎"
            scene.paused = true
        }
        
    }
    

    @IBAction func clearAll(sender: UIBarButtonItem) {
        guard scene.paused else {
            return
        }
        scene.grid.killAll()
    }
    
    
    @IBAction func colorSettingPress(sender: UIBarButtonItem)
    {
        if sender.title == "🔵" {
            scene.colorSetting = .red
            sender.title = "🔴"
        } else {
            scene.colorSetting = .blue
            sender.title = "🔵"
        }
    }
    
    override func shouldAutorotate() -> Bool
    {
        return true
    }
    

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask
    {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    

    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
    
}

