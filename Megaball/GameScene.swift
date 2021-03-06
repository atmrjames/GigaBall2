//
//  GameScene.swift
//  Megaball
//
//  Created by James Harding on 18/08/2019.
//  Copyright © 2019 James Harding. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameKit
//import GameKit

let PaddleCategoryName = "paddle"
let BallCategoryName = "ball"
let BrickCategoryName = "brick"
let BrickRemovalCategoryName = "brickRemoval"
let PowerUpCategoryName = "powerUp"
let LaserCategoryName = "laser"
let PowerIconCategoryName = "powerUpIcon"
let BackstopCategoryName = "backStop"
// Set up for categoryNames

enum CollisionTypes: UInt32 {
    case ballCategory = 1
    case brickCategory = 2
    case paddleCategory = 4
	case screenBlockCategory = 8
    case powerUpCategory = 16
    case laserCategory = 32
	case boarderCategory = 64
	case bottomScreenBlockCategory = 128
	case backstopCategory = 256
}
// Setup for collisionBitMask

//The categoryBitMask property is a number defining the type of object this is for considering collisions.
//The collisionBitMask property is a number defining what categories of object this node should collide with.
//The contactTestBitMask property is a number defining which collisions we want to be notified about.

//If you give a node a collision bitmask but not a contact test bitmask, it means they will bounce off each other but you won't be notified.
//If you give a node contact test but not collision bitmask it means they won't bounce off each other but you will be told when they overlap.

protocol GameViewControllerDelegate: class {
	func moveToMainMenu()
	func showPauseMenu(levelNumber: Int, numberOfLevels: Int, score: Int, packNumber: Int, height: Int, sender: String, gameoverBool: Bool)
	func showInbetweenView(levelNumber: Int, score: Int, packNumber: Int)
	func createInterstitial()
	func loadInterstitial()
	var selectedLevel: Int? { get set }
	var numberOfLevels: Int? { get set }
	var levelSender: String? { get set }
	var levelPack: Int? { get set }
}
// Setup the protocol to return to the main menu from GameViewController

class GameScene: SKScene, SKPhysicsContactDelegate {
	
	var backgroundMusic: SKAudioNode!
	// Setup game music
    
    var paddle = SKSpriteNode()
	var paddleLaser = SKSpriteNode()
	var paddleSticky = SKSpriteNode()
    var ball = SKSpriteNode()
    var brick = SKSpriteNode()
    var life = SKSpriteNode()
	var topScreenBlock = SKSpriteNode()
	var bottomScreenBlock = SKSpriteNode()
	var sideScreenBlockLeft = SKSpriteNode()
	var sideScreenBlockRight = SKSpriteNode()
	var background = SKSpriteNode()
	var directionMarker = SKSpriteNode()
	var backstop = SKSpriteNode()
    // Define objects
	
	let brickBlue: UIColor = #colorLiteral(red: 0.3137254902, green: 0.8352941176, blue: 0.8901960784, alpha: 1)
	let brickBlueDark: UIColor = #colorLiteral(red: 0, green: 0.462745098, blue: 1, alpha: 1)
	let brickBlueDarkExtra: UIColor = #colorLiteral(red: 0, green: 0.2274509804, blue: 0.4901960784, alpha: 1)
	let brickBlueLight: UIColor = #colorLiteral(red: 0.4941176471, green: 0.7254901961, blue: 1, alpha: 1)
	let brickBrown: UIColor = #colorLiteral(red: 0.6078431373, green: 0.2274509804, blue: 0, alpha: 1)
	let brickBrownLight: UIColor = #colorLiteral(red: 0.8509803922, green: 0.4784313725, blue: 0.2588235294, alpha: 1)
	let brickGreen: UIColor = #colorLiteral(red: 0.1137254902, green: 0.6156862745, blue: 0.1058823529, alpha: 1)
	let brickGreenDark: UIColor = #colorLiteral(red: 0.007843137255, green: 0.3843137255, blue: 0, alpha: 1)
	let brickGreenGigaball: UIColor = #colorLiteral(red: 0.8235294118, green: 1, blue: 0, alpha: 1)
	let brickGreenLight: UIColor = #colorLiteral(red: 0.5215686275, green: 1, blue: 0.5137254902, alpha: 1)
	let brickGreenSI: UIColor = #colorLiteral(red: 0.02352941176, green: 1, blue: 0, alpha: 1)
	let brickGrey: UIColor = #colorLiteral(red: 0.4196078431, green: 0.4196078431, blue: 0.4196078431, alpha: 1)
	let brickGreyDark: UIColor = #colorLiteral(red: 0.2431372549, green: 0.2431372549, blue: 0.2431372549, alpha: 1)
	let brickGreyLight: UIColor = #colorLiteral(red: 0.6901960784, green: 0.6862745098, blue: 0.6862745098, alpha: 1)
	let brickOrange: UIColor = #colorLiteral(red: 0.9725490196, green: 0.4274509804, blue: 0.1098039216, alpha: 1)
	let brickOrangeDark: UIColor = #colorLiteral(red: 0.7764705882, green: 0.3098039216, blue: 0.03529411765, alpha: 1)
	let brickOrangeLight: UIColor = #colorLiteral(red: 1, green: 0.6392156863, blue: 0.4274509804, alpha: 1)
	let brickPink: UIColor = #colorLiteral(red: 1, green: 0.3921568627, blue: 0.5960784314, alpha: 1)
	let brickPurple: UIColor = #colorLiteral(red: 0.6156862745, green: 0.2352941176, blue: 0.8274509804, alpha: 1)
	let brickPurpleDark: UIColor = #colorLiteral(red: 0.3568627451, green: 0.03529411765, blue: 0.5333333333, alpha: 1)
	let brickWhite: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
	let brickYellow: UIColor = #colorLiteral(red: 0.9725490196, green: 0.9058823529, blue: 0.1098039216, alpha: 1)
	let brickYellowDark: UIColor = #colorLiteral(red: 0.8901960784, green: 0.7411764706, blue: 0.05098039216, alpha: 1)
	let brickYellowLight: UIColor = #colorLiteral(red: 1, green: 0.968627451, blue: 0.5725490196, alpha: 1)
	// Brick colours
    
    var livesLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
	var multiplierLabel = SKLabelNode()
	var readyCountdown = SKSpriteNode()
	var goCountdown = SKSpriteNode()
	
	var buildLabel = SKLabelNode()
    // Define labels
    
    var pauseButton = SKSpriteNode()
	var pauseButtonSize: CGFloat = 0
	var pauseButtonTouch = SKSpriteNode()
    // Define buttons
	
	var paddleSizeIcon = SKSpriteNode()
	var ballSpeedIcon = SKSpriteNode()
	var stickyPaddleIcon = SKSpriteNode()
	var gravityIcon = SKSpriteNode()
	var lasersIcon = SKSpriteNode()
	var gigaBallIcon = SKSpriteNode()
	var hiddenBricksIcon = SKSpriteNode()
	var ballSizeIcon = SKSpriteNode()
	// Power-up icons
	
	var paddleSizeIconBar = SKSpriteNode()
	var ballSpeedIconBar = SKSpriteNode()
	var stickyPaddleIconBar = SKSpriteNode()
	var gravityIconBar = SKSpriteNode()
	var lasersIconBar = SKSpriteNode()
	var gigaBallIconBar = SKSpriteNode()
	var hiddenBricksIconBar = SKSpriteNode()
	var ballSizeIconBar = SKSpriteNode()
	// Power-up progress bars
	
	var paddleSizeIconEmptyBar = SKSpriteNode()
	var ballSpeedIconEmptyBar = SKSpriteNode()
	var stickyPaddleIconEmptyBar = SKSpriteNode()
	var gravityIconEmptyBar = SKSpriteNode()
	var lasersIconEmptyBar = SKSpriteNode()
	var gigaBallIconEmptyBar = SKSpriteNode()
	var hiddenBricksIconEmptyBar = SKSpriteNode()
	var ballSizeIconEmptyBar = SKSpriteNode()
	// Power-up empty progress bars
	
	var powerUpTray = SKSpriteNode()
	
	var screenBlockArray: [SKSpriteNode] = []

	var iconArray: [SKSpriteNode] = []
	var iconTextureArray: [SKTexture] = []
	var disabledIconTextureArray: [SKTexture] = []
	var iconTimerArray: [SKSpriteNode] = []
	var iconEmptyTimerArray: [SKSpriteNode] = []
	var iconTimerTextureArray: [SKTexture] = []
	var iconSize: CGFloat = 0
	
	var layoutUnit: CGFloat = 0
    var paddleWidth: CGFloat = 0
    var paddleGap: CGFloat = 0
	var minPaddleGap: CGFloat = 0
    var ballSize: CGFloat = 0
	var ballSizeBig: CGFloat = 0
	var ballSizeBiggest: CGFloat = 0
	var ballSizeSmall: CGFloat = 0
	var ballSizeSmallest: CGFloat = 0
    var ballStartingPositionY: CGFloat = 0
    var ballLaunchSpeed: Double = 0
    var ballLaunchAngleRad: Double = 0
	var brickHeight: CGFloat = 0
    var brickWidth: CGFloat = 0
    var numberOfBrickRows: Int = 0
    var numberOfBrickColumns: Int = 0
    var totalBricksWidth: CGFloat = 0
	var totalBricksHeight: CGFloat = 0
    var yBrickOffset: CGFloat = 0
	var yBrickOffsetEndless: CGFloat = 0
    var xBrickOffset: CGFloat = 0
    var powerUpSize: CGFloat = 0
	var screenBlockTopWidth: CGFloat = 0
	var topGap: CGFloat = 0
	var paddlePositionY: CGFloat = 0
	var screenBlockTopHeight: CGFloat = 0
	var screenBlockSideWidth: CGFloat = 0
	var gameWidth: CGFloat = 0
	var backStopWidth: CGFloat = 0
	var backStopHeight: CGFloat = 0
    // Object layout property defintion
    
    var ballIsOnPaddle: Bool = true
    var numberOfLives: Int = 0
    var collisionLocation: Double = 0
    var minAngleDeg: Double = 0
    var angleAdjustmentK: Double = 0
        // Effect of paddle position hit on ball angle. Larger number means more effect
	var xSpeedLive: CGFloat = 0
	var ySpeedLive: CGFloat = 0
    var bricksLeft: Int = 0
    var ballLinearDampening: CGFloat = 0
	var ballSpeedSlow: CGFloat = 0
	var ballSpeedSlowest: CGFloat = 0
	var ballSpeedNominal: CGFloat = 0
	var ballSpeedFast: CGFloat = 0
	var ballSpeedFastest: CGFloat = 0
	var ballSpeedLimit: CGFloat = 0
	var paddleMovementFactor: CGFloat = 0
	var paddleTiltMagnitude: CGFloat = 0
	var minTilt: CGFloat = 0
	var maxTilt: CGFloat = 0
	var levelNumber: Int = 0
	var startLevelNumber: Int = 0
	var numberOfLevels: Int = 0
	var levelSender: String = ""
	var packNumber: Int = 0
	var powerUpProbFactor: Int = 0
	var brickRemovalCounter: Int = 0
	var gravityActivated: Bool = false
	var pauseBallVelocityX: CGFloat = 0
	var pauseBallVelocityY: CGFloat = 0
    // Setup game metrics
    
    var lifeLostScore: Int = 0
    var brickDestroyScore: Int = 0
    var powerUpScore: Int = 0
	var powerUpMultiplierScore: Double = 0
	var levelCompleteScore: Int = 0
	var levelScore: Int = 0
	var levelHighscore: Int = 0
	var totalScore: Int = 0
	var totalHighscore: Int = 0
	var multiplier: Double = 0
	var scoreFactorString: String = ""
    // Setup score properties
	
	var adsSetting: Bool?
	var soundsSetting: Bool?
	var musicSetting: Bool?
	var hapticsSetting: Bool?
	var parallaxSetting: Bool?
	var paddleSensitivitySetting: Int?
	var gameCenterSetting: Bool?
	var ballSetting: Int?
	var paddleSetting: Int?
	var brickSetting: Int?
    var appIconSetting: Int?
	// User settings
	var saveGameSaveArray: [Int]?
    var saveMultiplier: Double?
    var saveBrickTextureArray: [Int]?
    var saveBrickColourArray: [Int]?
    var saveBrickXPositionArray: [Int]?
    var saveBrickYPositionArray: [Int]?
	var saveBallPropertiesArray: [Double]?
    // Game save settings
    
    var brickNormalTexture: SKTexture = SKTexture(imageNamed: "BrickNormal")
	var brickInvisibleTexture: SKTexture = SKTexture(imageNamed: "BrickInvisible")
    var brickMultiHit1Texture: SKTexture = SKTexture(imageNamed: "BrickMultiHit1")
    var brickMultiHit2Texture: SKTexture = SKTexture(imageNamed: "BrickMultiHit2")
    var brickMultiHit3Texture: SKTexture = SKTexture(imageNamed: "BrickMultiHit3")
	var brickMultiHit4Texture: SKTexture = SKTexture(imageNamed: "BrickMultiHit4")
	let brickIndestructible1Texture: SKTexture = SKTexture(imageNamed: "BrickIndestructible1")
    let brickIndestructible2Texture: SKTexture = SKTexture(imageNamed: "BrickIndestructible2")
	let brickNullTexture: SKTexture = SKTexture(imageNamed: "BrickNull")
    // brick textures
	
	let retroBrickNormalTexture: SKTexture = SKTexture(imageNamed: "retroBrickNormal")
	let retroBrickInvisibleTexture: SKTexture = SKTexture(imageNamed: "retroBrickInvisible")
    let retroBrickMultiHit1Texture: SKTexture = SKTexture(imageNamed: "RetroBrickMultiHit1")
    let retroBrickMultiHit2Texture: SKTexture = SKTexture(imageNamed: "RetroBrickMultiHit2")
    let retroBrickMultiHit3Texture: SKTexture = SKTexture(imageNamed: "RetroBrickMultiHit3")
	let retroBrickMultiHit4Texture: SKTexture = SKTexture(imageNamed: "RetroBrickMultiHit4")
	// retro brick textures
    
    let powerUpGetALife: SKTexture = SKTexture(imageNamed: "PowerUpGetALife")
    let powerUpDecreaseBallSpeed: SKTexture = SKTexture(imageNamed: "PowerUpReduceBallSpeed")
    let powerUpGigaBall: SKTexture = SKTexture(imageNamed: "PowerUpGigaBall")
    let powerUpStickyPaddle: SKTexture = SKTexture(imageNamed: "PowerUpStickyPaddle")
    let powerUpNextLevel: SKTexture = SKTexture(imageNamed: "PowerUpNextLevel")
    let powerUpIncreasePaddleSize: SKTexture = SKTexture(imageNamed: "PowerUpIncreasePaddleSize")
    let powerUpShowInvisibleBricks: SKTexture = SKTexture(imageNamed: "PowerUpShowInvisibleBricks")
    let powerUpLasers: SKTexture = SKTexture(imageNamed: "PowerUpLasers")
    let powerUpRemoveIndestructibleBricks: SKTexture = SKTexture(imageNamed: "PowerUpRemoveIndestructibleBricks")
    let powerUpMultiHitToNormalBricks: SKTexture = SKTexture(imageNamed: "PowerUpMultiHitToNormalBricks")
	let powerUpMystery: SKTexture = SKTexture(imageNamed: "PowerUpMystery")
    let powerUpLoseALife: SKTexture = SKTexture(imageNamed: "PowerUpLoseALife")
    let powerUpIncreaseBallSpeed: SKTexture = SKTexture(imageNamed: "PowerUpIncreaseBallSpeed")
    let powerUpUndestructiBall: SKTexture = SKTexture(imageNamed: "PowerUpUndestructiBall")
    let powerUpDecreasePaddleSize: SKTexture = SKTexture(imageNamed: "PowerUpDecreasePaddleSize")
    let powerUpMultiplier: SKTexture = SKTexture(imageNamed: "PowerUpMultiplier")
    let powerUpPointsBonus: SKTexture = SKTexture(imageNamed: "PowerUpPointsBonus")
    let powerUpPointsPenalty: SKTexture = SKTexture(imageNamed: "PowerUpPointsPenalty")
    let powerUpNormalToInvisibleBricks: SKTexture = SKTexture(imageNamed: "PowerUpNormalToInvisibleBricks")
    let powerUpMultiHitBricksReset: SKTexture = SKTexture(imageNamed: "PowerUpMultiHitBricksReset")
    let powerUpGravityBall: SKTexture = SKTexture(imageNamed: "PowerUpGravityBall")
	let powerUpMultiplierReset: SKTexture = SKTexture(imageNamed: "PowerUpMultiplierReset")
	let powerUpBricksDown: SKTexture = SKTexture(imageNamed: "PowerUpBricksDown")
	let powerUpBackstop: SKTexture = SKTexture(imageNamed: "PowerUpBackstop")
	let powerUpIncreaseBallSize: SKTexture = SKTexture(imageNamed: "PowerUpIncreaseBallSize")
	let powerUpDecreaseBallSize: SKTexture = SKTexture(imageNamed: "PowerUpDecreaseBallSize")
	let powerUpMultiBall: SKTexture = SKTexture(imageNamed: "PowerUpMultiBall")
	let powerUpPreSet: SKTexture = SKTexture(imageNamed: "PowerUpPreSet")
    // Power up textures
	
	var powerUpTextureArray: [SKTexture] = []
	
	let directionMarkerOuterTexture: SKTexture = SKTexture(imageNamed: "directionMarkerOuter")
	let directionMarkerInnerTexture: SKTexture = SKTexture(imageNamed: "directionMarkerInner")
	let directionMarkerOuterGigaTexture: SKTexture = SKTexture(imageNamed: "directionMarkerOuterGiga")
	let directionMarkerInnerGigaTexture: SKTexture = SKTexture(imageNamed: "directionMarkerInnerGiga")
	let directionMarkerOuterUndestructiTexture: SKTexture = SKTexture(imageNamed: "directionMarkerOuterUndestructi")
	let directionMarkerInnerUndestructiTexture: SKTexture = SKTexture(imageNamed: "directionMarkerInnerUndestructi")
	// direction marker textures
	
	var ballTexture: SKTexture = SKTexture(imageNamed: "ball")
	let threeDBall: SKTexture = SKTexture(imageNamed: "3DBall")
	let outlineBall: SKTexture = SKTexture(imageNamed: "outlineBall")
	let diamondBall: SKTexture = SKTexture(imageNamed: "diamondBall")
	let beachBall: SKTexture = SKTexture(imageNamed: "beachBall")
	let concentricBall: SKTexture = SKTexture(imageNamed: "concentricBall")
	let reuleauxBall: SKTexture = SKTexture(imageNamed: "reuleauxBall")
	let dotBall: SKTexture = SKTexture(imageNamed: "dotBall")
	let hobBall: SKTexture = SKTexture(imageNamed: "hobBall")
	let spiralBall: SKTexture = SKTexture(imageNamed: "spiralBall")
	let pixelBall: SKTexture = SKTexture(imageNamed: "pixelBall")
	let loadingBall: SKTexture = SKTexture(imageNamed: "loadingBall")
	let retroBall: SKTexture = SKTexture(imageNamed: "retroBall")
	// regular ball texutes
	
	var gigaBallTexture: SKTexture = SKTexture(imageNamed: "ballGiga")
	let threeDBallGiga: SKTexture = SKTexture(imageNamed: "3DBallGiga")
	let outlineBallGiga: SKTexture = SKTexture(imageNamed: "outlineBallGiga")
	let diamondBallGiga: SKTexture = SKTexture(imageNamed: "diamondBallGiga")
	let beachBallGiga: SKTexture = SKTexture(imageNamed: "beachBallGiga")
	let concentricBallGiga: SKTexture = SKTexture(imageNamed: "concentricBallGiga")
	let reuleauxBallGiga: SKTexture = SKTexture(imageNamed: "reuleauxBallGiga")
	let dotBallGiga: SKTexture = SKTexture(imageNamed: "dotBallGiga")
	let hobBallGiga: SKTexture = SKTexture(imageNamed: "hobBallGiga")
	let spiralBallGiga: SKTexture = SKTexture(imageNamed: "spiralBallGiga")
	let pixelBallGiga: SKTexture = SKTexture(imageNamed: "pixelBallGiga")
	let loadingBallGiga: SKTexture = SKTexture(imageNamed: "loadingBallGiga")
	let retroBallGiga: SKTexture = SKTexture(imageNamed: "retroBallGiga")
	// giga ball texutes
	
	var undestructiballTexture: SKTexture = SKTexture(imageNamed: "ballUndestructi")
	let threeDBallUndestructi: SKTexture = SKTexture(imageNamed: "3DBallUndestructi")
	let outlineBallUndestructi: SKTexture = SKTexture(imageNamed: "outlineBallUndestructi")
	let diamondBallUndestructi: SKTexture = SKTexture(imageNamed: "diamondBallUndestructi")
	let beachBallUndestructi: SKTexture = SKTexture(imageNamed: "beachBallUndestructi")
	let concentricBallUndestructi: SKTexture = SKTexture(imageNamed: "concentricBallUndestructi")
	let reuleauxBallUndestructi: SKTexture = SKTexture(imageNamed: "reuleauxBallUndestructi")
	let dotBallUndestructi: SKTexture = SKTexture(imageNamed: "dotBallUndestructi")
	let hobBallUndestructi: SKTexture = SKTexture(imageNamed: "hobBallUndestructi")
	let spiralBallUndestructi: SKTexture = SKTexture(imageNamed: "spiralBallUndestructi")
	let pixelBallUndestructi: SKTexture = SKTexture(imageNamed: "pixelBallUndestructi")
	let loadingBallUndestructi: SKTexture = SKTexture(imageNamed: "loadingBallUndestructi")
	let retroBallUndestructi: SKTexture = SKTexture(imageNamed: "retroBallUndestructi")
	// undestructi-ball texutes
	
	var paddleTexture: SKTexture = SKTexture(imageNamed: "regularPaddle")
	let threeDPaddle: SKTexture = SKTexture(imageNamed: "3DPaddle")
	let outlinePaddle: SKTexture = SKTexture(imageNamed: "outlinePaddle")
	let squarePaddle: SKTexture = SKTexture(imageNamed: "squarePaddle")
	let icePaddle: SKTexture = SKTexture(imageNamed: "icePaddle")
	let glassPaddle: SKTexture = SKTexture(imageNamed: "glassPaddle")
	let pixelPaddle: SKTexture = SKTexture(imageNamed: "pixelPaddle")
	let gigaPaddle: SKTexture = SKTexture(imageNamed: "gigaPaddle")
	let stripyPaddle: SKTexture = SKTexture(imageNamed: "stripyPaddle")
	let splitPaddle: SKTexture = SKTexture(imageNamed: "splitPaddle")
	let rainbowPaddle: SKTexture = SKTexture(imageNamed: "rainbowPaddle")
	let retroPaddle: SKTexture = SKTexture(imageNamed: "retroPaddle")
	// paddle textures
	
	var laserPaddleTexture: SKTexture = SKTexture(imageNamed: "regularLasers")
	let threeDLaserTexture: SKTexture = SKTexture(imageNamed: "3DLasers")
	let squareLaserTexture: SKTexture = SKTexture(imageNamed: "squareLasers")
	let glassLaserTexture: SKTexture = SKTexture(imageNamed: "glassLasers")
	let rainbowLaserTexture: SKTexture = SKTexture(imageNamed: "rainbowLasers")
	let retroLaserTexture: SKTexture = SKTexture(imageNamed: "retroLasers")
	let gigaLaserTexture: SKTexture = SKTexture(imageNamed: "gigaLasers")
	let stripyLaserTexture: SKTexture = SKTexture(imageNamed: "stripyLasers")
	// paddle laser textures
	
	var stickyPaddleTexture: SKTexture = SKTexture(imageNamed: "regularSticky")
	let threeDStickyPaddleTexture: SKTexture = SKTexture(imageNamed: "3DSticky")
	let glassStickyPaddleTexture: SKTexture = SKTexture(imageNamed: "glassSticky")
	let outlineStickyPaddleTexture: SKTexture = SKTexture(imageNamed: "outlineSticky")
	let pixelStickyPaddleTexture: SKTexture = SKTexture(imageNamed: "pixelSticky")
	let rainbowStickyPaddleTexture: SKTexture = SKTexture(imageNamed: "rainbowSticky")
	let retroStickyPaddleTexture: SKTexture = SKTexture(imageNamed: "retroSticky")
	let splitStickyPaddleTexture: SKTexture = SKTexture(imageNamed: "splitSticky")
	let squareStickyPaddleTexture: SKTexture = SKTexture(imageNamed: "squareSticky")
	// paddle sticky textures

	let backStopTexture: SKTexture = SKTexture(imageNamed: "backStopTexture")
	// backstop texture
    
	var laserNormalTexture: SKTexture = SKTexture(imageNamed: "laserNormal")
	let laser3D: SKTexture = SKTexture(imageNamed: "laser3D")
	let laserOutline: SKTexture = SKTexture(imageNamed: "laserOutline")
	let laserSquare: SKTexture = SKTexture(imageNamed: "laserSquare")
	let laserGlass: SKTexture = SKTexture(imageNamed: "laserGlass")
	let laserPixel: SKTexture = SKTexture(imageNamed: "laserPixel")
	let laserSplit: SKTexture = SKTexture(imageNamed: "laserSplit")
	let laserRed: SKTexture = SKTexture(imageNamed: "laserRed")
	let laserOrange: SKTexture = SKTexture(imageNamed: "laserOrange")
	let laserYellow: SKTexture = SKTexture(imageNamed: "laserYellow")
	let laserGreen: SKTexture = SKTexture(imageNamed: "laserGreen")
	let laserBlue: SKTexture = SKTexture(imageNamed: "laserBlue")
	let laserIndigo: SKTexture = SKTexture(imageNamed: "laserIndigo")
	let laserViolet: SKTexture = SKTexture(imageNamed: "laserViolet")
	let laserRetroPink: SKTexture = SKTexture(imageNamed: "laserRetroPink")
	let laserRetroBlue: SKTexture = SKTexture(imageNamed: "laserRetroBlue")
	// regular laser textures
	
    var laserGigaTexture: SKTexture = SKTexture(imageNamed: "laserGiga")
	let laser3DGiga: SKTexture = SKTexture(imageNamed: "laserGiga3D")
	let laserOutlineGiga: SKTexture = SKTexture(imageNamed: "laserGigaOutline")
	let laserSquareGiga: SKTexture = SKTexture(imageNamed: "laserGigaSquare")
	let laserGlassGiga: SKTexture = SKTexture(imageNamed: "laserGigaGlass")
	let laserPixelGiga: SKTexture = SKTexture(imageNamed: "laserGigaPixel")
	let laserSplitGiga: SKTexture = SKTexture(imageNamed: "laserGigaSplit")
    // giga laser textures
	
	var rainbowLaserArray: [SKTexture] = []
	var rainbowLaserIndex = 0
	
	var stripyLaserArray: [SKTexture] = []
	var stripyLaserIndex = 0
	
	var retroLaserArray: [SKTexture] = []
	var retroLaserIndex = 0
	
	let starterBackgroundTexture: SKTexture = SKTexture(imageNamed: "BackgroundStarterPack")
	let spaceBackgroundTexture: SKTexture = SKTexture(imageNamed: "BackgroundSpacePack")
	let endlessBackgroundTexture: SKTexture = SKTexture(imageNamed: "BackgroundEndlessMode")
    
    var stickyPaddleCatches: Int = 0
	var stickyPaddleCatchesTotal: Int = 0
	var backstopCatches: Int = 0
	var backstopCatchesTotal: Int = 0
    var laserPowerUpIsOn: Bool = false
    var laserTimer: Timer?
    var laserSideLeft: Bool = true
	var powerUpProximity: Bool = false
    // Power up properties
    
    var ballPositionOnPaddle: Double = 0
    
    let pauseHighlightedTexture: SKTexture = SKTexture(imageNamed: "ButtonPauseHighlighted")
    let pauseTexture: SKTexture = SKTexture(imageNamed: "ButtonPause")
    // Play/pause button textures
	
	let iconIncreasePaddleSizeTexture: SKTexture = SKTexture(imageNamed: "ExpandPaddleIcon")
	let iconDecreasePaddleSizeTexture: SKTexture = SKTexture(imageNamed: "ShrinkPaddleIcon")
	let iconDecreaseBallSpeedTexture: SKTexture = SKTexture(imageNamed: "SlowBallIcon")
	let iconIncreaseBallSpeedTexture: SKTexture = SKTexture(imageNamed: "FastBallIcon")
	let iconStickyPaddleTexture: SKTexture = SKTexture(imageNamed: "StickyPaddleIcon")
	let iconGravityTexture: SKTexture = SKTexture(imageNamed: "GravityIcon")
	let iconLasersTexture: SKTexture = SKTexture(imageNamed: "LasersIcon")
	let iconUndestructiballTexture: SKTexture = SKTexture(imageNamed: "UndestructiBallIcon")
	let iconGigaBallTexture: SKTexture = SKTexture(imageNamed: "GigaBallIcon")
	let iconHiddenBlocksTexture: SKTexture = SKTexture(imageNamed: "HiddenBricksIcon")
	let iconBallSizeBigTexture: SKTexture = SKTexture(imageNamed: "BallSizeBigIcon")
	let iconBallSizeSmallTexture: SKTexture = SKTexture(imageNamed: "BallSizeSmallIcon")
	// Power-up icon textures
	
	let iconPaddleSizeDisabledTexture: SKTexture = SKTexture(imageNamed: "PaddleSizeIconDisabled")
	let iconBallSpeedDisabledTexture: SKTexture = SKTexture(imageNamed: "BallSpeedIconDisabled")
	let iconStickyPaddleDisabledTexture: SKTexture = SKTexture(imageNamed: "StickyPaddleIconDisabled")
	let iconGravityDisabledTexture: SKTexture = SKTexture(imageNamed: "GravityIconDisabled")
	let iconLasersDisabledTexture: SKTexture = SKTexture(imageNamed: "LasersIconDisabled")
	let iconGigaBallDisabledTexture: SKTexture = SKTexture(imageNamed: "GigaBallIconDisabled")
	let iconHiddenBlocksDisabledTexture: SKTexture = SKTexture(imageNamed: "HiddenBricksIconDisabled")
	let iconBallSizeDisabledTexture: SKTexture = SKTexture(imageNamed: "BallSizeIconDisabled")
	// Power-up icon disabled textures
	
	let powerUpIconBarEmpty: SKTexture = SKTexture(imageNamed: "PowerUpTimerEmpty")
	let powerUpIconBarFull: SKTexture = SKTexture(imageNamed: "PowerUpTimerFull")
	// Power-up icon bar textures

    var touchBeganWhilstPlaying: Bool = false
    var paddleMoved: Bool = false
    var paddleMovedDistance: CGFloat = 0
	var ballRelativePositionOnPaddle: CGFloat = 0
    var gameoverStatus: Bool = false
    var endLevelNumber: Int = 0
	var mysteryPowerUp: Bool = false
	var ballLostBool: Bool = true
	var powerUpsOnScreen: Int = 0
	var powerUpLimit: Int = 0
	
	var brickBounceCounter: Int = 0 {
		didSet {
			if brickBounceCounter > 100 {
				ballStuck()
			}
		}
		// Property observer to release stuck ball
	}
	
	var killBall: Bool = false
	var endlessMode: Bool = false
	var gigaBallDeactivate: Bool = false
	var gravityDeactivate: Bool = false
    // Game trackers
	
	let straightLaunchAngleRad = 90 * Double.pi / 180
	let minLaunchAngleRad = 10 * Double.pi / 180
	let maxLaunchAngleRad = 70 * Double.pi / 180
	var launchAngleMultiplier = 0
	// Ball launch
    
    var fontSize: CGFloat = 0
    var labelSpacing: CGFloat = 0
    // Label metrics
	
	var totalStatsArray: [TotalStats] = []
	var packStatsArray: [PackStats] = []
	var levelStatsArray: [LevelStats] = []
    var levelsCompleted: Int = 0
	var ballHits: Int = 0
	var ballsLost: Int = 0
	var powerupsCollected: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	var powerupsGenerated: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	var playTime: Int = 0
	var bricksHit: [Int] = [0, 0, 0, 0, 0, 0, 0, 0]
	var bricksDestroyed: [Int] = [0, 0, 0, 0, 0, 0, 0, 0]
	var lasersFired: Int = 0
	var lasersHit: Int = 0
	// Stats trackers
	
	var finalBrickRowHeight: CGFloat = 0
	var endlessHeight: Int = 0
	var endlessMoveInProgress: Bool = false
	// Endless mode
	
	var countdownStarted: Bool = false
	
	var screenRatio: CGFloat = 0.0
	var screenSize: String = ""
	
//MARK: - Animation Setup
	
	let timerScaleUp = SKAction.scale(to: 1.25, duration: 0.05)
	let timerScaleDown = SKAction.scale(to: 1, duration: 0.05)
	let pointsScaleDown = SKAction.scale(to: 0.75, duration: 0.05)
	// Setup timer icon animation
	
//MARK: - Sound and Haptic Definition
    
    var lightHaptic = UIImpactFeedbackGenerator(style: .light)
	// use for ball hitting bricks and paddle
    var interfaceHaptic = UIImpactFeedbackGenerator(style: .light)
	// use for UI interactions
	var mediumHaptic = UIImpactFeedbackGenerator(style: .medium)
    var heavyHaptic = UIImpactFeedbackGenerator(style: .heavy)
	var softHaptic = UIImpactFeedbackGenerator(style: .heavy)
	// use for lost ball
	var rigidHaptic = UIImpactFeedbackGenerator(style: .heavy)
	// use for power-ups collected
	
	// Haptics defined
	
//MARK: - State Machine Defintion

    lazy var gameState: GKStateMachine = GKStateMachine(states: [
        PreGame(scene: self),
        Playing(scene: self),
        InbetweenLevels(scene: self),
        GameOver(scene: self),
        Paused(scene: self),
		Ad(scene: self)])
    // Sets up the game states
    
    weak var gameViewControllerDelegate:GameViewControllerDelegate?
    // Create the delegate property for the GameViewController
	
//MARK: - User Defaults & NSCoder Setup
	
	var defaults = UserDefaults.standard
	// User settings  setup
	
	let totalStatsStore = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask).first?.appendingPathComponent("totalStatsStore.plist")
	let packStatsStore = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask).first?.appendingPathComponent("packStatsStore.plist")
	let levelStatsStore = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask).first?.appendingPathComponent("levelStatsStore.plist")
	let encoder = PropertyListEncoder()
	let decoder = PropertyListDecoder()
	// NSCoder data store & encoder setup
	
    override func didMove(to view: SKView) {
		
//MARK: - Scene Setup
		
		if #available(iOS 13.0, *) {
			softHaptic = UIImpactFeedbackGenerator(style: .soft)
			// use for lost ball
			rigidHaptic = UIImpactFeedbackGenerator(style: .rigid)
			// use for power-ups collected
		}
		// Haptics redefined for iOS13
	
        physicsWorld.contactDelegate = self
        // Sets the GameScene as the delegate in the physicsWorld
        
        let boarder = SKPhysicsBody(edgeLoopFrom: frame)
        boarder.friction = 0
        boarder.restitution = 1
		boarder.categoryBitMask = CollisionTypes.boarderCategory.rawValue
		boarder.collisionBitMask = CollisionTypes.ballCategory.rawValue
		boarder.contactTestBitMask = CollisionTypes.ballCategory.rawValue
        self.physicsBody = boarder
        // Sets up the boarder to interact with the objects
		
		physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		// Setup gravity
		
		userSettings()
		// Load user settings
		
//MARK: - Object Initialisation
		
		let ballTextureArray = [ballTexture, threeDBall, outlineBall, diamondBall, beachBall, concentricBall, reuleauxBall, dotBall, hobBall, spiralBall, pixelBall, loadingBall, retroBall]
		let ballGigaTextureArray = [gigaBallTexture, threeDBallGiga, outlineBallGiga, diamondBallGiga, beachBallGiga, concentricBallGiga, reuleauxBallGiga, dotBallGiga, hobBallGiga, spiralBallGiga, pixelBallGiga, loadingBallGiga, retroBallGiga]
		let ballUndestructiTextureArray = [undestructiballTexture, threeDBallUndestructi, outlineBallUndestructi, diamondBallUndestructi, beachBallUndestructi, concentricBallUndestructi, reuleauxBallUndestructi, dotBallUndestructi, hobBallUndestructi, spiralBallUndestructi, pixelBallUndestructi, loadingBallUndestructi, retroBallUndestructi]
		// ball texture arrays
		
		ballTexture = ballTextureArray[ballSetting!]
		gigaBallTexture = ballGigaTextureArray[ballSetting!]
		undestructiballTexture = ballUndestructiTextureArray[ballSetting!]
		// ball texture set
		
		let paddleTextureArray = [paddleTexture, threeDPaddle, outlinePaddle, squarePaddle, icePaddle, glassPaddle, pixelPaddle, gigaPaddle, stripyPaddle, splitPaddle, rainbowPaddle, retroPaddle]
		let laserPaddleTextureArray = [laserPaddleTexture, threeDLaserTexture, laserPaddleTexture, squareLaserTexture, glassLaserTexture, glassLaserTexture, squareLaserTexture, gigaLaserTexture, stripyLaserTexture, laserPaddleTexture, rainbowLaserTexture, retroLaserTexture]
		let stickyPaddleTextureArray = [stickyPaddleTexture, threeDStickyPaddleTexture, outlineStickyPaddleTexture, squareStickyPaddleTexture, glassStickyPaddleTexture, glassStickyPaddleTexture, pixelStickyPaddleTexture, stickyPaddleTexture, stickyPaddleTexture, splitStickyPaddleTexture, rainbowStickyPaddleTexture, retroStickyPaddleTexture]
		// paddle texture arrays
		
		paddleTexture = paddleTextureArray[paddleSetting!]
		laserPaddleTexture = laserPaddleTextureArray[paddleSetting!]
		stickyPaddleTexture = stickyPaddleTextureArray[paddleSetting!]
		// paddle texture set
		
		let laserTextureArray = [laserNormalTexture, laser3D, laserOutline, laserSquare, laserGlass, laserGlass, laserPixel, laserNormalTexture, laserRed, laserSplit, laserRed, laserRetroPink]
		let laserGigaTextureArray = [laserGigaTexture, laser3DGiga, laserOutlineGiga, laserSquareGiga, laserGlassGiga, laserGlassGiga, laserPixelGiga, laserGigaTexture, laserGigaTexture, laserSplitGiga, laserGigaTexture, laserGigaTexture]
		
		rainbowLaserArray = [laserRed, laserOrange, laserYellow, laserGreen, laserBlue, laserIndigo, laserViolet]
		stripyLaserArray = [laserRed, laserNormalTexture]
		retroLaserArray = [laserRetroPink, laserRetroBlue]
		
		laserNormalTexture = laserTextureArray[paddleSetting!]
		laserGigaTexture = laserGigaTextureArray[paddleSetting!]
		// laser texture set
		
		if brickSetting! == 1 {
			brickNormalTexture = retroBrickNormalTexture
			brickInvisibleTexture = retroBrickInvisibleTexture
			brickMultiHit1Texture = retroBrickMultiHit1Texture
			brickMultiHit2Texture = retroBrickMultiHit2Texture
			brickMultiHit3Texture = retroBrickMultiHit3Texture
			brickMultiHit4Texture = retroBrickMultiHit4Texture
		}

        ball = self.childNode(withName: "ball") as! SKSpriteNode
        paddle = self.childNode(withName: "paddle") as! SKSpriteNode
		paddleLaser = self.childNode(withName: "paddleLaser") as! SKSpriteNode
		paddleSticky = self.childNode(withName: "paddleSticky") as! SKSpriteNode
        pauseButton = self.childNode(withName: "pauseButton") as! SKSpriteNode
		pauseButtonTouch = self.childNode(withName: "pauseButtonTouch") as! SKSpriteNode
        life = self.childNode(withName: "life") as! SKSpriteNode
		topScreenBlock = self.childNode(withName: "topScreenBlock") as! SKSpriteNode
		bottomScreenBlock = self.childNode(withName: "bottomScreenBlock") as! SKSpriteNode
		sideScreenBlockLeft = self.childNode(withName: "sideScreenBlockLeft") as! SKSpriteNode
		sideScreenBlockRight = self.childNode(withName: "sideScreenBlockRight") as! SKSpriteNode
		background = self.childNode(withName: "background") as! SKSpriteNode
		directionMarker = self.childNode(withName: "directionMarker") as! SKSpriteNode
		backstop = self.childNode(withName: "backStop") as! SKSpriteNode
        // Links objects to nodes
		
		paddleSizeIcon = self.childNode(withName: "paddleSizeIcon") as! SKSpriteNode
		ballSpeedIcon = self.childNode(withName: "ballSpeedIcon") as! SKSpriteNode
		stickyPaddleIcon = self.childNode(withName: "stickyPaddleIcon") as! SKSpriteNode
		gravityIcon = self.childNode(withName: "gravityIcon") as! SKSpriteNode
		lasersIcon = self.childNode(withName: "lasersIcon") as! SKSpriteNode
		gigaBallIcon = self.childNode(withName: "gigaBallIcon") as! SKSpriteNode
		hiddenBricksIcon = self.childNode(withName: "hiddenBricksIcon") as! SKSpriteNode
		ballSizeIcon = self.childNode(withName: "ballSizeIcon") as! SKSpriteNode
		// Power-up icon creation
		
		paddleSizeIconBar = self.childNode(withName: "paddleSizeIconBar") as! SKSpriteNode
		ballSpeedIconBar = self.childNode(withName: "ballSpeedIconBar") as! SKSpriteNode
		stickyPaddleIconBar = self.childNode(withName: "stickyPaddleIconBar") as! SKSpriteNode
		gravityIconBar = self.childNode(withName: "gravityIconBar") as! SKSpriteNode
		lasersIconBar = self.childNode(withName: "lasersIconBar") as! SKSpriteNode
		gigaBallIconBar = self.childNode(withName: "gigaBallIconBar") as! SKSpriteNode
		hiddenBricksIconBar = self.childNode(withName: "hiddenBricksIconBar") as! SKSpriteNode
		ballSizeIconBar = self.childNode(withName: "ballSizeIconBar") as! SKSpriteNode
		// Power-up icon timer bar creation
		
		paddleSizeIconEmptyBar = self.childNode(withName: "paddleSizeIconEmptyBar") as! SKSpriteNode
		ballSpeedIconEmptyBar = self.childNode(withName: "ballSpeedIconEmptyBar") as! SKSpriteNode
		stickyPaddleIconEmptyBar = self.childNode(withName: "stickyPaddleIconEmptyBar") as! SKSpriteNode
		gravityIconEmptyBar = self.childNode(withName: "gravityIconEmptyBar") as! SKSpriteNode
		lasersIconEmptyBar = self.childNode(withName: "lasersIconEmptyBar") as! SKSpriteNode
		gigaBallIconEmptyBar = self.childNode(withName: "gigaBallIconEmptyBar") as! SKSpriteNode
		hiddenBricksIconEmptyBar = self.childNode(withName: "hiddenBricksIconEmptyBar") as! SKSpriteNode
		ballSizeIconEmptyBar = self.childNode(withName: "ballSizeIconEmptyBar") as! SKSpriteNode
		// Power-up icon timer bar creation
		
		powerUpTextureArray = [powerUpGetALife, powerUpDecreaseBallSpeed, powerUpGigaBall, powerUpStickyPaddle, powerUpNextLevel, powerUpIncreasePaddleSize, powerUpShowInvisibleBricks, powerUpLasers, powerUpRemoveIndestructibleBricks, powerUpMultiHitToNormalBricks, powerUpLoseALife, powerUpIncreaseBallSpeed, powerUpUndestructiBall, powerUpDecreasePaddleSize, powerUpMultiplier, powerUpPointsBonus, powerUpPointsPenalty, powerUpNormalToInvisibleBricks, powerUpMultiHitBricksReset, powerUpGravityBall, powerUpMystery, powerUpMultiplierReset, powerUpBricksDown, powerUpBackstop, powerUpIncreaseBallSize, powerUpDecreaseBallSize, powerUpMultiBall]
		// Power up texture array
		
		powerUpTray = self.childNode(withName: "powerUpTray") as! SKSpriteNode
		// Power-up area
		
		screenRatio = frame.size.height/frame.size.width
        
		if screenRatio > 2 {
			screenSize = "X"
		} else if screenRatio < 1.7  {
			screenSize = "Pad"
			
		} else {
			screenSize = "8"
		}
		// Screen size and device detected
		
		if screenSize == "X" {
			gameWidth = frame.size.height/2.16
		} else {
			gameWidth = (frame.size.height/2.16) * 1.1
		}

		//
		screenBlockSideWidth = (frame.size.width - gameWidth)/2
		// Same aspect ratio as the iPhone X size phones
		
		sideScreenBlockLeft.isHidden = true
		sideScreenBlockRight.isHidden = true
		sideScreenBlockLeft.size.width = screenBlockSideWidth
		sideScreenBlockRight.size.width = screenBlockSideWidth
		sideScreenBlockLeft.position.x = -gameWidth/2-screenBlockSideWidth/2
		sideScreenBlockRight.position.x = gameWidth/2+screenBlockSideWidth/2
		
		numberOfBrickRows = 22
        numberOfBrickColumns = numberOfBrickRows/2
		layoutUnit = (gameWidth)/CGFloat(numberOfBrickRows)
		brickWidth = layoutUnit*2
		brickHeight = layoutUnit
		paddleGap = layoutUnit*7
		
		pauseButtonSize = layoutUnit*2
		iconSize = layoutUnit*1.5
		fontSize = 16
		
		screenBlockTopHeight = layoutUnit*3
		
		if screenSize == "X" {
			screenBlockTopHeight = layoutUnit*7.4
		} else if screenSize == "Pad" {
			pauseButtonSize = layoutUnit*1.5
		}
		
		labelSpacing = fontSize/1.5
		minPaddleGap = brickHeight*4
		
		totalBricksWidth = CGFloat(numberOfBrickColumns) * (brickWidth)
		totalBricksHeight = CGFloat(numberOfBrickRows) * (brickHeight)
		
		ballSize = layoutUnit*0.67
		ball.size.width = ballSize
        ball.size.height = ballSize
		life.texture = ballTexture
		life.size.width = ballSize*1.5
		life.size.height = ballSize*1.5
		
		paddleWidth = ballSize*7.5
		paddle.size.width = paddleWidth
		paddle.size.height = ballSize
		paddleLaser.texture = laserPaddleTexture
		paddleLaser.size.width = paddleWidth
		paddleLaser.size.height = ballSize*1.6
		paddleSticky.texture = stickyPaddleTexture
		paddleSticky.size.width = paddleWidth
		paddleSticky.size.height = ballSize*1.1
		paddle.centerRect = CGRect(x: 0.0/80.0, y: 0.0/10.0, width: 80.0/80.0, height: 10.0/10.0)
		paddleLaser.centerRect = CGRect(x: 0.0/80.0, y: 0.0/16.0, width: 80.0/80.0, height: 16.0/16.0)
		paddleSticky.centerRect = CGRect(x: 0.0/80.0, y: 0.0/11.0, width: 80.0/80.0, height: 11.0/11.0)
		
		topScreenBlock.size.height = screenBlockTopHeight
		topScreenBlock.size.width = frame.size.width
		sideScreenBlockLeft.size.height = frame.size.height - screenBlockTopHeight
		sideScreenBlockRight.size.height = frame.size.height - screenBlockTopHeight
		sideScreenBlockLeft.position.y = -frame.size.height/2+sideScreenBlockLeft.size.height/2
		sideScreenBlockLeft.zPosition = 1
		sideScreenBlockRight.position.y = -frame.size.height/2+sideScreenBlockRight.size.height/2
		sideScreenBlockRight.zPosition = 1
		
		topGap = brickHeight*2
		// Object size definition
		
		ballLinearDampening = -0.02

		topScreenBlock.position.x = 0
		topScreenBlock.position.y = frame.height/2 - screenBlockTopHeight/2
		yBrickOffset = frame.height/2 - topScreenBlock.size.height - topGap - brickHeight/2
		yBrickOffsetEndless = frame.height/2 - topScreenBlock.size.height - brickHeight/2
		finalBrickRowHeight = yBrickOffsetEndless - (brickHeight*(CGFloat(numberOfBrickRows)-1))
		paddle.position.x = 0
		paddlePositionY = frame.height/2 - topScreenBlock.size.height - topGap - totalBricksHeight - paddleGap - paddle.size.height/2
		paddle.position.y = paddlePositionY
		ball.position.x = 0
		ballStartingPositionY = paddlePositionY + paddle.size.height/2 + ball.size.height/2 + 1
		ball.position.y = ballStartingPositionY
		directionMarker.zPosition = 10
		// Object positioning definition
		
		bottomScreenBlock.size.height = frame.size.height/8
		bottomScreenBlock.size.width = frame.size.width
		bottomScreenBlock.position.x = 0
		bottomScreenBlock.position.y = paddlePositionY - paddle.size.height/2 - brickWidth*0.85
	
		background.size.height = frame.size.height - screenBlockTopHeight
		background.size.width = gameWidth
		background.position.x = 0
		background.position.y = -frame.size.height/2
		background.zPosition = 0
		
		ball.texture = ballTexture
		ball.physicsBody = SKPhysicsBody(circleOfRadius: ballSize/2)
        ball.physicsBody!.allowsRotation = false
        ball.physicsBody!.friction = 0.0
        ball.physicsBody!.affectedByGravity = false
        ball.physicsBody!.isDynamic = true
        ball.name = BallCategoryName
        ball.physicsBody!.categoryBitMask = CollisionTypes.ballCategory.rawValue
        ballPhysicsBodySet()
        ball.zPosition = 2
		ball.physicsBody!.usesPreciseCollisionDetection = true
		ball.physicsBody!.linearDamping = ballLinearDampening
        ball.physicsBody!.angularDamping = 0
		ball.physicsBody!.restitution = 1
		ball.physicsBody!.density = 2
		// Define ball properties

		paddle.texture = paddleTexture
		paddle.physicsBody = SKPhysicsBody(texture: paddle.texture!, size: CGSize(width: paddle.size.width, height: paddle.size.height))
		if paddle.physicsBody == nil {
			paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.frame.size)
			
		} else {
			print("llama created paddle physics body on the 1st attempt")
		}
		if paddle.physicsBody == nil {
			paddle.physicsBody = SKPhysicsBody(texture: paddle.texture!, size: CGSize(width: paddle.size.width, height: paddle.size.height))
		} else {
			print("llama created paddle physics body on or before the 2nd attempt")
		}
		if paddle.physicsBody == nil {
			paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.frame.size)
		} else {
			print("llama created paddle physics body on or before the 3rd attempt")
		}
		if paddle.physicsBody == nil {
			print("llama failed to created the paddle physics body")
		}
		// Ensure paddle physics body is created - try 4 times
        paddle.physicsBody!.allowsRotation = false
        paddle.physicsBody!.friction = 0.0
        paddle.physicsBody!.affectedByGravity = false
        paddle.physicsBody!.isDynamic = true
        paddle.name = PaddleCategoryName
        paddle.physicsBody!.categoryBitMask = CollisionTypes.paddleCategory.rawValue
		paddle.physicsBody!.collisionBitMask = CollisionTypes.paddleCategory.rawValue
        paddle.zPosition = 3
		paddleLaser.zPosition = 2
		paddleSticky.zPosition = 4
		paddle.physicsBody!.usesPreciseCollisionDetection = true
		paddle.physicsBody!.restitution = 1
		// Define paddle properties
		
		backstop.size.height = paddle.size.height
		backstop.size.width = gameWidth-2
		backstop.position.x = 0
		backstop.position.y = paddle.position.y - paddle.size.height - backstop.size.height/2
		backstop.texture = backStopTexture
		
		backstop.physicsBody = SKPhysicsBody(rectangleOf: backstop.frame.size)
		backstop.physicsBody!.allowsRotation = false
        backstop.physicsBody!.friction = 0.0
        backstop.physicsBody!.affectedByGravity = false
        backstop.physicsBody!.isDynamic = true
		backstop.physicsBody!.pinned = true
        backstop.name = BackstopCategoryName
        backstop.physicsBody!.categoryBitMask = 0
		backstop.physicsBody!.collisionBitMask = 0
		backstop.physicsBody!.contactTestBitMask = 0
        backstop.zPosition = 5
		backstop.physicsBody!.usesPreciseCollisionDetection = true
		backstop.physicsBody!.restitution = 1
		backstop.isHidden = true
		// Define backstop properties
		
		ball.isHidden = true
        paddle.isHidden = true
		paddleLaser.isHidden = true
		paddleSticky.isHidden = true
		directionMarker.isHidden = true
        // Hide ball and paddle
		
		screenBlockArray = [topScreenBlock, sideScreenBlockLeft, sideScreenBlockRight]
		
		for i in 1...screenBlockArray.count {
			let index = i-1
			screenBlockArray[index].physicsBody = SKPhysicsBody(rectangleOf: screenBlockArray[index].frame.size)
			screenBlockArray[index].physicsBody!.allowsRotation = false
			screenBlockArray[index].physicsBody!.friction = 0.0
			screenBlockArray[index].physicsBody!.affectedByGravity = false
			screenBlockArray[index].physicsBody!.isDynamic = false
			screenBlockArray[index].zPosition = 7
			screenBlockArray[index].physicsBody!.categoryBitMask = CollisionTypes.screenBlockCategory.rawValue
			screenBlockArray[index].physicsBody!.collisionBitMask = CollisionTypes.ballCategory.rawValue | CollisionTypes.laserCategory.rawValue
			screenBlockArray[index].physicsBody!.contactTestBitMask = CollisionTypes.ballCategory.rawValue | CollisionTypes.laserCategory.rawValue
		}
		// Define all screen block properties
		
		
		let centerPoint = CGPoint(x:bottomScreenBlock.size.width / 2 - (bottomScreenBlock.size.width * bottomScreenBlock.anchorPoint.x), y:bottomScreenBlock.size.height / 2 - (bottomScreenBlock.size.height * bottomScreenBlock.anchorPoint.y))
		bottomScreenBlock.physicsBody = SKPhysicsBody(rectangleOf: bottomScreenBlock.frame.size, center: centerPoint)
		bottomScreenBlock.physicsBody!.allowsRotation = false
		bottomScreenBlock.physicsBody!.friction = 0.0
		bottomScreenBlock.physicsBody!.affectedByGravity = false
		bottomScreenBlock.physicsBody!.isDynamic = true
		bottomScreenBlock.physicsBody!.pinned = true
		bottomScreenBlock.zPosition = 1
		
		bottomScreenBlock.physicsBody!.categoryBitMask = CollisionTypes.bottomScreenBlockCategory.rawValue
		bottomScreenBlock.physicsBody!.collisionBitMask = 0
		bottomScreenBlock.physicsBody!.contactTestBitMask = CollisionTypes.ballCategory.rawValue | CollisionTypes.powerUpCategory.rawValue
		
//MARK: - Label & UI Initialisation
		
        livesLabel = self.childNode(withName: "livesLabel") as! SKLabelNode
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
		multiplierLabel = self.childNode(withName: "multiplierLabel") as! SKLabelNode
		readyCountdown = self.childNode(withName: "readyCountdown") as! SKSpriteNode
		goCountdown = self.childNode(withName: "goCountdown") as! SKSpriteNode
		buildLabel = self.childNode(withName: "buildLabel") as! SKLabelNode
        // Links objects to label
		
		readyCountdown.size.height = 58
		readyCountdown.size.width = 248
		readyCountdown.position.x = 0
		readyCountdown.position.y = 0
		readyCountdown.isHidden = true
		readyCountdown.zPosition = 10
		
		goCountdown.size.height = 58
		goCountdown.size.width = 123
		goCountdown.position.x = 0
		goCountdown.position.y = 0
		goCountdown.isHidden = true
		goCountdown.zPosition = 10

        pauseButton.size.width = pauseButtonSize
        pauseButton.size.height = pauseButtonSize
        pauseButton.texture = pauseTexture
		pauseButton.position.x = -frame.size.width/2 + labelSpacing*2 + pauseButton.size.width/2
		pauseButton.position.y = frame.size.height/2 - labelSpacing*0.75 - pauseButton.size.height*1.25

		pauseButton.zPosition = 10
        pauseButton.isUserInteractionEnabled = false
		
		powerUpTray.zPosition = 8
		powerUpTray.size.width = gameWidth
		powerUpTray.size.height = iconSize*2
		powerUpTray.centerRect = CGRect(x: 5.0/40.0, y: 5.0/40.0, width: 30.0/40.0, height: 30.0/40.0)
		powerUpTray.scale(to:CGSize(width: gameWidth, height: iconSize*2))
		powerUpTray.position.x = 0
		
		if screenSize == "X" {
			powerUpTray.position.y = pauseButton.position.y - pauseButton.size.height/2 - powerUpTray.size.height/2 - labelSpacing/2
		} else {
			powerUpTray.position.y = frame.size.height/2 - powerUpTray.size.height/2
			pauseButton.position.y = frame.size.height/2 - screenBlockTopHeight - labelSpacing/2 - pauseButton.size.height/2
		}
		
		scoreLabel.position.x = frame.size.width/2 - labelSpacing*2
		scoreLabel.position.y = pauseButton.position.y + fontSize/4 + labelSpacing/2
		scoreLabel.fontSize = fontSize
		scoreLabel.zPosition = 10
		
		if screenSize == "Pad" {
			pauseButton.position.x = sideScreenBlockLeft.position.x + sideScreenBlockLeft.size.width/2 + pauseButton.size.width/2 + layoutUnit/2
			scoreLabel.position.x = sideScreenBlockRight.position.x - sideScreenBlockRight.size.width/2 - layoutUnit/2
		}
		
		multiplierLabel.position.x = scoreLabel.position.x
		multiplierLabel.position.y = scoreLabel.position.y - labelSpacing - fontSize/2
		multiplierLabel.fontSize = fontSize
		multiplierLabel.zPosition = 10
		life.position.x = -life.size.width/3
		life.position.y = pauseButton.position.y
		life.zPosition = 10
		life.isHidden = false
		livesLabel.position.x = life.size.width/3
		livesLabel.position.y = life.position.y
        livesLabel.fontSize = fontSize
		livesLabel.horizontalAlignmentMode = .left
		livesLabel.zPosition = 10
		buildLabel.position.x = -gameWidth/2 + labelSpacing
		buildLabel.position.y = -frame.size.height/2 + labelSpacing*2
		buildLabel.fontSize = fontSize/3*2
		buildLabel.zPosition = 10
		// Label size & position definition
		
		buildLabel.text = "Alpha Build 0.2.5(1) - TBC - 00/00/2020"
		
		pauseButtonTouch.size.width = pauseButtonSize*2.75
		pauseButtonTouch.size.height = pauseButtonSize*2.75
		pauseButtonTouch.position.y = pauseButton.position.y
		pauseButtonTouch.position.x = pauseButton.position.x
		pauseButtonTouch.zPosition = 10
        pauseButtonTouch.isUserInteractionEnabled = false
		// Pause button size and position
		
		iconArray = [paddleSizeIcon, ballSpeedIcon, stickyPaddleIcon, gravityIcon, lasersIcon, gigaBallIcon, hiddenBricksIcon, ballSizeIcon]
		disabledIconTextureArray = [iconPaddleSizeDisabledTexture, iconBallSpeedDisabledTexture, iconStickyPaddleDisabledTexture, iconGravityDisabledTexture, iconLasersDisabledTexture, iconGigaBallDisabledTexture, iconHiddenBlocksDisabledTexture, iconBallSizeDisabledTexture]
		iconTextureArray = [iconIncreasePaddleSizeTexture, iconDecreasePaddleSizeTexture, iconDecreaseBallSpeedTexture, iconIncreaseBallSpeedTexture, iconStickyPaddleTexture, iconGravityTexture, iconLasersTexture, iconUndestructiballTexture, iconGigaBallTexture, iconHiddenBlocksTexture, iconBallSizeBigTexture, iconBallSizeSmallTexture]
		iconTimerArray = [paddleSizeIconBar, ballSpeedIconBar, stickyPaddleIconBar, gravityIconBar, lasersIconBar, gigaBallIconBar, hiddenBricksIconBar, ballSizeIconBar]
		iconEmptyTimerArray = [paddleSizeIconEmptyBar, ballSpeedIconEmptyBar, stickyPaddleIconEmptyBar, gravityIconEmptyBar, lasersIconEmptyBar, gigaBallIconEmptyBar, hiddenBricksIconEmptyBar, ballSizeIconEmptyBar]
		
		for i in 1...iconArray.count {
			let index = i-1
			let iconSpacing = ((gameWidth-iconSize*2) - iconSize*(CGFloat(iconArray.count)-1)) / (CGFloat(iconArray.count)-1)
			iconArray[index].size.width = iconSize
			iconArray[index].size.height = iconSize
			iconArray[index].texture = disabledIconTextureArray[index]
			iconArray[index].position.x = -gameWidth/2 + iconSize + (iconSize+iconSpacing)*CGFloat(index)
			iconArray[index].position.y = powerUpTray.position.y + labelSpacing/2
			iconArray[index].zPosition = 10
			iconArray[index].name = PowerIconCategoryName
			iconEmptyTimerArray[index].size.width = iconSize
			iconEmptyTimerArray[index].size.height = iconSize/6.67
			iconEmptyTimerArray[index].texture = powerUpIconBarEmpty
			iconEmptyTimerArray[index].position.x = iconArray[index].position.x - iconEmptyTimerArray[index].size.width/2
			iconEmptyTimerArray[index].position.y = iconArray[index].position.y - iconSize/2 - iconEmptyTimerArray[index].size.height/2 - labelSpacing/2
			iconEmptyTimerArray[index].zPosition = 9
			iconTimerArray[index].size.width = iconEmptyTimerArray[index].size.width
			iconTimerArray[index].size.height = iconEmptyTimerArray[index].size.height
			iconTimerArray[index].texture = powerUpIconBarFull
			iconTimerArray[index].position.x = iconEmptyTimerArray[index].position.x
			iconTimerArray[index].position.y = iconEmptyTimerArray[index].position.y
			iconTimerArray[index].zPosition = 10
			iconTimerArray[index].isHidden = true
			iconTimerArray[index].centerRect = CGRect(x: 2.0/25.0, y: 0.0/2.5, width: 21.0/25.0, height: 2.5/2.5)
			iconTimerArray[index].scale(to:CGSize(width: iconEmptyTimerArray[index].size.width, height: iconEmptyTimerArray[index].size.height))
		}
		// Power-up progress icon definition and setup

//MARK: - Game Properties Initialisation
        
		ballSpeedNominal = ballSize * 37.5
		ballSpeedSlow = ballSize * 32.5
		ballSpeedSlowest = ballSize * 27.5
		ballSpeedFast = ballSize * 45
		ballSpeedFastest = ballSize * 55
		ballSpeedLimit = ballSpeedNominal
		// Ball speed parameters
		
//		ballSpeedNominal = ballSize * 30
//		ballSpeedSlow = ballSize * 25
//		ballSpeedSlowest = ballSize * 20
//		ballSpeedFast = ballSize * 35
//		ballSpeedFastest = ballSize * 40
		// Original ball speed
		
		minAngleDeg = 10
		angleAdjustmentK = 45
		// Ball angle parameters
		
		powerUpProbFactor = 2//10
		powerUpLimit = 2
		// Power-up parameters
		
		brickDestroyScore = 10
		lifeLostScore = -100
		levelCompleteScore = 100
		// Score properties
		
//MARK: - Score Database Setup
		
		if let totalData = try? Data(contentsOf: totalStatsStore!) {
			do {
				totalStatsArray = try decoder.decode([TotalStats].self, from: totalData)
			} catch {
				print("Error decoding total stats array, \(error)")
			}
		}
		// Load the total stats array from the NSCoder data store
		
		if let packData = try? Data(contentsOf: packStatsStore!) {
			do {
				packStatsArray = try decoder.decode([PackStats].self, from: packData)
			} catch {
				print("Error decoding pack stats array, \(error)")
			}
		}
		// Load the pack stats array from the NSCoder data store
		
		if let levelData = try? Data(contentsOf: levelStatsStore!) {
			do {
				levelStatsArray = try decoder.decode([LevelStats].self, from: levelData)
			} catch {
				print("Error decoding level stats array, \(error)")
			}
		}
		// Load the level stats array from the NSCoder data store
		
		levelsCompleted = totalStatsArray[0].levelsCompleted
		ballHits = totalStatsArray[0].ballHits
		ballsLost = totalStatsArray[0].ballsLost
		powerupsCollected = totalStatsArray[0].powerupsCollected
		powerupsGenerated = totalStatsArray[0].powerupsGenerated
		playTime = totalStatsArray[0].playTime
		bricksHit = totalStatsArray[0].bricksHit
		bricksDestroyed = totalStatsArray[0].bricksDestroyed
		lasersFired = totalStatsArray[0].lasersFired
		lasersHit = totalStatsArray[0].lasersHit
		// Update stats trackers with saved values
		
        NotificationCenter.default.addObserver(self, selector: #selector(self.pauseNotificationKeyReceived), name: Notification.Name.pauseNotificationKey, object: nil)
        // Sets up an observer to watch for notifications from AppDelegate to check if the app has quit
		
		NotificationCenter.default.addObserver(self, selector: #selector(self.restartGameNotificiationKeyReceived), name: .restartGameNotificiation, object: nil)
        // Sets up an observer to watch for notifications to check if the user has restarted the game
		
		let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture))
		swipeUp.direction = .up
		view.addGestureRecognizer(swipeUp)
		// Setup swipe gesture
		
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
			
			if paddleX1 > (gameWidth/2 - paddle.size.width/2) {
				paddleX1 = gameWidth/2 - paddle.size.width/2
			}
			if paddleX1 < -(gameWidth/2 - paddle.size.width/2) {
				paddleX1 = -(gameWidth/2 - paddle.size.width/2)
			}
			// Check paddle position isn't outside the frame
			
			paddle.position = CGPoint(x: paddleX1, y: paddle.position.y)
			// Sets the paddle to match the new calculated position
				
			if ballIsOnPaddle && paddleMovedDistance != 0 {
				ball.position.x = paddle.position.x + ballRelativePositionOnPaddle				
				ball.position.y = ballStartingPositionY
				paddleMoved = true
			}
			// Ball matches paddle position
			
			paddleLaser.position.x = paddle.position.x
			paddleLaser.position.y = paddle.position.y - paddle.size.height/2
			paddleSticky.position.x = paddle.position.x
			paddleSticky.position.y = paddle.position.y - paddle.size.height/2
			// Keep the different paddle textures together
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
		
		if ballIsOnPaddle {
			ballRelativePositionOnPaddle = ball.position.x - paddle.position.x
		}
		// Define the current position of the ball relative to the paddle
        
        if gameState.currentState is Playing || gameState.currentState is Paused {
            let touch = touches.first
            let positionInScene = touch!.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            
            if let name = touchedNode.name {
                if name == "pauseButton" || name == "pauseButtonTouch" && gameState.currentState is Playing {
					if endlessMoveInProgress == false {
						clearSavedGame()
						// Clear current saved game before re-saving
						gameState.enter(Paused.self)
					}
					// Don't allow pause if brick down animation is in progress
                }
            }
        }
        // Pause the game if the pause button is pressed
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if ballIsOnPaddle && touchBeganWhilstPlaying && paddleMoved == false && gameState.currentState is Playing {
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
		
		brickBounceCounter = 0
		ballIsOnPaddle = false
		ballLostBool = false
        // Resets ball on paddle status
		
		ballRelativePositionOnPaddle = 0
        
        if stickyPaddleCatches != 0 {
            stickyPaddleCatches-=1
			let iconBarLength: CGFloat = (CGFloat(stickyPaddleCatches)/CGFloat(stickyPaddleCatchesTotal))
			stickyPaddleIconBar.run(SKAction.scaleX(to: iconBarLength, duration: 0.05))
			// Size icon timer based on number of catches remaining
            if stickyPaddleCatches == 0 {
				paddleSticky.isHidden = true
				stickyPaddleCatchesTotal = 0
				stickyPaddleIcon.texture = iconStickyPaddleDisabledTexture
				stickyPaddleIconBar.isHidden = true
				stickyPaddleIconBar.xScale = 0
				// Sticky paddle reset
            }
        }

        ballPositionOnPaddle = Double((ball.position.x - paddle.position.x)/(paddle.size.width/2))
        // Define the relative position between the ball and paddle

		if ballPositionOnPaddle < 0 {
            launchAngleMultiplier = 1
		} else {
			launchAngleMultiplier = -1
		}
        // Determines which angle the ball will launch and modify the multiplier accordingly
        
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
            ballLaunchAngleRad = straightLaunchAngleRad - ((maxLaunchAngleRad - minLaunchAngleRad) * ballPositionOnPaddle) + (minLaunchAngleRad * Double(launchAngleMultiplier))
            // Determine the launch angle based on the location of the ball on the paddle
        }
        
        let dxLaunch = cos(ballLaunchAngleRad) * Double(ballSpeedLimit)
        let dyLaunch = sin(ballLaunchAngleRad) * Double(ballSpeedLimit)
		ball.physicsBody!.velocity = CGVector(dx: dxLaunch, dy: dyLaunch)
        // Launches ball

		if hapticsSetting! {
			lightHaptic.impactOccurred()
		}
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
		
		if gameState.currentState is Paused {
			if self.isPaused == false && countdownStarted == false {
				self.isPaused = true
			}
		}
		// Ensures game is paused when returning from background

        if gameState.currentState is Playing {
			
			xSpeedLive = ball.physicsBody!.velocity.dx
			ySpeedLive = ball.physicsBody!.velocity.dy
		
			if gravityActivated {
				if ball.position.y < paddle.position.y + ballSize*4 {
					ball.physicsBody?.affectedByGravity = false
				} else {
					ball.physicsBody?.affectedByGravity = true
					// Stop the ball being effected by gravity near the paddle
				}
			}
			// Sets the ball's gravity control

			if ballIsOnPaddle {
				ball.position.y = ballStartingPositionY
				// Ensure ball remains on paddle
			} else {
				ballSpeedControl()
				// Ensure ball speed remains within limits
			}
		}
    }
    
    func ballLost() {
		if hapticsSetting! {
			softHaptic.impactOccurred()
		}
		ballsLost+=1
        self.ball.isHidden = true
		ball.texture = ballTexture
		ballRelativePositionOnPaddle = 0
        ball.position.x = paddle.position.x
        ball.position.y = ballStartingPositionY
        ball.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        ballIsOnPaddle = true
        paddleMoved = true
		ballLostBool = true
		endlessMoveInProgress = false
        // Reset ball position
		
		brickRemovalCounter = 0
		// Reset brick removal counter
		
		enumerateChildNodes(withName: BrickCategoryName) { (node, _) in
			node.removeAllActions()
			node.alpha = 1.0
		}
		// Reset bricks and re-hide invisible bricks

        powerUpsReset()
		// Reset any gained power-ups
		
		let scaleDown = SKAction.scale(to: 0.1, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let removeItemGroup = SKAction.group([scaleDown, fadeOut])
		// Setup power-up removal animation
		
		enumerateChildNodes(withName: PowerUpCategoryName) { (node, _) in
            node.removeAllActions()
            node.run(removeItemGroup, completion: {
                node.removeFromParent()
            })
        }
        // Remove any remaining power-ups
		
		enumerateChildNodes(withName: LaserCategoryName) { (node, _) in
            node.removeAllActions()
            node.run(removeItemGroup, completion: {
                node.removeFromParent()
            })
        }
        // Remove any remaining lasers
		
		if endlessMode == false {
			levelScore = levelScore + lifeLostScore
			scoreLabel.text = String(totalScore + levelScore)
		}
		// Update score - no points for dying in endless mode

		multiplier = 1.0
		scoreFactorString = String(format:"%.1f", multiplier)
		if endlessMode {
			scoreLabel.text = "\(endlessHeight) m"
		}
		multiplierLabel.text = "x\(scoreFactorString)"
		// Reset score multiplier
		
        if numberOfLives > 0 {
			
			life.removeAllActions()
            
            let fadeOutLife = SKAction.fadeOut(withDuration: 0.25)
            let scaleDownLife = SKAction.scale(to: 0, duration: 0.25)
            let waitTimeLife = SKAction.wait(forDuration: 0.25)
            let fadeInLife = SKAction.fadeIn(withDuration: 0.5)
			let scaleUpLife = SKAction.scale(to: 1, duration: 0.5)
			let largeLife = SKAction.scale(to: 1.5, duration: 0)
            let lifeLostGroup = SKAction.group([fadeOutLife, scaleDownLife, waitTimeLife])
            let resetLifeGroup = SKAction.group([scaleUpLife, fadeInLife])
            // Setup life lost animation
            
            let fadeOutBall = SKAction.fadeOut(withDuration: 0)
            let scaleDownBall = SKAction.scale(to: 0, duration: 0)
            let waitTimeBall = SKAction.wait(forDuration: 0.25)
            let fadeInBall = SKAction.fadeIn(withDuration: 0.25)
            let scaleUpBall = SKAction.scale(to: 1, duration: 0.25)
            let resetBallGroup = SKAction.group([fadeOutBall, scaleDownBall, waitTimeBall])
            let ballGroup = SKAction.group([fadeInBall, scaleUpBall])
            // Setup ball animation
            
            self.life.run(waitTimeLife, completion: {
                self.life.run(lifeLostGroup, completion: {
					self.life.run(waitTimeLife, completion: {
						self.life.run(largeLife, completion: {
							self.life.run(resetLifeGroup)
							self.numberOfLives -= 1
							self.livesLabel.text = "x\(self.numberOfLives)"
						})
					})
                })
            })
            // Update number of lives
            
            ball.run(resetBallGroup, completion: {
                self.ball.isHidden = false
                self.ball.run(ballGroup)
            })
            // Animate ball back onto paddle and loss of a life
        }
		
        if numberOfLives == 0 {
            gameoverStatus = true
            gameState.enter(InbetweenLevels.self)
            return
		} else {
			saveCurrentGame()
		}
    }
    
    func ballLostAnimation() {
		ballLostBool = true
		saveCurrentGame()
        let scaleDown = SKAction.scale(to: 0, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let ballLostGroup = SKAction.group([scaleDown, fadeOut])
		ball.run(ballLostGroup, completion: {
			self.ballLost()
		})
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
            
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
			
			if firstBody.categoryBitMask == CollisionTypes.ballCategory.rawValue && secondBody.categoryBitMask == CollisionTypes.boarderCategory.rawValue {
				
				frameBallControl(xSpeed: -xSpeedLive)

			}
			// Ball hits Frame
			
			if firstBody.categoryBitMask == CollisionTypes.ballCategory.rawValue && secondBody.categoryBitMask == CollisionTypes.backstopCategory.rawValue {
				
				if hapticsSetting! {
					lightHaptic.impactOccurred()
				}
				if gigaBallDeactivate {
					deactivateGigaBall()
				}
				// Deactivate giga-ball power-up
				if gravityDeactivate {
					deactivateGravity()
				}
				// Deactivate gravity power-up
				backstopCatches-=1
				// Size icon timer based on number of catches remaining
				if backstopCatches == 0 {
					if hapticsSetting! {
						heavyHaptic.impactOccurred()
					}
					self.run(SKAction.wait(forDuration: 0.025), completion: {
						self.backstop.run(SKAction.scale(by: 0.25, duration: 0.1), completion: {
							self.backstop.isHidden = true
							self.backstopCatches = 0
							self.backstopCatchesTotal = 0
							self.backstop.physicsBody!.categoryBitMask = 0
							self.backstop.physicsBody!.collisionBitMask = 0
							self.backstop.physicsBody!.contactTestBitMask = 0
							self.backstop.run(SKAction.scale(by: 4, duration: 0.0))
						})
					})
					// Backstop paddle reset
				} else if backstopCatches < 0 {
					backstopCatches = 0
				}
			}
			// Ball hits backstop

			if firstBody.categoryBitMask == CollisionTypes.ballCategory.rawValue && secondBody.categoryBitMask == CollisionTypes.screenBlockCategory.rawValue {
				
				let frameBlockNode = secondBody.node
				let frameBlockSprite = frameBlockNode as! SKSpriteNode
				
				if frameBlockSprite.size.width < frameBlockSprite.size.height {
				// Ball hits side block
					frameBallControl(xSpeed: -xSpeedLive)
				} else {
				// Ball hits top block
					if gigaBallDeactivate {
						deactivateGigaBall()
					}
					// Deactivate giga-ball power-up
					if gravityDeactivate {
						deactivateGravity()
					}
					// Deactivate gravity power-up
					
					if ySpeedLive < 0 {
						ball.physicsBody!.velocity = CGVector(dx: xSpeedLive, dy: ySpeedLive)
					} else {
						ball.physicsBody!.velocity = CGVector(dx: xSpeedLive, dy: -ySpeedLive)
					}
					let angleDeg = Double(atan2(Double(ball.physicsBody!.velocity.dy), Double(ball.physicsBody!.velocity.dx)))/Double.pi*180
					ballHorizontalControl(angleDegInput: angleDeg)
					// Ensure the ySpeed is downwards
				}
			}
		   // Ball hits screenblock

            if firstBody.categoryBitMask == CollisionTypes.ballCategory.rawValue && secondBody.categoryBitMask == CollisionTypes.brickCategory.rawValue {
                if let brickNode = secondBody.node {
                    hitBrick(node: brickNode, sprite: brickNode as! SKSpriteNode)
                }
				let angleDeg = Double(atan2(Double(ball.physicsBody!.velocity.dy), Double(ball.physicsBody!.velocity.dx)))/Double.pi*180
				
				if ball.texture != gigaBallTexture {
					ballHorizontalControl(angleDegInput: angleDeg)
					ballVerticalControl()
				}
				// Only apply ball angle correct when hitting bricks with giga-ball power off
            }
            // Ball hits Brick
            
            if firstBody.categoryBitMask == CollisionTypes.ballCategory.rawValue && secondBody.categoryBitMask == CollisionTypes.paddleCategory.rawValue {
				
				if gigaBallDeactivate {
					deactivateGigaBall()
				}
				// Deactivate giga-ball power-up
				if gravityDeactivate {
					deactivateGravity()
				}
				// Deactivate gravity power-up
				
                paddleHit()
            }
            // Ball hits Paddle
            
            if firstBody.categoryBitMask == CollisionTypes.brickCategory.rawValue && secondBody.categoryBitMask == CollisionTypes.laserCategory.rawValue {
                if let brickNode = firstBody.node {
					lasersHit+=1
					hitBrick(node: brickNode, sprite: brickNode as! SKSpriteNode, laserNode: secondBody.node!, laserSprite: (secondBody.node as! SKSpriteNode))
                }
            }
            // Laser hits Brick
			
			if firstBody.categoryBitMask == CollisionTypes.screenBlockCategory.rawValue && secondBody.categoryBitMask == CollisionTypes.laserCategory.rawValue {
				if let laserNode = secondBody.node {
					laserNode.removeFromParent()
                }
            }
            // Laser hits Top
            
            if firstBody.categoryBitMask == CollisionTypes.paddleCategory.rawValue && secondBody.categoryBitMask == CollisionTypes.powerUpCategory.rawValue {

				let powerUpNode = secondBody.node
				
				if powerUpNode?.zPosition == 2 {
					powerUpNode?.zPosition = 1
					applyPowerUp(node: secondBody.node!)
				} else {
					return
				}
				// Use zPosition to track if power-up has aleady been collected to prevent double hits
				
            }
            // Power-up hits Paddle
			
			if firstBody.categoryBitMask == CollisionTypes.ballCategory.rawValue && secondBody.categoryBitMask == CollisionTypes.bottomScreenBlockCategory.rawValue {
				ballLostAnimation()
			}
			// Ball hits bottom screen block
		
			if firstBody.categoryBitMask == CollisionTypes.powerUpCategory.rawValue && secondBody.categoryBitMask == CollisionTypes.bottomScreenBlockCategory.rawValue {
				
				powerUpsOnScreen-=1
				let powerUpNode = firstBody.node
				let powerUpSprite = powerUpNode as! SKSpriteNode
				
				if powerUpSprite.texture == self.powerUpMystery {
					self.powerUpGenerator (sprite: powerUpSprite)
					powerUpNode!.removeFromParent()
					// If mystery power-up, remove and generate a new power-up in its position
				} else {
					let startingFade = SKAction.fadeAlpha(to: 0.75, duration: 0.25)
					let scaleDown = SKAction.scale(to: 0.25, duration: 1)
					let fadeOut = SKAction.fadeOut(withDuration: 1)
					let removeItemGroup = SKAction.group([scaleDown, fadeOut])
					removeItemGroup.timingMode = .easeIn
					let removeItemSequence = SKAction.sequence([startingFade, removeItemGroup])
					powerUpSprite.run(removeItemSequence, completion: {
						powerUpNode!.removeFromParent()
					})
					// Otherwise animate the power-up out
				}
			}
			// Power-up hits bottom screen block
        }
    }
	
	func deactivateGigaBall() {
		gigaBallDeactivate = false
		gigaBallIcon.texture = iconGigaBallDisabledTexture
		ball.texture = ballTexture
		ballPhysicsBodySet()
		powerUpLimit = 2
	}
	
	func deactivateGravity() {
		gravityDeactivate = false
		gravityIcon.texture = iconGravityDisabledTexture
		physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		ball.physicsBody!.affectedByGravity = false
		gravityActivated = false
	}
	
    func hitBrick(node: SKNode, sprite: SKSpriteNode, laserNode: SKNode? = nil, laserSprite: SKSpriteNode? = nil) {
		
        if hapticsSetting! {
			lightHaptic.impactOccurred()
		}

		if  laserSprite?.texture != laserGigaTexture {
            laserNode?.removeFromParent()
        }
        // Remove laser if giga-ball power up isn't activated
		
		if sprite.texture == brickIndestructible2Texture {
			brickBounceCounter+=1
		} else {
			brickBounceCounter = 0
		}
		
		if sprite.texture == brickMultiHit1Texture || sprite.texture == brickMultiHit2Texture || sprite.texture == brickMultiHit3Texture || sprite.isHidden {
			levelScore = levelScore + Int(Double(brickDestroyScore) * multiplier)
			if endlessMode == false {
				scoreLabel.text = String(totalScore + levelScore)
			}
		}
        
        switch sprite.texture {
        case brickMultiHit1Texture:
			bricksHit[1]+=1
            sprite.texture = brickMultiHit2Texture
            break
        case brickMultiHit2Texture:
			bricksHit[2]+=1
            sprite.texture = brickMultiHit3Texture
            break
		case brickMultiHit3Texture:
			bricksHit[3]+=1
            sprite.texture = brickMultiHit4Texture
            break
        case brickMultiHit4Texture:
			bricksHit[4]+=1
            removeBrick(node: node, sprite: sprite)
            break
		case brickIndestructible1Texture:
			bricksHit[5]+=1
			removeBrick(node: node, sprite: sprite)
			sprite.texture = brickIndestructible2Texture
            break
		case brickIndestructible2Texture:
			bricksHit[6]+=1
			removeBrick(node: node, sprite: sprite)
            break
        case brickInvisibleTexture:
			bricksHit[7]+=1
            if sprite.isHidden {
                let scaleDown = SKAction.scale(to: 1, duration: 0)
                let fadeOut = SKAction.fadeOut(withDuration: 0)
                let resetGroup = SKAction.group([scaleDown, fadeOut])
                let scaleUp = SKAction.scale(to: 1, duration: 0)
                let fadeIn = SKAction.fadeIn(withDuration: 0.2)
                let brickHitGroup = SKAction.group([scaleUp, fadeIn])
                sprite.run(resetGroup, completion: {
                    sprite.isHidden = false
                    sprite.run(brickHitGroup)
                })
                // Animate bricks in
                break
			} else {
				removeBrick(node: node, sprite: sprite)
			}
            break
        default:
		// Normal bricks
            bricksHit[0]+=1
			if sprite.isHidden {
				let scaleDown = SKAction.scale(to: 1, duration: 0)
                let fadeOut = SKAction.fadeOut(withDuration: 0)
                let resetGroup = SKAction.group([scaleDown, fadeOut])
                let scaleUp = SKAction.scale(to: 1, duration: 0)
                let fadeIn = SKAction.fadeIn(withDuration: 0.2)
                let brickHitGroup = SKAction.group([scaleUp, fadeIn])
                sprite.run(resetGroup, completion: {
                    sprite.isHidden = false
                    sprite.run(brickHitGroup)
                })
			} else {
				removeBrick(node: node, sprite: sprite)
			}
            break
        }
    }
    
    func removeBrick(node: SKNode, sprite: SKSpriteNode) {
		
		if sprite.texture == brickNullTexture {
			node.removeFromParent()
			return
		}
		
		powerUpProximity = false
		enumerateChildNodes(withName: PowerUpCategoryName) { (nodePowerUp, stop) in
			if sprite.position.y > nodePowerUp.position.y-self.brickWidth*2 && sprite.position.y < nodePowerUp.position.y+self.brickWidth*2 {
				self.powerUpProximity = true
				stop.initialize(to: true)
			}
		}
		
		if powerUpProximity == false && sprite.texture != brickIndestructible2Texture {
			let powerUpProb = Int.random(in: 1...powerUpProbFactor)
			if powerUpProb == 1 && bricksLeft > 1 {
				powerUpGenerator(sprite: sprite)
			}
			// probability of getting a power up if brick is removed
		}
		// Generate power-up only if not too close to another power-up or if hitting an indestructible 2 brick

		if sprite.texture != brickIndestructible1Texture && sprite.texture != brickIndestructible2Texture  {
			let waitBrickRemove = SKAction.wait(forDuration: 0.0167*2)
			node.name = BrickRemovalCategoryName
			node.isHidden = true
			node.run(waitBrickRemove, completion: {
				node.removeFromParent()
			})
			// Wait before removing brick to allow ball to bounce off brick correctly - 0.0167 = ~1 frame at 60 fps
		}
		
		countBricks()
		
		switch sprite.texture {
		case brickMultiHit1Texture:
			bricksDestroyed[1]+=1
			break
		case brickMultiHit2Texture:
			bricksDestroyed[2]+=1
			break
		case brickMultiHit3Texture:
			bricksDestroyed[3]+=1
			break
		case brickMultiHit4Texture:
			bricksDestroyed[4]+=1
			break
		case brickIndestructible1Texture:
			bricksDestroyed[5]+=1
			break
		case brickIndestructible2Texture:
			bricksDestroyed[6]+=1
			break
		case brickInvisibleTexture:
			bricksDestroyed[7]+=1
			break
		default:
		// Normal bricks
			bricksDestroyed[0]+=1
			break
		}
		
		if sprite.texture != brickIndestructible2Texture {
			
			if brickRemovalCounter == 9 && endlessMode == false {
				if multiplier < 2.0 {
					multiplier = multiplier + 0.1
				}
				brickRemovalCounter = 0
			} else {
				brickRemovalCounter+=1
			}
			// Update multiplier
			
			levelScore = levelScore + Int(Double(brickDestroyScore) * multiplier)
		}
		
		if endlessMode == false {
			scoreLabel.text = String(totalScore + levelScore)
		}
		scoreFactorString = String(format:"%.1f", multiplier)
		if endlessMode {
			scoreLabel.text = "\(endlessHeight) m"
		}
		multiplierLabel.text = "x\(scoreFactorString)"
		// Update score
				
		if sprite.texture == brickIndestructible1Texture {
			bricksLeft-=1
		}
        
        if bricksLeft == 0 && endlessMode == false {
			clearSavedGame()
			levelScore = levelScore + levelCompleteScore
			scoreLabel.text = String(totalScore + levelScore)
            gameState.enter(InbetweenLevels.self)
			return
        }
        // Loads the next level or ends the game if all bricks have been removed
    }
	
	func countBricks() {
				
		bricksLeft = 0
		var endlessModeBricks = 0
		
		enumerateChildNodes(withName: BrickCategoryName) { (nodeBrick, _) in
			let spriteBrick = nodeBrick as! SKSpriteNode
			if spriteBrick.texture != self.brickIndestructible2Texture {
				self.bricksLeft+=1
				// Count the number of active bricks remaining
				
				if self.endlessMode && spriteBrick.position.y <= self.finalBrickRowHeight + self.brickHeight/2 {
					endlessModeBricks+=1
				}
				// Count number of active bricks in bottom row of bricks in endless mode
				
				if self.endlessMode && spriteBrick.hasActions() {
					self.endlessMoveInProgress = true
				} else {
					self.endlessMoveInProgress = false
				}
				// Checks if brick move is already in progress in endless mode
			}
		}
				
		if endlessMode && endlessMoveInProgress == false && endlessModeBricks == 0 {
			moveEndlessModeRowDown()
		}
		// If there's no other bricks in the bottom row and a move isn't currently in progress, move to the row with the next lowest bricks
	}
	
	func moveEndlessModeRowDown() {
		
		endlessMoveInProgress = true
						
		enumerateChildNodes(withName: BrickCategoryName) { (node, _) in
			let brickSprite = node as! SKSpriteNode
			
			if node.position.y <= self.finalBrickRowHeight + self.brickHeight/2 {
				node.removeFromParent()
			}
			// Count number of active bricks in bottom row of bricks in endless mode
			
			let moveBricksDown = SKAction.moveBy(x: 0, y: -brickSprite.size.height, duration: 0.05)
			node.run(moveBricksDown)
		}
		// Move bricks down
		
		if gameState.currentState is Playing {
			buildNewEndlessRow()
		}

		endlessHeight+=1
		
		if endlessHeight <= 10 {
			let achievement = GKAchievement(identifier: "achievementEndlessTen")
			if achievement.isCompleted == false {
				let height = Double(endlessHeight)
				let percentComplete = height/10.0*100.0
				achievement.percentComplete = percentComplete
				achievement.showsCompletionBanner = true
				GKAchievement.report([achievement]) { (error) in
					print(error?.localizedDescription ?? "Error reporting achievementEndlessTen achievement")
				}
			}
		}
		if endlessHeight <= 100 {
			let achievement = GKAchievement(identifier: "achievementEndlessHundred")
			if achievement.isCompleted == false {
				let height = Double(endlessHeight)
				let percentComplete = height/100.0*100.0
				achievement.percentComplete = percentComplete
				achievement.showsCompletionBanner = true
				GKAchievement.report([achievement]) { (error) in
					print(error?.localizedDescription ?? "Error reporting achievementEndlessHundred achievement")
				}
			}
		}
		if endlessHeight <= 1000 {
			let achievement = GKAchievement(identifier: "achievementEndlessOneK")
			if achievement.isCompleted == false {
				let height = Double(endlessHeight)
				let percentComplete = height/1000.0*100.0
				achievement.percentComplete = percentComplete
				achievement.showsCompletionBanner = true
				GKAchievement.report([achievement]) { (error) in
					print(error?.localizedDescription ?? "Error reporting achievementEndlessOneK achievement")
				}
			}
		}
		if endlessHeight <= 10000 {
			let achievement = GKAchievement(identifier: "achievementEndlessTenK")
			if achievement.isCompleted == false {
				let height = Double(endlessHeight)
				let percentComplete = height/10000.0*100.0
				achievement.percentComplete = percentComplete
				achievement.showsCompletionBanner = true
				GKAchievement.report([achievement]) { (error) in
					print(error?.localizedDescription ?? "Error reporting achievementEndlessTenK achievement")
				}
			}
		}
		// Check for endless mode achivements
		
		if multiplier < 2.0 {
			multiplier = multiplier + 0.1
			if multiplier > 2.0 {
				multiplier = 2.0
			}
		}
		
		levelScore = levelScore + Int(100 * multiplier)
		if endlessMode == false {
			scoreLabel.text = String(totalScore + levelScore)
		}
		
		scoreFactorString = String(format:"%.1f", multiplier)
		if endlessMode {
			scoreLabel.text = "\(endlessHeight) m"
		}
		
		multiplierLabel.text = "x\(scoreFactorString)"
		// Update multiplier & score

		let wait = SKAction.wait(forDuration: 0.075)
        self.run(wait, completion: {
            self.countBricks()
        })
        // To run once the new row is inserted - slight delay to allow frame to move forward before executing
	}
    
    func paddleHit() {
        if hapticsSetting! {
			lightHaptic.impactOccurred()
		}
        ballHits+=1
		brickBounceCounter = 0
		ballRelativePositionOnPaddle = ball.position.x - paddle.position.x
        
		let xSpeed = ball.physicsBody!.velocity.dx
		let ySpeed = ball.physicsBody!.velocity.dy
		let paddleLeftEdgePosition = paddle.position.x - paddle.size.width/2
		let paddleRightEdgePosition = paddle.position.x + paddle.size.width/2
		let collisionPercentage = Double((ball.position.x - paddle.position.x)/(paddle.size.width/2))
		// Define collision position between the ball and paddle
		let ySpeedCorrected: Double = sqrt(Double(ySpeed*ySpeed))
		// Assumes the ball's ySpeed is always positive
		var angleDeg = Double(atan2(Double(ySpeedCorrected), Double(xSpeed)))/Double.pi*180
		// Angle of the ball
		
//		print("Llama collision: ", collisionPercentage, angleDeg, (ball.position.x-paddle.position.x))
		
		if ball.position.x > paddleLeftEdgePosition + ball.size.width/3 && ball.position.x < paddleRightEdgePosition - ball.size.width/3  {
		// Only apply if the ball hits the centre of the paddle

			if stickyPaddleCatches != 0 {
			// Catch the ball
				
				ballIsOnPaddle = true
				ball.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
				paddleMoved = true
				ball.position.y = ballStartingPositionY
				invisibleBrickFlash()
				return
				// Don't try to adjust the ball's angle if it is on the paddle
			
			} else if ballIsOnPaddle == false && ball.position.y >= paddle.position.y + paddle.size.height/2 {
			// Only applies if the ball hits the top surface of the paddle

				angleDeg = angleDeg - angleAdjustmentK*collisionPercentage
				// Angle adjustment formula - the ball's angle can change up to angleAdjustmentK deg depending on where the ball hits the paddle
				
//				print("Angle correction: ", angleDeg)
				
				if angleDeg < 0+minAngleDeg {
//					print("Angle correction 5")
					angleDeg = minAngleDeg
				}
				// Travelling up and right alternative
				if angleDeg > 180-minAngleDeg {
//					print("Angle correction 6")
					angleDeg = 180-minAngleDeg
				}
				// Travelling up and left alternative
				// Prevents the new angle from over correting to a downward angle
			}
		}
		
		if ballIsOnPaddle == false && ball.position.y >= paddle.position.y {
		// Only control the ball's angle if it is above the centre of the paddle
			ballHorizontalControl(angleDegInput: angleDeg)
		}
		
		invisibleBrickFlash()
		
		let waitPaddleHitSave = SKAction.wait(forDuration: 0.1)
		paddle.run(waitPaddleHitSave, completion: {
			self.saveCurrentGame()
		})
		
    }
	
	func invisibleBrickFlash() {
		var nonHiddenNodeFound = false
		enumerateChildNodes(withName: BrickCategoryName) { (node, stop) in
			let sprite = node as! SKSpriteNode
			if node.isHidden == false && (sprite.texture == self.brickNormalTexture || sprite.texture == self.brickInvisibleTexture || sprite.texture == self.brickMultiHit1Texture || sprite.texture == self.brickMultiHit2Texture || sprite.texture == self.brickMultiHit3Texture || sprite.texture == self.brickMultiHit4Texture) {
				nonHiddenNodeFound = true
				stop.initialize(to: true)
			}
		}
		// Check to see if there are any non-hidden destructible bricks left
		
		if nonHiddenNodeFound == false {
		// Only run if there are only hidden destructible and indestructible bricks left
			enumerateChildNodes(withName: BrickCategoryName) { (node, stop) in
				let sprite = node as! SKSpriteNode
				if sprite.texture == self.brickNormalTexture || sprite.texture == self.brickInvisibleTexture {
					if sprite.texture == self.brickNormalTexture {
						node.alpha = 0.75
					} else {
						node.alpha = 0.75
					}
					node.isHidden = false
				}
			}
			// Flash bricks on
			let waitDuration = SKAction.wait(forDuration: 0.2)
			let completionBlock = SKAction.run {
				self.enumerateChildNodes(withName: BrickCategoryName) { (node, stop) in
					let sprite = node as! SKSpriteNode
					if sprite.texture == self.brickNormalTexture || sprite.texture == self.brickInvisibleTexture {
						node.isHidden = true
						node.alpha = 1.0
					}
				}
			}
			// Flash bricks off
			let sequence = SKAction.sequence([waitDuration, completionBlock])
			self.run(sequence, withKey: "invisibleBrickFlash")
		}
		// Show hidden bricks if there are no noraml or invisible bricks showing
	}
    
    func powerUpGenerator (sprite: SKSpriteNode) {
		
		powerUpsOnScreen+=1
		
		if powerUpsOnScreen > powerUpLimit {
			powerUpsOnScreen-=1
			return
		}
		// Limit number of power-ups available at once
        
        let powerUp = SKSpriteNode(imageNamed: "PowerUpPreSet")
        
		powerUp.size.width = brickWidth*0.85
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
		powerUp.physicsBody!.collisionBitMask = CollisionTypes.paddleCategory.rawValue | CollisionTypes.bottomScreenBlockCategory.rawValue
		powerUp.physicsBody!.contactTestBitMask = CollisionTypes.paddleCategory.rawValue | CollisionTypes.bottomScreenBlockCategory.rawValue
        powerUp.zPosition = 2
        addChild(powerUp)
		
		var powerUpIdentityArray: [Int] = []
		
		enumerateChildNodes(withName: PowerUpCategoryName) { (node, stop) in
			let sprite = node as! SKSpriteNode
			
			for i in 1...self.powerUpTextureArray.count {
				let index = i-1
				if sprite.texture == self.powerUpTextureArray[index] {
					powerUpIdentityArray.append(index)
				}
				// If the new power-up texture matches the texure of an existing power-up, add the power-up ID number to the array
			}
		}
        
		let powerUpProb = Int.random(in: 15...23)
        switch powerUpProb {
        case 0:
		// Get a life
			if powerUpIdentityArray.contains(0) || numberOfLives >= 5 || endlessMode {
				powerUpsOnScreen-=1
				self.powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
			} else {
				powerUp.texture = powerUpGetALife
				powerupsGenerated[0]+=1
			}
			// Don't show if number of lives is 5 or more or power-up already falling or endless mode
		case 1:
		// Lose a life
			if numberOfLives <= 0 || mysteryPowerUp || powerUpIdentityArray.contains(1) || endlessMode {
				powerUpsOnScreen-=1
				powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
			} else {
				powerUp.texture = powerUpLoseALife
				powerupsGenerated[1]+=1
			}
			// Don't show if on last life or in place of mystery power-up or power-up already falling or endless mode
		case 2:
		// Decrease ball speed
			if powerUpIdentityArray.contains(2) {
				powerUpsOnScreen-=1
				self.powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
			} else {
				powerUp.texture = powerUpDecreaseBallSpeed
				powerupsGenerated[2]+=1
			}
			// Don't show if power-up already falling
		case 3:
		// Increase ball speed
			if powerUpIdentityArray.contains(3) {
				powerUpsOnScreen-=1
				self.powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
			} else {
				powerUp.texture = powerUpIncreaseBallSpeed
				powerupsGenerated[3]+=1
			}
			// Don't show if power-up already falling
        case 15:
		// Increase paddle size
			if powerUpIdentityArray.contains(4) {
				powerUpsOnScreen-=1
				self.powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
			} else {
				powerUp.texture = powerUpIncreasePaddleSize
				powerupsGenerated[4]+=1
			}
			// Don't show if power-up already falling
		case 16:
		// Decrease paddle size
			if powerUpIdentityArray.contains(5) {
				powerUpsOnScreen-=1
				self.powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
			} else {
				powerUp.texture = powerUpDecreasePaddleSize
				powerupsGenerated[5]+=1
			}
			// Don't show if power-up already falling
		case 17:
		// Sticky paddle
			if powerUpIdentityArray.contains(6) {
				powerUpsOnScreen-=1
				self.powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
			} else {
				powerUp.texture = powerUpStickyPaddle
				powerupsGenerated[6]+=1
			}
			// Don't show if power-up already falling
		case 7:
		// Gravity ball
			if powerUpIdentityArray.contains(7) {
				powerUpsOnScreen-=1
				self.powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
			} else {
				powerUp.texture = powerUpGravityBall
				powerupsGenerated[7]+=1
			}
			// Don't show if power-up already falling
		case 8:
		// Bonus points
			if powerUpIdentityArray.contains(8) || endlessMode {
				powerUpsOnScreen-=1
				self.powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
			} else {
				powerUp.texture = powerUpPointsBonus
				powerupsGenerated[8]+=1
			}
			// Don't show if power-up already falling or in endless mode
		case 9:
		// Penalty points
			if levelScore <= Int(1000*multiplier) || mysteryPowerUp || powerUpIdentityArray.contains(9) || endlessMode {
				powerUpsOnScreen-=1
				powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
			} else {
				powerUp.texture = powerUpPointsPenalty
				powerupsGenerated[9]+=1
			}
			// Don't show if score is less than penalty points amount or in place of mystery power-up or power-up already falling or in endless mode
		case 10:
		// x2 multiplier
			if multiplier >= 2.0 || powerUpIdentityArray.contains(10) || endlessMode {
				powerUpsOnScreen-=1
				powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
			} else {
				powerUp.texture = powerUpMultiplier
				powerupsGenerated[10]+=1
			}
			// Don't show if multiplier at 2.5 or above or power-up already falling or in endless mode
		case 11:
		// Multiplier reset
			if multiplier <= 1.1 || mysteryPowerUp || powerUpIdentityArray.contains(11) || endlessMode {
				powerUpsOnScreen-=1
				powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
			} else {
				powerUp.texture = powerUpMultiplierReset
				powerupsGenerated[11]+=1
			}
			// Don't show if multiplier is 1.5 or in place of mystery power-up or power-up already falling or in endless mode
        case 12:
		// Next level
			if mysteryPowerUp || powerUpIdentityArray.contains(12) || endlessMode {
				powerUpsOnScreen-=1
				self.powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
			} else {
				powerUp.texture = powerUpNextLevel
				powerupsGenerated[12]+=1
			}
			// Don't show in place of mystery power-up or power-up already falling or endless mode
        case 13:
		// Invisible bricks become visible
			powerUp.texture = self.powerUpShowInvisibleBricks
			var hiddenNodeFound = false
			enumerateChildNodes(withName: BrickCategoryName) { (node, stop) in
				if node.isHidden == true {
					hiddenNodeFound = true
					stop.initialize(to: true)
				}
			}
			powerupsGenerated[13]+=1
			if hiddenNodeFound == false || powerUpIdentityArray.contains(13) {
				powerUpsOnScreen-=1
				self.powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
				powerupsGenerated[13]-=1
			}
			// Don't show if no invisible/hidden bricks or power-up already falling
        case 14:
		// Normal bricks become invisble bricks
			powerUp.texture = powerUpNormalToInvisibleBricks
			var normalNodeFound = false
			enumerateChildNodes(withName: BrickCategoryName) { (node, stop) in
				let sprite = node as! SKSpriteNode
				if sprite.texture != self.brickMultiHit1Texture && sprite.texture != self.brickMultiHit2Texture && sprite.texture != self.brickMultiHit3Texture && sprite.texture != self.brickMultiHit4Texture && sprite.texture != self.brickInvisibleTexture && sprite.texture != self.brickIndestructible1Texture && sprite.texture != self.brickIndestructible2Texture {
					normalNodeFound = true
					stop.initialize(to: true)
				}
			}
			powerupsGenerated[14]+=1
			if normalNodeFound == false || powerUpIdentityArray.contains(14) {
				powerUpsOnScreen-=1
				self.powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
				powerupsGenerated[14]-=1
			}
			// Don't show if no normal bricks or power-up already falling
		case 4:
		// Multi-hit bricks become normal bricks
			powerUp.texture = powerUpMultiHitToNormalBricks
			var multiNodeFound = false
			enumerateChildNodes(withName: BrickCategoryName) { (node, stop) in
				let sprite = node as! SKSpriteNode
				if sprite.texture == self.brickMultiHit1Texture || sprite.texture == self.brickMultiHit2Texture {
					multiNodeFound = true
					stop.initialize(to: true)
				}
			}
			powerupsGenerated[15]+=1
			if multiNodeFound == false || powerUpIdentityArray.contains(15) {
				powerUpsOnScreen-=1
				self.powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
				powerupsGenerated[15]-=1
			}
			// Don't show if no multi-hit bricks or power-up already falling
		case 5:
		// Multi-hit bricks reset
			powerUp.texture = powerUpMultiHitBricksReset
			var multiHitBrickFound = false
			enumerateChildNodes(withName: BrickCategoryName) { (node, stop) in
				let sprite = node as! SKSpriteNode
				if sprite.texture == self.brickMultiHit2Texture || sprite.texture == self.brickMultiHit3Texture || sprite.texture == self.brickMultiHit4Texture {
					multiHitBrickFound = true
					stop.initialize(to: true)
				}
			}
			powerupsGenerated[16]+=1
			if multiHitBrickFound == false || powerUpIdentityArray.contains(16) {
				powerUpsOnScreen-=1
				self.powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
				powerupsGenerated[16]-=1
			}
			// Don't show if no multi-hit bricks that have been hit or power-up already falling
		case 6:
		// Remove indestructible bricks
			powerUp.texture = powerUpRemoveIndestructibleBricks
			var indestructibleNodeFound = false
			enumerateChildNodes(withName: BrickCategoryName) { (node, stop) in
				let sprite = node as! SKSpriteNode
				if sprite.texture == self.brickIndestructible2Texture || sprite.texture == self.brickIndestructible1Texture {
					indestructibleNodeFound = true
					stop.initialize(to: true)
				}
			}
			powerupsGenerated[17]+=1
			if indestructibleNodeFound == false || powerUpIdentityArray.contains(17) {
				powerUpsOnScreen-=1
				self.powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
				powerupsGenerated[17]-=1
			}
			// Don't show if no indestructible bricks or power-up already falling
		case 18:
		// giga-ball
			if powerUpIdentityArray.contains(18) {
				powerUpsOnScreen-=1
				self.powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
			} else {
				powerUp.texture = powerUpGigaBall
				powerupsGenerated[18]+=1
			}
			// Don't show if power-up already falling
        case 19:
		// Undestructi-ball
			if powerUpIdentityArray.contains(19) {
				powerUpsOnScreen-=1
				self.powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
			} else {
				powerUp.texture = powerUpUndestructiBall
				powerupsGenerated[19]+=1
			}
			// Don't show if power-up already falling
		case 20:
		// Lasers
			if powerUpIdentityArray.contains(20) {
				powerUpsOnScreen-=1
				self.powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
			} else {
				powerUp.texture = powerUpLasers
				powerupsGenerated[20]+=1
			}
			// Don't show if power-up already falling
		case 24:
		// Move all bricks down 2 rows
			powerUp.texture = powerUpBricksDown
			var bricksAtBottom = false
			enumerateChildNodes(withName: BrickCategoryName) { (node, stop) in
				if node.position.y < self.paddle.position.y + self.minPaddleGap {
					bricksAtBottom = true
					stop.initialize(to: true)
				}
			}
			powerupsGenerated[21]+=1
			if bricksAtBottom || powerUpIdentityArray.contains(21) || endlessMode {
				powerUpsOnScreen-=1
				powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
				powerupsGenerated[21]-=1
			}
			// Don't show if bricks are already at lowest point or power-up already falling or endless mode
		case 25:
		// Mystery power-up
			if mysteryPowerUp || powerUpIdentityArray.contains(22) {
				powerUpsOnScreen-=1
				self.powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
			} else {
				powerUp.texture = powerUpMystery
				powerupsGenerated[22]+=1
			}
			// Don't show in place of mystery power-up or power-up already falling
		case 23:
		// Backstop power-up
			if powerUpIdentityArray.contains(23) || backstopCatches > 0 {
				powerUpsOnScreen-=1
				self.powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
			} else {
				powerUp.texture = powerUpBackstop
				if powerupsGenerated.count < 24 {
					powerupsGenerated.append(0)
				}
				powerupsGenerated[23]+=1
			}
			// Don't show power-up if already falling or in action
		case 21:
		// Increase ball size
			if powerUpIdentityArray.contains(24) {
				powerUpsOnScreen-=1
				self.powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
			} else {
				powerUp.texture = powerUpIncreaseBallSize
				powerupsGenerated[24]+=1
			}
			// Don't show if power-up already falling
		case 22:
		// Decrease ball size
			if powerUpIdentityArray.contains(25) {
				powerUpsOnScreen-=1
				self.powerUpGenerator (sprite: sprite)
				powerUp.removeFromParent()
			} else {
				powerUp.texture = powerUpDecreaseBallSize
				powerupsGenerated[25]+=1
			}
			// Don't show if power-up already falling
        default:
            break
        }
        
		let move = SKAction.moveBy(x: 0, y: -frame.height, duration: 5)
		powerUp.run(move, withKey: "PowerUpDrop")
    }
    
	func applyPowerUp (node: SKNode) {
		
		let sprite = node as! SKSpriteNode
		
		if ballLostBool {
			return
		}
		// Don't apply the power up if the ball has been lost
		
		if hapticsSetting! {
			rigidHaptic.impactOccurred()
		}
		
		powerUpsOnScreen-=1
		// Remove the power up from the power-up on screen tracker
		
		let scaleUp = SKAction.scale(to: 1.5, duration: 0.01)
		let startingFade = SKAction.fadeAlpha(to: 0.75, duration: 0.01)
		let scaleDown = SKAction.scale(to: 0.75, duration: 1)
		let fadeOut = SKAction.fadeOut(withDuration: 0.75)
		let moveUp = SKAction.moveBy(x: 0, y: sprite.size.height*2, duration: 0.75)
		let startingGroup = SKAction.group([scaleUp, startingFade])
		let powerupGroup = SKAction.group([moveUp, fadeOut, scaleDown])
		powerupGroup.timingMode = .easeIn
		let powerupSequence = SKAction.sequence([startingGroup, powerupGroup])
		node.removeAllActions()
		// Animation setup
		if sprite.texture == powerUpMystery {
			node.removeFromParent()
		} else {
			node.run(powerupSequence, completion: {
				self.mysteryPowerUp = false
				node.removeFromParent()
			})
		}
		// Power-up collection animation
		
        switch sprite.texture {
            
        case powerUpGetALife:
        // Get a life
            numberOfLives+=1
            livesLabel.text = "x\(numberOfLives)"
			
			life.removeAllActions()
			
			let scaleUp = SKAction.scale(to: 1.75, duration: 0.1)
			let scaleDown = SKAction.scale(to: 1, duration: 0.15)
			let newLifeSequence = SKAction.sequence([scaleUp, scaleDown])
			life.run(newLifeSequence)
            powerUpScore = 50
			powerUpMultiplierScore = 0.1
			powerupsCollected[0]+=1
            
        case powerUpLoseALife:
        // Lose a life
			ball.physicsBody!.linearDamping = 2
            ballLostAnimation()
            powerUpScore = 0
			powerUpMultiplierScore = 0
			powerupsCollected[1]+=1
            
        case powerUpDecreaseBallSpeed:
        // Decrease ball speed
			removeAction(forKey: "powerUpDecreaseBallSpeed")
			removeAction(forKey: "powerUpIncreaseBallSpeed")
			removeAction(forKey: "powerUpDecreaseBallSpeedTimer")
			removeAction(forKey: "ballSpeedTimer")
			// Remove any current ball speed power up timers
			ballSpeedIcon.texture = self.iconDecreaseBallSpeedTexture
			ballSpeedIconBar.isHidden = false
			// Show power-up icon timer
			if ballSpeedLimit == ballSpeedNominal {
				ballSpeedLimit = ballSpeedSlow
			} else if ballSpeedLimit < ballSpeedNominal {
				ballSpeedLimit = ballSpeedSlowest
			} else if ballSpeedLimit > ballSpeedNominal {
				ballSpeedLimit = ballSpeedNominal
				ballSpeedIcon.texture = self.iconBallSpeedDisabledTexture
				ballSpeedIconBar.isHidden = true
			}
            powerUpScore = 50
			powerUpMultiplierScore = 0.1
			powerupsCollected[2]+=1
			// Power up set
            let timer: Double = 10 * multiplier
            let waitDuration = SKAction.wait(forDuration: timer)
			let completionBlock = SKAction.run {
				self.ballSpeedLimit = self.ballSpeedNominal
				self.ballSpeedIcon.texture = self.iconBallSpeedDisabledTexture
				self.ballSpeedIconBar.isHidden = true
				// Hide power-up icons
            }
			ballSpeedIconBar.run(SKAction.scaleX(to: 1.0, duration: 0.05), completion: {
				self.ballSpeedIconBar.run(SKAction.scaleX(to: 0.0, duration: timer), withKey: "ballSpeedTimer")
			})
            let sequence = SKAction.sequence([waitDuration, completionBlock])
			ballSpeedIcon.run(SKAction.sequence([timerScaleUp, timerScaleDown]), withKey: "powerUpDecreaseBallSpeedTimer")
			// Setup timer animation
            self.run(sequence, withKey: "powerUpDecreaseBallSpeed")
            // Power up reverted
            
        case powerUpIncreaseBallSpeed:
        // Increase ball speed
			removeAction(forKey: "powerUpDecreaseBallSpeed")
			removeAction(forKey: "powerUpIncreaseBallSpeed")
			removeAction(forKey: "powerUpDecreaseBallSpeedTimer")
			removeAction(forKey: "ballSpeedTimer")
			// Remove any current ball speed power up timers
			ballSpeedIcon.texture = self.iconIncreaseBallSpeedTexture
			ballSpeedIconBar.isHidden = false
			// Show power-up icon timer
			if ballSpeedLimit == ballSpeedNominal {
				ballSpeedLimit = ballSpeedFast
			} else if ballSpeedLimit > ballSpeedNominal {
				ballSpeedLimit = ballSpeedFastest
			} else if ballSpeedLimit < ballSpeedNominal {
				ballSpeedLimit = ballSpeedNominal
				ballSpeedIcon.texture = self.iconBallSpeedDisabledTexture
				ballSpeedIconBar.isHidden = true
			}
            powerUpScore = -50
			powerUpMultiplierScore = -0.1
			powerupsCollected[3]+=1
            // Power up set
            let timer: Double = 10 * multiplier
            let waitDuration = SKAction.wait(forDuration: timer)
			let completionBlock = SKAction.run {
				self.ballSpeedLimit = self.ballSpeedNominal
				self.ballSpeedIcon.texture = self.iconBallSpeedDisabledTexture
				self.ballSpeedIconBar.isHidden = true
				// Hide power-up icons
            }
			ballSpeedIconBar.run(SKAction.scaleX(to: 1.0, duration: 0.05), completion: {
				self.ballSpeedIconBar.run(SKAction.scaleX(to: 0.0, duration: timer), withKey: "ballSpeedTimer")
			})
            let sequence = SKAction.sequence([waitDuration, completionBlock])
			ballSpeedIcon.run(SKAction.sequence([timerScaleUp, timerScaleDown]), withKey: "powerUpDecreaseBallSpeedTimer")
			// Setup timer animation
            self.run(sequence, withKey: "powerUpIncreaseBallSpeed")
            // Power up reverted
			
		case powerUpIncreasePaddleSize:
        // Increase paddle size
			removeAction(forKey: "powerUpIncreasePaddleSize")
			removeAction(forKey: "powerUpDecreasePaddleSize")
			removeAction(forKey: "powerUpPaddleSizeTimer")
			removeAction(forKey: "paddleSizeTimer")
			// Remove any current ball speed power up timers
			paddleSizeIcon.texture = self.iconIncreasePaddleSizeTexture
			paddleSizeIconBar.isHidden = false
			// Show power-up icon timer
			paddle.centerRect = CGRect(x: 10.0/80.0, y: 0.0/10.0, width: 60.0/80.0, height: 10.0/10.0)
			paddleLaser.centerRect = CGRect(x: 10.0/80.0, y: 0.0/16.0, width: 60.0/80.0, height: 16.0/16.0)
			paddleSticky.centerRect = CGRect(x: 10.0/80.0, y: 0.0/11.0, width: 60.0/80.0, height: 11.0/11.0)
			// Ensure good scaling of paddles
			if paddle.xScale < 1.0 {
				paddleSizeIcon.texture = self.iconPaddleSizeDisabledTexture
				paddleSizeIconBar.isHidden = true
				paddle.run(SKAction.scaleX(to: 1.0, duration: 0.2))
				paddleLaser.run(SKAction.scaleX(to: 1.0, duration: 0.2))
				paddleSticky.run(SKAction.scaleX(to: 1.0, duration: 0.2))
			} else if paddle.xScale == 1.0 {
				paddle.run(SKAction.scaleX(to: 1.5, duration: 0.2))
				paddleLaser.run(SKAction.scaleX(to: 1.5, duration: 0.2))
				paddleSticky.run(SKAction.scaleX(to: 1.5, duration: 0.2))
			} else if paddle.xScale == 1.5 {
				paddle.run(SKAction.scaleX(to: 2.0, duration: 0.2))
				paddleLaser.run(SKAction.scaleX(to: 2.0, duration: 0.2))
				paddleSticky.run(SKAction.scaleX(to: 2.0, duration: 0.2))
			} else if paddle.xScale == 2.0 || paddle.xScale == 2.5 {
				paddle.run(SKAction.scaleX(to: 2.5, duration: 0.2))
				paddleLaser.run(SKAction.scaleX(to: 2.5, duration: 0.2))
				paddleSticky.run(SKAction.scaleX(to: 2.5, duration: 0.2))
			}
			// Resize paddle based on its current size
			if paddle.position.x + paddle.size.width/2 > gameWidth/2 {
				paddle.position.x = gameWidth/2 - paddle.size.width/2
			}
			if paddle.position.x - paddle.size.width/2 < -gameWidth/2 {
				paddle.position.x = -gameWidth/2 + paddle.size.width/2
			}
			// Ensure the paddle stays within the game's bounds
            powerUpScore = 50
			powerUpMultiplierScore = 0.1
			powerupsCollected[4]+=1
            // Power up set
            let timer: Double = 10 * multiplier
            let waitDuration = SKAction.wait(forDuration: timer)
            let completionBlock = SKAction.run {
				self.paddle.centerRect = CGRect(x: 10.0/80.0, y: 0.0/10.0, width: 60.0/80.0, height: 10.0/10.0)
				self.paddleLaser.centerRect = CGRect(x: 10.0/80.0, y: 0.0/16.0, width: 60.0/80.0, height: 16.0/16.0)
				self.paddleSticky.centerRect = CGRect(x: 10.0/80.0, y: 0.0/11.0, width: 60.0/80.0, height: 11.0/11.0)
				if self.hapticsSetting! {
					self.rigidHaptic.impactOccurred()
				}
				self.paddle.run(SKAction.scaleX(to: 1, duration: 0.2), completion: {
					self.recentreBall()
				})
				self.paddleLaser.run(SKAction.scaleX(to: 1, duration: 0.2))
				self.paddleSticky.run(SKAction.scaleX(to: 1, duration: 0.2))
				self.paddleSizeIcon.texture = self.iconPaddleSizeDisabledTexture
				self.paddleSizeIconBar.isHidden = true
				// Hide power-up icons
            }
			paddleSizeIconBar.run(SKAction.scaleX(to: 1.0, duration: 0.05), completion: {
				self.paddleSizeIconBar.run(SKAction.scaleX(to: 0.0, duration: timer), withKey: "paddleSizeTimer")
			})
            let sequence = SKAction.sequence([waitDuration, completionBlock])
			paddleSizeIcon.run(SKAction.sequence([timerScaleUp, timerScaleDown]), withKey: "powerUpPaddleSizeTimer")
			// Setup timer animation
            self.run(sequence, withKey: "powerUpIncreasePaddleSize")
            // Power up reverted
			
		case powerUpDecreasePaddleSize:
        // Decrease paddle size
			removeAction(forKey: "powerUpDecreasePaddleSize")
			removeAction(forKey: "powerUpIncreasePaddleSize")
			removeAction(forKey: "powerUpPaddleSizeTimer")
			removeAction(forKey: "paddleSizeTimer")
			// Remove any current ball speed power up timers
			paddleSizeIcon.texture = self.iconDecreasePaddleSizeTexture
			paddleSizeIconBar.isHidden = false
			// Show power-up icon timer
			paddle.centerRect = CGRect(x: 10.0/80.0, y: 0.0/10.0, width: 60.0/80.0, height: 10.0/10.0)
			paddleLaser.centerRect = CGRect(x: 10.0/80.0, y: 0.0/16.0, width: 60.0/80.0, height: 16.0/16.0)
			paddleSticky.centerRect = CGRect(x: 10.0/80.0, y: 0.0/11.0, width: 60.0/80.0, height: 11.0/11.0)
			// Ensure good scaling of paddles
			if paddle.xScale < 1.0 {
				paddle.run(SKAction.scaleX(to: 0.5, duration: 0.2), completion: {
					self.recentreBall()
				})
				paddleLaser.run(SKAction.scaleX(to: 0.5, duration: 0.2))
				paddleSticky.run(SKAction.scaleX(to: 0.5, duration: 0.2))
			} else if paddle.xScale == 1.0 {
				paddle.run(SKAction.scaleX(to: 0.75, duration: 0.2), completion: {
					self.recentreBall()
				})
				paddleLaser.run(SKAction.scaleX(to: 0.75, duration: 0.2))
				paddleSticky.run(SKAction.scaleX(to: 0.75, duration: 0.2))
			} else if paddle.xScale > 1.0 {
				paddleSizeIcon.texture = self.iconPaddleSizeDisabledTexture
				paddleSizeIconBar.isHidden = true
				paddle.run(SKAction.scaleX(to: 1.0, duration: 0.2), completion: {
					self.recentreBall()
				})
				paddleLaser.run(SKAction.scaleX(to: 1.0, duration: 0.2))
				paddleSticky.run(SKAction.scaleX(to: 1.0, duration: 0.2))
			}
			// Resize paddle based on its current size
			
            powerUpScore = -50
			powerUpMultiplierScore = -0.1
			powerupsCollected[5]+=1
            // Power up set
            let timer: Double = 10 * multiplier
            let waitDuration = SKAction.wait(forDuration: timer)
            let completionBlock = SKAction.run {
				self.paddle.centerRect = CGRect(x: 10.0/80.0, y: 0.0/10.0, width: 60.0/80.0, height: 10.0/10.0)
				self.paddleLaser.centerRect = CGRect(x: 10.0/80.0, y: 0.0/16.0, width: 60.0/80.0, height: 16.0/16.0)
				self.paddleSticky.centerRect = CGRect(x: 10.0/80.0, y: 0.0/11.0, width: 60.0/80.0, height: 11.0/11.0)
                if self.hapticsSetting! {
					self.rigidHaptic.impactOccurred()
				}
                self.paddle.run(SKAction.scaleX(to: 1, duration: 0.2))
				self.paddleLaser.run(SKAction.scaleX(to: 1, duration: 0.2))
				self.paddleSticky.run(SKAction.scaleX(to: 1, duration: 0.2))
				self.paddleSizeIcon.texture = self.iconPaddleSizeDisabledTexture
				self.paddleSizeIconBar.isHidden = true
				// Hide power-up icons
            }
			paddleSizeIconBar.run(SKAction.scaleX(to: 1.0, duration: 0.05), completion: {
				self.paddleSizeIconBar.run(SKAction.scaleX(to: 0.0, duration: timer), withKey: "paddleSizeTimer")
			})
            let sequence = SKAction.sequence([waitDuration, completionBlock])
			paddleSizeIcon.run(SKAction.sequence([timerScaleUp, timerScaleDown]), withKey: "powerUpPaddleSizeTimer")
			// Setup timer animation
            self.run(sequence, withKey: "powerUpDecreasePaddleSize")
            // Power up reverted
			
		case powerUpStickyPaddle:
        // Sticky paddle
			stickyPaddleIcon.texture = self.iconStickyPaddleTexture
			stickyPaddleIconBar.isHidden = false
			// Show power-up icon timer
			stickyPaddleIconBar.run(SKAction.scaleX(to: 1.0, duration: 0.05))
            stickyPaddleCatches = 4 + Int(Double(multiplier))
			stickyPaddleCatchesTotal = stickyPaddleCatches
            powerUpScore = 50
			powerUpMultiplierScore = 0.1
			powerupsCollected[6]+=1
			paddleSticky.isHidden = false
            // Power up set and limit number of catches per power up
			
		case powerUpGravityBall:
		// Gravity ball
			removeAction(forKey: "powerUpGravityBall")
			removeAction(forKey: "gravityTimer")
			removeAction(forKey: "powerUpGravityTimer")
			// Remove any current ball speed power up timers
			gravityIcon.texture = self.iconGravityTexture
			gravityIconBar.isHidden = false
			// Show power-up icon timer
			physicsWorld.gravity = CGVector(dx: 0, dy: -1.5)
			ball.physicsBody!.affectedByGravity = true
			gravityActivated = true
			gravityDeactivate = false
			powerUpScore = -50
			powerUpMultiplierScore = -0.1
			powerupsCollected[7]+=1
			// Power up set
			let timer: Double = 10 * multiplier
			let waitDuration = SKAction.wait(forDuration: timer)
			let completionBlock = SKAction.run {
				if self.ballIsOnPaddle {
					self.deactivateGravity()
				} else {
					self.gravityDeactivate = true
				}
				self.gravityIconBar.isHidden = true
				// Hide power-up icons
			}
			gravityIconBar.run(SKAction.scaleX(to: 1.0, duration: 0.05), completion: {
				self.gravityIconBar.run(SKAction.scaleX(to: 0.0, duration: timer), withKey: "gravityTimer")
			})
			let sequence = SKAction.sequence([waitDuration, completionBlock])
			gravityIcon.run(SKAction.sequence([timerScaleUp, timerScaleDown]), withKey: "powerUpGravityTimer")
			// Setup timer animation
			self.run(sequence, withKey: "powerUpGravityBall")
			// Power up reverted
			
		case powerUpPointsBonus:
		// 1k points
			removeAction(forKey: "pointsAnimation")
			powerUpScore = 1000
			powerUpMultiplierScore = 0.1
			powerupsCollected[8]+=1
			scoreLabel.run(SKAction.sequence([timerScaleUp, timerScaleDown]), withKey: "pointsAnimation")
			// Power up set
			
		case powerUpPointsPenalty:
		// -1k points
			removeAction(forKey: "pointsAnimation")
			powerUpScore = -1000
			powerUpMultiplierScore = -0.1
			powerupsCollected[9]+=1
			scoreLabel.run(SKAction.sequence([pointsScaleDown, timerScaleDown]), withKey: "pointsAnimation")
			// Power up set
			
		case powerUpMultiplier:
		// Multiplier
			removeAction(forKey: "multiplierAnimation")
			multiplier = 2.0
			powerUpScore = 50
			powerUpMultiplierScore = 0
			powerupsCollected[10]+=1
			multiplierLabel.run(SKAction.sequence([timerScaleUp, timerScaleDown]), withKey: "multiplierAnimation")
			// Power up set
			
		case powerUpMultiplierReset:
		// Mutliplier reset to 1
			removeAction(forKey: "multiplierAnimation")
			multiplier = 1.0
			brickRemovalCounter = 0
			powerUpScore = -50
			powerUpMultiplierScore = 0
			powerupsCollected[11]+=1
			multiplierLabel.run(SKAction.sequence([pointsScaleDown, timerScaleDown]), withKey: "multiplierAnimation")
			
		case powerUpNextLevel:
        // Next level
            powerUpScore = 50
			powerUpMultiplierScore = 0
			powerupsCollected[12]+=1
			levelScore = levelScore + Int(Double(powerUpScore) * multiplier)
			scoreLabel.text = String(totalScore + levelScore)
			clearSavedGame()
            gameState.enter(InbetweenLevels.self)
			return
			
		case powerUpShowInvisibleBricks:
		// Invisible bricks become visible
			removeAction(forKey: "powerUpInvisibleBricks")
			removeAction(forKey: "invisibleBricksTimer")
			// Remove any animations and timers
			hiddenBricksIcon.texture = iconHiddenBlocksDisabledTexture
			hiddenBricksIconBar.isHidden = true
			// Show power-up icon timer for invisible bricks
			enumerateChildNodes(withName: BrickCategoryName) { (node, _) in
				if node.isHidden == true {
					let startingScale = SKAction.scale(to: 1, duration: 0)
					let startingFade = SKAction.fadeOut(withDuration: 0)
					let scaleUp = SKAction.scale(to: 1, duration: 0)
					let fadeIn = SKAction.fadeIn(withDuration: 0.2)
					let startingGroup = SKAction.group([startingFade, startingScale])
					let brickGroup = SKAction.group([scaleUp, fadeIn])
					node.run(startingGroup, completion: {
						node.isHidden = false
						node.run(brickGroup)
					})
				}
			}
			powerUpScore = 50
			powerUpMultiplierScore = 0.1
			powerupsCollected[13]+=1
			// Power up set
			
		case powerUpNormalToInvisibleBricks:
		// Normal bricks become invisble bricks
			removeAction(forKey: "powerUpInvisibleBricks")
			removeAction(forKey: "invisibleBricksTimer")
			removeAction(forKey: "powerUpHiddenBricksTimer")
			// Remove any animations and timers
			hiddenBricksIcon.texture = self.iconHiddenBlocksTexture
			hiddenBricksIconBar.isHidden = false
			// Show power-up icon timer
			enumerateChildNodes(withName: BrickCategoryName) { (node, _) in
				let temporarySprite = node as! SKSpriteNode
				if temporarySprite.texture != self.brickMultiHit1Texture && temporarySprite.texture != self.brickMultiHit2Texture && temporarySprite.texture != self.brickMultiHit3Texture && temporarySprite.texture != self.brickMultiHit4Texture && temporarySprite.texture != self.brickIndestructible1Texture && temporarySprite.texture != self.brickIndestructible2Texture {
					temporarySprite.isHidden = true
				}
			}
			powerUpScore = -50
			powerUpMultiplierScore = -0.1
			powerupsCollected[14]+=1
			// Power up set
			let timer: Double = 10 * multiplier
			let waitDuration = SKAction.wait(forDuration: timer)
			let completionBlock = SKAction.run {
				self.enumerateChildNodes(withName: BrickCategoryName) { (node, _) in
					let temporarySprite = node as! SKSpriteNode
					if node.isHidden == true && temporarySprite.texture != self.brickInvisibleTexture {
						let startingScale = SKAction.scale(to: 1, duration: 0)
						let startingFade = SKAction.fadeOut(withDuration: 0)
						let scaleUp = SKAction.scale(to: 1, duration: 0)
						let fadeIn = SKAction.fadeIn(withDuration: 0.2)
						let startingGroup = SKAction.group([startingFade, startingScale])
						let brickGroup = SKAction.group([scaleUp, fadeIn])
						node.run(startingGroup, completion: {
							node.isHidden = false
							node.run(brickGroup)
						})
					}
				}
				self.hiddenBricksIcon.texture = self.iconHiddenBlocksDisabledTexture
				self.hiddenBricksIconBar.isHidden = true
			}
			hiddenBricksIconBar.run(SKAction.scaleX(to: 1.0, duration: 0.05), completion: {
				self.hiddenBricksIconBar.run(SKAction.scaleX(to: 0.0, duration: timer), withKey: "invisibleBricksTimer")
			})
			let sequence = SKAction.sequence([waitDuration, completionBlock])
			hiddenBricksIcon.run(SKAction.sequence([timerScaleUp, timerScaleDown]), withKey: "powerUpHiddenBricksTimer")
			// Setup timer animation
			self.run(sequence, withKey: "powerUpInvisibleBricks")
			// Power up reverted
			
		case powerUpMultiHitToNormalBricks:
		// Multi-hit bricks become normal bricks
			enumerateChildNodes(withName: BrickCategoryName) { (node, _) in
				let temporarySprite = node as! SKSpriteNode
				if temporarySprite.texture == self.brickMultiHit1Texture || temporarySprite.texture == self.brickMultiHit2Texture || temporarySprite.texture == self.brickMultiHit3Texture {
					temporarySprite.texture = self.brickMultiHit4Texture
				}
			}
			powerUpScore = 50
			powerUpMultiplierScore = 0.1
			powerupsCollected[15]+=1
			// Power up set
			
		case powerUpMultiHitBricksReset:
		// Multi-hit bricks reset
			enumerateChildNodes(withName: BrickCategoryName) { (node, _) in
				let temporarySprite = node as! SKSpriteNode
				if temporarySprite.texture == self.brickMultiHit2Texture || temporarySprite.texture == self.brickMultiHit3Texture || temporarySprite.texture == self.brickMultiHit4Texture {
					temporarySprite.texture = self.brickMultiHit1Texture
				}
			}
			powerUpScore = -50
			powerUpMultiplierScore = -0.1
			powerupsCollected[16]+=1
			// Power up set
			
		case powerUpRemoveIndestructibleBricks:
		// Remove indestructible bricks
			enumerateChildNodes(withName: BrickCategoryName) { (node, _) in
				let temporarySprite = node as! SKSpriteNode
				if temporarySprite.texture == self.brickIndestructible2Texture || temporarySprite.texture == self.brickIndestructible1Texture {
					temporarySprite.texture = self.brickNullTexture
					temporarySprite.isHidden = true
					self.removeBrick(node: node, sprite: temporarySprite)
				}
			}
			powerUpScore = 50
			powerUpMultiplierScore = 0.1
			powerupsCollected[17]+=1
			// Power up set
			if bricksLeft == 0 && endlessMode == false {
				levelScore = levelScore + levelCompleteScore
				if endlessMode == false {
					scoreLabel.text = String(totalScore + levelScore)
				}
				gameState.enter(InbetweenLevels.self)
				return
			}
			// If the last active brick has been removed, end the level

        case powerUpGigaBall:
        // giga-ball
			removeAction(forKey: "powerUpGigaBall")
			removeAction(forKey: "powerUpUndestructiBall")
			removeAction(forKey: "powerUpGigaBallTimer")
			removeAction(forKey: "gigaBallTimer")
			// Remove any animations and timers
			gigaBallIcon.texture = self.iconGigaBallTexture
			gigaBallIconBar.isHidden = false
			// Show power-up icon timer
			gigaBallDeactivate = false
            ball.texture = gigaBallTexture
            ballPhysicsBodySet()
            powerUpScore = 50
			powerUpMultiplierScore = 0.1
			powerupsCollected[18]+=1
			powerUpLimit = 4
            // Power up set
            let timer: Double = 10 * multiplier
            let waitDuration = SKAction.wait(forDuration: timer)
            let completionBlock = SKAction.run {
				if self.ballIsOnPaddle {
					self.deactivateGigaBall()
				} else {
					self.gigaBallDeactivate = true
				}
				self.gigaBallIconBar.isHidden = true
				// Hide power-up icons
            }
			gigaBallIconBar.run(SKAction.scaleX(to: 1.0, duration: 0.05), completion: {
				self.gigaBallIconBar.run(SKAction.scaleX(to: 0.0, duration: timer), withKey: "gigaBallTimer")
			})
            let sequence = SKAction.sequence([waitDuration, completionBlock])
			gigaBallIcon.run(SKAction.sequence([timerScaleUp, timerScaleDown]), withKey: "powerUpGigaBallTimer")
			// Setup timer animation
            self.run(sequence, withKey: "powerUpGigaBall")
            // Power up reverted
            
        case powerUpUndestructiBall:
        // Undestructi-ball
            removeAction(forKey: "powerUpGigaBall")
			removeAction(forKey: "powerUpUndestructiBall")
			removeAction(forKey: "powerUpGigaBallTimer")
			removeAction(forKey: "gigaBallTimer")
			// Remove any animations and timers
			gigaBallIcon.texture = self.iconUndestructiballTexture
			gigaBallIconBar.isHidden = false
			// Show power-up icon timer
			gigaBallDeactivate = false
            ball.texture = undestructiballTexture
            ballPhysicsBodySet()
			powerUpLimit = 2
            powerUpScore = -50
			powerupsCollected[19]+=1
			powerUpMultiplierScore = -0.1
            // Power up set
            let timer: Double = 10 * multiplier
            let waitDuration = SKAction.wait(forDuration: timer)
            let completionBlock = SKAction.run {
                self.ball.texture = self.ballTexture
				self.ballPhysicsBodySet()
				self.gigaBallIcon.texture = self.iconGigaBallDisabledTexture
				self.gigaBallIconBar.isHidden = true
				// Hide power-up icons
            }
			gigaBallIconBar.run(SKAction.scaleX(to: 1.0, duration: 0.05), completion: {
				self.gigaBallIconBar.run(SKAction.scaleX(to: 0.0, duration: timer), withKey: "gigaBallTimer")
			})
            let sequence = SKAction.sequence([waitDuration, completionBlock])
			gigaBallIcon.run(SKAction.sequence([timerScaleUp, timerScaleDown]), withKey: "powerUpGigaBallTimer")
			// Setup timer animation
            self.run(sequence, withKey: "powerUpUndestructiBall")
            // Power up reverted

        case powerUpLasers:
        // Lasers
			removeAction(forKey: "powerUpLasers")
			removeAction(forKey: "powerUpLaserTimer")
			removeAction(forKey: "laserTimer")
			laserTimer?.invalidate()
			// Remove any current animations and timers
			lasersIcon.texture = self.iconLasersTexture
			lasersIconBar.isHidden = false
			// Show power-up icon timer
            laserPowerUpIsOn = true
			paddleLaser.isHidden = false
            laserTimer = Timer.scheduledTimer(timeInterval: 0.33, target: self, selector: #selector(laserGenerator), userInfo: nil, repeats: true)
			powerUpScore = 50
			powerUpMultiplierScore = 0.1
			powerupsCollected[20]+=1
			powerUpLimit = 4
            // Power up set - lasers will fire every 0.1s
            let timer: Double = 10 * multiplier
            let waitDuration = SKAction.wait(forDuration: timer)
            let completionBlock = SKAction.run {
                self.laserTimer?.invalidate()
				self.paddleLaser.isHidden = true
				self.laserPowerUpIsOn = false
				self.powerUpLimit = 2
				self.lasersIcon.texture = self.iconLasersDisabledTexture
				self.lasersIconBar.isHidden = true
				// Hide power-up icons
            }
			lasersIconBar.run(SKAction.scaleX(to: 1.0, duration: 0.05), completion: {
				self.lasersIconBar.run(SKAction.scaleX(to: 0.0, duration: timer), withKey: "laserTimer")
			})
            let sequence = SKAction.sequence([waitDuration, completionBlock])
			lasersIcon.run(SKAction.sequence([timerScaleUp, timerScaleDown]), withKey: "powerUpLaserTimer")
			// Setup timer animation
            self.run(sequence, withKey: "powerUpLasers")
            // Power up reverted - lasers will fire for 10s
		
		case powerUpBricksDown:
		// Move all bricks down
			enumerateChildNodes(withName: BrickCategoryName) { (node, _) in
				let brickSprite = node as! SKSpriteNode
				let moveBricksDown = SKAction.moveBy(x: 0, y: -brickSprite.size.height*2, duration: 0.5)
				moveBricksDown.timingMode = .easeInEaseOut
				node.run(moveBricksDown)
			}
			powerUpScore = -50
			powerUpMultiplierScore = -0.1
			powerupsCollected[21]+=1
			
		case powerUpMystery:
		// Mystery power-up
			powerUpScore = 0
			powerUpMultiplierScore = 0
			powerupsCollected[22]+=1
			mysteryPowerUp = true
			powerUpGenerator (sprite: sprite)
			
		case powerUpBackstop:
		// Backstop power
			if backstopCatches == 0 {
				backstop.size.height = self.paddle.size.height
				backstop.size.width = self.gameWidth-2
				backstop.run(SKAction.scale(by: 0.25, duration: 0.0), completion: {
					self.backstop.isHidden = false
					self.backstop.run(SKAction.scale(by: 4, duration: 0.1), completion: {
						self.backstopCatches = 1
						self.backstopCatchesTotal = self.backstopCatches
						self.powerUpScore = 50
						self.powerUpMultiplierScore = 0.1
						self.powerupsCollected[23]+=1
						self.backstop.physicsBody!.categoryBitMask = CollisionTypes.backstopCategory.rawValue
						self.backstop.physicsBody!.collisionBitMask = CollisionTypes.ballCategory.rawValue
						self.backstop.physicsBody!.contactTestBitMask = CollisionTypes.ballCategory.rawValue
						self.ballPhysicsBodySet()
						// Power up set and limit number of catches per power up
					})
				})
			}
			// don't do anything if power-up already in place
            
		case powerUpIncreaseBallSize:
        // Increase ball size
			removeAction(forKey: "powerUpIncreaseBallSize")
			removeAction(forKey: "powerUpDecreaseBallSize")
			removeAction(forKey: "powerUpBallSizeTimer")
			removeAction(forKey: "ballSizeTimer")
			// Remove any current ball size power up timers
			
			ballSizeIcon.texture = self.iconBallSizeBigTexture
			ballSizeIconBar.isHidden = false
			// Show power-up icon timer

			if ball.xScale == 1.0 {
				ball.run(SKAction.scale(to: 1.5, duration: 0.2), completion: {
					self.setBallStartingPositionY()
				})
			} else if ball.xScale > 1.0 {
				ball.run(SKAction.scale(to: 2.0, duration: 0.2), completion: {
					self.setBallStartingPositionY()
				})
			} else if ball.xScale < 1.0 {
				ball.run(SKAction.scale(to: 1.0, duration: 0.2), completion: {
					self.setBallStartingPositionY()
				})
				ballSizeIcon.texture = self.iconBallSizeDisabledTexture
				ballSizeIconBar.isHidden = true
			}

            powerUpScore = 50
			powerUpMultiplierScore = 0.1
			powerupsCollected[24]+=1
			// Power up set

            let timer: Double = 10 * multiplier
            let waitDuration = SKAction.wait(forDuration: timer)
			let completionBlock = SKAction.run {
				if self.hapticsSetting! {
					self.rigidHaptic.impactOccurred()
				}
				self.ball.run(SKAction.scale(to: 1, duration: 0.2), completion: {
					self.setBallStartingPositionY()
				})
				self.ballSizeIcon.texture = self.iconBallSizeDisabledTexture
				self.ballSizeIconBar.isHidden = true
				// Hide power-up icons
            }
			ballSizeIconBar.run(SKAction.scaleX(to: 1.0, duration: 0.05), completion: {
				self.ballSizeIconBar.run(SKAction.scaleX(to: 0.0, duration: timer), withKey: "ballSizeTimer")
			})
            let sequence = SKAction.sequence([waitDuration, completionBlock])
			ballSizeIcon.run(SKAction.sequence([timerScaleUp, timerScaleDown]), withKey: "powerUpBallSizeTimer")
			// Setup timer animation
            self.run(sequence, withKey: "powerUpIncreaseBallSize")
            // Power up reverted
            
        case powerUpDecreaseBallSize:
        // Decrease ball size
			removeAction(forKey: "powerUpIncreaseBallSize")
			removeAction(forKey: "powerUpDecreaseBallSize")
			removeAction(forKey: "powerUpBallSizeTimer")
			removeAction(forKey: "ballSizeTimer")
			// Remove any current ball speed power up timers
			
			ballSizeIcon.texture = self.iconBallSizeSmallTexture
			ballSizeIconBar.isHidden = false
			// Show power-up icon timer
			
			if ball.xScale == 1.0 {
				ball.run(SKAction.scale(to: 0.75, duration: 0.2), completion: {
					self.setBallStartingPositionY()
				})
			} else if ball.xScale < 1.0 {
				ball.run(SKAction.scale(to: 0.5, duration: 0.2), completion: {
					self.setBallStartingPositionY()
				})
			} else if ball.xScale > 1.0 {
				ball.run(SKAction.scale(to: 1.0, duration: 0.2), completion: {
					self.setBallStartingPositionY()
				})
				ballSizeIcon.texture = self.iconBallSizeDisabledTexture
				ballSizeIconBar.isHidden = true
			}
			
            powerUpScore = -50
			powerUpMultiplierScore = -0.1
			powerupsCollected[25]+=1
            // Power up set
			
            let timer: Double = 10 * multiplier
            let waitDuration = SKAction.wait(forDuration: timer)
			let completionBlock = SKAction.run {
				if self.hapticsSetting! {
					self.rigidHaptic.impactOccurred()
				}
				self.ball.run(SKAction.scale(to: 1, duration: 0.2), completion: {
					self.setBallStartingPositionY()
				})
				self.ballSizeIcon.texture = self.iconBallSizeDisabledTexture
				self.ballSizeIconBar.isHidden = true
				// Hide power-up icons
            }
			ballSizeIconBar.run(SKAction.scaleX(to: 1.0, duration: 0.05), completion: {
				self.ballSizeIconBar.run(SKAction.scaleX(to: 0.0, duration: timer), withKey: "ballSizeTimer")
			})
            let sequence = SKAction.sequence([waitDuration, completionBlock])
			ballSizeIcon.run(SKAction.sequence([timerScaleUp, timerScaleDown]), withKey: "powerUpBallSizeTimer")
			// Setup timer animation
            self.run(sequence, withKey: "powerUpDecreaseBallSize")
            // Power up reverted
		
        default:
            break
        }
        // Identify power up and perform action

        levelScore = levelScore + Int(Double(powerUpScore) * multiplier)
		multiplier = multiplier + powerUpMultiplierScore
		if multiplier < 1.0 {
			multiplier = 1.0
		} else if multiplier > 2.0 {
			multiplier = 2.0
		}
//		 Ensure multiplier never goes below 1 or above 2
		if endlessMode == false {
			scoreLabel.text = String(totalScore + levelScore)
		}
		scoreFactorString = String(format:"%.1f", multiplier)
		if endlessMode {
			scoreLabel.text = "\(endlessHeight) m"
		}
		multiplierLabel.text = "x\(scoreFactorString)"
        // Update score
    }
	
	func setBallStartingPositionY() {
		ballStartingPositionY = paddlePositionY + paddle.size.height/2 + ball.size.height/2 + 1
		if ballIsOnPaddle {
			ball.position.y = ballStartingPositionY
			// Ensure ball remains on paddle
		}
	}
    
    func powerUpsReset() {
        self.removeAllActions()
        // Stop all timers and animations
       
		powerUpsOnScreen = 0
		multiplier = 1.0
        
		ball.physicsBody!.linearDamping = ballLinearDampening
		powerUpLimit = 2
		ball.texture = ballTexture
		ballPhysicsBodySet()
		gigaBallIcon.texture = iconGigaBallDisabledTexture
		gigaBallIconBar.isHidden = true
		// Giga-Ball/Undestructiball reset
		
		deactivateGigaBall()
		
		paddle.centerRect = CGRect(x: 0.0/80.0, y: 0.0/10.0, width: 80.0/80.0, height: 10.0/10.0)
		paddleLaser.centerRect = CGRect(x: 0.0/80.0, y: 0.0/16.0, width: 80.0/80.0, height: 16.0/16.0)
		paddleSticky.centerRect = CGRect(x: 0.0/80.0, y: 0.0/11.0, width: 80.0/80.0, height: 11.0/11.0)
		// Ensure good scaling of paddles
		paddle.run(SKAction.scaleX(to: 1.0, duration: 0.2))
		paddleLaser.run(SKAction.scaleX(to: 1.0, duration: 0.2))
		paddleSticky.run(SKAction.scaleX(to: 1.0, duration: 0.2))
		paddleSizeIcon.texture = iconPaddleSizeDisabledTexture
		paddleSizeIconBar.isHidden = true
		// Paddle size reset
		
		ballSpeedLimit = ballSpeedNominal
		ballSpeedIcon.texture = iconBallSpeedDisabledTexture
		ballSpeedIconBar.isHidden = true
		// Ball speed reset
		
		laserTimer?.invalidate()
		lasersIcon.texture = iconLasersDisabledTexture
		paddleLaser.isHidden = true
		lasersIconBar.isHidden = true
		laserPowerUpIsOn = false
		// Laser reset
		
		deactivateGravity()
		physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		ball.physicsBody!.affectedByGravity = false
		gravityActivated = false
		gravityIcon.texture = iconGravityDisabledTexture
		gravityIconBar.isHidden = true
		// Gravity reset
		
		paddleSticky.isHidden = true
		stickyPaddleCatches = 0
		stickyPaddleCatchesTotal = 0
		stickyPaddleIcon.texture = iconStickyPaddleDisabledTexture
		stickyPaddleIconBar.isHidden = true
		stickyPaddleIconBar.xScale = 0
		// Sticky paddle reset
		
		backstop.run(SKAction.scale(by: 0.25, duration: 0.1),completion: {
			self.backstop.isHidden = true
			self.backstopCatches = 0
			self.backstopCatchesTotal = 0
			self.backstop.physicsBody!.categoryBitMask = 0
			self.backstop.physicsBody!.collisionBitMask = 0
			self.backstop.physicsBody!.contactTestBitMask = 0
			self.backstop.run(SKAction.scale(by: 4, duration: 0.0))
		})
		// Backstop paddle reset
		
		ballSizeIcon.texture = iconBallSizeDisabledTexture
		ballSizeIconBar.isHidden = true
		ball.run(SKAction.scale(to: 1.0, duration: 0.2), completion: {
			self.setBallStartingPositionY()
		})
		// Ball size reset
		
		enumerateChildNodes(withName: BrickCategoryName) { (node, _) in
			let temporarySprite = node as! SKSpriteNode
			if node.isHidden == true && temporarySprite.texture != self.brickInvisibleTexture {
				let startingScale = SKAction.scale(to: 1, duration: 0)
				let startingFade = SKAction.fadeOut(withDuration: 0)
				let scaleUp = SKAction.scale(to: 1, duration: 0)
				let fadeIn = SKAction.fadeIn(withDuration: 0.2)
				let startingGroup = SKAction.group([startingFade, startingScale])
				let brickGroup = SKAction.group([scaleUp, fadeIn])
				node.run(startingGroup, completion: {
					node.isHidden = false
					node.run(brickGroup)
				})
			}
		}
		hiddenBricksIcon.texture = iconHiddenBlocksDisabledTexture
		hiddenBricksIconBar.isHidden = true
		// Invisible bricks reset
		
		// Remove any existing power-up icons and timers
    }
	
	func ballPhysicsBodySet() {
		if ball.texture == gigaBallTexture {
		// Giga-Ball power-up
			print("llama llama giga-ball set")
			ball.physicsBody!.contactTestBitMask = CollisionTypes.brickCategory.rawValue | CollisionTypes.paddleCategory.rawValue | CollisionTypes.screenBlockCategory.rawValue | CollisionTypes.boarderCategory.rawValue | CollisionTypes.bottomScreenBlockCategory.rawValue | CollisionTypes.backstopCategory.rawValue
			// Reset undestructi-ball power-up
			ball.physicsBody!.collisionBitMask = CollisionTypes.paddleCategory.rawValue | CollisionTypes.screenBlockCategory.rawValue | CollisionTypes.boarderCategory.rawValue | CollisionTypes.backstopCategory.rawValue
			// Set giga-ball power-up
		} else if ball.texture == undestructiballTexture {
		// Undestructible power-up
			print("llama llama undestructible set")
			ball.physicsBody!.collisionBitMask = CollisionTypes.brickCategory.rawValue | CollisionTypes.paddleCategory.rawValue | CollisionTypes.screenBlockCategory.rawValue | CollisionTypes.boarderCategory.rawValue | CollisionTypes.backstopCategory.rawValue
			// Reset giga-ball power-up
			ball.physicsBody!.contactTestBitMask = CollisionTypes.paddleCategory.rawValue | CollisionTypes.screenBlockCategory.rawValue | CollisionTypes.boarderCategory.rawValue | CollisionTypes.bottomScreenBlockCategory.rawValue | CollisionTypes.backstopCategory.rawValue
			// Set undestructible power-up
		} else {
			print("llama llama ball set")
			ball.physicsBody!.collisionBitMask = CollisionTypes.brickCategory.rawValue | CollisionTypes.paddleCategory.rawValue | CollisionTypes.screenBlockCategory.rawValue | CollisionTypes.boarderCategory.rawValue | CollisionTypes.backstopCategory.rawValue
			ball.physicsBody!.contactTestBitMask = CollisionTypes.brickCategory.rawValue | CollisionTypes.paddleCategory.rawValue | CollisionTypes.screenBlockCategory.rawValue | CollisionTypes.boarderCategory.rawValue | CollisionTypes.bottomScreenBlockCategory.rawValue | CollisionTypes.backstopCategory.rawValue
			// Set ball physics body
		}
	}
	// Set ball's physic's bodies
    
    func moveToMainMenu() {
		gameViewControllerDelegate?.moveToMainMenu()
    }
    // Function to return to the MainViewController from the GameViewController, run as a delegate from GameViewController
	
	func showPauseMenu(sender: String) {
		var score = totalScore
		if sender == "Pause" {
			score = totalScore + levelScore
			// Update score for pause menu
		} else {
            scoreLabel.isHidden = true
            multiplierLabel.isHidden = true
            pauseButton.isHidden = true
            livesLabel.isHidden = true
            life.isHidden = true
			// Hide UI
		}
		gameViewControllerDelegate?.showPauseMenu(levelNumber: levelNumber, numberOfLevels: numberOfLevels, score: score, packNumber: packNumber, height: endlessHeight, sender: sender, gameoverBool: gameoverStatus)
		// Pass over highscore data to pause menu
    }
	
	func showInbetweenView() {
		gameViewControllerDelegate?.showInbetweenView(levelNumber: levelNumber, score: totalScore, packNumber: packNumber)
		// Pass over data to inbetween view
	}
	
	func createInterstitial() {
		gameViewControllerDelegate?.createInterstitial()
	}
	// Setup interstitial ad
	
	func loadInterstitial() {
		gameViewControllerDelegate?.loadInterstitial()
	}
	// Show interstitial ad

	func recentreBall() {
		if ballIsOnPaddle {
			if ball.position.x - ball.size.width/2 < paddle.position.x - paddle.size.width/2 {
				ball.position.x = paddle.position.x - paddle.size.width/2 + ball.size.width/2
			} else if ball.position.x + ball.size.width/2 > paddle.position.x + paddle.size.width/2 {
				ball.position.x = paddle.position.x + paddle.size.width/2 - ball.size.width/2
			}
		}
	}
	// Recentre ball if it isn't on smaller paddle
	
	func userSettings() {
		adsSetting = defaults.bool(forKey: "adsSetting")
		soundsSetting = defaults.bool(forKey: "soundsSetting")
		musicSetting = defaults.bool(forKey: "musicSetting")
		hapticsSetting = defaults.bool(forKey: "hapticsSetting")
		parallaxSetting = defaults.bool(forKey: "parallaxSetting")
		paddleSensitivitySetting = defaults.integer(forKey: "paddleSensitivitySetting")
		gameCenterSetting = defaults.bool(forKey: "gameCenterSetting")
		ballSetting = defaults.integer(forKey: "ballSetting")
        paddleSetting = defaults.integer(forKey: "paddleSetting")
		brickSetting = defaults.integer(forKey: "brickSetting")
        appIconSetting = defaults.integer(forKey: "appIconSetting")
		// User settings
		
		saveGameSaveArray = defaults.object(forKey: "saveGameSaveArray") as! [Int]?
        saveMultiplier = defaults.double(forKey: "saveMultiplier")
        saveBrickTextureArray = defaults.object(forKey: "saveBrickTextureArray") as! [Int]?
        saveBrickColourArray = defaults.object(forKey: "saveBrickColourArray") as! [Int]?
        saveBrickXPositionArray = defaults.object(forKey: "saveBrickXPositionArray") as! [Int]?
        saveBrickYPositionArray = defaults.object(forKey: "saveBrickYPositionArray") as! [Int]?
		saveBallPropertiesArray = defaults.object(forKey: "saveBallPropertiesArray") as! [Double]?
        // Game save settings
		
		paddle.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
		if ballIsOnPaddle {
			ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
		}
		// Stop paddle and ball tilt
		
		if paddleSensitivitySetting == 0 {
			paddleMovementFactor = 1.00
		} else if paddleSensitivitySetting == 1 {
			paddleMovementFactor = 1.25
		} else if paddleSensitivitySetting == 2 {
			paddleMovementFactor = 1.50
		} else if paddleSensitivitySetting == 3 {
			paddleMovementFactor = 2.00
		} else if paddleSensitivitySetting == 4 {
			paddleMovementFactor = 3.00
		}
		// Reset paddle sensitivity
	}
	// Set user settings
	
	func musicHandler() {
		if musicSetting! && backgroundMusic == nil {
			if let musicURL = Bundle.main.url(forResource: "BrendanBlockTitleMusic", withExtension: "mp3") {
				backgroundMusic = SKAudioNode(url: musicURL)
				addChild(backgroundMusic)
			}
		}
        if musicSetting! {
			backgroundMusic.run(SKAction.play())
		} else if backgroundMusic != nil {
			backgroundMusic.run(SKAction.stop())
		}
    }
    // Background music setup

	func ballStuck() {
		enumerateChildNodes(withName: BrickCategoryName) { (node, _) in
			let temporarySprite = node as! SKSpriteNode
			if temporarySprite.texture == self.brickIndestructible1Texture || temporarySprite.texture == self.brickIndestructible2Texture {
					node.removeFromParent()
			}
		}
		brickBounceCounter = 0
	}

	func ballHorizontalControl(angleDegInput: Double) {
		
		if gravityActivated && ball.position.y > paddle.position.y + ballSize*4 {
			return
		}
		// Do not run ball angle correction if gravity is activated and the ball is above the non-gravity area
		
		var xSpeed = ball.physicsBody!.velocity.dx
		var ySpeed = ball.physicsBody!.velocity.dy
		let currentSpeed = sqrt(xSpeed*xSpeed + ySpeed*ySpeed)
		var angleDeg = angleDegInput
		
//		print("Llama start horizontal angle: ", angleDeg)
		
		if angleDeg <= minAngleDeg && angleDeg > 0 {
//			print("Horizontal correction 1")
			angleDeg = minAngleDeg
		}
		// Up and right
		if angleDeg >= -minAngleDeg && angleDeg <= 0 {
//			print("Horizontal correction 2")
			angleDeg = -minAngleDeg
		}
		// Down and right
		if angleDeg <= 180+minAngleDeg && angleDeg >= 180-minAngleDeg {
//			print("Horizontal correction 3")
			angleDeg = 180-minAngleDeg
		}
		// Up and left
		if angleDeg >= -180-minAngleDeg && angleDeg <= -180+minAngleDeg {
//			print("Horizontal correction 4")
			angleDeg = -180+minAngleDeg
		}
		// Down and left

//		print("Llama new horizontal angle: ", angleDeg)
		
		let angleRad = (angleDeg*Double.pi/180)
		xSpeed = CGFloat(cos(angleRad)) * currentSpeed
		ySpeed = CGFloat(sin(angleRad)) * currentSpeed
		ball.physicsBody!.velocity = CGVector(dx: xSpeed, dy: ySpeed)
		// Set the new angle of the ball
	}
	
	func ballVerticalControl() {
		
		if gravityActivated && ball.position.y > paddle.position.y + ballSize*4 {
			return
		}
		// Do not run ball angle correction if gravity is activated and the ball is above the non-gravity area
		
		var xSpeed = ball.physicsBody!.velocity.dx
		var ySpeed = ball.physicsBody!.velocity.dy
		let currentSpeed = sqrt(xSpeed*xSpeed + ySpeed*ySpeed)
		var angleDeg = Double(atan2(ySpeed, xSpeed))/Double.pi*180
		let verticalMinAngle = minAngleDeg/2
		
//		print("Llama start vertical angle: ", angleDeg)
		
		// Vertical Control
		if ball.position.x >= 0 {
			// ball is on right side of screen
			if angleDeg > 90-verticalMinAngle && angleDeg <= 90 {
//				print("Vertical correction R1")
				angleDeg = 90-verticalMinAngle
			}
			// Travelling up and right
			if angleDeg <= 90+verticalMinAngle && angleDeg > 90 {
//				print("Vertical correction R2")
				angleDeg = 90+verticalMinAngle
			}
			// Travelling up and left
			if angleDeg >= -90 && angleDeg < -90+verticalMinAngle {
//				print("Vertical correction R3")
				angleDeg = -90+verticalMinAngle
			}
			// Travelling down and right
			if angleDeg < -90 && angleDeg >= -90-verticalMinAngle {
//				print("Vertical correction R4")
				angleDeg = -90-verticalMinAngle
			}
			// Travelling down and left
		} else {
			// ball is on left side of screen
			if angleDeg >= 90-verticalMinAngle && angleDeg < 90 {
//				print("Vertical correction L1")
				angleDeg = 90-verticalMinAngle
			}
			// Travelling up and right
			if angleDeg < 90+verticalMinAngle && angleDeg >= 90 {
//				print("Vertical correction L2")
				angleDeg = 90+verticalMinAngle
			}
			// Travelling up and left
			if angleDeg > -90 && angleDeg <= -90+verticalMinAngle {
//				print("Vertical correction L3")
				angleDeg = -90+verticalMinAngle
			}
			// Travelling down and right
			if angleDeg <= -90 && angleDeg > -90-verticalMinAngle {
//				print("Vertical correction L4")
				angleDeg = -90-verticalMinAngle
			}
			// Travelling down and left
		}
		
//		print("Llama new vertical angle: ", angleDeg)
		
		let angleRad = (angleDeg*Double.pi/180)
		xSpeed = CGFloat(cos(angleRad)) * currentSpeed
		ySpeed = CGFloat(sin(angleRad)) * currentSpeed
		ball.physicsBody!.velocity = CGVector(dx: xSpeed, dy: ySpeed)
		// Set the new angle of the ball
	}
	
	func ballSpeedControl() {
		let xSpeed = ball.physicsBody!.velocity.dx
		let ySpeed = ball.physicsBody!.velocity.dy
		let currentSpeed = sqrt(xSpeed*xSpeed + ySpeed*ySpeed)
		if currentSpeed > ballSpeedLimit + currentSpeed/10 {
			ball.physicsBody!.linearDamping = 1.0
		} else if currentSpeed < ballSpeedLimit {
			if gravityActivated == false || ball.position.y < paddle.position.y + ballSize*4 {
				ball.physicsBody!.linearDamping = -1.0
			}
		} else {
			ball.physicsBody!.linearDamping = ballLinearDampening
		}
	}
	// Set the new speed of the ball and ensure it stays within the boundary
	
	func frameBallControl(xSpeed: CGFloat) {
		let ySpeed = ball.physicsBody!.velocity.dy
		var newXSpeed = xSpeed
		if (ball.position.x > 0 && xSpeed > 0) || (ball.position.x < 0 && xSpeed < 0) {
			newXSpeed = -xSpeed
		}
		ball.physicsBody!.velocity = CGVector(dx: newXSpeed, dy: ySpeed)
		// Ensure the ball bounces off the wall correctly]
//		print("Frame control")
		
		let angleDeg = Double(atan2(Double(ball.physicsBody!.velocity.dy), Double(ball.physicsBody!.velocity.dx)))/Double.pi*180
		ballHorizontalControl(angleDegInput: angleDeg)
	}
	
    @objc func laserGenerator() {
		
		if gameState.currentState is Playing {
        
			let laser = SKSpriteNode(imageNamed: "LaserNormal")
			
			laser.texture = laserNormalTexture
			
			
			if paddleTexture == rainbowPaddle {
				if rainbowLaserIndex > rainbowLaserArray.count-1 {
					rainbowLaserIndex = 0
				}
				laserNormalTexture = rainbowLaserArray[rainbowLaserIndex]
				rainbowLaserIndex+=1
			}
			// rainbow lasers
			
			if paddleTexture == stripyPaddle {
				if stripyLaserIndex > stripyLaserArray.count-1 {
					stripyLaserIndex = 0
				}
				laserNormalTexture = stripyLaserArray[stripyLaserIndex]
				stripyLaserIndex+=1
			}
			// stripy lasers
			
			if paddleTexture == retroPaddle {
				if retroLaserIndex > retroLaserArray.count-1 {
					retroLaserIndex = 0
				}
				laserNormalTexture = retroLaserArray[retroLaserIndex]
				retroLaserIndex+=1
			}
			// retro lasers
			
			laser.size.width = layoutUnit/4
			laser.size.height = laser.size.width*4
			
			if laserSideLeft {
				laser.position = CGPoint(x: paddle.position.x - paddle.size.width/2 + laser.size.width, y: paddle.position.y + paddleLaser.size.height/2 + laser.size.height/2)
				laser.texture = laserNormalTexture
				laserSideLeft = false
				// Left position
			} else {
				laser.position = CGPoint(x: paddle.position.x + paddle.size.width/2  - laser.size.width, y: paddle.position.y + paddleLaser.size.height/2 + laser.size.height/2)
				laser.texture = laserNormalTexture
				laserSideLeft = true
				// Right position
			}
			// Alternate position of laser on paddle
			
			laser.physicsBody = SKPhysicsBody(rectangleOf: laser.frame.size)
			laser.physicsBody!.allowsRotation = false
			laser.physicsBody!.friction = 0.0
			laser.physicsBody!.affectedByGravity = false
			laser.physicsBody!.isDynamic = true
			laser.name = LaserCategoryName
			laser.physicsBody!.categoryBitMask = CollisionTypes.laserCategory.rawValue
			laser.physicsBody!.collisionBitMask = CollisionTypes.brickCategory.rawValue | CollisionTypes.screenBlockCategory.rawValue
			laser.physicsBody!.contactTestBitMask = CollisionTypes.brickCategory.rawValue | CollisionTypes.screenBlockCategory.rawValue
			laser.zPosition = 2
			// Define laser properties
			
			if ball.texture == gigaBallTexture {
				laser.physicsBody!.collisionBitMask = 0
				laser.texture = laserGigaTexture
			}
			// if giga-ball power up is activated, allow laser to pass through bricks
			
			addChild(laser)
			lasersFired+=1
			
			let move = SKAction.moveBy(x: 0, y: frame.height, duration: 2)
			laser.run(move, completion: {
				laser.removeFromParent()
			})
			// Define laser movement
		}
    }
    
    @objc func pauseNotificationKeyReceived() {
		
		if self.gameState.currentState is Paused {
			// do nothing
		} else if self.gameState.currentState is Playing {
			clearSavedGame()
			// Clear current saved game before re-saving
			self.gameState.enter(Paused.self)
		}
    }
    // Pause the game if a notifcation from AppDelegate is received that the game will quit
	
	@objc func restartGameNotificiationKeyReceived() {
				
		if numberOfLevels > 1 {
			startLevelNumber = LevelPackSetup().startLevelNumber[packNumber]
			numberOfLevels = LevelPackSetup().numberOfLevels[packNumber]

			gameViewControllerDelegate?.selectedLevel = startLevelNumber
			gameViewControllerDelegate?.numberOfLevels = numberOfLevels
			gameViewControllerDelegate?.levelSender = levelSender
			gameViewControllerDelegate?.levelPack = packNumber
		}
		
		clearSavedGame()
		// If restarting after resuming, make sure the correct level is selected
		
        gameState.enter(PreGame.self)
    }
    // Pause the game if a notifcation from AppDelegate is received that the game will quit
	
	@objc func swipeGesture(gesture: UISwipeGestureRecognizer) -> Void {
		if endlessMoveInProgress == false && gameState.currentState is Playing {
			clearSavedGame()
			gameState.enter(Paused.self)
		}
		// Don't allow pause if brick down animation is in progress
	}
	
	func saveCurrentGame() {
		print("llama llama save current game")
		if numberOfLives == 0 && ballLostBool && ballIsOnPaddle == false {
			clearSavedGame()
			return
		}
		// If number of lives is 0 and ball lost animtion has started, don't save current game
				
		var currentLevelNumber = levelNumber
		let currentEndLevelNumber = endLevelNumber
		let currentPackNumber = packNumber
		var currentLevelScore = levelScore
		let currentTotalScore = totalScore + levelScore
		var currentNumberOfLives = numberOfLives
		let currentHeight = endlessHeight
		let currentNumberOfLevels = numberOfLevels
		
		if (gameState.currentState is InbetweenLevels || gameState.currentState is Ad) && gameoverStatus == false {
			if numberOfLevels > 1 {
				currentLevelNumber+=1
			} else {
				clearSavedGame()
				return
			}
		}
		// If inbetween levels but only playing 1 level at a time don't save
		
		let gameSaveArray = [currentLevelNumber, currentEndLevelNumber, currentPackNumber, currentLevelScore, currentTotalScore, currentNumberOfLives, currentHeight, currentNumberOfLevels]
		
		var currentMultiplier = multiplier
		
		if ballLostBool {
			currentLevelScore = currentLevelScore + lifeLostScore
			currentNumberOfLives-=1
		}
		// If ball is lost on pause, update properties to reflect that when reloading the game
		
		if ballLostBool || gameState.currentState is InbetweenLevels || gameState.currentState is Ad {
			currentMultiplier = 1.0
		}
		// If ball is lost or inbetween levels or ads, reset the multiplier
		
		var brickTextureArray: [Int]? = []
		var brickColourArray: [Int]? = []
		var brickXPositionArray: [Int]? = []
		var brickYPositionArray: [Int]? = []
		var ballPropertiesArray: [Double]? = []
		
		if gameState.currentState is Playing || gameState.currentState is Paused {
			enumerateChildNodes(withName: BrickCategoryName) { (node, _) in
				let sprite = node as! SKSpriteNode
				var spriteTextureIndex: Int?
				switch sprite.texture {
				case self.brickNormalTexture:
					if sprite.isHidden == false {
						spriteTextureIndex = 0
					} else {
						spriteTextureIndex = 1
					}
				case self.brickInvisibleTexture:
					if sprite.isHidden == false {
						spriteTextureIndex = 2
					} else {
						spriteTextureIndex = 3
					}
				case self.brickMultiHit1Texture:
					spriteTextureIndex = 4
				case self.brickMultiHit2Texture:
					spriteTextureIndex = 5
				case self.brickMultiHit3Texture:
					spriteTextureIndex = 6
				case self.brickMultiHit4Texture:
					spriteTextureIndex = 7
				case self.brickIndestructible1Texture:
					spriteTextureIndex = 8
				case self.brickIndestructible2Texture:
					spriteTextureIndex = 9
				case self.brickNullTexture:
					spriteTextureIndex = 10
				default:
					spriteTextureIndex = 0
				}
				
				var spriteColourIndex: Int?
				switch sprite.color {
				case self.brickBlue:
					spriteColourIndex = 0
				case self.brickBlueDark:
					spriteColourIndex = 1
				case self.brickBlueDarkExtra:
					spriteColourIndex = 2
				case self.brickBlueLight:
					spriteColourIndex = 3
				case self.brickGreenGigaball:
					spriteColourIndex = 4
				case self.brickGreenSI:
					spriteColourIndex = 5
				case self.brickGrey:
					spriteColourIndex = 6
				case self.brickGreyDark:
					spriteColourIndex = 7
				case self.brickGreyLight:
					spriteColourIndex = 8
				case self.brickOrange:
					spriteColourIndex = 9
				case self.brickOrangeDark:
					spriteColourIndex = 10
				case self.brickOrangeLight:
					spriteColourIndex = 11
				case self.brickPink:
					spriteColourIndex = 12
				case self.brickPurple:
					spriteColourIndex = 13
				case self.brickWhite:
					spriteColourIndex = 14
				case self.brickYellow:
					spriteColourIndex = 15
				case self.brickYellowLight:
					spriteColourIndex = 16
					
				case self.brickBrown:
					spriteColourIndex = 17
				case self.brickBrownLight:
					spriteColourIndex = 18
				case self.brickGreen:
					spriteColourIndex = 19
				case self.brickGreenDark:
					spriteColourIndex = 20
				case self.brickGreenLight:
					spriteColourIndex = 21
				case self.brickPurpleDark:
					spriteColourIndex = 22
				case self.brickYellowDark:
					spriteColourIndex = 23
					
				default:
					spriteColourIndex = 100
				}
				
				let currentBrickTexture = spriteTextureIndex
				let currentBrickColour = spriteColourIndex
				brickTextureArray!.append(currentBrickTexture!)
				brickColourArray!.append(currentBrickColour!)
				
				var currentBrickXIndex = Double((self.gameWidth/2 - self.brickWidth/2 - sprite.position.x)/self.brickWidth)
				var currentBrickYIndex = Double((self.yBrickOffset - sprite.position.y)/self.brickHeight)
				if self.endlessMode {
					currentBrickYIndex = Double((self.yBrickOffsetEndless - sprite.position.y)/self.brickHeight)
				}
				
				currentBrickXIndex = round(currentBrickXIndex)
				currentBrickYIndex = round(currentBrickYIndex)
				// Round to the nearest integer
				
				brickXPositionArray!.append(Int(currentBrickXIndex))
				brickYPositionArray!.append(Int(currentBrickYIndex))
			}
			// Brick save
				
			if ballIsOnPaddle == false && self.ballLostBool == false && (gameState.currentState is Playing || gameState.currentState is Paused) {
				let ballXPosition = Double(ball.position.x)
				let ballYPosition = Double(ball.position.y)
				let ballDXVelocity = Double(pauseBallVelocityX)
				let ballDYVelocity = Double(pauseBallVelocityY)
				let paddleXPosition = Double(paddle.position.x)
				ballPropertiesArray = [ballXPosition, ballYPosition, ballDXVelocity, ballDYVelocity, paddleXPosition]
			}
			// Only save ball properties if ball is in play and not on paddle
		}
		// Save bricks, ball and power-up if playing or paused

		saveGameSaveArray! = gameSaveArray
		saveMultiplier! = currentMultiplier
		
		if brickXPositionArray != [] {
			saveBrickTextureArray! = brickTextureArray!
			saveBrickColourArray! = brickColourArray!
			saveBrickXPositionArray! = brickXPositionArray!
			saveBrickYPositionArray! = brickYPositionArray!
		}
		
		if ballPropertiesArray != [] {
			saveBallPropertiesArray! = ballPropertiesArray!
		}
		
		defaults.set(saveGameSaveArray!, forKey: "saveGameSaveArray")
		defaults.set(saveMultiplier!, forKey: "saveMultiplier")
		defaults.set(saveBrickTextureArray!, forKey: "saveBrickTextureArray")
		defaults.set(saveBrickColourArray!, forKey: "saveBrickColourArray")
		defaults.set(saveBrickXPositionArray!, forKey: "saveBrickXPositionArray")
		defaults.set(saveBrickYPositionArray!, forKey: "saveBrickYPositionArray")
		defaults.set(saveBallPropertiesArray!, forKey: "saveBallPropertiesArray")
		
		print("llama saved game log: ", saveGameSaveArray!, saveMultiplier!, saveBrickTextureArray!, saveBrickColourArray!, saveBrickXPositionArray!, saveBrickYPositionArray!, saveBallPropertiesArray!)
	}
	
	func clearSavedGame() {
		userSettings()
		saveGameSaveArray! = []
		saveMultiplier! = 1.0
		saveBrickTextureArray! = []
		saveBrickColourArray! = []
		saveBrickXPositionArray! = []
		saveBrickYPositionArray! = []
		saveBallPropertiesArray! = []
		defaults.set(saveGameSaveArray!, forKey: "saveGameSaveArray")
		defaults.set(saveMultiplier!, forKey: "saveMultiplier")
		defaults.set(saveBrickTextureArray!, forKey: "saveBrickTextureArray")
		defaults.set(saveBrickColourArray!, forKey: "saveBrickColourArray")
		defaults.set(saveBrickXPositionArray!, forKey: "saveBrickXPositionArray")
		defaults.set(saveBrickYPositionArray!, forKey: "saveBrickYPositionArray")
		defaults.set(saveBallPropertiesArray!, forKey: "saveBallPropertiesArray")
		print("llama llama save game data cleared GS: ", saveGameSaveArray!)
	}
	
	func resumeGame() {
		if saveGameSaveArray! != [] {
			if saveBallPropertiesArray != [] {
				ballIsOnPaddle = false
				ballLostBool = false
				ball.position.x = CGFloat(saveBallPropertiesArray![0])
				ball.position.y = CGFloat(saveBallPropertiesArray![1])
				paddle.position.x = CGFloat(saveBallPropertiesArray![4])
				numberOfLevels = saveGameSaveArray![7]
			} else {
				saveCurrentGame()
			}
			// Load ball position and velocity if it has been saved
			self.gameState.enter(Paused.self)
		}
	}
	
	func resumeFromPauseCountdown() {
			
		countdownStarted = true
		isPaused = false
		pauseAllNodes()
		pauseButton.texture = pauseHighlightedTexture
		pauseButton.size.width = pauseButtonSize*0.9
		pauseButton.size.height = pauseButtonSize*0.9
		// Unpause scene to allow for animation ensuring all other nodes remain paused for now
		
		let startScale = SKAction.scale(to: 2, duration: 0)
		let startFade = SKAction.fadeOut(withDuration: 0)
		let scaleIn = SKAction.scale(to: 1, duration: 0.25)
		let scaleOut = SKAction.scale(to: 0.5, duration: 0.25)
		let fadeIn = SKAction.fadeIn(withDuration: 0.25)
		let fadeOut = SKAction.fadeOut(withDuration: 0.25)
		let wait = SKAction.wait(forDuration: 0.75)
		readyCountdown.removeAllActions()
		goCountdown.removeAllActions()
		// Setup animation properties

		let startGroup = SKAction.group([startScale, startFade])
		// Prep label ahead of animation
		let animationIn1 = SKAction.group([scaleIn, fadeIn, wait])
		// Animate in with pause
		let animationIn2 = SKAction.group([scaleIn, fadeIn])
		// Animate in
		let animationOut = SKAction.group([scaleOut, fadeOut])
		// Animate out
		
		readyCountdown.run(startGroup, completion: {
			self.readyCountdown.isHidden = false
			self.readyCountdown.run(animationIn1, completion: {
				self.readyCountdown.run(animationOut, completion: {
					self.readyCountdown.isHidden = true
					self.goCountdown.run(startGroup, completion: {
						self.goCountdown.isHidden = false
						self.goCountdown.run(animationIn2, completion: {
							self.gameState.enter(Playing.self)
							// Restart playing
							if self.hapticsSetting! {
								self.lightHaptic.impactOccurred()
							}
							self.goCountdown.run(animationOut, completion: {
								self.goCountdown.isHidden = true
							})
						})
					})
				})
			})
		})
		// Animate countdown
	}
	
	func pauseAllNodes() {
        enumerateChildNodes(withName: PaddleCategoryName) { (node, _) in
            node.isPaused = true
        }
        enumerateChildNodes(withName: BallCategoryName) { (node, _) in
            self.ball.physicsBody!.velocity.dx = 0
            self.ball.physicsBody!.velocity.dy = 0
            node.isPaused = true
        }
        enumerateChildNodes(withName: BrickCategoryName) { (node, _) in
            node.isPaused = true
        }
        enumerateChildNodes(withName: BrickRemovalCategoryName) { (node, _) in
            node.isPaused = true
        }
        enumerateChildNodes(withName: PowerUpCategoryName) { (node, _) in
			node.removeAction(forKey: "PowerUpDrop")
        }
        enumerateChildNodes(withName: LaserCategoryName) { (node, _) in
            node.isPaused = true
        }
        // Pause all nodes individually
        
        ball.physicsBody!.affectedByGravity = false
        // Ensure the ball won't fall under gravity if the gameScene is unpaused
        
        if ballIsOnPaddle == false && ballLostBool == false {
            
            let angleRad = atan2(Double(self.pauseBallVelocityY), Double(self.pauseBallVelocityX))
            let angleDeg = Double(angleRad)/Double.pi*180
            let rotationAngle = CGFloat(angleRad)
            directionMarker.zRotation = rotationAngle
            directionMarker.size.width = ball.size.width*3.5
            directionMarker.size.height = ball.size.height*3.5
            directionMarker.position.x = ball.position.x
            directionMarker.position.y = ball.position.y
            // Set direction marker rotation to match the ball's direction of travel and position
            
            if ball.texture == gigaBallTexture {
                directionMarker.texture = directionMarkerOuterGigaTexture
            } else if ball.texture == undestructiballTexture {
                directionMarker.texture = directionMarkerOuterUndestructiTexture
            } else {
                directionMarker.texture = directionMarkerOuterTexture
            }
            // Set direction marker outer texture if the ball is near either edge of frame
            
            if directionMarker.position.x > 0 + frame.size.width/2 - directionMarker.size.width/2 {
                if angleDeg > -90 && angleDeg < 90 {
                    if ball.texture == gigaBallTexture {
                        directionMarker.texture = directionMarkerInnerGigaTexture
                    } else if ball.texture == undestructiballTexture {
                        directionMarker.texture = directionMarkerInnerUndestructiTexture
                    } else {
                        directionMarker.texture = directionMarkerInnerTexture
                    }
                    // Set texture of direction marker based on ball texture
                }
            }
            else if directionMarker.position.x < 0 - frame.size.width/2 + directionMarker.size.width/2 {
                if angleDeg < -90 || angleDeg > 90 {
                    if ball.texture == gigaBallTexture {
                        directionMarker.texture = directionMarkerInnerGigaTexture
                    } else if ball.texture == undestructiballTexture {
                        directionMarker.texture = directionMarkerInnerUndestructiTexture
                    } else {
                        directionMarker.texture = directionMarkerInnerTexture
                    }
                    // Set texture of direction marker based on ball texture
                }
            }
            // Set direction marker inner texture if the ball is near either edge of frame
    
            directionMarker.isHidden = false
            // Show ball direction marker
        }
    }
    // Pause all nodes
	
	func playFromPause() {
		
		clearSavedGame()
		countdownStarted = false
		pauseButton.texture = pauseTexture
		pauseButton.size.width = pauseButtonSize
        pauseButton.size.height = pauseButtonSize
		directionMarker.isHidden = true
		isPaused = false
		
		enumerateChildNodes(withName: PaddleCategoryName) { (node, _) in
			node.isPaused = false
		}
		enumerateChildNodes(withName: BallCategoryName) { (node, _) in
			self.ball.physicsBody!.velocity = CGVector(dx: self.pauseBallVelocityX, dy: self.pauseBallVelocityY)
			node.isPaused = false
		}
		enumerateChildNodes(withName: BrickCategoryName) { (node, _) in
			node.isPaused = false
		}
		enumerateChildNodes(withName: BrickRemovalCategoryName) { (node, _) in
			node.isPaused = false
		}
		enumerateChildNodes(withName: PowerUpCategoryName) { (node, _) in
			let move = SKAction.moveBy(x: 0, y: -self.frame.height, duration: 7.5)
			node.run(move, withKey: "PowerUpDrop")
		}
		enumerateChildNodes(withName: LaserCategoryName) { (node, _) in
			node.isPaused = false
		}
		// Restart game, unpause all nodes
		
		ball.physicsBody!.affectedByGravity = true
		// Enusre the ball is affected by gravity
		
		if killBall {
			
			if numberOfLives == 0 {
				numberOfLives = 1
			}
			ballLost()
			levelScore = levelScore - lifeLostScore
			scoreLabel.text = String(totalScore + levelScore)
			// Score isn't reduced when killing ball
		}
		killBall = false
		
		if endlessMode {
			countBricks()
		}
	}
}

extension Notification.Name {
    public static let pauseNotificationKey = Notification.Name(rawValue: "pauseNotificationKey")
	public static let restartGameNotificiation = Notification.Name(rawValue: "restartGameNotificiation")
}
// Setup for notifcations from AppDelegate

