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
    var aliens:NSMutableArray = NSMutableArray()
    
    //bitmask
    
    //bitwise multiplication
    let alienCategory: UInt32 = 0x1 << 1
    let photonTorpedoCategory: UInt32 = 0x1 << 0
    

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
    
    func addAlien() {
        
        let alien:SKSpriteNode = SKSpriteNode(imageNamed: "alien")
        alien.physicsBody = SKPhysicsBody(rectangleOfSize: alien.size)
        alien.physicsBody?.dynamic = true
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
        alien.physicsBody?.collisionBitMask = 0
        
        //Where to create aliens along the x axis
        let minX = alien.size.width/2
        let maxX = self.frame.size.width - alien.size.width/2
        let rangex = maxX - minX
        let position: CGFloat = CGFloat(arc4random()) % CGFloat(rangex) + CGFloat(minX)
        
        alien.position = CGPointMake(position, self.frame.size.height + alien.size.height)
        
        self.addChild(alien)
        
        let minDuration = 2
        let maxDuration = 4
        let rangeDuration = maxDuration - minDuration
        let duration = Int(arc4random()) % Int(rangeDuration) + Int(minDuration)
//        
//        var actionArray:NSMutableArray = NSMutableArray()
//        actionArray.addObject(SKAction.moveTo(CGPointMake(position, -alien.size.height ) , duration: NSTimeInterval(duration)))
//        actionArray.addObject(SKAction.removeFromParent())
        
        let move = SKAction.moveTo(CGPointMake(position, -alien.size.height ), duration: NSTimeInterval(duration))
        let remove = SKAction.removeFromParent()
        alien.runAction(SKAction.sequence([move,remove]))
        
        //alien.runAction(SKAction.sequence(actionArray))
        
        //Must finish soon
        
        //Studying for statistics sorry :(
        
    }
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate:CFTimeInterval) {
        
        lastYieldTimeInterval += timeSinceLastUpdate
        if (lastYieldTimeInterval > 1) {
            lastYieldTimeInterval = 0
            addAlien()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.runAction(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        
        var touch:UITouch = touches.first! as UITouch
            //.anyObject() as UITouch
        var location:CGPoint = touch.locationInNode(self)
        
        var torpedo:SKSpriteNode = SKSpriteNode(imageNamed: "torpedo")
        torpedo.position = player.position
        
        torpedo.physicsBody = SKPhysicsBody(circleOfRadius: torpedo.size.width/2)
        torpedo.physicsBody?.dynamic = true
        
        torpedo.physicsBody?.contactTestBitMask = photonTorpedoCategory
        torpedo.physicsBody?.contactTestBitMask = alienCategory
        torpedo.physicsBody?.contactTestBitMask = 0
        torpedo.physicsBody?.usesPreciseCollisionDetection = true
        
        var offset:CGPoint = vecSub(location, b: torpedo.position)
        
        if ( offset.y < 0 ) {
            return
        }
        
        
        self.addChild(torpedo)
        
        var direction:CGPoint = vecNormalize(offset)
        
        var shotLength:CGPoint = vecMulti(direction, b: 1000)
        
        var finalDestination:CGPoint = vecAdd(shotLength, b: torpedo.position)
        
        let velocity = 581/1
        
        let moveDuration:Float = Float(self.size.width) / Float(velocity)
        
        
        
        let move = SKAction.moveTo(finalDestination, duration: NSTimeInterval(moveDuration))
        let remove = SKAction.removeFromParent()
        
        
        torpedo.runAction(SKAction.sequence([move,remove]))
        
        //var actio
        
        
        
        
//       /* Called when a touch begins */
//        
//        for touch in touches {
//            let location = touch.locationInNode(self)
//            let sprite = SKSpriteNode(imageNamed:"alien")
//            //let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
//        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        var timeSinceLastUpdate = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        if (timeSinceLastUpdate > 1) {
            timeSinceLastUpdate = 1/60
            lastUpdateTimeInterval = currentTime
        }
        
        self.updateWithTimeSinceLastUpdate(timeSinceLastUpdate)
    }
    
    func vecAdd(a:CGPoint, b:CGPoint)->CGPoint {
        return CGPointMake(a.x + b.x, a.y + b.y)
    }
    
    func vecSub(a:CGPoint, b:CGPoint)->CGPoint{
        return CGPointMake(a.x - b.x, a.y - b.y)
    }
    
    func vecMulti(a:CGPoint, b:CGFloat)->CGPoint{
        return CGPointMake(a.x * b, a.y * b)
    }
    
    func vecLength(a:CGPoint)->CGFloat{
        return CGFloat(sqrt(CGFloat(a.x)*CGFloat(a.x)+CGFloat(a.y)*CGFloat(a.y)))
    }

    func vecNormalize(a:CGPoint)->CGPoint{
        var length: CGFloat = vecLength(a)
        return CGPointMake(a.x / length, a.y / length)
    }

    
    
    
    
}
