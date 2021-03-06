//
//  Level035.swift
//  Megaball
//
//  Created by James Harding on 13/04/2020.
//  Copyright © 2020 James Harding. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene {
    func loadLevel35() {

        var brickArray: [SKNode] = []
        // Array to store all bricks

        for i in 0..<numberOfBrickRows {
            for j in 0..<numberOfBrickColumns {
                let brick = SKSpriteNode(imageNamed: "BrickNormal")
                brick.texture = brickNullTexture
                
                if j == 2 && i >= 2 && i <= 19 {
                    brick.texture = brickNormalTexture
                    brick.color = brickYellowLight
                }
                if j >= 4 && j <= 6 && i == 0 {
                    brick.texture = brickNormalTexture
                    brick.color = brickYellowLight
                }
                if j >= 3 && j <= 7 && i == 1 {
                    brick.texture = brickNormalTexture
                    brick.color = brickYellowLight
                }
                
                if j == 8 && i >= 2 && i <= 19 {
                    brick.texture = brickNormalTexture
                    brick.color = brickYellow
                }
                if j >= 4 && j <= 6 && i == 21 {
                    brick.texture = brickNormalTexture
                    brick.color = brickYellow
                }
                if j >= 3 && j <= 7 && i == 20 {
                    brick.texture = brickNormalTexture
                    brick.color = brickYellow
                }
                
                if j >= 4 && j <= 6 && i >= 1 && i <= 20 {
                    brick.texture = brickNormalTexture
                    brick.color = brickGreyDark
                }
                if j >= 3 && j <= 7 && i >= 2 && i <= 19 {
                    brick.texture = brickNormalTexture
                    brick.color = brickGreyDark
                }
                
                if j == 4 && i >= 2 && i <= 5 {
                    brick.texture = brickMultiHit1Texture
                }
                if j == 5 && i >= 1 && i <= 2 {
                    brick.texture = brickMultiHit1Texture
                }
                if j == 5 && i >= 3 && i <= 4 {
                    brick.texture = brickMultiHit2Texture
                }
                if j == 5 && i >= 5 && i <= 6 {
                    brick.texture = brickMultiHit3Texture
                }
                if j == 6 && i >= 2 && i <= 5 {
                    brick.texture = brickMultiHit3Texture
                }
                
                if j == 4 && i >= 9 && i <= 12 {
                    brick.texture = brickNormalTexture
                    brick.color = brickOrangeDark
                }
                if j == 5 && i >= 8 && i <= 9 {
                    brick.texture = brickNormalTexture
                    brick.color = brickOrangeDark
                }
                if j == 5 && i >= 10 && i <= 11 {
                    brick.texture = brickNormalTexture
                    brick.color = brickOrange
                }
                if j == 5 && i >= 12 && i <= 13 {
                    brick.texture = brickNormalTexture
                    brick.color = brickOrangeLight
                }
                if j == 6 && i >= 9 && i <= 12 {
                    brick.texture = brickNormalTexture
                    brick.color = brickOrangeLight
                }
                
                if j == 4 && i >= 16 && i <= 19 {
                    brick.texture = brickNormalTexture
                    brick.color = brickGreen
                }
                if j == 5 && i >= 15 && i <= 16 {
                    brick.texture = brickNormalTexture
                    brick.color = brickGreen
                }
                if j == 5 && i >= 17 && i <= 18 {
                    brick.texture = brickNormalTexture
                    brick.color = brickGreenSI
                }
                if j == 5 && i >= 19 && i <= 20 {
                    brick.texture = brickNormalTexture
                    brick.color = brickGreenLight
                }
                if j == 6 && i >= 16 && i <= 19 {
                    brick.texture = brickNormalTexture
                    brick.color = brickGreenLight
                }

                brick.position = CGPoint(x: -gameWidth/2 + brickWidth/2 + brickWidth*CGFloat(j), y: yBrickOffset - brickHeight*CGFloat(i))
                
                if brick.texture == brickInvisibleTexture {
                    brick.isHidden = true
                }
                
                brickArray.append(brick)
            }
        }
        // Set brick textures and positions
        
        brickCreation(brickArray: brickArray)
        // Run brick creation
    }
}

//brick.texture = brickNormalTexture
//brick.color = brickWhite
