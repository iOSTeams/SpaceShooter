//
//  GameOverScene.swift
//  SpaceShooter
//
//  Created by King Justin on 3/26/16.
//  Copyright © 2016 justinleesf. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    init(size:CGSize, won: Bool) {
        super.init(size: size)
        self.backgroundColor = SKColor.redColor()
        
        var message:NSString = NSString()
        
        if (won) {
            message = "You win"
        } else {
            message = "You lost"
        }
        
        var label:SKLabelNode = SKLabelNode.init(fontNamed: "HoeflerText-BlackItalic")
        label.text = message as String
        label.fontColor = SKColor.whiteColor()
        
        label.position = CGPointMake(self.size.width/2, self.size.height/2)
        
        self.addChild(label)
        
        self.runAction(SKAction.sequence([SKAction.waitForDuration(1),
        SKAction.runBlock({
            var transition:SKTransition = SKTransition.flipHorizontalWithDuration(0.3)
            var scene:SKScene = GameScene(size:self.size)
            self.view?.presentScene(scene, transition: transition)
        })
    ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
