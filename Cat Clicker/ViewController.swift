//
//  ViewController.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 3/12/22.
//

import UIKit
import AVFoundation
struct Achievement {
    var completedImage: UIImage
    var description: String
    var isComplete: Bool
}

protocol ViewControllerDelegate: AnyObject {
    func upgrade(coinDecrement: Int, cpcIncrement: Int)
    func getCoins() -> Int
    func resetcoinsVC()
    func addCat(cat: Cat)
    func getCatList() -> [Cat]
    func zeroCoins()
    func changeSelectedCat(cat: Cat)
    func getSelectedCat() -> String
    func increaseCps(amount: Int)
    func zeroCpC()
    func getTotalClicks() -> Int
    func getAchievements() -> [Achievement]
    func getCps() -> Int
    func increaseTuna(amount: Int)
    func increaseAdPoints(increment: Int)
    func getAdPoints() -> Int
}


class ViewController: UIViewController, ViewControllerDelegate {
    var coins: Int = 0
    var tuna: Int = 0
    var acquiredCats = [Cat(name: "Orange", description: "Does Nothing", image: UIImage(named: "Orange")!)]
    var selectedCat = "Orange"
    var cpc: Int = 1
    var cps: Int = 0
    var timerIncrement: Double = 5
    var clicks: Int = 0
    var player: AVAudioPlayer?
    var achievements: [Achievement] = [Achievement(completedImage: UIImage(named: "Alien Cat")!, description: "Click 1000 Times", isComplete: false), Achievement(completedImage: UIImage(named: "Time Cat")!, description: "Click 1 Million Times", isComplete: false), Achievement(completedImage: UIImage(named: "Ad Cat")!, description: "Watch 50 Ads", isComplete: false)]
    var adPoints = 0
    
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var dogRewardLabel: UILabel!
    @IBOutlet weak var settingsBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var catImageView: UIImageView!
    
    func getAdPoints() -> Int {
        return adPoints
    }
    func increaseAdPoints(increment: Int) {
       adPoints += increment
    }
    func getSelectedCat() -> String {
        return selectedCat
    }
    func zeroCoins() {
        if coins < 0 {
            coins = 0
        }
        
    }
    func getAchievements() -> [Achievement] {
        return achievements
    }
    func zeroCpC() {
        if cpc < 1 {
            cpc = 1
        }
        
    }
    func increaseTuna(amount: Int) {
        tuna += amount
    }
    func getCps() -> Int {
        return cps
    }
    func getCatList() -> [Cat] {
        return acquiredCats
    }
    func addCat(cat: Cat) {
        acquiredCats.append(cat)
    }
    func resetcoinsVC() {
        coinLabel.text = "Coins: \(coins)"
    }
    func getCoins() -> Int{
        return coins
    }
    func upgrade(coinDecrement: Int, cpcIncrement: Int) {
        coins -= coinDecrement
        cpc += cpcIncrement
    }
    func incrementCoins(increment: Int) {
        coins += increment
        coinLabel.text = "Coins: \(coins)"
    }
    func increaseCps(amount: Int) {
        cps += amount
    }
    func changeSelectedCat(cat: Cat) {
        selectedCat = cat.name
    }
    func getTotalClicks() -> Int {
        return clicks
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ShopViewController {
            destinationVC.viewControllerClass = self
        }
        if let destinationVC = segue.destination as? CrateShopViewController {
            destinationVC.viewControllerClass = self
        }
        if let destinationVC = segue.destination as? StatsAchievementsViewController {
            destinationVC.viewControllerClass = self
        }
        if let destinationVC = segue.destination as? catMenuViewController {
            destinationVC.acquiredCats = acquiredCats
            
            destinationVC.viewControllerClass = self
        }
        if let destinationVC = segue.destination as? AdViewController {
            destinationVC.viewControllerClass = self
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        //callcps()
        Timer.scheduledTimer(timeInterval: timerIncrement, target: self, selector: #selector(callcps), userInfo: nil, repeats: true)
        let tap = UITapGestureRecognizer(target: self, action: #selector(catDidClick(_:)))
        catImageView.addGestureRecognizer(tap)
        catImageView.isUserInteractionEnabled = true
    }
    override func viewWillAppear(_ animated: Bool) {
        dogRewardLabel.text = ""
        catImageView.image = UIImage(named: selectedCat)
        if adPoints >= 50 && !acquiredCats.contains(where: { cat in
            return cat.name == "Ad Cat"
        }){
            achievements[2].isComplete = true
            addCat(cat: Cat(name: "Ad Cat", description: "More Ad Rewards", image: UIImage(named: "Ad Cat")!))
        }
    }

    @objc func catDidClick(_ sender: Any) {
        animateCatOnPress()
        dogRewardLabel.text = ""
        incrementCoins(increment: cpc)
        clicks += 1
        
        if selectedCat == "Time Cat"{
            incrementCoins(increment: cpc)
            incrementCoins(increment: cpc)
        }
        if selectedCat == "Alien Cat"{
            let grayCps: Double = (Double(cpc) * 0.5)
            incrementCoins(increment: Int(round((grayCps))))
        }
        if selectedCat == "Dog" {
            var dogTreasure: [String] = ["Treasure!"]
            for _ in 1...50 {
                dogTreasure.append("Nope")
            }
            var dogReward = dogTreasure.randomElement()
            if dogReward == "Treasure!" {
                dogReward = dogTreasure.randomElement()
                if dogReward == "Treasure!" && !acquiredCats.contains(where: { cat in
                    return cat.name == "Easter Egg"
                }){
                    addCat(cat: Cat(name: "Easter Egg", description: "You found the Easter Egg!", image: UIImage(named: "Easter Egg")!))
                    dogRewardLabel.text = "Dog found the Easter Egg!"
                } else {
                    
                        let dogCps: Double = (Double(cps) * 0.1)
                        increaseCps(amount: Int(round((dogCps))))
                    
                    resetcoinsVC()
                    dogRewardLabel.text = "Dog found some Autocoin!"
                }
            }
            
        }
        if clicks > 999 && !acquiredCats.contains(where: { cat in
            return cat.name == "Alien Cat"
        }){
            achievements[0].isComplete = true
            addCat(cat: Cat(name: "Alien Cat", description: "x1.5 CpC", image: UIImage(named: "Alien Cat")!))
            dogRewardLabel.text = "Alien Cat Earned!"
        }
        if clicks > 999999 && !acquiredCats.contains(where: { cat in
            return cat.name == "Time Cat"
        }){
            achievements[1].isComplete = true
            addCat(cat: Cat(name: "Time Cat", description: "x3 CpC, x3 Autocoin", image: UIImage(named: "Time Cat")!))
            dogRewardLabel.text = "Time Cat Earned!"
        }
        
        playSound()
        
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Cat-sound-meow", withExtension: "mp3") else {return}
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        
        } catch let error as NSError{print(error.localizedDescription)}
    }
    
    func animateCatOnPress() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .allowUserInteraction) {
            self.catImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { success in
            UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction) {
                self.catImageView.transform = CGAffineTransform.identity
            } completion: { success in
               
            }
        }

    }
    
    @IBAction func settingsButtonDidTouch(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear) {
           // self.settingsBarButtonItem.customView?.transform = CGAffineTransform(rotationAngle: .pi)
            self.navigationItem.rightBarButtonItem?.customView?.transform = CGAffineTransform(rotationAngle: .pi)
        } completion: { success in
            
        }

    }
    
    
    
    @objc func callcps() {
       // DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
       //     self.coins += self.cps
       //     self.resetcoinsVC()
       //     self.callcps()
       // }
        self.coins += cps
        if selectedCat == "Gray" {
            let grayCps: Double = (Double(cps) * 0.05)
            incrementCoins(increment: Int(round((grayCps))))
        }
        if selectedCat == "Time Cat" {
            self.coins += cps
            self.coins += cps
        }
        self.resetcoinsVC()
    }
    @IBAction func shopButtonDidClick(_ sender: Any) {
        performSegue(withIdentifier: "shopSegue", sender: nil)
    }
    
    @IBAction func crateShopButtonDidClick(_ sender: Any) {
        performSegue(withIdentifier: "crateShopSegue", sender: nil)
    }
    @IBAction func catMenuButtonDidClick(_ sender: Any) {
        performSegue(withIdentifier: "catMenuSegue", sender: nil)
    }
    
    @IBAction func statsAchievementsButtonDidClick(_ sender: Any) {
        performSegue(withIdentifier: "statsAchievementsSegue", sender: nil)
    }
    
    @IBAction func adButtonDidTouch(_ sender: Any) {
        performSegue(withIdentifier: "adSegue", sender: nil)
    }
    
    
}

