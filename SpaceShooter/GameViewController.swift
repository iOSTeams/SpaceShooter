//
//  GameViewController.swift
//  SpaceShooter
//
//  Created by King Justin on 3/20/16.
//  Copyright (c) 2016 justinleesf. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import AVKit


class GameViewController: UIViewController {
    
    var backgroundMusicPlayer: AVAudioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        /*if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }*/
    }
    
    override func viewWillLayoutSubviews() {
        
        var bgMusicURL:NSURL = NSBundle.mainBundle().URLForResource("bgmusic", withExtension: "mp3")!
        backgroundMusicPlayer = try! AVAudioPlayer(contentsOfURL: bgMusicURL )
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
        
        var SkView:SKView = self.view as! SKView
        SkView.showsFPS = true
        SkView.showsNodeCount = true
        SkView.ignoresSiblingOrder = true
        
        let scene:SKScene = GameScene(size: SkView.bounds.size)
        
        scene.scaleMode = .AspectFill

        SkView.presentScene(scene)
        
    }
    
 

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
