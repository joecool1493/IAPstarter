//
//  GameScene.swift
//  joeyNewfield
//
//  Created by Joey Newfield on 1/23/18.
//  Copyright © 2018 Joey Newfield. All rights reserved.
//

import SpriteKit
import StoreKit


var bigBlackLaserPurchased = false
var fastLaserPurchased = false


class GameScene: SKScene, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    var soundOn = true
    //change soundOff to false if you don't want to hear the sound effects
    
    let worldNode = SKNode()
    let ship = SKSpriteNode(imageNamed: "spaceship1")
    let smallBlackLaserNode = SKSpriteNode(imageNamed: "blackSquare")
    let bigBlackLaserNode = SKSpriteNode(imageNamed: "blackSquare")
    let fastLaserNode = SKSpriteNode(imageNamed: "whiteSquare")
    
    let blackLaserSound = SKAction.playSoundFileNamed("blackLaserSound.wav", waitForCompletion: false)
    let fastLaserSound = SKAction.playSoundFileNamed("fastLaserSound.mp3", waitForCompletion: false)
    
    var lives = 5
    var livesLabel: SKLabelNode!
    
    var smallBlackLaserNodeLabel1: SKLabelNode!
    var bigBlackLaserNodeLabel1: SKLabelNode!
    var fastLaserNodeLabel1: SKLabelNode!
    
    var smallBlackLaserNodeLabel2: SKLabelNode!
    var bigBlackLaserNodeLabel2: SKLabelNode!
    var fastLaserNodeLabel2: SKLabelNode!
    
    var subtractLifeButton: SKLabelNode!
    
    var restorePurchasesButton: SKLabelNode!
    
    
    
    override func didMove(to view: SKView) {
        
        self.view?.backgroundColor = SKColor.blue
        
        addChild(worldNode)
        
        setupNodes()
        setupLabels()
        
        //Check to see if users can make payments
        
        if(SKPaymentQueue.canMakePayments()) {
            print("IAP enabled, loading.")
            let productID: NSSet = NSSet(objects: "SP000", "SP001", "SP002")
            let request : SKProductsRequest = SKProductsRequest(productIdentifiers : productID as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("IAPs are not enabled. Please check.")
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        SKPaymentQueue.default().remove(self)
        print("Queue removed")
        
        if let touch = touches.first {
            
            let touchLocation = touch.location(in: self)
            let touchedNode = self.atPoint(touchLocation)
            
            if touchedNode.name == "spaceship" {
                
                shootLaserBeam()
            }
            
            if touchedNode.name == "Subtract Life" && lives > 0 {
                
                lives = lives - 1
                
            } else  if touchedNode.name == "Subtract Life" && lives == 0 {
                for product in list {
                    let prodID = product.productIdentifier
                    if (prodID == "SP000") {
                        p = product
                        buyProduct(p)
                        break
                    }
                }
            }
            
            if touchedNode.name == "Big Laser" {
                
                print("Big laser touched.")
                
                for product in list {
                    let prodID = product.productIdentifier
                    if (prodID == "SP001") {
                        p = product
                        buyProduct(p)
                        break
                    }
                }
            }
            
            if touchedNode.name == "Fast Laser" {
                
                print("Fast laser touched.")
                
                for product in list {
                    let prodID = product.productIdentifier
                    if (prodID == "SP002") {
                        p = product
                        buyProduct(p)
                        break
                    }
                }
            }
            
            if touchedNode.name == "Restore Button" {
                
                if(SKPaymentQueue.canMakePayments()) {
                    
                    SKPaymentQueue.default().add(self)
                    SKPaymentQueue.default().restoreCompletedTransactions()
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        updateLivesLabel()
        updateNodeImages()
        updateSubtractLivesLabel()
    }
    
    func setupNodes() {
        
        ship.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ship.position = CGPoint(x: self.size.width * 0.3, y: self.size.height * 0.4)
        ship.setScale(0.25)
        ship.zPosition = 5
        ship.name = "spaceship"
        worldNode.addChild(ship)
        
        smallBlackLaserNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        smallBlackLaserNode.zPosition = 5
        smallBlackLaserNode.setScale(0.05)
        smallBlackLaserNode.position = CGPoint(x: self.size.width * 0.225, y: self.size.height * 0.1)
        worldNode.addChild(smallBlackLaserNode)
        
        bigBlackLaserNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bigBlackLaserNode.zPosition = 5
        bigBlackLaserNode.setScale(0.125)
        bigBlackLaserNode.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.1)
        bigBlackLaserNode.alpha = 0.35
        bigBlackLaserNode.name = "Big Laser"
        worldNode.addChild(bigBlackLaserNode)
        
        fastLaserNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        fastLaserNode.zPosition = 5
        fastLaserNode.setScale(0.10)
        fastLaserNode.position = CGPoint(x: self.size.width * 0.775, y: self.size.height * 0.1)
        fastLaserNode.alpha = 0.35
        fastLaserNode.name = "Fast Laser"
        worldNode.addChild(fastLaserNode)
        
        
    }
    
    func setupLabels() {
        
        smallBlackLaserNodeLabel1 = SKLabelNode(fontNamed: "Helvetica")
        smallBlackLaserNodeLabel1.verticalAlignmentMode = .center
        smallBlackLaserNodeLabel1.horizontalAlignmentMode = .center
        smallBlackLaserNodeLabel1.position = CGPoint(x: self.size.width * 0.225, y: self.size.height * 0.2)
        smallBlackLaserNodeLabel1.fontColor = SKColor.black
        smallBlackLaserNodeLabel1.fontSize = 16
        smallBlackLaserNodeLabel1.text = "Small Laser"
        smallBlackLaserNodeLabel1.zPosition = 6
        worldNode.addChild(smallBlackLaserNodeLabel1)
        
        smallBlackLaserNodeLabel2 = SKLabelNode(fontNamed: "Helvetica")
        smallBlackLaserNodeLabel2.verticalAlignmentMode = .center
        smallBlackLaserNodeLabel2.horizontalAlignmentMode = .center
        smallBlackLaserNodeLabel2.position = CGPoint(x: self.size.width * 0.225, y: self.size.height * 0.17)
        smallBlackLaserNodeLabel2.fontColor = SKColor.black
        smallBlackLaserNodeLabel2.fontSize = 11
        smallBlackLaserNodeLabel2.text = "Unlocked"
        smallBlackLaserNodeLabel2.zPosition = 6
        worldNode.addChild(smallBlackLaserNodeLabel2)
        
        bigBlackLaserNodeLabel1 = SKLabelNode(fontNamed: "Helvetica")
        bigBlackLaserNodeLabel1.verticalAlignmentMode = .center
        bigBlackLaserNodeLabel1.horizontalAlignmentMode = .center
        bigBlackLaserNodeLabel1.position = CGPoint(x: self.size.width * 0.5, y: smallBlackLaserNodeLabel1.position.y - 2)
        bigBlackLaserNodeLabel1.fontColor = SKColor.black
        bigBlackLaserNodeLabel1.fontSize = 16
        bigBlackLaserNodeLabel1.text = "Big Laser"
        bigBlackLaserNodeLabel1.zPosition = 6
        worldNode.addChild(bigBlackLaserNodeLabel1)
        
        bigBlackLaserNodeLabel2 = SKLabelNode(fontNamed: "Helvetica")
        bigBlackLaserNodeLabel2.verticalAlignmentMode = .center
        bigBlackLaserNodeLabel2.horizontalAlignmentMode = .center
        bigBlackLaserNodeLabel2.position = CGPoint(x: self.size.width * 0.5, y: smallBlackLaserNodeLabel2.position.y - 2)
        bigBlackLaserNodeLabel2.fontColor = SKColor.black
        bigBlackLaserNodeLabel2.fontSize = 11
        bigBlackLaserNodeLabel2.text = "Buy to Unlock"
        bigBlackLaserNodeLabel2.zPosition = 6
        worldNode.addChild(bigBlackLaserNodeLabel2)
        
        fastLaserNodeLabel1 = SKLabelNode(fontNamed: "Helvetica")
        fastLaserNodeLabel1.verticalAlignmentMode = .center
        fastLaserNodeLabel1.horizontalAlignmentMode = .center
        fastLaserNodeLabel1.position = CGPoint(x: self.size.width * 0.775, y: smallBlackLaserNodeLabel1.position.y - 2)
        fastLaserNodeLabel1.fontColor = SKColor.black
        fastLaserNodeLabel1.fontSize = 16
        fastLaserNodeLabel1.text = "Fast Laser"
        fastLaserNodeLabel1.zPosition = 6
        worldNode.addChild(fastLaserNodeLabel1)
        
        fastLaserNodeLabel2 = SKLabelNode(fontNamed: "Helvetica")
        fastLaserNodeLabel2.verticalAlignmentMode = .center
        fastLaserNodeLabel2.horizontalAlignmentMode = .center
        fastLaserNodeLabel2.position = CGPoint(x: self.size.width * 0.775, y: smallBlackLaserNodeLabel2.position.y - 2)
        fastLaserNodeLabel2.fontColor = SKColor.black
        fastLaserNodeLabel2.fontSize = 11
        fastLaserNodeLabel2.text = "Buy to Unlock"
        fastLaserNodeLabel2.zPosition = 6
        worldNode.addChild(fastLaserNodeLabel2)
        
        livesLabel = SKLabelNode(fontNamed: "Helvetica")
        livesLabel.verticalAlignmentMode = .center
        livesLabel.horizontalAlignmentMode = .center
        livesLabel.position = CGPoint(x: self.size.width * 0.675, y: self.size.height * 0.85)
        livesLabel.fontColor = SKColor.black
        livesLabel.fontSize = 18
        livesLabel.text = "Lives Remaining: \(lives)"
        livesLabel.zPosition = 6
        worldNode.addChild(livesLabel)
        
        subtractLifeButton = SKLabelNode(fontNamed: "Helvetica")
        subtractLifeButton.verticalAlignmentMode = .center
        subtractLifeButton.horizontalAlignmentMode = .center
        subtractLifeButton.position = CGPoint(x: livesLabel.position.x, y: self.size.height * 0.75)
        subtractLifeButton.fontColor = SKColor.white
        subtractLifeButton.fontSize = 17
        subtractLifeButton.text = "Click: Lives - 1"
        subtractLifeButton.zPosition = 6
        subtractLifeButton.name = "Subtract Life"
        worldNode.addChild(subtractLifeButton)
        
        restorePurchasesButton = SKLabelNode(fontNamed: "Helvetica")
        restorePurchasesButton.verticalAlignmentMode = .center
        restorePurchasesButton.horizontalAlignmentMode = .center
        restorePurchasesButton.position = CGPoint(x: livesLabel.position.x, y: self.size.height * 0.50)
        restorePurchasesButton.fontColor = SKColor.white
        restorePurchasesButton.fontSize = 17
        restorePurchasesButton.text = "Restore Purchases"
        restorePurchasesButton.zPosition = 6
        restorePurchasesButton.name = "Restore Button"
        worldNode.addChild(restorePurchasesButton)
    }
    
    func shootLaserBeam() {
        
        if fastLaserPurchased == true {
            
            let laserBeam = SKSpriteNode(imageNamed: "whiteSquare")
            laserBeam.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            laserBeam.position = ship.position
            laserBeam.zPosition = 3
            laserBeam.setScale(0.1)
            
            worldNode.addChild(laserBeam)
            
            let moveY = size.height
            let moveDuration = moveY / 750
            
            if soundOn == true {
                let sequence = SKAction.sequence([
                    SKAction.run{
                        self.run(self.fastLaserSound)
                    },
                    SKAction.moveBy(x: 0, y: moveY, duration: TimeInterval(moveDuration)),
                    SKAction.removeFromParent()
                    ])
                laserBeam.run(sequence)
            } else if soundOn == false {
                let sequence = SKAction.sequence([
                    SKAction.moveBy(x: 0, y: moveY, duration: TimeInterval(moveDuration)),
                    SKAction.removeFromParent()
                    ])
                laserBeam.run(sequence)
            }
            
        } else if bigBlackLaserPurchased == true && fastLaserPurchased == false {
            
            let laserBeam = SKSpriteNode(imageNamed: "blackSquare")
            laserBeam.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            laserBeam.position = ship.position
            laserBeam.zPosition = 3
            laserBeam.setScale(0.125)
            
            worldNode.addChild(laserBeam)
            
            let moveY = size.height
            let moveDuration = moveY / 220
            
            if soundOn == true {
                let sequence = SKAction.sequence([
                    SKAction.run{
                        self.run(self.blackLaserSound)
                    },
                    SKAction.moveBy(x: 0, y: moveY, duration: TimeInterval(moveDuration)),
                    SKAction.removeFromParent()
                    ])
                laserBeam.run(sequence)
            } else if soundOn == false {
                let sequence = SKAction.sequence([
                    SKAction.moveBy(x: 0, y: moveY, duration: TimeInterval(moveDuration)),
                    SKAction.removeFromParent()
                    ])
                laserBeam.run(sequence)
            }
            
        } else {
            
            let laserBeam = SKSpriteNode(imageNamed: "blackSquare")
            laserBeam.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            laserBeam.position = ship.position
            laserBeam.zPosition = 3
            laserBeam.setScale(0.05)
            
            worldNode.addChild(laserBeam)
            
            let moveY = size.height
            let moveDuration = moveY / 220
            
            if soundOn == true {
                let sequence = SKAction.sequence([
                    SKAction.run{
                        self.run(self.blackLaserSound)
                    },
                    SKAction.moveBy(x: 0, y: moveY, duration: TimeInterval(moveDuration)),
                    SKAction.removeFromParent()
                    ])
                laserBeam.run(sequence)
            } else if soundOn == false {
                let sequence = SKAction.sequence([
                    SKAction.moveBy(x: 0, y: moveY, duration: TimeInterval(moveDuration)),
                    SKAction.removeFromParent()
                    ])
                laserBeam.run(sequence)
            }
        }
    }
    
    
    func updateLivesLabel() {
        
        livesLabel.text = "Lives Remaining: \(lives)"
        
    }
    
    func updateSubtractLivesLabel() {
        if lives > 0 {
            subtractLifeButton.text = "Click: Lives - 1"
        } else {
            subtractLifeButton.text = "Click to Purchase 5 lives"
        }
    }
    
    func updateNodeImages() {
        if bigBlackLaserPurchased == true {
            bigBlackLaserNode.alpha = 1.0
        }
        
        if fastLaserPurchased == true {
            fastLaserNode.alpha = 1.0
        }
    }
    
    
    func savePurchasedBools() {
        
        let bigBlackLaserPurchasedDefault = UserDefaults.standard
        bigBlackLaserPurchasedDefault.set(bigBlackLaserPurchased, forKey: "BigBlackLaserPurchased")
        bigBlackLaserPurchasedDefault.synchronize()
        
        let fastLaserPurchasedDefault = UserDefaults.standard
        fastLaserPurchasedDefault.set(fastLaserPurchased, forKey: "FastLaserPurchased")
        fastLaserPurchasedDefault.synchronize()
        
        print(bigBlackLaserPurchased)
        print(fastLaserPurchased)
        
    }
    
    
    //In-App Purchases Section
    
    var list = [SKProduct]()
    var p = SKProduct()
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Requesting Product info.")
        
        let myProduct = response.products
        
        for product in myProduct {
            print("Product added.")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            
            list.append(product)
        }
    }
    
    public func buyProduct(_ product: SKProduct) {
        
        SKPaymentQueue.default().add(self)
        
        print("Buying \(p.productIdentifier)...")
        
        let payment = SKPayment(product: product)
        
        SKPaymentQueue.default().add(payment)
        
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        print("Purchases Restored")
        
        let alertController = UIAlertController(title: "Thank You", message: "Your purchase(s) have been restored. You might need to restart the app.", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
        }
        //
        
        alertController.addAction(okAction)
        
        self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        print("Add payment")
        
        for transaction : AnyObject in transactions {
            
            let trans = transaction as! SKPaymentTransaction
            
            switch trans.transactionState {
                
            case .purchased:
                print("Buy OK - unlock IAP here")
                //Here is where to implement code after purhcase is complete
                
                if p.productIdentifier == "SP000" {
                    lives = lives + 5
                }
                
                if p.productIdentifier == "SP001" {
                    bigBlackLaserPurchased = true
                    savePurchasedBools()
                }
                
                if p.productIdentifier == "SP002" {
                    
                    fastLaserPurchased = true
                    savePurchasedBools()
                }
                
                print(p.productIdentifier)
                
                SKPaymentQueue.default().finishTransaction(trans)
                SKPaymentQueue.default().remove(self)
                break
                
            case .restored:
                restore(transaction: trans)
                break
                
            case .failed:
                print("purchase failed")
                SKPaymentQueue.default().finishTransaction(trans)
                break
                
            default:
                print("default")
                break
            }
        }
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restoring... \(productIdentifier)")
        
        if productIdentifier == "SP001" {
            bigBlackLaserPurchased = true
            savePurchasedBools()
        } else {
            print("something went wrong")
        }
        
        if productIdentifier == "SP002" {
            fastLaserPurchased = true
            savePurchasedBools()
        } else {
            print("something went wrong")
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    ////
    ////////
    
}

