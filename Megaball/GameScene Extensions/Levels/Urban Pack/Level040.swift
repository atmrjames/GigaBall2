//
//  Level040.swift
//  Megaball
//
//  Created by James Harding on 13/04/2020.
//  Copyright © 2020 James Harding. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene {
    func loadLevel40() {

        var brickArray: [SKNode] = []
        // Array to store all bricks

        for i in 0..<numberOfBrickRows {
            for j in 0..<numberOfBrickColumns {
                let brick = SKSpriteNode(imageNamed: "BrickNormal")
                brick.texture = brickNullTexture
                
                if i >= 19 {
                    brick.texture = brickNormalTexture
                    brick.color = brickBlueDarkExtra
                }
                
                if i >= 16 && i <= 18 {
                    brick.texture = brickNormalTexture
                    brick.color = brickBlueDark
                }
                
                if i >= 12 && i <= 15 {
                    brick.texture = brickNormalTexture
                    brick.color = brickBlueLight
                }
                
                if i == 11 {
                    brick.texture = brickInvisibleTexture
                }
                if i == 12 && (j == 0 || j == 1 || j == 2 || j == 4 || j == 5 || j == 6 || j == 8 || j == 9 || j == 10) {
                    brick.texture = brickInvisibleTexture
                }
                if i == 13 && (j == 0 || j == 2 || j == 5 || j == 6 || j == 8 || j == 10) {
                    brick.texture = brickInvisibleTexture
                }
                if i == 14 && (j == 2 || j == 6 || j == 8 || j == 10) {
                    brick.texture = brickInvisibleTexture
                }
                if i == 15 && (j == 2 || j == 6 || j == 10) {
                    brick.texture = brickInvisibleTexture
                }
                
                if i == 10 {
                    brick.texture = brickNormalTexture
                    brick.color = brickBlueDarkExtra
                }
                if i == 9 && (j == 0 || j == 1 || j == 2 || j == 4 || j == 5 || j == 6 || j == 8 || j == 9 || j == 10) {
                    brick.texture = brickNormalTexture
                    brick.color = brickBlueDarkExtra
                }
                if i == 8 && (j == 0 || j == 2 || j == 5 || j == 6 || j == 8 || j == 10) {
                    brick.texture = brickNormalTexture
                    brick.color = brickBlueDarkExtra
                }
                if i == 7 && (j == 2 || j == 6 || j == 8 || j == 10) {
                    brick.texture = brickNormalTexture
                    brick.color = brickBlueDarkExtra
                }
                if i == 6 && (j == 2 || j == 6 || j == 10) {
                    brick.texture = brickNormalTexture
                    brick.color = brickBlueDarkExtra
                }
                
                if j == 8 && (i == 0 || i == 4) {
                    brick.texture = brickIndestructible1Texture
                }
                if j == 9 && (i >= 1 && i <= 3) {
                    brick.texture = brickIndestructible1Texture
                }
                if j == 8 && (i == 21 || i == 17) {
                    brick.texture = brickNormalTexture
                    brick.color = brickYellowLight
                }
                if j == 9 && (i >= 18 && i <= 20) {
                    brick.texture = brickNormalTexture
                    brick.color = brickYellowLight
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
