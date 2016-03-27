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
        
        
        //var actionArray:NSMutableArray = NSMutableArray()
        //Show loss screen
        let d = SKAction.runBlock({
            var transition: SKTransition = SKTransition.flipHorizontalWithDuration(1.0)
            var gameOverScene:SKScene = GameOverScene(size: self.size, won: false)
            self.view?.presentScene(gameOverScene, transition: transition)
        })
        
        
            alien.runAction(SKAction.sequence([move,d,remove]))
        //alien.runAction(SKAction.sequence(actionArray))
        
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
        torpedo.physicsBody?.collisionBitMask = 0
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
    

    

    
    
    func torpedoDidCollideWithAlien(torpedo:SKSpriteNode, alien:SKSpriteNode){
        print("hit")
        torpedo.removeFromParent()
        alien.removeFromParent()
        
        aliensDestroyed += 1
        
        if ( aliensDestroyed > 2) {
            //Transition to gameover
            var transition: SKTransition = SKTransition.flipHorizontalWithDuration(0.3)
            var gameOverScene:SKScene = GameOverScene(size: self.size, won: true)
            self.view?.presentScene(gameOverScene, transition: transition)
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
//        if (( firstBody.categoryBitMask & photonTorpedoCategory) != 0 && (secondBody.categoryBitMask & alienCategory) != 0) {
//            
//            torpedoDidCollideWithAlien( firstBody.node as! SKSpriteNode, alien:secondBody.node as! SKSpriteNode )
//        }
        
        if ((firstBody.contactTestBitMask & photonTorpedoCategory) != 0 && (secondBody.contactTestBitMask & alienCategory) != 0){
            torpedoDidCollideWithAlien(firstBody.node as! SKSpriteNode, alien: secondBody.node as! SKSpriteNode)
        }
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
