//
//  ViewController.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 3/12/22.
//

import UIKit

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
}


class ViewController: UIViewController, ViewControllerDelegate {
    
    
    
    
    
    
    var coins: Int = 0
    var acquiredCats = [Cat(name: "Orange", description: "Does Nothing", image: UIImage(named: "Orange")!)]
    var selectedCat = "Orange"
    var cpc: Int = 1
    var cps: Int = 0
    var timerIncrement: Double = 5
    var clicks: Int = 970
    var achievements: [Achievement] = [Achievement(completedImage: UIImage(named: "Alien Cat")!, description: "Click 1000 Times", isComplete: false), Achievement(completedImage: UIImage(named: "Time Cat")!, description: "Click 1 Million Times", isComplete: false)]
    
    
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var dogRewardLabel: UILabel!
    @IBOutlet weak var catImageView: UIImageView!
    
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
    }

    @objc func catDidClick(_ sender: Any) {
        if clicks > 999 && !acquiredCats.contains(where: { cat in
            return cat.name == "Alien Cat"
        }){
            achievements[0].isComplete = true
            addCat(cat: Cat(name: "Alien Cat", description: "x1.5 CpC", image: UIImage(named: "Alien Cat")!))
        }
        if clicks > 999999 && !acquiredCats.contains(where: { cat in
            return cat.name == "Time Cat"
        }){
            achievements[1].isComplete = true
            addCat(cat: Cat(name: "Time Cat", description: "x3 CpC, x3 Autocoin", image: UIImage(named: "Time Cat")!))
        }
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

