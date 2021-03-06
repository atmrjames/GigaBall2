//
//  Level013.swift
//  Megaball
//
//  Created by James Harding on 03/03/2020.
//  Copyright © 2020 James Harding. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene {
    func loadLevel13() {
        
        var brickArray: [SKNode] = []
        // Array to store all bricks

        for i in 0..<numberOfBrickRows {
            for j in 0..<numberOfBrickColumns {
                let brick = SKSpriteNode(imageNamed: "BrickNormal")
                brick.texture = brickNullTexture
                
                if j == 0 && (i == 5 || i == 20) {
                    brick.texture = brickIndestructible1Texture
                }
                
                if j == 1 && (i == 5 || i == 20) {
                    brick.texture = brickIndestructible2Texture
                }
                if j == 1 && (i == 1 || i == 4 || i == 6 || i == 13 || i == 19 || i == 21) {
                    brick.texture = brickIndestructible1Texture
                }
                if j == 1 && (i == 3 || i == 7 || i == 8 || i == 17 || i == 18) {
                    brick.texture = brickInvisibleTexture
                }
                
                if j == 2 && (i == 1 || i == 13) {
                    brick.texture = brickIndestructible2Texture
                }
                if j == 2 && (i == 0 || i == 2 || i == 5 || i == 12 || i == 14 || i == 20) {
                    brick.texture = brickIndestructible1Texture
                }
                if j == 2 && (i == 9 || i == 10 || i == 11 || i == 15 || i == 16) {
                    brick.texture = brickInvisibleTexture
                }
                
                if j == 3 && (i == 1 || i == 13) {
                    brick.texture = brickIndestructible1Texture
                }
                if j == 3 && (i == 5 || i == 20) {
                   brick.texture = brickInvisibleTexture
                }
                
                if j == 4 && (i == 2 || i == 5 || i == 13 || i == 20) {
                   brick.texture = brickInvisibleTexture
                }
                if j == 4 && i == 16 {
                   brick.texture = brickMultiHit3Texture
                }
                
                if j == 5 && i == 2 {
                    brick.texture = brickIndestructible1Texture
                }
                if j == 5 && (i == 4 || i == 10 || i == 11 || i == 12 || i == 19) {
                   brick.texture = brickInvisibleTexture
                }
                if j == 5 && i == 16 {
                   brick.texture = brickMultiHit1Texture
                }
                if j == 5 && (i == 15 || i == 17) {
                   brick.texture = brickMultiHit3Texture
                }
                
                if j == 6 && i == 2 {
                    brick.texture = brickIndestructible2Texture
                }
                if j == 6 && (i == 1 || i == 3) {
                    brick.texture = brickIndestructible1Texture
                }
                if j == 6 && (i == 9 || i == 19) {
                   brick.texture = brickInvisibleTexture
                }
                if j == 6 && i == 16 {
                   brick.texture = brickMultiHit3Texture
                }
                
                if j == 7 && (i == 2 || i == 10) {
                    brick.texture = brickIndestructible1Texture
                }
                if j == 7 && i == 19 {
                   brick.texture = brickInvisibleTexture
                }
                
                if j == 8 && i == 10 {
                    brick.texture = brickIndestructible2Texture
                }
                if j == 8 && (i == 5 || i == 9 || i == 11 || i == 19) {
                    brick.texture = brickIndestructible1Texture
                }
                if j == 8 && (i == 3 || i == 8 || i == 12 || i == 13) {
                   brick.texture = brickInvisibleTexture
                }
                
                if j == 9 && (i == 5 || i == 19) {
                    brick.texture = brickIndestructible2Texture
                }
                if j == 9 && (i == 4 || i == 6 || i == 10 || i == 18 || i == 20) {
                    brick.texture = brickIndestructible1Texture
                }
                if j == 9 && (i == 7 || i == 14 || i == 15 || i == 16 || i == 17) {
                   brick.texture = brickInvisibleTexture
                }
                
                if j == 10 && (i == 5 || i == 19) {
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
