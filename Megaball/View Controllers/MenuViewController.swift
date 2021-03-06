//
//  MenuViewController.swift
//  Megaball
//
//  Created by James Harding on 07/09/2019.
//  Copyright © 2019 James Harding. All rights reserved.
//

import UIKit
import GoogleMobileAds
import GameKit

class MenuViewController: UIViewController, MenuViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let interfaceHaptic = UIImpactFeedbackGenerator(style: .light)
    // Haptics setup
    
    var selectedLevel: Int?
    var numberOfLevels: Int?
    var levelSender: String?
    var levelPack: Int?
    // Game view properties
    
    let defaults = UserDefaults.standard
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
    
    let totalStatsStore = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask).first?.appendingPathComponent("totalStatsStore.plist")
    let packStatsStore = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask).first?.appendingPathComponent("packStatsStore.plist")
    let levelStatsStore = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask).first?.appendingPathComponent("levelStatsStore.plist")
    let encoder = PropertyListEncoder()
    let decoder = PropertyListDecoder()
    var totalStatsArray: [TotalStats] = []
    var packStatsArray: [PackStats] = []
    var levelStatsArray: [LevelStats] = []
    // NSCoder data store & encoder setup
    
    @IBOutlet var modeSelectTableView: UITableView!
    @IBOutlet var iconCollectionView: UICollectionView!
    @IBOutlet var logoButton: UIButton!
    
    @IBOutlet var bannerAdCollapsed: NSLayoutConstraint!
    @IBOutlet var bannerAdOpenSmall: NSLayoutConstraint!
    @IBOutlet var bannerAdOpenLarge: NSLayoutConstraint!
    
    var firstLaunch: Bool = false
    // Check if this is the first opening of the app since closing to know if to run splash screen
    
    @IBAction func logoButton(_ sender: Any) {
        if hapticsSetting! {
            interfaceHaptic.impactOccurred()
        }
        moveToAbout()
    }
    
    @IBOutlet var bannerView: GADBannerView!
    // Ad banner view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modeSelectTableView.delegate = self
        modeSelectTableView.dataSource = self
        modeSelectTableView.register(UINib(nibName: "ModeSelectTableViewCell", bundle: nil), forCellReuseIdentifier: "modeSelectCell")
        // Levels tableView setup
        
        iconCollectionView.delegate = self
        iconCollectionView.dataSource = self
        iconCollectionView.register(UINib(nibName: "MainMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "iconCell")
        // Levels tableView setup
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.returnMenuNotificationKeyReceived), name: .returnMenuNotification, object: nil)
        // Sets up an observer to watch for notifications to check if the user has returned from the settings menu
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.splashScreenEndedNotificationKeyReceived), name: .splashScreenEndedNotification, object: nil)
        // Sets up an observer to watch for the end of the splash screen in order to load game center authentification
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.foregroundNotificationKeyReceived), name: .foregroundNotification, object: nil)
        // Sets up an observer to watch for the app returning from the background
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.backgroundNotificationKeyReceived), name: .backgroundNotification, object: nil)
        // Sets up an observer to watch for the app going into the background
        
        print(NSHomeDirectory())
        // Prints the location of the NSUserDefaults plist (Library>Preferences)
        
        logoButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        collectionViewLayout()
        defaultSettings()
        refreshView()
        authGCPlayer()
        // Game Center authorisation
        
        print("llama game save array: ", saveGameSaveArray!)

        showSplashScreen()
        // Show splashscreen when first opening the app if there is no game to resume
    }

    override func viewWillAppear(_ animated: Bool) {
        refreshView()
    }
    
    func showSplashScreen() {
        if firstLaunch == false {
            firstLaunch = true
            let splashView = self.storyboard?.instantiateViewController(withIdentifier: "splashView") as! SplashViewController
            
            if saveGameSaveArray!.count > 0 {
                splashView.gameToResume = true
            } else {
                splashView.gameToResume = false
            }
            
            self.addChild(splashView)
            splashView.view.frame = self.view.frame
            self.view.addSubview(splashView.view)
            splashView.didMove(toParent: self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "modeSelectCell", for: indexPath) as! ModeSelectTableViewCell
        
        modeSelectTableView.rowHeight = 150.0
        
        if view.frame.size.height > 1000 {
            modeSelectTableView.rowHeight = 150.0
        }
                
        switch indexPath.row {
        case 0:
            cell.modeImageIcon.image = UIImage(named:"TutorialIcon.png")
            cell.modeTextLabel.text = "Tutorial (WIP)"
            cell.modeTextLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            hideCell(cell: cell)
        case 1:
            cell.modeImageIcon.image = UIImage(named:"ClassicIcon.png")
            cell.modeTextLabel.text = "Classic Mode"
            
        case 2:
            cell.modeImageIcon.image = UIImage(named:"EndlessIcon.png")
            cell.modeTextLabel.text = "Endless Mode"

        default:
            print("Error: Out of range")
            break
        }
        
        UIView.animate(withDuration: 0.1) {
            cell.cellView1.transform = .identity
            cell.cellView1.backgroundColor = #colorLiteral(red: 0.8705882353, green: 0.8705882353, blue: 0.8705882353, alpha: 1)
        }
        
        return cell
    }
    
    func hideCell(cell: ModeSelectTableViewCell) {
        modeSelectTableView.rowHeight = 0.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if hapticsSetting! {
            interfaceHaptic.impactOccurred()
        }
        
        UIView.animate(withDuration: 0.1) {
            let cell = self.modeSelectTableView.cellForRow(at: indexPath) as! ModeSelectTableViewCell
            cell.cellView1.backgroundColor = #colorLiteral(red: 0.5015605688, green: 0.4985827804, blue: 0.503851831, alpha: 1)
        }
        
        if indexPath.row == 0 {
        // Tutorial
//            levelSender = "MainMenu"
//            moveToGame(selectedLevel: LevelPackSetup().startLevelNumber[0], numberOfLevels: LevelPackSetup().numberOfLevels[0], sender: levelSender!, levelPack: 0)
        }
        
        if indexPath.row == 1 {
        // Level packs
            moveToPackSelector()
        }
        
        if indexPath.row == 2 {
        // Endless mode
            moveToLevelStats(startLevel: LevelPackSetup().startLevelNumber[1], levelNumber: LevelPackSetup().startLevelNumber[1], packNumber: 1)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        // Update collection view
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if hapticsSetting! {
            interfaceHaptic.impactOccurred()
        }
        UIView.animate(withDuration: 0.1) {
            let cell = self.modeSelectTableView.cellForRow(at: indexPath) as! ModeSelectTableViewCell
            cell.cellView1.transform = .init(scaleX: 0.95, y: 0.95)
            cell.cellView1.backgroundColor = #colorLiteral(red: 0.8335226774, green: 0.9983789325, blue: 0.5007104874, alpha: 1)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if hapticsSetting! {
            interfaceHaptic.impactOccurred()
        }
        UIView.animate(withDuration: 0.1) {
            let cell = self.modeSelectTableView.cellForRow(at: indexPath) as! ModeSelectTableViewCell
            cell.cellView1.transform = .identity
            cell.cellView1.backgroundColor = #colorLiteral(red: 0.8705882353, green: 0.8705882353, blue: 0.8705882353, alpha: 1)
        }
    }
    
    func collectionViewLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        if view.frame.size.width <= 414 && iconCollectionView.frame.size.width != view.frame.size.width-100 {
            iconCollectionView.frame.size.width = view.frame.size.width-100
        }
        // Ensures the collection view is the correct size
        
        let spacing = (iconCollectionView.frame.size.width-(50*3))/2
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing

        iconCollectionView!.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! MainMenuCollectionViewCell
        
        cell.frame.size.height = 50
        cell.frame.size.width = cell.frame.size.height
        
        cell.widthConstraint.constant = 50
        
        switch indexPath.row {
        case 0:
            cell.iconImage.image = UIImage(named:"ButtonStats.png")
        case 1:
            cell.iconImage.image = UIImage(named:"ButtonItems.png")
        case 2:
            cell.iconImage.image = UIImage(named:"ButtonSettings.png")
        default:
            print("Error: Out of range")
            break
        }
        
        UIView.animate(withDuration: 0.1) {
            cell.view.transform = .identity
        }
        
        return cell        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if hapticsSetting! {
            interfaceHaptic.impactOccurred()
        }
        
        if indexPath.row == 0 {
            moveToStats()
        }
        if indexPath.row == 1 {
            moveToItems()
        }
        if indexPath.row == 2 {
            moveToSettings()
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if hapticsSetting! {
            interfaceHaptic.impactOccurred()
        }
        UIView.animate(withDuration: 0.1) {
            let cell = self.iconCollectionView.cellForItem(at: indexPath) as! MainMenuCollectionViewCell
            cell.view.transform = .init(scaleX: 0.95, y: 0.95)
            
            switch indexPath.row {
            case 0:
                cell.iconImage.image = UIImage(named:"ButtonStatsHighlighted.png")
            case 1:
                cell.iconImage.image = UIImage(named:"ButtonItemsHighlighted.png")
            case 2:
                cell.iconImage.image = UIImage(named:"ButtonSettingsHighlighted.png")
            default:
                print("Error: Out of range")
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if hapticsSetting! {
            interfaceHaptic.impactOccurred()
        }
        UIView.animate(withDuration: 0.1) {
            let cell = self.iconCollectionView.cellForItem(at: indexPath) as! MainMenuCollectionViewCell
            cell.view.transform = .identity
            
            switch indexPath.row {
            case 0:
                cell.iconImage.image = UIImage(named:"ButtonStats.png")
            case 1:
                cell.iconImage.image = UIImage(named:"ButtonItems.png")
            case 2:
                cell.iconImage.image = UIImage(named:"ButtonSettings.png")
            default:
                print("Error: Out of range")
                break
            }
        }
    }
    
    func defaultSettings() {
        defaults.register(defaults: ["adsSetting": true])
        defaults.register(defaults: ["soundsSetting": true])
        defaults.register(defaults: ["musicSetting": true])
        defaults.register(defaults: ["hapticsSetting": true])
        defaults.register(defaults: ["parallaxSetting": true])
        defaults.register(defaults: ["paddleSensitivitySetting": 2])
        defaults.register(defaults: ["gameCenterSetting": false])
        defaults.register(defaults: ["ballSetting": 0])
        defaults.register(defaults: ["paddleSetting": 0])
        defaults.register(defaults: ["brickSetting": 0])
        defaults.register(defaults: ["appIconSetting": 0])
        // User settings
        
        defaults.register(defaults: ["saveGameSaveArray": []])
        defaults.register(defaults: ["saveMultiplier": 1.0])
        defaults.register(defaults: ["saveBrickTextureArray": []])
        defaults.register(defaults: ["saveBrickColourArray": []])
        defaults.register(defaults: ["saveBrickXPositionArray": []])
        defaults.register(defaults: ["saveBrickYPositionArray": []])
        defaults.register(defaults: ["saveBallPropertiesArray": []])
        // Game save settings
    }
    // Set default settings

    func moveToGame(selectedLevel: Int, numberOfLevels: Int, sender: String, levelPack: Int) {
        let gameView = self.storyboard?.instantiateViewController(withIdentifier: "gameView") as! GameViewController
        gameView.menuViewControllerDelegate = self
        gameView.selectedLevel = selectedLevel
        gameView.numberOfLevels = numberOfLevels
        gameView.levelSender = sender
        gameView.levelPack = levelPack
        self.navigationController?.pushViewController(gameView, animated: true)
    }
    // Segue to GameViewController
    
    func moveToPackSelector() {
        let packSelectorView = self.storyboard?.instantiateViewController(withIdentifier: "packSelectorView") as! PackSelectViewController
        self.addChild(packSelectorView)
        packSelectorView.view.frame = self.view.frame
        self.view.addSubview(packSelectorView.view)
        packSelectorView.didMove(toParent: self)
    }
    
    func moveToLevelStats(startLevel: Int, levelNumber: Int, packNumber: Int) {
        let levelStatsView = self.storyboard?.instantiateViewController(withIdentifier: "levelStatsView") as! LevelStatsViewController
        levelStatsView.startLevel = startLevel
        levelStatsView.levelNumber = levelNumber
        levelStatsView.packNumber = packNumber
        self.addChild(levelStatsView)
        levelStatsView.view.frame = self.view.frame
        self.view.addSubview(levelStatsView.view)
        levelStatsView.didMove(toParent: self)
    }
    // Segue to LevelStatsViewController
    
    func moveToSettings() {
        let settingsView = self.storyboard?.instantiateViewController(withIdentifier: "settingsVC") as! SettingsViewController
        settingsView.navigatedFrom = "MainMenu"
        self.addChild(settingsView)
        settingsView.view.frame = self.view.frame
        self.view.addSubview(settingsView.view)
        settingsView.didMove(toParent: self)
    }
    // Segue to Settings
    
    func moveToAbout() {
        let aboutView = self.storyboard?.instantiateViewController(withIdentifier: "aboutVC") as! AboutViewController
        self.addChild(aboutView)
        aboutView.view.frame = self.view.frame
        self.view.addSubview(aboutView.view)
        aboutView.didMove(toParent: self)
    }
    
    func moveToItems() {
        let itemsView = self.storyboard?.instantiateViewController(withIdentifier: "itemsView") as! ItemsViewController
        self.addChild(itemsView)
        itemsView.view.frame = self.view.frame
        self.view.addSubview(itemsView.view)
        itemsView.didMove(toParent: self)
    }
    
    func moveToStats() {
        let statsView = self.storyboard?.instantiateViewController(withIdentifier: "statsView") as! StatsViewController
        self.addChild(statsView)
        statsView.view.frame = self.view.frame
        self.view.addSubview(statsView.view)
        statsView.didMove(toParent: self)
    }
    
    func loadData() {
        
        if let totalData = try? Data(contentsOf: totalStatsStore!) {
            do {
                totalStatsArray = try decoder.decode([TotalStats].self, from: totalData)
            } catch {
                print("Error decoding total stats array, \(error)")
            }
        }
        // Load the total stats array from the NSCoder data store
        
        if totalStatsArray.count == 0 {
            let totalStatsItem = TotalStats()
            totalStatsArray = Array(repeating: totalStatsItem, count: 1)
            do {
                let data = try encoder.encode(totalStatsArray)
                try data.write(to: totalStatsStore!)
            } catch {
                print("Error setting up total stats array, \(error)")
            }
        }
        // Fill the empty array with 0s on first opening and re-save
        
        if let packData = try? Data(contentsOf: packStatsStore!) {
            do {
                packStatsArray = try decoder.decode([PackStats].self, from: packData)
            } catch {
                print("Error decoding high score array, \(error)")
            }
        }
        // Load the pack stats array from the NSCoder data store
        
        if packStatsArray.count == 0 {
            let packStatsItem = PackStats()
            packStatsArray = Array(repeating: packStatsItem, count: 100)
            do {
                let data = try encoder.encode(packStatsArray)
                try data.write(to: packStatsStore!)
            } catch {
                print("Error setting up pack stats array, \(error)")
            }
        }
        // Fill the empty array with 0s on first opening and re-save
        
        if let levelData = try? Data(contentsOf: levelStatsStore!) {
            do {
                levelStatsArray = try decoder.decode([LevelStats].self, from: levelData)
            } catch {
                print("Error decoding level stats array, \(error)")
            }
        }
        // Load the level stats array from the NSCoder data store
        
        if levelStatsArray.count == 0 {
            let levelStatsItem = LevelStats()
            levelStatsArray = Array(repeating: levelStatsItem, count: 500)
            do {
                let data = try encoder.encode(levelStatsArray)
                try data.write(to: levelStatsStore!)
            } catch {
                print("Error setting up level stats array, \(error)")
            }
        }
        // Fill the empty array with blank items on first opening and re-save
    }
    
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
    }
    
    func authGCPlayer() {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = { (view, error) in
            if view != nil {
                self.present(view!, animated: true, completion: {
                    self.updateGCAuth()
                })
            } else {
                self.updateGCAuth()
            }
        }
    }
    // Sets up game center
    
    func updateGCAuth() {
//      TODO: check user is the same user as signed in the previous session
        if GKLocalPlayer.local.isAuthenticated {
            gameCenterSetting = true
        } else {
            gameCenterSetting = false
        }
        defaults.set(gameCenterSetting!, forKey: "gameCenterSetting")
    }
    // Sets up game center
    
    func updateAds() {
        if defaults.bool(forKey: "adsSetting") {
            bannerView.isHidden = false
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            bannerView.rootViewController = self
            // Configure banner ad
            
            bannerAdCollapsed.isActive = false
            bannerAdOpenSmall.isActive = true
            bannerAdOpenLarge.isActive = true

            bannerView.load(GADRequest())
            // Load banner ad
        } else {
            bannerView.isHidden = true
            
            bannerAdOpenSmall.isActive = false
            bannerAdOpenLarge.isActive = false
            bannerAdCollapsed.isActive = true
        }
    }
    // Show or hide banner ad depending on setting
    
    func refreshView() {
        loadData()
        userSettings()
        updateAds()
        modeSelectTableView.reloadData()
        iconCollectionView.reloadData()
    }
    
    @objc func returnMenuNotificationKeyReceived(_ notification: Notification) {
        refreshView()
    }
    
    @objc private func splashScreenEndedNotificationKeyReceived(_ notification: Notification) {
        updateGCAuth()
        refreshView()
        
        if saveGameSaveArray!.count > 0 {
            loadSavedGame()
        }
    }
    // Runs when the splash screen has ended
    
    @objc private func foregroundNotificationKeyReceived(_ notification: Notification) {
        print("llama llama menu foreground")
        authGCPlayer()
        refreshView()
    }
    // Runs when the splash screen has ended
    
    @objc private func backgroundNotificationKeyReceived(_ notification: Notification) {
        print("llama llama menu background")
    }
    // Runs when the splash screen has ended
    
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
        print("llama llama save game data cleared MM: ", saveGameSaveArray!)
    }
    
    func loadSavedGame() {
        levelSender = "MainMenu"
        numberOfLevels = saveGameSaveArray![1] - saveGameSaveArray![0] + 1
        moveToGame(selectedLevel: saveGameSaveArray![0], numberOfLevels: numberOfLevels!, sender: levelSender!, levelPack: saveGameSaveArray![2])
        print("llama resume game: ", saveGameSaveArray![0], numberOfLevels!, levelSender!, saveGameSaveArray![2])
// TODO: Show specific loading splashscreen - delay for some time to load data, login to game center, etc
    }
}

extension Notification.Name {
    public static let returnMenuNotification = Notification.Name(rawValue: "returnMenuNotification")
    public static let splashScreenEndedNotification = Notification.Name(rawValue: "splashScreenEndedNotification")
    public static let foregroundNotification = Notification.Name(rawValue: "foregroundNotification")
    public static let backgroundNotification = Notification.Name(rawValue: "backgroundNotification")
}
// Notification setup
