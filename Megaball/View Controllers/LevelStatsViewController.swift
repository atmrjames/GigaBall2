//
//  LevelStatsViewController.swift
//  Megaball
//
//  Created by James Harding on 07/02/2020.
//  Copyright © 2020 James Harding. All rights reserved.
//

import UIKit

class LevelStatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let defaults = UserDefaults.standard
    var adsSetting: Bool?
    var soundsSetting: Bool?
    var musicSetting: Bool?
    var hapticsSetting: Bool?
    var parallaxSetting: Bool?
    var paddleSensitivitySetting: Int?
    // User settings
    
    let packStatsStore = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask).first?.appendingPathComponent("packStatsStore.plist")
    let levelStatsStore = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask).first?.appendingPathComponent("levelStatsStore.plist")
    let encoder = PropertyListEncoder()
    let decoder = PropertyListDecoder()
    var packStatsArray: [PackStats] = []
    var levelStatsArray: [LevelStats] = []
    // NSCoder data store & encoder setup
    
    let formatter = DateFormatter()
    // Setup date formatter
    
    let interfaceHaptic = UIImpactFeedbackGenerator(style: .light)
    var group: UIMotionEffectGroup?
    var blurView: UIVisualEffectView?
    // UI property setup
    
    var startLevel: Int?
    var levelNumber: Int?
    var packNumber: Int?
    var levelSender: String = "MainMenu"
    var statRows: Int = 6
    // Key properties
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var levelStatsView: UIView!
    @IBOutlet var levelNameLabel: UILabel!
    @IBOutlet var packNameAndLevelNumberLabel: UILabel!
    @IBOutlet var levelImageView: UIImageView!
    @IBOutlet var levelTableView: UITableView!
    @IBOutlet var playButtonLabel: UIButton!
    // UIViewController outlets
    
    @IBAction func backButton(_ sender: Any) {
        if hapticsSetting! {
            interfaceHaptic.impactOccurred()
        }
        NotificationCenter.default.post(name: .returnLevelSelectFromStatsNotification, object: nil)
        removeAnimate()
    }
    @IBAction func playButton(_ sender: Any) {
        if hapticsSetting! {
            interfaceHaptic.impactOccurred()
        }
        moveToGame(selectedLevel: levelNumber!, numberOfLevels: 1, sender: levelSender, levelPack: packNumber!)
    }
    // UIViewController actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.returnLevelStatsNotificationKeyReceived), name: .returnLevelStatsNotification, object: nil)
        // Sets up an observer to watch for notifications to check if the user has returned from the settings menu
        
        levelTableView.delegate = self
        levelTableView.dataSource = self
        levelTableView.register(UINib(nibName: "StatsTableViewCell", bundle: nil), forCellReuseIdentifier: "customStatCell")
        // TableView setup
        
        userSettings()
        loadData()
        if parallaxSetting! {
            addParallax()
        }
        updateLabels()
        levelTableView.reloadData()
        showAnimate()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customStatCell", for: indexPath) as! StatsTableViewCell
        levelTableView.rowHeight = 35.0
        
        let numberOfAttempts = levelStatsArray[levelNumber!].scores.count
        let scoreArraySum = levelStatsArray[levelNumber!].scores.reduce(0, +)
        
        switch indexPath.row {
        case 0:
            
            if numberOfAttempts == 0 {
                cell.statDescription.text = "No statistics available"
                cell.statValue.text = ""
            } else {
                cell.statDescription.text = "Highscore"
                if let highScore = levelStatsArray[levelNumber!].scores.max() {
                    cell.statValue.text = String(highScore)
                } else {
                    cell.statValue.text = ""
                }
            }
            return cell
        case 1:
            if numberOfAttempts == 0 {
                hideCell(cell: cell)
            } else {
                cell.statDescription.text = "Highscore date"
                
                if let highScore = levelStatsArray[levelNumber!].scores.max() {
                    let highScoreIndex = levelStatsArray[levelNumber!].scores.firstIndex(of: highScore)
                    let highScoreDate = levelStatsArray[levelNumber!].scoreDates[highScoreIndex!]
                    // Find date of highscore
                    
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let inputDate = formatter.string(from: highScoreDate)
                    let outputDate = formatter.date(from: inputDate)
                    formatter.dateFormat = "dd/MM/yyyy"
                    let convertedDate = formatter.string(from: outputDate!)
                    // Date to string conversion
                    
                    cell.statValue.text = convertedDate
                } else {
                    cell.statValue.text = ""
                }
            }
            return cell
        case 2:
            if numberOfAttempts == 0 {
                hideCell(cell: cell)
            } else {
                cell.statDescription.text = "Plays"
                cell.statValue.text = String(numberOfAttempts)
            }
            return cell
        case 3:
            if numberOfAttempts == 0 {
                hideCell(cell: cell)
            } else {
                cell.statDescription.text = "Completion rate"
                let completionRate: Double = Double(levelStatsArray[levelNumber!].numberOfCompletes)/Double(numberOfAttempts)*100.0

                let completionRateString = String(format:"%.1f", completionRate)
                // Double to string conversion to 1 decimal place
                
                cell.statValue.text = String(completionRateString)+"%"
            }
            return cell
        case 4:
            if numberOfAttempts == 0 {
                hideCell(cell: cell)
            } else {
                cell.statDescription.text = "Cumulative score"
                cell.statValue.text = String(scoreArraySum)
            }
            return cell
        
        case 5:
            if numberOfAttempts == 0 {
                hideCell(cell: cell)
            } else {
                cell.statDescription.text = "Average score"
                let averageScore = scoreArraySum/numberOfAttempts
                cell.statValue.text = String(averageScore)
            }
            return cell
        default:
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func hideCell(cell: StatsTableViewCell) {
        cell.statValue.text = ""
        cell.statDescription.text = ""
        levelTableView.rowHeight = 0.0
    }
    
    func moveToGame(selectedLevel: Int, numberOfLevels: Int, sender: String, levelPack: Int) {
        let gameView = self.storyboard?.instantiateViewController(withIdentifier: "gameView") as! GameViewController
        gameView.menuViewControllerDelegate = self as? MenuViewControllerDelegate
        gameView.selectedLevel = selectedLevel
        gameView.numberOfLevels = numberOfLevels
        gameView.levelSender = sender
        gameView.levelPack = levelPack
        self.navigationController?.pushViewController(gameView, animated: true)
    }
    // Segue to GameViewController with selected level
    
    func userSettings() {
        adsSetting = defaults.bool(forKey: "adsSetting")
        soundsSetting = defaults.bool(forKey: "soundsSetting")
        musicSetting = defaults.bool(forKey: "musicSetting")
        hapticsSetting = defaults.bool(forKey: "hapticsSetting")
        parallaxSetting = defaults.bool(forKey: "parallaxSetting")
        paddleSensitivitySetting = defaults.integer(forKey: "paddleSensitivitySetting")
        // Load user settings
    }
    
    func loadData() {
        if let packData = try? Data(contentsOf: packStatsStore!) {
            do {
                packStatsArray = try decoder.decode([PackStats].self, from: packData)
            } catch {
                print("Error decoding high score array, \(error)")
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
    }
    
    func addParallax() {
        let amount = 25
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount

        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount

        group = UIMotionEffectGroup()
        group!.motionEffects = [horizontal, vertical]
        levelStatsView.addMotionEffect(group!)
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            self.view.alpha = 0.0})
        { (finished: Bool) in
            if (finished) {
                self.view.removeFromSuperview()
            }
        }
    }
    
    func updateLabels() {
        levelNameLabel.text = LevelPackSetup().levelNameArray[levelNumber!-1]
        packNameAndLevelNumberLabel.text = LevelPackSetup().packTitles[packNumber!]+" - Level "+String(levelNumber!-startLevel!+1)
        levelImageView.image = LevelPackSetup().levelImageArray[levelNumber!-1]
        //        levelImageView.layer.cornerRadius = 10.0
        levelImageView.layer.masksToBounds = false
        levelImageView.layer.shadowColor = UIColor.black.cgColor
        levelImageView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        levelImageView.layer.shadowRadius = 10.0
        levelImageView.layer.shadowOpacity = 0.5
        playButtonLabel.setTitle("Play Level " + String(levelNumber!-startLevel!+1), for: .normal)
    }
    
    @objc func returnLevelStatsNotificationKeyReceived(_ notification: Notification) {
            userSettings()
            loadData()
            levelTableView.reloadData()
    }
    
}

extension Notification.Name {
    public static let returnLevelStatsNotification = Notification.Name(rawValue: "returnLevelStatsNotification")
}
// Notification setup
