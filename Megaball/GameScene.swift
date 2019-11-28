//
//  GameScene.swift
//  Megaball
//
//  Created by James Harding on 18/08/2019.
//  Copyright © 2019 James Harding. All rights reserved.
//

import SpriteKit
import GameplayKit

let PaddleCategoryName = "paddle"
let BallCategoryName = "ball"
let BlockCategoryName = "block"
let PowerUpCategoryName = "powerUp"
let LaserCategoryName = "laser"
let ScreenBlockCategoryName = "screenBlock"
// Set up for categoryNames

enum CollisionTypes: UInt32 {
    case ballCategory = 1
    case blockCategory = 2
    case paddleCategory = 4
	case screenBlockCategory = 8
    case powerUpCategory = 16
    case laserCategory = 32
}
// Setup for collisionBitMask

//The categoryBitMask property is a number defining the type of object this is for considering collisions.
//The collisionBitMask property is a number defining what categories of object this node should collide with.
//The contactTestBitMask property is a number defining which collisions we want to be notified about.

//If you give a node a collision bitmask but not a contact test bitmask, it means they will bounce off each other but you won't be notified.
//If you give a node contact test but not collision bitmask it means they won't bounce off each other but you will be told when they overlap.

protocol GameViewControllerDelegate: class {
    func moveToMainMenu()
    func showEndLevelStats(levelNumber: Int, levelScore: Int, levelTime: Double, cumulativeScore: Int, cumulativeTime: Double, levelHighscore: Int, levelBestTime: Double, bestScoreToLevel: Int, bestTimeToLevel: Double, cumulativeHighscore: Int, gameoverStatus: Bool)
	func showPauseMenu(levelNumber: Int)
}
// Setup the protocol to return to the main menu from GameViewController

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var paddle = SKSpriteNode()
    var ball = SKSpriteNode()
    var block = SKSpriteNode()
    var blockDouble = SKSpriteNode()
    var blockInvisible = SKSpriteNode()
    var blockNull = SKSpriteNode()
    var life = SKSpriteNode()
	var topScreenBlock = SKSpriteNode()
	var bottomScreenBlock = SKSpriteNode()
    // Define objects
    
    var livesLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var highScoreLabel = SKLabelNode()
    var timerLabel = SKLabelNode()
    var bestTimeLabel = SKLabelNode()
    var levelNumberLabel = SKLabelNode()
	var countdownLabel = SKLabelNode()
    // Define labels
    
    var pausedButton = SKSpriteNode()
    var pauseButtonSize: CGFloat = 0
    // Define buttons

	var layoutUnit: CGFloat = 0
    var paddleWidth: CGFloat = 0
    var paddleGap: CGFloat = 0
    var ballSize: CGFloat = 0
    var ballStartingPositionY: CGFloat = 0
    var ballLaunchSpeed: Double = 0
    var ballLaunchAngleRad: Double = 0
    var ballLostHeight: CGFloat = 0
	var ballLostAnimationHeight: CGFloat = 0
    var blockHeight: CGFloat = 0
    var blockWidth: CGFloat = 0
    var numberOfBlockRows: Int = 0
    var numberOfBlockColumns: Int = 0
    var totalBlocksWidth: CGFloat = 0
	var totalBlocksHeight: CGFloat = 0
    var yBlockOffset: CGFloat = 0
    var xBlockOffset: CGFloat = 0
    var powerUpSize: CGFloat = 0
	var topScreenBlockHeight: CGFloat = 0
	var bottomScreenBlockHeight: CGFloat = 0
	var screenBlockWidth: CGFloat = 0
	var topGap: CGFloat = 0
	var paddlePositionY: CGFloat = 0
	var screenBlockHeight: CGFloat = 0
    // Object layout property defintion
    
    var dxBall: Double = 0
    var dyBall: Double = 0
    var speedBall: Double = 0
    var ballIsOnPaddle: Bool = true
    var numberOfLives: Int = 3
    var collisionLocation: Double = 0
    var minAngleDeg: Double = 20
    var maxAngleDeg: Double = 160
    var angleAdjustmentK: Double = 50
        // Effect of paddle position hit on ball angle. Larger number means more effect
    var blocksLeft: Int = 0
    var ballLinearDampening: CGFloat = 0
	let ballMaxSet: CGFloat = 550
	let ballMinSet: CGFloat = 450
	let ballMaxLimit: CGFloat = 750
    let ballMinLimit: CGFloat = 250
    var ballMaxSpeed: CGFloat = 0
    var ballMinSpeed: CGFloat = 0
	
    var reducedBallSpeed: CGFloat = 0
    var increasedBallSpeed: CGFloat = 0
    var xSpeed: CGFloat = 0
    var ySpeed: CGFloat = 0
    var currentSpeed: CGFloat = 0
	var paddleMovementFactor: CGFloat = 1.1
	var levelNumber: Int = 0
    // Setup game metrics
    
    var lifeLostScore: Int = 0
    var blockHitScore: Int = 0
    var blockDestroyScore: Int = 0
    var powerUpScore: Int = 0
	var levelCompleteScore: Int = 0
    
	var cumulativeScore: Int = 0
    var levelScore: Int = 0
	var highscore: Int = 0
	var scoreFactor: Int = 0
    var bestCumulativeTime: Double = 0
    // Setup score properties
    
    var timeBonusPoints: Int = 0
    var level1TimeBonus: Int = 0
    var level2TimeBonus: Int = 0
	var level3TimeBonus: Int = 0
    // Level time bonuses
    
    let blockTexture: SKTexture = SKTexture(imageNamed: "Block")
    let blockDouble1Texture: SKTexture = SKTexture(imageNamed: "BlockDouble1")
    let blockDouble2Texture: SKTexture = SKTexture(imageNamed: "BlockDouble2")
    let blockDouble3Texture: SKTexture = SKTexture(imageNamed: "BlockDouble3")
    let blockInvisibleTexture: SKTexture = SKTexture(imageNamed: "BlockInvisible")
    let blockNullTexture: SKTexture = SKTexture(imageNamed: "BlockNull")
    let blockIndestructibleTexture: SKTexture = SKTexture(imageNamed: "BlockIndestructible")
    // Block textures
    
    let powerUp00Texture: SKTexture = SKTexture(imageNamed: "PowerUp00")
    let powerUp01Texture: SKTexture = SKTexture(imageNamed: "PowerUp01")
    let powerUp02Texture: SKTexture = SKTexture(imageNamed: "PowerUp02")
    let powerUp03Texture: SKTexture = SKTexture(imageNamed: "PowerUp03")
    let powerUp04Texture: SKTexture = SKTexture(imageNamed: "PowerUp04")
    let powerUp05Texture: SKTexture = SKTexture(imageNamed: "PowerUp05")
    let powerUp06Texture: SKTexture = SKTexture(imageNamed: "PowerUp06")
    let powerUp07Texture: SKTexture = SKTexture(imageNamed: "PowerUp07")
    let powerUp08Texture: SKTexture = SKTexture(imageNamed: "PowerUp08")
    let powerUp09Texture: SKTexture = SKTexture(imageNamed: "PowerUp09")
	let powerUp10Texture: SKTexture = SKTexture(imageNamed: "PowerUp10")
    let powerUp11Texture: SKTexture = SKTexture(imageNamed: "PowerUp11")
    let powerUp12Texture: SKTexture = SKTexture(imageNamed: "PowerUp12")
    let powerUp13Texture: SKTexture = SKTexture(imageNamed: "PowerUp13")
    let powerUp90Texture: SKTexture = SKTexture(imageNamed: "PowerUp90")
    let powerUp91Texture: SKTexture = SKTexture(imageNamed: "PowerUp91")
    let powerUp92Texture: SKTexture = SKTexture(imageNamed: "PowerUp92")
    let powerUp93Texture: SKTexture = SKTexture(imageNamed: "PowerUp93")
    let powerUp94Texture: SKTexture = SKTexture(imageNamed: "PowerUp94")
    let powerUp95Texture: SKTexture = SKTexture(imageNamed: "PowerUp95")
    let powerUp96Texture: SKTexture = SKTexture(imageNamed: "PowerUp96")
    let powerUp97Texture: SKTexture = SKTexture(imageNamed: "PowerUp97")
    let powerUp98Texture: SKTexture = SKTexture(imageNamed: "PowerUp98")
    let powerUp99Texture: SKTexture = SKTexture(imageNamed: "PowerUp99")
    // Power up textures
    
	let concaveTexture: SKTexture = SKTexture(imageNamed: "Concave Paddle")
	let convexTexture: SKTexture = SKTexture(imageNamed: "Convex Paddle")
	// Paddle textures
	
    let ballTexture: SKTexture = SKTexture(imageNamed: "Ball")
    let superballTexture: SKTexture = SKTexture(imageNamed: "Superball")
    let undestructiballTexture: SKTexture = SKTexture(imageNamed: "Undestructiball")
    // Ball textures
    
    let laserTexture: SKTexture = SKTexture(imageNamed: "Laser")
    let superLaserTexture: SKTexture = SKTexture(imageNamed: "SuperLaser")
    // Laser textures
    
    var stickyPaddleCatches: Int = 0
    var laserPowerUpIsOn: Bool = false
    var laserTimer: Timer?
    var laserSideLeft: Bool = true
	let ballSpeedChange: CGFloat = 100
    // Power up properties
    
    var contactCount: Int = 0
    var ballPositionOnPaddle: Double = 0
    
    let playTexture: SKTexture = SKTexture(imageNamed: "PlayButton")
    let pauseTexture: SKTexture = SKTexture(imageNamed: "PauseButton")
    // Play/pause button textures
    
    var touchBeganWhilstPlaying: Bool = false
    var paddleMoved: Bool = false
    var paddleMovedDistance: CGFloat = 0
    var gameoverStatus: Bool = false
    var endLevelNumber: Int = 0
    // Game trackers
    
    var fontSize: CGFloat = 0
    var labelSpacing: CGFloat = 0
    // Label metrics
    
    var cumulativeTimerValue: Double = 0
    var levelTime: Double = 0
    
    let lightHaptic = UIImpactFeedbackGenerator(style: .light)
    let mediumHaptic = UIImpactFeedbackGenerator(style: .medium)
    let heavyHaptic = UIImpactFeedbackGenerator(style: .heavy)
    
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
        PreGame(scene: self),
        Playing(scene: self),
        InbetweenLevels(scene: self),
        GameOver(scene: self),
        Paused(scene: self)])
    // Sets up the game states
    
    weak var gameViewControllerDelegate:GameViewControllerDelegate?
    // Create the delegate property for the GameViewController
    
    let dataStore = UserDefaults.standard
    // Setup NSUserDefaults data store
    
    var scoreArray: [Int] = [1]
    var timerArray: [Double] = [1]
    // Creates arrays to store highscores and times from NSUserDefauls
    
    override func didMove(to view: SKView) {
		
//MARK: - Scene Setup

        physicsWorld.contactDelegate = self
        // Sets the GameScene as the delegate in the physicsWorld
        
        let boarder = SKPhysicsBody(edgeLoopFrom: self.frame)
        boarder.friction = 0
        boarder.restitution = 1
        self.physicsBody = boarder
        // Sets up the boarder to interact with the objects
		
		physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		// Setup gravity
		
//MARK: - Object Initialisation
        
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        paddle = self.childNode(withName: "paddle") as! SKSpriteNode
        pausedButton = self.childNode(withName: "pauseButton") as! SKSpriteNode
        life = self.childNode(withName: "life") as! SKSpriteNode
		topScreenBlock = self.childNode(withName: "topScreenBlock") as! SKSpriteNode
		bottomScreenBlock = self.childNode(withName: "bottomScreenBlock") as! SKSpriteNode
        // Links objects to nodes
	
		layoutUnit = self.frame.width/20
		blockWidth = layoutUnit*2
		blockHeight = layoutUnit*1
		ballSize = layoutUnit*0.67
		ball.size.width = ballSize
        ball.size.height = ballSize
		life.size.width = ballSize
        life.size.height = ballSize
		paddleWidth = layoutUnit*5
		paddle.size.width = paddleWidth
		paddle.size.height = ballSize
		paddleGap = layoutUnit*7
		ballLostAnimationHeight = paddle.size.height + ball.size.height
        ballLostHeight = ballLostAnimationHeight*3
		screenBlockHeight = layoutUnit*4
		topScreenBlock.size.height = screenBlockHeight
		topScreenBlock.size.width = self.frame.width
		bottomScreenBlock.size.height = screenBlockHeight
		bottomScreenBlock.size.width = self.frame.width
		topGap = layoutUnit*3
		// Object size definition

		topScreenBlock.position.x = 0
		topScreenBlock.position.y = self.frame.height/2 - screenBlockHeight/2
		numberOfBlockRows = 20
        numberOfBlockColumns = 10
        totalBlocksWidth = blockWidth * CGFloat(numberOfBlockColumns)
		totalBlocksHeight = blockHeight * CGFloat(numberOfBlockRows)
        xBlockOffset = totalBlocksWidth/2 - blockWidth/2
		yBlockOffset = self.frame.height/2 - topScreenBlock.size.height - topGap - blockHeight/2
		paddle.position.x = 0
		paddlePositionY = self.frame.height/2 - topScreenBlock.size.height - topGap - totalBlocksHeight - paddleGap - paddle.size.height/2
		paddle.position.y = paddlePositionY
		ball.position.x = 0
		ballStartingPositionY = paddlePositionY + paddle.size.height/2 + ballSize/2 + ballSize/4
		ball.position.y = ballStartingPositionY
		bottomScreenBlock.position.x = 0
		bottomScreenBlock.position.y = -self.frame.height/2 + screenBlockHeight/2
		// Object positioning definition
		
		ball.physicsBody = SKPhysicsBody(circleOfRadius: ballSize/2)
        ball.physicsBody!.allowsRotation = false
        ball.physicsBody!.friction = 0.0
        ball.physicsBody!.affectedByGravity = false
        ball.physicsBody!.isDynamic = true
        ball.name = BallCategoryName
        ball.physicsBody!.categoryBitMask = CollisionTypes.ballCategory.rawValue
        ball.physicsBody!.collisionBitMask = CollisionTypes.blockCategory.rawValue | CollisionTypes.paddleCategory.rawValue | CollisionTypes.screenBlockCategory.rawValue
		ball.physicsBody!.contactTestBitMask = CollisionTypes.blockCategory.rawValue | CollisionTypes.paddleCategory.rawValue
		ball.physicsBody!.usesPreciseCollisionDetection = true
        ball.zPosition = 2
        ball.physicsBody?.linearDamping = ballLinearDampening
        ball.physicsBody?.angularDamping = 0
		ball.physicsBody?.restitution = 1
        // Define ball properties
		let xRangeBall = SKRange(lowerLimit:-self.frame.width/2 + ballSize/2,upperLimit:self.frame.width/2 - ballSize/2)
        ball.constraints = [SKConstraint.positionX(xRangeBall)]
        // Stops the ball leaving the screen
		
		definePaddleProperties()
		// Define paddle properties
		
		ball.isHidden = true
        paddle.isHidden = true
        // Hide ball and paddle
		
		topScreenBlock.physicsBody = SKPhysicsBody(rectangleOf: topScreenBlock.frame.size)
		topScreenBlock.physicsBody!.allowsRotation = false
		topScreenBlock.physicsBody!.friction = 0.0
		topScreenBlock.physicsBody!.affectedByGravity = false
		topScreenBlock.physicsBody!.isDynamic = false
		topScreenBlock.zPosition = 0
		topScreenBlock.name = ScreenBlockCategoryName
		topScreenBlock.physicsBody!.categoryBitMask = CollisionTypes.screenBlockCategory.rawValue
		topScreenBlock.physicsBody!.collisionBitMask = CollisionTypes.ballCategory.rawValue | CollisionTypes.laserCategory.rawValue
		topScreenBlock.physicsBody!.contactTestBitMask = CollisionTypes.laserCategory.rawValue
		// Define top screen block properties
		
		bottomScreenBlock.physicsBody = SKPhysicsBody(rectangleOf: bottomScreenBlock.frame.size)
		bottomScreenBlock.physicsBody!.allowsRotation = false
		bottomScreenBlock.physicsBody!.friction = 0.0
		bottomScreenBlock.physicsBody!.affectedByGravity = false
		bottomScreenBlock.physicsBody!.isDynamic = true
		bottomScreenBlock.zPosition = 0
		bottomScreenBlock.name = ScreenBlockCategoryName
		bottomScreenBlock.physicsBody!.categoryBitMask = CollisionTypes.screenBlockCategory.rawValue
		bottomScreenBlock.physicsBody!.contactTestBitMask = CollisionTypes.powerUpCategory.rawValue
		// Define top screen block properties
		
//MARK: - Label & UI Initialisation
		
        livesLabel = self.childNode(withName: "livesLabel") as! SKLabelNode
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        highScoreLabel = self.childNode(withName: "highScoreLabel") as! SKLabelNode
        timerLabel = self.childNode(withName: "timerLabel") as! SKLabelNode
        bestTimeLabel = self.childNode(withName: "bestTimeLabel") as! SKLabelNode
        levelNumberLabel = self.childNode(withName: "levelNumberLabel") as! SKLabelNode
		countdownLabel = self.childNode(withName: "countdownLabel") as! SKLabelNode
        // Links objects to labels

        fontSize = 16
        labelSpacing = fontSize/1.5
		levelNumberLabel.position.y = self.frame.height/2 - topScreenBlock.size.height + labelSpacing*4
        levelNumberLabel.position.x = 0
        levelNumberLabel.fontSize = fontSize
		levelNumberLabel.isHidden = true
        scoreLabel.position.y = levelNumberLabel.position.y
        scoreLabel.position.x = -self.frame.width/2 + labelSpacing*2
        scoreLabel.fontSize = fontSize
        highScoreLabel.position.y = scoreLabel.position.y - labelSpacing*2
        highScoreLabel.position.x = scoreLabel.position.x
        highScoreLabel.fontSize = fontSize
		timerLabel.position.y = levelNumberLabel.position.y
        timerLabel.position.x = self.frame.width/2 - labelSpacing*2
        timerLabel.fontSize = fontSize
        bestTimeLabel.position.y = timerLabel.position.y - labelSpacing*2
        bestTimeLabel.position.x = timerLabel.position.x
        bestTimeLabel.fontSize = fontSize
		life.position.y = -self.frame.height/2 + bottomScreenBlock.size.height - labelSpacing*2
		life.position.x = -life.size.width/2
		livesLabel.position.y = life.position.y
        livesLabel.position.x = life.size.width/2
        livesLabel.fontSize = fontSize
		countdownLabel.isHidden = true
		countdownLabel.fontSize = fontSize*10
		countdownLabel.position.x = 0
		countdownLabel.position.y = 0
        // Label size & position definition
		
		pauseButtonSize = blockWidth*0.75
        pausedButton.size.width = pauseButtonSize
        pausedButton.size.height = pauseButtonSize
        pausedButton.texture = pauseTexture
		pausedButton.position.y = self.frame.height/2 - topScreenBlock.size.height + labelSpacing + pausedButton.size.height/2
        pausedButton.position.x = 0
		pausedButton.zPosition = 1
        pausedButton.isUserInteractionEnabled = false
		// Pause button size and position
		
//MARK: - Game Properties Initialisation
        
        ballMaxSpeed = ballMaxSet
        ballMinSpeed = ballMinSet
        ballLinearDampening = -0.005
		ballLaunchSpeed = 2
		// Ball speed parameters
		
		blockHitScore = 1
		blockDestroyScore = 5
		powerUpScore = 25
		lifeLostScore = -100
		levelCompleteScore = 100
		scoreFactor = 1
        
        level1TimeBonus = 200
        level2TimeBonus = 200
		level3TimeBonus = 200
        // Define level time bonus points
        
        endLevelNumber = 3
		// Define number of levels
		
//MARK: - Score Database Setup
        
        if let scoreStore = dataStore.array(forKey: "ScoreStore") as? [Int] {
            scoreArray = scoreStore
        }
        // Setup array to store all scores
		
        if let timerStore = dataStore.array(forKey: "TimerStore") as? [Double] {
            timerArray = timerStore
        }
        // Setup array to store all completed level timers
        
        print(NSHomeDirectory())
        // Prints the location of the NSUserDefaults plist (Library>Preferences)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: Notification.Name.myNotificationKey, object: nil)
        // Sets up an observer to watch for notifications from AppDelegate to check if the app has quit
        
        gameState.enter(PreGame.self)
        // Tell the state machine to enter the waiting for tap state
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    // Defines actions for a dragged touch
        
        if gameState.currentState is Playing {
            // Only executes code below when game state is playing
        
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            let previousLocation = touch!.previousLocation(in: self)
            // Define the current touch position and previous touch position
            
			var paddleX0 = CGFloat(0)
            var paddleX1 = CGFloat(0)
            // Define the property to store the x position of the paddle
            paddleMovedDistance = touchLocation.x - previousLocation.x
			paddleX0 = paddle.position.x
			paddleX1 = paddleX0 + (paddleMovedDistance*paddleMovementFactor)
			paddle.position = CGPoint(x: paddleX1, y: paddle.position.y)
            // Sets the paddle to match the touch's x position
			
			if ballIsOnPaddle && paddleMovedDistance != 0 {
				ball.position.x = ball.position.x + (paddle.position.x - paddleX0)
				ball.position.y = ballStartingPositionY
				paddleMoved = true
			}
			// Ball matches paddle position
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch gameState.currentState {
        case is Playing:
            touchBeganWhilstPlaying = true
            paddleMoved = false
        default:
            break
        }
        
        if gameState.currentState is Playing || gameState.currentState is Paused {
            let touch = touches.first
            let positionInScene = touch!.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            
            if let name = touchedNode.name {
                if name == "pauseButton" && gameState.currentState is Playing {
					gameState.enter(Paused.self)
                }
            }
        }
        // Pause the game if the pause button is pressed
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentSpeed < 1 && ballIsOnPaddle && touchBeganWhilstPlaying && paddleMoved == false && gameState.currentState is Playing {
            releaseBall()
        }
        touchBeganWhilstPlaying = false
        // Release the ball from the paddle only if the paddle has not been moved
    }
    
    func releaseBall() {
        
        if ball.hasActions() {
            ball.removeAllActions()
            // Stop animation actions on ball
            let fadeIn = SKAction.fadeIn(withDuration: 0)
            let scaleUp = SKAction.scale(to: 1, duration: 0)
            let resetGroup = SKAction.group([fadeIn, scaleUp])
            ball.run(resetGroup, completion: {
                self.ball.isHidden = false
            })
            // Reset ball on paddle immediately
        }
        
        if stickyPaddleCatches != 0 {
            stickyPaddleCatches-=1
            if stickyPaddleCatches == 0 {
                paddle.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
        
        let straightLaunchAngleRad = 90 * Double.pi / 180
        let minLaunchAngleRad = 10 * Double.pi / 180
        let maxLaunchAngleRad = 60 * Double.pi / 180
        var launchAngleMultiplier = 1
        
        ballPositionOnPaddle = Double((ball.position.x - paddle.position.x)/(paddle.size.width/2))
        // Define the relative position between the ball and paddle
        
        if ballPositionOnPaddle < 0 {
            launchAngleMultiplier = -1
        }
        // Determin which angle the ball will launch and modify the multiplier accordingly
        
        if ballPositionOnPaddle > 1 {
            ballPositionOnPaddle = 1
        } else if ballPositionOnPaddle < -1 {
            ballPositionOnPaddle = -1
        }
        // Limit ball position to bounds of paddle
        
        if ballPositionOnPaddle == 0 {
            let randomLaunchDirection = Bool.random()
            if randomLaunchDirection {
                ballLaunchAngleRad = straightLaunchAngleRad + minLaunchAngleRad
            } else {
                ballLaunchAngleRad = straightLaunchAngleRad - minLaunchAngleRad
            }
            // Randomise which direction the ball leaves the paddle if its in the middle
        } else {
            ballLaunchAngleRad = straightLaunchAngleRad - ((maxLaunchAngleRad - minLaunchAngleRad) * ballPositionOnPaddle + (minLaunchAngleRad * Double(launchAngleMultiplier)))
            // Determine the launch angle based on the location of the ball on the paddle
        }
        
        let dxLaunch = cos(ballLaunchAngleRad) * ballLaunchSpeed
        let dyLaunch = sin(ballLaunchAngleRad) * ballLaunchSpeed
        ball.physicsBody?.applyImpulse(CGVector(dx: dxLaunch, dy: dyLaunch))
        // Launches ball
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        // Haptic feedback
        
        startTimer()
        
        ballIsOnPaddle = false
        // Resets ball on paddle status
    }
    
    func startTimer() {
        let wait = SKAction.wait(forDuration: 0.01) //change countdown speed here
        let block = SKAction.run({
            self.levelTime += 0.01
            self.timerLabel.text = String(format: "%.2f", self.levelTime)
        })
        let timerSequence = SKAction.sequence([wait,block])
        self.run(SKAction.repeatForever(timerSequence), withKey: "levelTimer")
        pausedButton.texture = pauseTexture
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if gameState.currentState is Playing {
			xSpeed = ball.physicsBody!.velocity.dx
			ySpeed = ball.physicsBody!.velocity.dy
			currentSpeed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx + ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
			// Calculate ball speed
			
            if ball.position.y <= paddle.position.y - ballLostAnimationHeight {
                ballLostAnimation()
            }
            if ball.position.y <= paddle.position.y - ballLostHeight {
                ballLost()
            }
			// Determine if ball has been lost below paddle
			
			paddle.position.y = paddlePositionY
			// Ensure paddle remains at its set height
			
			if ballIsOnPaddle {
				ball.position.y = ballStartingPositionY
			}
			// Ensure ball remains on paddle
        }
        
        if gameState.currentState is Playing && ballIsOnPaddle == false {
            if currentSpeed > ballMaxSpeed {
				ball.physicsBody!.linearDamping = 0.5
            } else if currentSpeed < ballMinSpeed {
				ball.physicsBody!.linearDamping = -0.5
            } else {
                ball.physicsBody!.linearDamping = ballLinearDampening
            }
        }
        // Regulate ball's speed
    }
    
    func ballLost() {
        self.ball.isHidden = true
        ball.position.x = paddle.position.x
        ball.position.y = ballStartingPositionY
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        ballIsOnPaddle = true
        paddleMoved = true
        // Reset ball position
        
        levelScore = levelScore + lifeLostScore
        scoreLabel.text = String(levelScore)
        // Update score
        
        self.removeAction(forKey: "levelTimer")
        // Stop timer
        
        powerUpsReset()
        
        if numberOfLives == 0 {
            gameoverStatus = true
            gameState.enter(InbetweenLevels.self)
            return
        }
        if numberOfLives > 0 {
            
            let fadeOutLife = SKAction.fadeOut(withDuration: 0.25)
            let scaleDownLife = SKAction.scale(to: 0, duration: 0.25)
            let waitTimeLife = SKAction.wait(forDuration: 0.25)
            let fadeInLife = SKAction.fadeIn(withDuration: 0.25)
            let scaleUpLife = SKAction.scale(to: 1, duration: 0)
            let lifeLostGroup = SKAction.group([fadeOutLife, scaleDownLife, waitTimeLife])
            let wait = SKAction.sequence([waitTimeLife])
            let resetLifeGroup = SKAction.sequence([waitTimeLife, scaleUpLife, fadeInLife])
            // Setup life lost animation
            
            let fadeOutBall = SKAction.fadeOut(withDuration: 0)
            let scaleDownBall = SKAction.scale(to: 0, duration: 0)
            let waitTimeBall = SKAction.wait(forDuration: 0.25)
            let fadeInBall = SKAction.fadeIn(withDuration: 0.25)
            let scaleUpBall = SKAction.scale(to: 1, duration: 0.25)
            let resetBallGroup = SKAction.group([fadeOutBall, scaleDownBall, waitTimeBall])
            let ballGroup = SKAction.group([fadeInBall, scaleUpBall])
            // Setup ball animation
            
            self.life.run(wait, completion: {
                self.life.run(lifeLostGroup, completion: {
                    self.life.run(resetLifeGroup)
                    self.numberOfLives -= 1
                    self.livesLabel.text = "x\(self.numberOfLives)"
                })
            })
            // Update number of lives
            
            ball.run(resetBallGroup, completion: {
                self.ball.isHidden = false
                self.ball.run(ballGroup)
            })
            // Animate ball back onto paddle and loss of a life
        }
    }
    
    func ballLostAnimation() {
        let scaleDown = SKAction.scale(to: 0, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let ballLostGroup = SKAction.group([scaleDown, fadeOut])
        ball.run(ballLostGroup)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if gameState.currentState is Playing && ballIsOnPaddle == false {
            // Only executes code below when game state is playing
            
            contactCount+=1
            
            let ySpeedMin: CGFloat = 100
            let xSpeedMin: CGFloat = 5
            var xDirectionMultiplier: Int = 1
            var yDirectionMultiplier: Int = 1

            xSpeed = ball.physicsBody!.velocity.dx
            ySpeed = ball.physicsBody!.velocity.dy
            currentSpeed = sqrt(xSpeed*xSpeed + ySpeed*ySpeed)

            if xSpeed < 0 {
                xDirectionMultiplier = -1
            }
            if ySpeed < 0 {
                yDirectionMultiplier = -1
            }

            if ySpeed < ySpeedMin && ySpeed > 0 {
                ySpeed = ySpeedMin
                xSpeed = sqrt(currentSpeed*currentSpeed + ySpeed*ySpeed)*CGFloat(xDirectionMultiplier)
            } else if ySpeed > -ySpeedMin && ySpeed <= 0 {
                ySpeed = -ySpeedMin
                xSpeed = sqrt(currentSpeed*currentSpeed + ySpeed*ySpeed)*CGFloat(xDirectionMultiplier)
            } else if xSpeed < xSpeedMin && xSpeed > 0 {
                xSpeed = xSpeedMin
                ySpeed = sqrt(currentSpeed*currentSpeed + xSpeed*xSpeed)*CGFloat(yDirectionMultiplier)
            } else if xSpeed > -xSpeedMin && xSpeed <= 0 {
                xSpeed = -xSpeedMin
                ySpeed = sqrt(currentSpeed*currentSpeed + xSpeed*xSpeed)*CGFloat(yDirectionMultiplier)
            }
            // Adjust ball direction whilst preserving speed if angle in x or y is too shallow

            ball.physicsBody!.velocity.dx = xSpeed
            ball.physicsBody!.velocity.dy = ySpeed
            
        }
            
        if gameState.currentState is Playing {
        
            var firstBody: SKPhysicsBody
            var secondBody: SKPhysicsBody
            // Local variables to hold the two physics bodies involved in a collision.
            
            if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
                firstBody = contact.bodyA
                secondBody = contact.bodyB
            } else {
                firstBody = contact.bodyB
                secondBody = contact.bodyA
            }
            // Stores the 2 bodies, with the body with the lower category being first

            if firstBody.categoryBitMask == CollisionTypes.ballCategory.rawValue && secondBody.categoryBitMask == CollisionTypes.blockCategory.rawValue {
                if let blockNode = secondBody.node {
                    hitBlock(node: blockNode, sprite: blockNode as! SKSpriteNode)
                }
            }
            // Hit block if it makes contact with ball
            
            if firstBody.categoryBitMask == CollisionTypes.ballCategory.rawValue && secondBody.categoryBitMask == CollisionTypes.paddleCategory.rawValue {
                paddleHit()
            }
            // Hit ball if it makes contact with paddle
            
            if firstBody.categoryBitMask == CollisionTypes.blockCategory.rawValue && secondBody.categoryBitMask == CollisionTypes.laserCategory.rawValue {
                if let blockNode = firstBody.node {
					hitBlock(node: blockNode, sprite: blockNode as! SKSpriteNode, laserNode: secondBody.node!, laserSprite: (secondBody.node as! SKSpriteNode))
                }
            }
            // Hit laser if it makes contact with block
			
			if firstBody.categoryBitMask == CollisionTypes.screenBlockCategory.rawValue && secondBody.categoryBitMask == CollisionTypes.laserCategory.rawValue {
				if let laserNode = secondBody.node {
					laserNode.removeFromParent()
                }
            }
            // Hit laser if it makes contact with screenBlock
            
            if firstBody.categoryBitMask == CollisionTypes.paddleCategory.rawValue && secondBody.categoryBitMask == CollisionTypes.powerUpCategory.rawValue {
                applyPowerUp(sprite: secondBody.node! as! SKSpriteNode)
                secondBody.node!.removeAllActions()
                secondBody.node!.removeFromParent()
            }
            // Collect power up if it makes contact with paddle
			
            if firstBody.categoryBitMask == CollisionTypes.screenBlockCategory.rawValue && secondBody.categoryBitMask == CollisionTypes.powerUpCategory.rawValue {
                secondBody.node!.removeAllActions()
                secondBody.node!.removeFromParent()
            }
            // Remove power up if it makes contact with bottomScreenBlock
        }
    }
    
    func hitBlock(node: SKNode, sprite: SKSpriteNode, laserNode: SKNode? = nil, laserSprite: SKSpriteNode? = nil) {
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        // Haptic feedback
        
        if laserSprite?.texture == laserTexture {
            laserNode?.removeFromParent()
        }
        // Remove laser if superball power up isn't activated
        
        switch sprite.texture {
        case blockTexture:
            removeBlock(node: node, sprite: sprite)
            break
        case blockDouble1Texture:
            sprite.texture = blockDouble2Texture
            levelScore = levelScore + blockHitScore*scoreFactor
            break
        case blockDouble2Texture:
            sprite.texture = blockDouble3Texture
            levelScore = levelScore + blockHitScore*scoreFactor
            break
        case blockDouble3Texture:
            removeBlock(node: node, sprite: sprite)
            break
        case blockInvisibleTexture:
            if sprite.isHidden {
                let scaleDown = SKAction.scale(to: 0, duration: 0)
                let fadeOut = SKAction.fadeOut(withDuration: 0)
                let resetGroup = SKAction.group([scaleDown, fadeOut])
                let scaleUp = SKAction.scale(to: 1, duration: 0.1)
                let fadeIn = SKAction.fadeIn(withDuration: 0.1)
                let blockHitGroup = SKAction.group([scaleUp, fadeIn])
                sprite.run(resetGroup, completion: {
                    sprite.isHidden = false
                    sprite.run(blockHitGroup)
                })
                // Animate block in

                levelScore = levelScore + blockHitScore*scoreFactor
                break
            }
            removeBlock(node: node, sprite: sprite)
            break
        default:
            break
        }
        scoreLabel.text = String(levelScore)
        // Update score
    }
    // This method takes an SKNode. First, it creates an instance of SKEmitterNode from the BrokenPlatform.sks file, then sets it's position to the same position as the node. The emitter node's zPosition is set to 3, so that the particles appear above the remaining blocks. After the particles are added to the scene, the node (bamboo block) is removed.
    
    func removeBlock(node: SKNode, sprite: SKSpriteNode) {
        
        node.removeFromParent()
        // Remove block
        
        let powerUpProb = Int.random(in: 1...10)
        if powerUpProb == 1 && blocksLeft != 1 {
            powerUpGenerator(sprite: sprite)
        }
        // 1 in 10 probability of getting a power up if block is removed
        
        blocksLeft -= 1
        levelScore = levelScore + blockDestroyScore*scoreFactor
        scoreLabel.text = String(levelScore)
        // Update number of blocks left and current score
        
        if blocksLeft == 0 {
            if levelNumber == endLevelNumber {
                gameoverStatus = true
            }
            gameState.enter(InbetweenLevels.self)
        }
        // Loads the next level or ends the game if all blocks have been removed
    }
    
    func paddleHit() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        // Haptic feedback
        
        contactCount = 0
        
		let paddleLeftEdgePosition = paddle.position.x - paddle.size.width/2
		let paddleRightEdgePosition = paddle.position.x + paddle.size.width/2
		let stickyPaddleTolerance = paddle.size.width*0.05
		
		if ball.position.x > paddleLeftEdgePosition + stickyPaddleTolerance && ball.position.x < paddleRightEdgePosition - stickyPaddleTolerance && stickyPaddleCatches != 0 {
			// Catch the ball if the sticky paddle power up is applied and the ball hits the centre of the paddle
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
			// reposition ball within boundries of paddle
            ballIsOnPaddle = true
            paddleMoved = true
            ball.position.y = ballStartingPositionY
			
            
        } else {
        
            let collisionPercentage = Double((ball.position.x - paddle.position.x)/(paddle.size.width/2))
            // Define collision position between the ball and paddle
            
            if collisionPercentage < 1 && collisionPercentage > -1 && ball.position.y > paddle.position.y {
            // Only apply if the ball hits the paddles top surface
				
				let ySpeedCorrected: Double = sqrt(Double(ySpeed*ySpeed))
				// Assumes the ball's ySpeed is always positive
                var angleRad = atan2(Double(ySpeedCorrected), Double(xSpeed))
                // Variables to hold the angle and speed of the ball
                
                angleRad = angleRad - ((angleAdjustmentK * Double.pi / 180) * collisionPercentage)
                // Angle adjustment formula
                
                if angleRad > 0 {
                    angleRad = angleRad + Double.random(in: (-angleRad/10)...angleRad/10)
                } else {
                    angleRad = angleRad + Double.random(in: angleRad/10...(-angleRad/10))
                }
                // Adds a small element of randomness into the ball's angle
                
                if angleRad < (minAngleDeg * Double.pi / 180) {
                    angleRad = (minAngleDeg * Double.pi / 180)
                }
                if angleRad > (maxAngleDeg * Double.pi / 180) {
                    angleRad = (maxAngleDeg * Double.pi / 180)
                }
                if angleRad >= (90 * Double.pi / 180) && angleRad <= (91 * Double.pi / 180) {
                    angleRad = (91 * Double.pi / 180)
                }
                if angleRad < (90 * Double.pi / 180) && angleRad >= (89 * Double.pi / 180) {
                    angleRad = (89 * Double.pi / 180)
                }
                // Changes the angle of the ball based on where it hits the paddle
                
                xSpeed = CGFloat(cos(angleRad)) * currentSpeed
                ySpeed = CGFloat(sin(angleRad)) * currentSpeed
                ball.physicsBody!.velocity.dx = xSpeed
                ball.physicsBody!.velocity.dy = ySpeed
                // Set the new speed and angle of the ball
            }
        }
    }

    func pauseGame() {
        if gameState.currentState is Paused {
            pausedButton.texture = playTexture
            self.isPaused = true
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            // Haptic feedback
            removeAction(forKey: "levelTimer")
            // Stop timer
        }
    }
    
    func unpauseGame() {
        if gameState.currentState is Paused {
            pausedButton.texture = pauseTexture
            self.isPaused = false
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            // Haptic feedback
            if ballIsOnPaddle == false {
                startTimer()
            }
            // Restart timer if ball was paused whilst in play
            gameState.enter(Playing.self)
        }
    }
    
    @objc func notificationReceived(_ notification: Notification) {
        pauseGame()
    }
    // Pause the game if a notifcation from AppDelegate is received that the game will quit
    
    func powerUpGenerator (sprite: SKSpriteNode) {
        
        let powerUp = SKSpriteNode(imageNamed: "PowerUp00")
        
        powerUp.size.width = blockWidth
        powerUp.size.height = powerUp.size.width
        powerUp.position = CGPoint(x: sprite.position.x, y: sprite.position.y)
        powerUp.physicsBody = SKPhysicsBody(rectangleOf: powerUp.frame.size)
        powerUp.physicsBody!.allowsRotation = false
        powerUp.physicsBody!.friction = 0.0
        powerUp.physicsBody!.affectedByGravity = false
        powerUp.physicsBody!.isDynamic = false
		powerUp.physicsBody!.mass = 0
        powerUp.name = PowerUpCategoryName
        powerUp.physicsBody!.categoryBitMask = CollisionTypes.powerUpCategory.rawValue
		powerUp.physicsBody!.collisionBitMask = CollisionTypes.paddleCategory.rawValue
		powerUp.physicsBody!.contactTestBitMask = CollisionTypes.paddleCategory.rawValue
        powerUp.zPosition = 1
        addChild(powerUp)
        
        let powerUpProb = Int.random(in: 0...20)
        switch powerUpProb {
        case 0:
            powerUp.texture = powerUp00Texture
			// Get a life
        case 1:
            powerUp.texture = powerUp01Texture
			// Reduce ball speed
        case 2:
            powerUp.texture = powerUp02Texture
			// Superball
        case 3:
            powerUp.texture = powerUp03Texture
			// Sticky paddle
        case 4:
            powerUp.texture = powerUp04Texture
			// Next level
        case 5:
            powerUp.texture = powerUp05Texture
			// Increase paddle size
        case 6:
            powerUp.texture = powerUp06Texture
			// Invisible blocks become visible
        case 7:
            powerUp.texture = powerUp07Texture
			// Lasers
		case 8:
            powerUp.texture = powerUp08Texture
			// Indestructible blocks become multi-hit blocks
		case 9:
			powerUp.texture = powerUp09Texture
			// Multi-hit blocks become normal blocks
        case 10:
            powerUp.texture = powerUp90Texture
			// Lose a life
        case 11:
            powerUp.texture = powerUp91Texture
			// Increase ball speed
        case 12:
            powerUp.texture = powerUp92Texture
			// Undestructiball
		case 13:
			powerUp.texture = powerUp93Texture
			// Decrease paddle size
		case 14:
			powerUp.texture = powerUp94Texture
			// Double points
		case 15:
			powerUp.texture = powerUp95Texture
			// 1000 points
		case 16:
			powerUp.texture = powerUp96Texture
			// -1000 points
		case 17:
			powerUp.texture = powerUp97Texture
			// Normal blocks become invisble blocks
		case 18:
			powerUp.texture = powerUp98Texture
			// Normal blocks become multi-hit blocks
		case 19:
			powerUp.texture = powerUp99Texture
			// Gravity ball
		case 20:
			powerUp.texture = powerUp10Texture
			// Mystery power-up
        default:
            break
        }
        
        let move = SKAction.moveBy(x: 0, y: -self.frame.height, duration: 5)
        powerUp.run(move, completion: {
            powerUp.removeFromParent()
        })
    }
    
    func applyPowerUp (sprite: SKSpriteNode) {
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        // Haptic feedback

        switch sprite.texture {
            
        case powerUp00Texture:
        // Get a life
            numberOfLives+=1
            livesLabel.text = "x\(numberOfLives)"
            powerUpScore = 25
            
        case powerUp90Texture:
        // Lose a life
            ballLostAnimation()
            self.run(SKAction.wait(forDuration: 0.2), completion: {
                self.ballLost()
            })
            powerUpScore = 0
            
        case powerUp01Texture:
        // Reduce ball speed
			self.removeAction(forKey: "powerUp01")
			self.removeAction(forKey: "powerUp91")
			// Remove any current ball speed power up timers
			if ballMinSpeed >= ballMinLimit + ballSpeedChange {
				ballMaxSpeed = ballMaxSpeed - ballSpeedChange
				ballMinSpeed = ballMinSpeed - ballSpeedChange
			}
            powerUpScore = 25
			// Power up set
            let powerUp01Timer: Double = 10
            let powerUp01Wait = SKAction.wait(forDuration: powerUp01Timer)
			let completionBlock01 = SKAction.run {
				self.ballMaxSpeed = self.ballMaxSet
				self.ballMinSpeed = self.ballMinSet
            }
            let powerUp01Sequence = SKAction.sequence([powerUp01Wait, completionBlock01])
            self.run(powerUp01Sequence, withKey: "powerUp01")
            // Power up reverted
            
        case powerUp91Texture:
        // Increase ball speed
			self.removeAction(forKey: "powerUp01")
			self.removeAction(forKey: "powerUp91")
			// Remove any current ball speed power up timers
			if ballMaxSpeed <= ballMaxLimit - ballSpeedChange {
				ballMaxSpeed = ballMaxSpeed + ballSpeedChange
				ballMinSpeed = ballMinSpeed + ballSpeedChange
			}
            powerUpScore = -25
            // Power up set
            let powerUp91Timer: Double = 10
            let powerUp91Wait = SKAction.wait(forDuration: powerUp91Timer)
			let completionBlock91 = SKAction.run {
				self.ballMaxSpeed = self.ballMaxSet
				self.ballMinSpeed = self.ballMinSet
            }
            let powerUp91Sequence = SKAction.sequence([powerUp91Wait, completionBlock91])
            self.run(powerUp91Sequence, withKey: "powerUp91")
            // Power up reverted
            
        case powerUp02Texture:
        // Superball
            self.removeAction(forKey: "powerUp02")
            // Remove any current superball power up timer
            self.removeAction(forKey: "powerUp92")
            ball.texture = superballTexture
            ball.physicsBody!.contactTestBitMask = CollisionTypes.blockCategory.rawValue | CollisionTypes.paddleCategory.rawValue
            // Reset undestructiball power up
            ball.physicsBody!.collisionBitMask = CollisionTypes.paddleCategory.rawValue | CollisionTypes.screenBlockCategory.rawValue
            powerUpScore = 25
            // Power up set
            let powerUp02Timer: Double = 10
            let powerUp02Wait = SKAction.wait(forDuration: powerUp02Timer)
            let completionBlock02 = SKAction.run {
				self.ball.physicsBody!.collisionBitMask = CollisionTypes.blockCategory.rawValue | CollisionTypes.paddleCategory.rawValue | CollisionTypes.screenBlockCategory.rawValue
                self.ball.texture = self.ballTexture
            }
            let powerUp02Sequence = SKAction.sequence([powerUp02Wait, completionBlock02])
            self.run(powerUp02Sequence, withKey: "powerUp02")
            // Power up reverted
            
        case powerUp92Texture:
        // Undestructiball
            self.removeAction(forKey: "powerUp92")
            // Remove any current undestructiball power up timer
            self.removeAction(forKey: "powerUp02")
            ball.texture = undestructiballTexture
            ball.physicsBody!.collisionBitMask = CollisionTypes.blockCategory.rawValue | CollisionTypes.paddleCategory.rawValue | CollisionTypes.screenBlockCategory.rawValue
            // Reset superball power up
            ball.physicsBody!.contactTestBitMask = CollisionTypes.paddleCategory.rawValue
            powerUpScore = -25
            // Power up set
            let powerUp92Timer: Double = 10
            let powerUp92Wait = SKAction.wait(forDuration: powerUp92Timer)
            let completionBlock92 = SKAction.run {
                self.ball.physicsBody!.contactTestBitMask = CollisionTypes.blockCategory.rawValue | CollisionTypes.paddleCategory.rawValue
                self.ball.texture = self.ballTexture
            }
            let powerUp92Sequence = SKAction.sequence([powerUp92Wait, completionBlock92])
            self.run(powerUp92Sequence, withKey: "powerUp92")
            // Power up reverted

        case powerUp03Texture:
        // Sticky paddle
            stickyPaddleCatches = 5
            powerUpScore = 25
            paddle.color = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            // Power up set and limit number of catches per power up
            
        case powerUp04Texture:
        // Next level
            powerUpScore = 25
            if levelNumber == endLevelNumber {
                gameoverStatus = true
            }
            gameState.enter(InbetweenLevels.self)
            
        case powerUp05Texture:
        // Increase paddle size
            self.removeAction(forKey: "powerUp05")
            self.removeAction(forKey: "powerUp93")
            // Remove any current timer for paddle size power ups
            if paddle.size.width <= frame.size.width/2 {
                lightHaptic.impactOccurred()
                paddle.run(SKAction.scaleX(by: 1.5, y: 1, duration: 0.2), completion: {
                    self.definePaddleProperties()
                })
            }
            powerUpScore = 25
            // Power up set
            let powerUp05Timer: Double = 10
            let powerUp05Wait = SKAction.wait(forDuration: powerUp05Timer)
            let completionBlock05 = SKAction.run {
                self.lightHaptic.impactOccurred()
                self.paddle.run(SKAction.scaleX(to: 1, duration: 0.2), completion: {
                    self.paddle.size.width = self.paddleWidth
                    self.definePaddleProperties()
                })
                if self.ballIsOnPaddle {
                    self.releaseBall()
                }
            }
            let powerUp05Sequence = SKAction.sequence([powerUp05Wait, completionBlock05])
            self.run(powerUp05Sequence, withKey: "powerUp05")
            // Power up reverted
            
        case powerUp93Texture:
        // Decrease paddle size
            self.removeAction(forKey: "powerUp93")
            self.removeAction(forKey: "powerUp05")
            // Remove any current timer for paddle size power ups
            if paddle.size.width >= frame.size.width/8 {
                lightHaptic.impactOccurred()
                paddle.run(SKAction.scaleX(by: 0.67, y: 1, duration: 0.2), completion: {
                    self.definePaddleProperties()
                })
                if ballIsOnPaddle {
                    releaseBall()
                }
            }
            powerUpScore = -25
            // Power up set
            let powerUp93Timer: Double = 10
            let powerUp93Wait = SKAction.wait(forDuration: powerUp93Timer)
            let completionBlock93 = SKAction.run {
                self.lightHaptic.impactOccurred()
                self.paddle.run(SKAction.scaleX(to: 1, duration: 0.2), completion: {
                    self.paddle.size.width = self.paddleWidth
                    self.definePaddleProperties()
                })
            }
            let powerUp93Sequence = SKAction.sequence([powerUp93Wait, completionBlock93])
            self.run(powerUp93Sequence, withKey: "powerUp93")
            // Power up reverted
            
        case powerUp07Texture:
        // Lasers
            self.removeAction(forKey: "powerUp07")
            laserTimer?.invalidate()
            // Remove any current timer for lasers
            laserPowerUpIsOn = true
            laserTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(laserGenerator), userInfo: nil, repeats: true)
			powerUpScore = 25
            // Power up set - lasers will fire every 0.1s
            let powerUp07Timer: Double = 10
            let powerUp07Wait = SKAction.wait(forDuration: powerUp07Timer)
            let completionBlock07 = SKAction.run {
                self.laserTimer?.invalidate()
            }
            let powerUp07Sequence = SKAction.sequence([powerUp07Wait, completionBlock07])
            self.run(powerUp07Sequence, withKey: "powerUp07")
            // Power up reverted - lasers will fire for 10s
			
		case powerUp06Texture:
		// Invisible blocks become visible
			enumerateChildNodes(withName: BlockCategoryName) { (node, _) in
				if node.isHidden == true {
					let startingScale = SKAction.scale(to: 0, duration: 0)
					let startingFade = SKAction.fadeOut(withDuration: 0)
					let scaleUp = SKAction.scale(to: 1, duration: 0.5)
					let fadeIn = SKAction.fadeIn(withDuration: 0.5)
					let startingGroup = SKAction.group([startingFade, startingScale])
					let blockGroup = SKAction.group([scaleUp, fadeIn])
					node.run(startingGroup, completion: {
						node.isHidden = false
						node.run(blockGroup)
					})
				}
			}
			powerUpScore = 25
			// Power up set
			
		case powerUp08Texture:
		// Indestructible blocks become multi-hit blocks
			enumerateChildNodes(withName: BlockCategoryName) { (node, _) in
				let sprite = node as! SKSpriteNode
				if sprite.texture == self.blockIndestructibleTexture {
					sprite.texture = self.blockDouble1Texture
					self.blocksLeft += 1
				}
			}
			powerUpScore = 25
			// Power up set
			
		case powerUp09Texture:
		// Multi-hit blocks become normal blocks
			enumerateChildNodes(withName: BlockCategoryName) { (node, _) in
				let sprite = node as! SKSpriteNode
				if sprite.texture == self.blockDouble1Texture || sprite.texture == self.blockDouble2Texture || sprite.texture == self.blockDouble3Texture {
					sprite.texture = self.blockTexture
				}
			}
			powerUpScore = 25
			// Power up set
		
		case powerUp94Texture:
		// Double points
			self.removeAction(forKey: "powerUp94")
			// Remove any current double points timers
			scoreFactor = scoreFactor*2
			powerUpScore = 25
			// Power up set
			let powerUp94Timer: Double = 10
			let powerUp94Wait = SKAction.wait(forDuration: powerUp94Timer)
			let completionBlock94 = SKAction.run {
				self.scoreFactor = 1
			}
			let powerUp94Sequence = SKAction.sequence([powerUp94Wait, completionBlock94])
			self.run(powerUp94Sequence, withKey: "powerUp94")
			// Power up reverted
			
		case powerUp95Texture:
		// 1000 points
			powerUpScore = 1000
			// Power up set
			
		case powerUp96Texture:
		// -1000 points
			powerUpScore = -1000
			// Power up set
			
		case powerUp97Texture:
		// Normal blocks become invisble blocks
			enumerateChildNodes(withName: BlockCategoryName) { (node, _) in
				let sprite = node as! SKSpriteNode
				if sprite.texture == self.blockTexture {
					sprite.texture = self.blockInvisibleTexture
					sprite.isHidden = true
				}
			}
			powerUpScore = -25
			// Power up set
			
		case powerUp98Texture:
		// Normal blocks become multi-hit blocks
			enumerateChildNodes(withName: BlockCategoryName) { (node, _) in
				let sprite = node as! SKSpriteNode
				if sprite.texture == self.blockTexture {
					sprite.texture = self.blockDouble1Texture
				}
			}
			powerUpScore = -25
			// Power up set
			
		case powerUp99Texture:
		// Gravity ball
			self.removeAction(forKey: "powerUp99")
			// Remove any current gravity timers
			physicsWorld.gravity = CGVector(dx: 0, dy: -1.62)
			ball.physicsBody!.affectedByGravity = true
			powerUpScore = -25
			// Power up set
			let powerUp99Timer: Double = 10
			let powerUp99Wait = SKAction.wait(forDuration: powerUp99Timer)
			let completionBlock99 = SKAction.run {
				self.ball.physicsBody!.affectedByGravity = false
			}
			let powerUp99Sequence = SKAction.sequence([powerUp99Wait, completionBlock99])
			self.run(powerUp99Sequence, withKey: "powerUp99")
			// Power up reverted
			
		case powerUp10Texture:
		// Mystery power-up
			powerUpScore = 0
			
			powerUpGenerator (sprite: sprite)
			

			
        default:
            break
        }
        // Identify power up and perform action
        
        levelScore = levelScore + powerUpScore*scoreFactor
        scoreLabel.text = String(levelScore)
        // Update score
    }
    
    func powerUpsReset() {
        self.removeAllActions()
        // Stop all timers
        paddle.size.width = paddleWidth
        ball.physicsBody!.collisionBitMask = CollisionTypes.blockCategory.rawValue | CollisionTypes.paddleCategory.rawValue | CollisionTypes.screenBlockCategory.rawValue
        ball.physicsBody!.contactTestBitMask = CollisionTypes.blockCategory.rawValue | CollisionTypes.paddleCategory.rawValue
        stickyPaddleCatches = 0
        paddle.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ball.texture = ballTexture
		ballMinSpeed = ballMinSet
		ballMaxSpeed = ballMaxSet
        definePaddleProperties()
        laserPowerUpIsOn = false
        laserTimer?.invalidate()
		scoreFactor = 1
		physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		ball.physicsBody!.affectedByGravity = false
    }
    
    func moveToMainMenu() {
        gameViewControllerDelegate?.moveToMainMenu()
    }
    // Function to return to the MainViewController from the GameViewController, run as a delegate from GameViewController
    
    func showEndLevelStats() {
        gameViewControllerDelegate?.showEndLevelStats(levelNumber: levelNumber, levelScore: levelScore, levelTime: levelTime, cumulativeScore: cumulativeScore, cumulativeTime: cumulativeTimerValue, levelHighscore: 5, levelBestTime: 6.0, bestScoreToLevel: 7, bestTimeToLevel: 8.0, cumulativeHighscore: 9, gameoverStatus: gameoverStatus)
    }
	
	func showPauseMenu() {
        gameViewControllerDelegate?.showPauseMenu(levelNumber: levelNumber)
    }
    
    func definePaddleProperties() {
		paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.frame.size)
        paddle.physicsBody!.allowsRotation = false
        paddle.physicsBody!.friction = 0.0
        paddle.physicsBody!.affectedByGravity = false
        paddle.physicsBody!.isDynamic = true
        paddle.name = PaddleCategoryName
        paddle.physicsBody!.categoryBitMask = CollisionTypes.paddleCategory.rawValue
		paddle.physicsBody!.collisionBitMask = CollisionTypes.paddleCategory.rawValue
        paddle.zPosition = 2
        // Define paddle properties
        let xRangePaddle = SKRange(lowerLimit:-self.frame.width/2 + paddle.size.width/2,upperLimit:self.frame.width/2 - paddle.size.width/2)
        paddle.constraints = [SKConstraint.positionX(xRangePaddle)]
        // Stops the paddle leaving the screen
    }
    
    @objc func laserGenerator() {
        
        let laser = SKSpriteNode(imageNamed: "Laser")
        
        laser.size.height = blockHeight/2
        laser.size.width = laser.size.height * 0.67
        
        if laserSideLeft {
            laser.position = CGPoint(x: paddle.position.x - paddle.size.width/2, y: paddle.position.y + paddle.size.height/2)
            laserSideLeft = false
            // Left position
        } else {
            laser.position = CGPoint(x: paddle.position.x + paddle.size.width/2, y: paddle.position.y + paddle.size.height/2)
            laserSideLeft = true
            // Right position
        }
        // Alternate position of laser on paddle
        
        laser.texture = laserTexture
        laser.physicsBody = SKPhysicsBody(rectangleOf: laser.frame.size)
        laser.physicsBody!.allowsRotation = false
        laser.physicsBody!.friction = 0.0
        laser.physicsBody!.affectedByGravity = false
        laser.physicsBody!.isDynamic = true
        laser.name = LaserCategoryName
        laser.physicsBody!.categoryBitMask = CollisionTypes.laserCategory.rawValue
		laser.physicsBody!.collisionBitMask = CollisionTypes.blockCategory.rawValue | CollisionTypes.screenBlockCategory.rawValue
		laser.physicsBody!.contactTestBitMask = CollisionTypes.blockCategory.rawValue | CollisionTypes.screenBlockCategory.rawValue
		laser.physicsBody!.usesPreciseCollisionDetection = true
        laser.zPosition = 1
        // Define laser properties
        
        if ball.texture == superballTexture {
            laser.physicsBody!.collisionBitMask = 0
            laser.texture = superLaserTexture
        }
        // if superball power up is activated, allow laser to pass through blocks
        
        addChild(laser)
        
        let move = SKAction.moveBy(x: 0, y: self.frame.height, duration: 2)
        laser.run(move, completion: {
            laser.removeFromParent()
        })
        // Define laser movement
    }
    
}

extension Notification.Name {
    public static let myNotificationKey = Notification.Name(rawValue: "myNotificationKey")
}
// Setup for notifcation from AppDelegate

//MARK: - Action List
/***************************************************************/

//TODO: - [Name Of To Do]

//FIXME: - [Name Of Fix Me]

//ERROR: [Name Of Error]

//!!!: - [Name Of Issue]

//???: - [Name Of Issue]


