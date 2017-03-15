//
//  GameScene.swift
//  IOS 7 Lesson 2
//
//  Created by Admin on 3/2/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene , SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    let playerNode = SKSpriteNode (imageNamed : "player-1.png")
    var flyNodeList : [SKSpriteNode] = []
    let PLAYER_MAGIN_BOTTOM : CGFloat = 20
    let SCREEN_MAGIN : CGFloat = 20
    var playerBullets : [SKSpriteNode] = []
    let PLAYER_BULLET_NAME = "Player Bullet"
    let PLAYER_MASK = 1
    let ENEMY_MASK = 2
    let ENEMY_BULLET_MASK = 4
    let PLAYER_BULLET_MASK = 8
    //sound & texture (am thanh + hinh anh)
    let playerShootSoundAction = SKAction.playSoundFileNamed("player-shoot", waitForCompletion: false)
    let playerExplodeSoundAction = SKAction.playSoundFileNamed("player-explosion", waitForCompletion: false)
    let flyTexture : [SKTexture] = [SKTexture.init(imageNamed: "fly-1-1" ), SKTexture.init(imageNamed: "fly-1-2" )]
    
    let explosionLV1Texture : [SKTexture] = [
        SKTexture.init(imageNamed: "explosion-1-0" ),
        SKTexture.init(imageNamed: "explosion-1-1" ),
        SKTexture.init(imageNamed: "explosion-1-2" ),
        SKTexture.init(imageNamed: "explosion-1-3" )]
    
    let explosionPlayerTexture : [SKTexture] = [
        SKTexture.init(imageNamed: "explosion-2-0" ),
        SKTexture.init(imageNamed: "explosion-2-1" ),
        SKTexture.init(imageNamed: "explosion-2-2" ),
        SKTexture.init(imageNamed: "explosion-2-3" )]
    
    let starFieldNode = SKEmitterNode(fileNamed: "StarField")
    
    var startTime : TimeInterval = -100
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x:0 , y:0)
        addPlayer()
        addEnemyRow(flyY: self.size.height - SCREEN_MAGIN, spaceY: 0.0)
        addStarField()
    }
    
    func addStarField() -> Void {
        if let starFieldNode = SKEmitterNode(fileNamed: "StarField")
        {
            starFieldNode.position = CGPoint(x : self.size.width/2 ,  y : self.size.height)
            starFieldNode.zPosition = -100
            starFieldNode.particlePositionRange = CGVector(dx: self.size.width, dy: self.size.height)
            
            addChild(starFieldNode)
        }
    }
    
    func addPlayer()->Void{
        playerNode.anchorPoint = CGPoint(x: 0.5 , y :0)
        playerNode.position = CGPoint(x: self.size.width/2, y: PLAYER_MAGIN_BOTTOM)
        playerNode.physicsBody = SKPhysicsBody(rectangleOf: playerNode.size)
        playerNode.physicsBody?.collisionBitMask = 0
        playerNode.physicsBody?.linearDamping = 0
        playerNode.physicsBody?.categoryBitMask = UInt32(PLAYER_MASK)
        playerNode.physicsBody?.contactTestBitMask = UInt32(ENEMY_BULLET_MASK)
        
        
        addChild(playerNode)
        configPhysic()
    }
    
    func addEnemyRow(flyY : CGFloat, spaceY : CGFloat) -> Void {
        let flyWidth : CGFloat = 28
        let flySpace : CGFloat = 10
        let flyXStart : CGFloat = size.width/2
        let flyXMid : CGFloat = 2
        let spaceX : CGFloat = flyWidth + flySpace
        
        for flyIndex in 0..<5 {
            
            let flyX = flyXStart + (spaceX * (CGFloat(flyIndex) - flyXMid))
            
            let flyNode = SKSpriteNode(imageNamed: "fly-1-1.png")
            flyNode.anchorPoint = CGPoint(x: 0.5 , y :1)
            flyNode.position = CGPoint(x: CGFloat(flyX), y :flyY - spaceY)
            flyNode.physicsBody = SKPhysicsBody(rectangleOf: flyNode.size)
            flyNode.physicsBody?.collisionBitMask = 0
            flyNode.physicsBody?.linearDamping = 0
            flyNode.physicsBody?.categoryBitMask = UInt32(ENEMY_MASK) //000010
            flyNode.physicsBody?.contactTestBitMask = UInt32(PLAYER_BULLET_MASK)
            
            let animatedAction : SKAction = .repeatForever(.animate(with: [flyTexture[0],flyTexture[1]], timePerFrame: 0.5))// moi 0.5 s chuyen anh 1 lan
            flyNode.run(animatedAction)
            
            addChild(flyNode)
            flyNodeList.append(flyNode)
        }
    }
    
    func  configPhysic() -> Void {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self  //khi nao xay ra va cham thi se gui den self (gamescene)
    }
    
    func removeNodesFromList(nodeA : SKSpriteNode , nodeB: SKSpriteNode, listNeedRemoval: inout [SKSpriteNode]) -> Void {
        if (listNeedRemoval.contains(nodeA))
        {
            listNeedRemoval = listNeedRemoval.filter {$0 != nodeA}
        }else if (listNeedRemoval.contains(nodeB))
        {
            listNeedRemoval = listNeedRemoval.filter {$0 != nodeB}
        }
        
    }
    
    func addExplosion(position : CGPoint, isEnemyExplosion: Bool) -> Void {
        let explosion1st : String
        let explosionAction : SKAction
        
        if isEnemyExplosion{
            explosion1st = "explosion-1-0"
            explosionAction = SKAction.animate(with: [
                explosionLV1Texture[0],
                explosionLV1Texture[1],
                explosionLV1Texture[2],
                explosionLV1Texture[3]], timePerFrame: 0.2)
        }else{
            explosion1st = "explosion-2-0"
            explosionAction = SKAction.animate(with: [
                explosionPlayerTexture[0],
                explosionPlayerTexture[1],
                explosionPlayerTexture[2],
                explosionPlayerTexture[3]], timePerFrame: 0.2)
        }
        
        let explosionNode = SKSpriteNode(imageNamed: explosion1st)
        explosionNode.position = position
        if isEnemyExplosion{
            explosionNode.run(.sequence([playerExplodeSoundAction,explosionAction, .removeFromParent()]))
        }
        else{
            explosionNode.run(.sequence([playerExplodeSoundAction,explosionAction, .removeFromParent()])){() -> Void in self.endGame()}
        }
        addChild(explosionNode)
    }
    
    //code va cham
    func didBegin(_ contact: SKPhysicsContact) {
        //ten 2 object va cham
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        guard let nodeA = bodyA.node , let nodeB = bodyB.node else {
            return
        }
        
        
        //2 or 8 == 10 => neu ruoi va cham voi dan = 10 bit mask
        switch bodyA.categoryBitMask | bodyB.categoryBitMask {
        case 10://playerbullet + enemy
            nodeA.removeFromParent()
            nodeB.removeFromParent()
            //remove fly
            removeNodesFromList(nodeA: nodeA as! SKSpriteNode, nodeB: nodeB as! SKSpriteNode, listNeedRemoval: &flyNodeList)
            //remove bullet
            removeNodesFromList(nodeA: nodeA as! SKSpriteNode, nodeB: nodeB as! SKSpriteNode, listNeedRemoval: &playerBullets)
            addExplosion(position: nodeA.position , isEnemyExplosion: true)
            
        case 3: //player + enemy
            nodeA.removeFromParent()
            nodeB.removeFromParent()
        case 5://enemy bullet + player
            nodeA.removeFromParent()
            nodeB.removeFromParent()
            addExplosion(position: nodeA.position , isEnemyExplosion: false)
            
        case 12: //bullet + bullet
            nodeA.removeFromParent()
            nodeB.removeFromParent()
            
            removeNodesFromList(nodeA: nodeA as! SKSpriteNode, nodeB: nodeB as! SKSpriteNode, listNeedRemoval: &playerBullets)
        default:
            print("Unexpect event happend")
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let location  = firstTouch.location(in: self)
            playerNode.position = CGPoint(x: location.x , y: PLAYER_MAGIN_BOTTOM)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let location  = firstTouch.location(in: self)
            playerNode.position = CGPoint(x: location.x , y: PLAYER_MAGIN_BOTTOM)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if startTime == -1 {
            startTime = currentTime
        }
        
        if (currentTime - startTime) > 1{
            playerShoot()
            startTime = currentTime
            enemyShoot(enemyNode: selectEnemy())
        }
        
        //        self.enumerateChildNodes(withName: PLAYER_BULLET_NAME) {
        //            node,pointer in
        //            if node.position.y > self.size.height {
        //                node.removeFromParent()
        //            }
        //        }
        for playerBullet in self.playerBullets {
            if playerBullet.position.y > self.size.height {
                playerBullet.removeFromParent()
            }
        }
        
        self.playerBullets = playerBullets.filter{
            node in
            return node.parent != nil
        }
    }
    
    func enemyShoot(enemyNode : SKSpriteNode) ->Void{
        let enemyBullet = SKSpriteNode (imageNamed: "bullet-2.png")
        
        enemyBullet.position = CGPoint(x: enemyNode.position.x, y: (enemyNode.position.y - enemyNode.size.height))
        enemyBullet.anchorPoint = CGPoint(x: 0.5 , y : 1)
        enemyBullet.yScale = enemyBullet.yScale * -1
        enemyBullet.physicsBody = SKPhysicsBody(rectangleOf: enemyBullet.size)
        enemyBullet.physicsBody?.collisionBitMask = 0
        enemyBullet.physicsBody?.linearDamping = 0
        enemyBullet.physicsBody?.velocity = CGVector(dx: 0, dy: -300)
        enemyBullet.physicsBody?.categoryBitMask = UInt32(ENEMY_BULLET_MASK) //tuong duong voi 1 co the khai bao la int dc 001
        enemyBullet.physicsBody?.contactTestBitMask = UInt32(PLAYER_MASK | PLAYER_BULLET_MASK) //2 o day la khai bao co the va cham voi categorybitmask 2
        
        addChild(enemyBullet)
    }
    
    func playerShoot() -> Void {
        let bulletNode = SKSpriteNode (imageNamed: "bullet-1.png")
        
        bulletNode.name = PLAYER_BULLET_NAME
        bulletNode.position = CGPoint(x: playerNode.position.x, y: (playerNode.position.y + playerNode.size.height))
        bulletNode.anchorPoint = CGPoint(x: 0.5 , y :0)
        bulletNode.physicsBody = SKPhysicsBody(rectangleOf: bulletNode.size)
        bulletNode.physicsBody?.collisionBitMask = 0 // khong co va cham dap
        bulletNode.physicsBody?.linearDamping = 0 //luc can
        bulletNode.physicsBody?.velocity = CGVector(dx: 0, dy: 400)
        bulletNode.physicsBody?.categoryBitMask = UInt32(PLAYER_BULLET_MASK) //tuong duong voi 1 co the khai bao la int dc 001
        bulletNode.physicsBody?.contactTestBitMask = UInt32(ENEMY_MASK | ENEMY_BULLET_MASK) //2 o day la khai bao co the va cham voi categorybitmask 2
        bulletNode.run(playerShootSoundAction)
        
        playerBullets.append(bulletNode)
        addChild(bulletNode)
    }
    
    func selectEnemy() -> SKSpriteNode{
        if flyNodeList.count<1
        {
            addEnemyRow(flyY: self.size.height - SCREEN_MAGIN, spaceY: 0.0)
        }
        return flyNodeList[Int(arc4random_uniform(UInt32(flyNodeList.count)))]
    }
    
    func endGame(){
        // restart the game
        let gameScene = GameScene(size: self.size)
        self.view!.presentScene(gameScene)
    }
}
