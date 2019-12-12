//
//  InbewteenLevelsViewController.swift
//  Megaball
//
//  Created by James Harding on 08/09/2019.
//  Copyright © 2019 James Harding. All rights reserved.
//

import UIKit

class InbewteenLevelsViewController: UIViewController {
    
    var levelNumber: Int = 4
    var levelScore: Int = 4
    var levelHighscore: Int = 4
    var totalScore: Int = 4
    var totalHighscore: Int = 4
    var gameoverStatus: Bool = false
    // Properties to store passed over data

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var levelCompleteLabel: UILabel!
    @IBOutlet weak var levelScoreLabel: UILabel!
    @IBOutlet weak var levelHighscoreLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var totalHighscoreLabel: UILabel!

    @IBOutlet weak var filledStar1: UIImageView!
    @IBOutlet weak var filledStar2: UIImageView!
    @IBOutlet weak var filledStar3: UIImageView!
    
    @IBOutlet weak var nextLevelButtonLabel: UIButton!
    @IBOutlet weak var restartButtonLabel: UIButton!
    
    @IBAction func nextLevelButton(_ sender: UIButton) {
        removeAnimate(nextAction: .continueToNextLevel)
        // move game scene to playing
    }
    
    @IBAction func restartButton(_ sender: UIButton) {
        restart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showAnimate()
        updateLabels()
    }

    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
    }
    
    func removeAnimate(nextAction: Notification.Name) {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            self.view.alpha = 0.0
        }) { (finished: Bool) in
            if (finished) {
                NotificationCenter.default.post(name: nextAction, object: nil)
                // Send notification to load the next level
                self.view.removeFromSuperview()
            }
        }
    }
    
    func updateLabels() {
        
        if gameoverStatus {
            levelCompleteLabel.text = "G A M E  O V E R"
            nextLevelButtonLabel.setTitle("MAIN MENU", for: .normal)
            restartButtonLabel.isHidden = false
        } else {
            levelCompleteLabel.text = "L E V E L  \(levelNumber)"
            nextLevelButtonLabel.setTitle("NEXT LEVEL", for: .normal)
            restartButtonLabel.isHidden = true
        }
        levelScoreLabel.text = String(levelScore)
        levelHighscoreLabel.text = "Highscore: \(levelHighscore)"
        totalScoreLabel.text = String(totalScore)
        totalHighscoreLabel.text = "Highscore: \(totalHighscore)"
    }
    
    func restart() {
        removeAnimate(nextAction: .restart)
        // move game scene to pregame
    }
}

