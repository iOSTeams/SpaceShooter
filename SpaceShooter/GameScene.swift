//
//  GameScene.swift
//  SpaceShooter
//
//  Created by King Justin on 3/20/16.
//  Copyright (c) 2016 justinleesf. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate  {
    
    var player: SKSpriteNode = SKSpriteNode()
    var lastYieldTimeInterval: NSTimeInterval = NSTimeInterval()
    var lastUpdateTimeInterval: NSTimeInterval = NSTimeInterval()
    var aliensDestroyed: Int = 0
    
    

    override func didMoveToView(view: SKView) {
//        /* Setup your scene here */
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!"
//        myLabel.fontSize = 45
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
//        
//        self.addChild(myLabel)
    }
    
    override init(size:CGSize) {
        super.init(size: size)
        self.backgroundColor = SKColor.blackColor()
        
        player = SKSpriteNode(imageNamed: "shuttle")
        
        player.position = CGPointMake(self.frame.size.width/2, player.size.height/2 + 20)
        
        self.addChild(player)
        self.physicsWorld.gravity = CGVectorMake(0,0)
        self.physicsWorld.contactDelegate = self
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
