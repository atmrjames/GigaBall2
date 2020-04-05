//
//  Playing.swift
//  Megaball
//
//  Created by James Harding on 22/08/2019.
//  Copyright © 2019 James Harding. All rights reserved.
//

import SpriteKit
import GameplayKit

class Playing: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        
        print("llama llama entered playing")
        
        scene.userSettings()
        // Set user settings
        
        scene.musicHandler()
        
        if previousState is InbetweenLevels || previousState is Ad {
            scene.clearSavedGame()
            scene.levelNumber+=1
            // Increment level number
        }
        
        if previousState is PreGame || previousState is InbetweenLevels || previousState is Ad {
            reloadUI()
            loadNextLevel()
        }
        
        if previousState is Paused {
        // Unpause game
            scene.playFromPause()            
        }
    }
    // This function runs when this state is entered.

    func reloadUI() {
        scene.scoreLabel.isHidden = false
        scene.multiplierLabel.isHidden = false
        scene.pauseButton.isHidden = false
        scene.livesLabel.isHidden = false
        scene.life.isHidden = false
        // Show game labels
        
        scene.livesLabel.text = "x\(scene.numberOfLives)"
        // Reset labels
    }
    
    func loadNextLevel() {
        
        if scene.levelNumber > scene.endLevelNumber {
            scene.levelNumber = scene.endLevelNumber
        }
        scene.brickRemovalCounter = 0
        scene.powerUpsOnScreen = 0
        scene.levelScore = 0
        // Reset counters & scores
        
        scene.ball.position.y = scene.ballStartingPositionY

        if scene.saveGameSaveArray!.count > 0 {
            print("llama resume game log: ", scene.saveGameSaveArray!, scene.saveMultiplier!, scene.saveBrickTextureArray!, scene.saveBrickColourArray!, scene.saveBrickXPositionArray!, scene.saveBrickYPositionArray!)
            scene.levelScore = scene.saveGameSaveArray![3]
            scene.totalScore = scene.saveGameSaveArray![4]
            scene.numberOfLives = scene.saveGameSaveArray![5]
            scene.multiplier = scene.saveMultiplier!
        }
        // If resuming a game, reset counters and scores to saved values
        
        scene.scoreLabel.text = String(scene.totalScore)
        scene.scoreFactorString = String(format:"%.1f", scene.multiplier)
        scene.multiplierLabel.text = "x\(scene.scoreFactorString)"
        scene.livesLabel.text = "x\(self.scene.numberOfLives)"
        // Update number of lives label

        scene.ball.removeAllActions()
        scene.paddle.removeAllActions()
        scene.ballIsOnPaddle = true
        scene.paddle.position.x = 0
        scene.paddle.position.y = scene.paddlePositionY
        scene.ball.position.x = 0
        scene.ball.position.y = scene.ballStartingPositionY
        // Reset ball and paddle

        if scene.saveGameSaveArray! == [] {
            let startingScale = SKAction.scale(to: 0.8, duration: 0)
            let startingFade = SKAction.fadeOut(withDuration: 0)
            let scaleUp = SKAction.scale(to: 1, duration: 0.5)
            let fadeIn = SKAction.fadeIn(withDuration: 0.5)
            let wait = SKAction.wait(forDuration: 0.25)
            let startingGroup = SKAction.group([startingScale, startingFade])
            let animationGroup = SKAction.group([scaleUp, fadeIn])
            let animationSequence = SKAction.group([wait, animationGroup])
            
            scene.ball.run(startingGroup)
            scene.ball.isHidden = false
            scene.ball.run(animationSequence, completion: {
                self.scene.ballStartingPositionY = self.scene.ball.position.y
                // Resets the ball's starting position incase it is moved during the animation in
            })
            scene.paddle.run(startingGroup)
            scene.paddle.isHidden = false
            scene.paddle.run(animationSequence)
            // Animate paddle and ball in
        // Don't animate if resuming from save
        } else if scene.saveGameSaveArray!.count > 0 {
            scene.ball.isHidden = false
            scene.paddle.isHidden = false
            scene.totalScore = scene.totalScore - scene.levelScore
            
            if scene.saveBallPropertiesArray != [] {
                scene.pauseBallVelocityX = CGFloat(scene.saveBallPropertiesArray![2])
                scene.pauseBallVelocityY = CGFloat(scene.saveBallPropertiesArray![3])
                            
                if sqrt(scene.pauseBallVelocityX*scene.pauseBallVelocityX) + sqrt(scene.pauseBallVelocityY*scene.pauseBallVelocityY) == 0 {
                    scene.ballLaunchAngleRad = scene.straightLaunchAngleRad + scene.minLaunchAngleRad
                    scene.pauseBallVelocityX = cos(CGFloat(scene.ballLaunchAngleRad)) * CGFloat(scene.ballSpeedLimit)
                    scene.pauseBallVelocityY = sin(CGFloat(scene.ballLaunchAngleRad)) * CGFloat(scene.ballSpeedLimit)
                }
                // If ball velocity is zero, but shouldn't be, set a default launch speed when resuming
            }
        }
        // Reset total score to reflect pre-save value
            
        if scene.saveBrickXPositionArray != [] {
            scene.resumeBrickCreation()
            // Load saved level
        } else {
            switch scene.levelNumber {
            // Tutorial
            case 100:
                scene.loadLevel100()
            // Endless mode
            case 0:
                scene.loadLevel0()
            // Classic
            case 1:
                scene.loadLevel1()
            case 2:
                scene.loadLevel2()
            case 3:
                scene.loadLevel3()
            case 4:
                scene.loadLevel4()
            case 5:
                scene.loadLevel5()
            case 6:
                scene.loadLevel6()
            case 7:
                scene.loadLevel7()
            case 8:
                scene.loadLevel8()
            case 9:
                scene.loadLevel9()
            case 10:
                scene.loadLevel10()
            // Space
            case 11:
                scene.loadLevel11()
            case 12:
                scene.loadLevel12()
            case 13:
                scene.loadLevel13()
            case 14:
                scene.loadLevel14()
            case 15:
                scene.loadLevel15()
            case 16:
                scene.loadLevel16()
            case 17:
                scene.loadLevel17()
            case 18:
                scene.loadLevel18()
            case 19:
                scene.loadLevel19()
            case 20:
                scene.loadLevel20()
            default:
                break
            }
            // Load level in
        }
    }
        
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is GameOver.Type:
            return true
        case is InbetweenLevels.Type:
            return true
        case is Paused.Type:
            return true
        case is Ad.Type:
            return true
        default:
            return false
        }
    }
}

