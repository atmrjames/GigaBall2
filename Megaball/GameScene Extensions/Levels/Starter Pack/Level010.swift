//
//  Level010.swift
//  Megaball
//
//  Created by James Harding on 18/12/2019.
//  Copyright © 2019 James Harding. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene {
    func loadLevel10() {

        var brickArray: [SKNode] = []
        // Array to store all bricks

        for i in 0..<numberOfBrickRows {
            for j in 0..<numberOfBrickColumns {
                let brick = SKSpriteNode(imageNamed: "BrickNormal")
                brick.texture = brickNullTexture
                
                if (j == 0 || j == 10) && (i == 0 || i == 1 || i == 20 || i == 21) {
                        brick.texture = brickMultiHit3Texture
                }
                if (j == 1 || j == 9) && (i == 2 || i == 3 || i == 18 || i == 19) {
                        brick.texture = brickMultiHit3Texture
                }
                if (j == 2 || j == 8) && (i == 4 || i == 5 || i == 16 || i == 17) {
                        brick.texture = brickMultiHit3Texture
                }
                if (j == 3 || j == 7) && (i == 6 || i == 7 || i == 14 || i == 15) {
                        brick.texture = brickMultiHit3Texture
                }
                if (j == 4 || j == 6) && (i == 8 || i == 9 || i == 12 || i == 13) {
                        brick.texture = brickMultiHit3Texture
                }
                
                if (j == 1 || j == 9) && i >= 4 && i <= 17 {
                    brick.texture = brickInvisibleTexture
                }
                if j >= 2 && j <= 8 && (i == 2 || i == 3 || i == 18 || i == 19) {
                    brick.texture = brickInvisibleTexture
                }
                
                if (j == 3 || j == 7) && i >= 8 && i <= 13 {
                        brick.texture = brickMultiHit1Texture
                }
                if j >= 4 && j <= 6 && (i == 6 || i == 7 || i == 14 || i == 15) {
                    brick.texture = brickMultiHit1Texture
                }
                
                if j == 5 && (i == 10 || i == 11) {
                    brick.texture = brickIndestructible1Texture
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
