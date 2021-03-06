//
//  Level056.swift
//  Megaball
//
//  Created by James Harding on 13/04/2020.
//  Copyright © 2020 James Harding. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene {
    func loadLevel56() {

        var brickArray: [SKNode] = []
        // Array to store all bricks

        for i in 0..<numberOfBrickRows {
            for j in 0..<numberOfBrickColumns {
                let brick = SKSpriteNode(imageNamed: "BrickNormal")
                brick.texture = brickNullTexture
                
                if (j == 1 || j == 9) && i >= 5 && i <= 6 {
                    brick.texture = brickNormalTexture
                    brick.color = brickGreenSI
                }
                if (j == 2 || j == 8) && ((i >= 4 && i <= 5) || (i >= 7 && i <= 19)) {
                    brick.texture = brickNormalTexture
                    brick.color = brickGreenSI
                }
                if (j == 3 || j == 7) && ((i >= 4 && i <= 5) || (i >= 7 && i <= 8) || (i >= 20 && i <= 21)) {
                    brick.texture = brickNormalTexture
                    brick.color = brickGreenSI
                }
                if (j == 4 || j == 6) && ((i >= 0 && i <= 5) || (i >= 7 && i <= 21) ) {
                    brick.texture = brickNormalTexture
                    brick.color = brickGreenSI
                }
                if j == 5 && ((i >= 0 && i <= 1) || (i >= 4 && i <= 5) || (i >= 7 && i <= 8) || (i >= 20 && i <= 21)) {
                    brick.texture = brickNormalTexture
                    brick.color = brickGreenSI
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
