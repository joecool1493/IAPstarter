//
//  GameViewController.swift
//  joeyNewfield
//
//  Created by Joey Newfield on 1/23/18.
//  Copyright © 2018 Joey Newfield. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
            view.showsPhysics = true
        }
        
        
        let bigBlackLaserPurchasedDefault = UserDefaults.standard
        bigBlackLaserPurchased = bigBlackLaserPurchasedDefault.bool(forKey: "BigBlackLaserPurchased")
        let fastLaserPurchasedDefault = UserDefaults.standard
        fastLaserPurchased = fastLaserPurchasedDefault.bool(forKey: "FastLaserPurchased")
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

