//
//  ViewController.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 3/12/22.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseDatabase
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
    func getCurrentDay() -> Int
    func getDay() -> Int
    func getCatList() -> [Cat]
    func zeroCoins()
    func changeSelectedCat(cat: Cat)
    func getSelectedCat() -> String
    func increaseCps(amount: Int)
    func zeroCpC()
    func getAdsWatchedToday() -> Int
    func getTotalClicks() -> Int
    func getAchievements() -> [Achievement]
    func getCps() -> Int
    func increaseTuna(amount: Int)
    func increaseAdPoints(increment: Int)
    func getAdPoints() -> Int
    func getTuna() -> Int
    func increasePhalanxCount()
    func roundAndAbbreviate(num: Double) -> String
    func zeroTuna()
    
    func increaseCalendarCount()
}


class ViewController: UIViewController, ViewControllerDelegate {
    var calendar: Int = 0
    var user : UserModel?
    var hallOfFame: HallOfFamerModel?
    var coins: Int = 0
    var tuna: Int = 0
    var firebaseAcquiredCats: [String] = ["Orange"]
    var acquiredCats = [Cat(name: "Orange", description: "Does Nothing", image: UIImage(named: "Orange")!)]
    var selectedCat = "Orange"
    var cpc: Int = 1
    var cps: Int = 0
    var adsWatchedToday: Int = 0
    var currentDay: Int = 0
    var timerIncrement: Double = 5
    var clicks: Int = 0
    var temp: Int = 0
    var gazAvailable: Bool = false
    var player: AVAudioPlayer?
    var achievements: [Achievement] = [Achievement(completedImage: UIImage(named: "Alien Cat")!, description: "Click 1000 Times", isComplete: false), Achievement(completedImage: UIImage(named: "Time Cat")!, description: "Click 10,000 Times", isComplete: false), Achievement(completedImage: UIImage(named: "Ad Cat")!, description: "Watch 50 Ads", isComplete: false)]
    var adPoints = 0
    var phalanx = 0
    var achievement1IsComplete: Bool {
        return achievements[0].isComplete
    }
    var achievement2IsComplete: Bool {
        return achievements[1].isComplete
    }
    var achievement3IsComplete: Bool {
        return achievements[2].isComplete
    }
    
    
    
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var dogRewardLabel: UILabel!
    @IBOutlet weak var catImageView: UIImageView!
    
    func getAdPoints() -> Int {
        return adPoints
    }
    func increaseAdPoints(increment: Int) {
       adPoints += increment
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let upgrade = ["adPoints" : adPoints]
        UserModel.collection.child(userID).updateChildValues(upgrade)
    }
    func getSelectedCat() -> String {
        return selectedCat
    }
    func zeroCoins() {
        if coins < 0 {
            coins = 0
            guard let userID = Auth.auth().currentUser?.uid else {return}
            let upgrade = ["coins" : 0]
            UserModel.collection.child(userID).updateChildValues(upgrade)
        }
        
    }
    func getAdsWatchedToday() -> Int {
        print("getAdsWatchedToday func called")
        return adsWatchedToday
    }
    func zeroTuna() {
        if tuna < 0 {
            tuna = 0
            guard let userID = Auth.auth().currentUser?.uid else {return}
            let upgrade = ["tuna" : 0]
            UserModel.collection.child(userID).updateChildValues(upgrade)
        }
    }
    func getAchievements() -> [Achievement] {
        return achievements
    }
    func zeroCpC() {
        if cpc < 1 {
            cpc = 1
            guard let userID = Auth.auth().currentUser?.uid else {return}
            let upgrade = ["cpc" : cpc]
            UserModel.collection.child(userID).updateChildValues(upgrade)
        }
        
    }
    func increasePhalanxCount() {
        phalanx += 1
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let upgrade = ["phalanx" : phalanx]
        UserModel.collection.child(userID).updateChildValues(upgrade)
    }
    func increaseCalendarCount() {
        calendar += 1
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let upgrade = ["calendar" : calendar]
        UserModel.collection.child(userID).updateChildValues(upgrade)
    }
    func getTuna() -> Int {
        return tuna
    }
    
    
    func increaseTuna(amount: Int) {
        tuna += amount
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let upgrade = ["tuna" : tuna]
        UserModel.collection.child(userID).updateChildValues(upgrade)
    }
    func getCps() -> Int {
        return cps
    }
    func getCatList() -> [Cat] {
        return acquiredCats
    }
    func addCat(cat: Cat) {
        acquiredCats.append(cat)
        firebaseAcquiredCats.append(cat.name)
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        //var catsForFirebase = firebaseAcquiredCats.map { (key: Int, value: String) in
         //   return value
        //}
        let upgrade = ["firebaseAcquiredCats" : firebaseAcquiredCats]
        UserModel.collection.child(userID).updateChildValues(upgrade)
        print("cat acquired")
    }
    func resetcoinsVC() {
        let displayCoins: String = roundAndAbbreviate(num: Double(coins))
        coinLabel.text = "Coins: \(displayCoins)"
    }
    func getCoins() -> Int{
        return coins
    }
    func getDay() -> Int {
        // 1. Choose a date
        let today = Date()
        // 2. Pick the date components
        let day   = (Calendar.current.component(.day, from: today))
        let hour   = (Calendar.current.component(.hour, from: today))
        let minute = (Calendar.current.component(.minute, from: today))
        let second = (Calendar.current.component(.second, from: today))
        return day
    }
    func upgrade(coinDecrement: Int, cpcIncrement: Int) {
        coins -= coinDecrement
        if selectedCat == "Gazillionaire Cat" && coinDecrement < 0 {
            coins -= coinDecrement
        }
        cpc += cpcIncrement
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let upgrade = ["coins" : coins, "cpc" : cpc]
        UserModel.collection.child(userID).updateChildValues(upgrade)
    }
    func incrementCoins(increment: Int) {
        coins += increment
        if selectedCat == "Gazillionaire Cat" {
            coins += increment
        }
        resetcoinsVC()
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let upgrade = ["coins" : coins]
        UserModel.collection.child(userID).updateChildValues(upgrade)
    }
    func increaseCps(amount: Int) {
        cps += amount
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let upgrade = ["cps" : cps]
        UserModel.collection.child(userID).updateChildValues(upgrade)
    }
    func changeSelectedCat(cat: Cat) {
        selectedCat = cat.name
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let upgrade = ["selectedCat" : selectedCat]
        UserModel.collection.child(userID).updateChildValues(upgrade)
        catImageView.image = UIImage(named: selectedCat)
        print(selectedCat)
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
        if let destinationVC = segue.destination as? LeaderboardViewController {
            destinationVC.viewControllerClass = self
        }
        if let destinationVC = segue.destination as? catMenuViewController {
            destinationVC.viewControllerClass = self
        }
        if let destinationVC = segue.destination as? AdViewController {
            destinationVC.viewControllerClass = self
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if let currentUserId = Auth.auth().currentUser?.uid {
            UserModel.collection.child(currentUserId).observeSingleEvent(of: .value) { snapshot in
                guard let user = UserModel(snapshot: snapshot) else {return}
                self.user = user
                HallOfFamerModel.collection.child(currentUserId).observeSingleEvent(of: .value) { snapshot in
                    self.hallOfFame = HallOfFamerModel(snapshot: snapshot)
                    self.setup()
                } withCancel: { error in
                    self.setup()
                }

                
            }
        }
        
        
        
        
        
        
    }
    func setup() {
        callcps()
        let tap = UITapGestureRecognizer(target: self, action: #selector(catDidClick(_:)))
        catImageView.addGestureRecognizer(tap)
        catImageView.isUserInteractionEnabled = true
        guard let userID = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(userID).observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String: Any] else {return}
            print("Data Recieved: \(data)")
            let coins = data["coins"] as? Int ?? 0
            self.coins = coins
            DispatchQueue.main.async {
                self.coinLabel.text = "Coins: \(coins)"
            }
            let tuna = data["tuna"] as? Int ?? 0
            let clicks = data["clicks"] as? Int ?? 0
            let upgradeNumber = data["upgradeNumber"] as? Int ?? 1
            guard let userID = Auth.auth().currentUser?.uid else {return}
            let upgrade = ["upgradeNumber" : upgradeNumber]
            UserModel.collection.child(userID).updateChildValues(upgrade)
            let cps = data["cps"] as? Int ?? 0
            let cpc = data["cpc"] as? Int ?? 1
            let adPoints = data["adPoints"] as? Int ?? 0
            let phalanx = data["phalanx"] as? Int ?? 0
            
            let calendar = data["calendar"] as? Int ?? 0
            let currentDay = data["currentDay"] as? Int ?? 1
            let achievement1IsComplete = data["achievement1IsComplete"] as? Bool ?? false
            self.achievements[0].isComplete = achievement1IsComplete
            let achievement2IsComplete = data["achievement2IsComplete"] as? Bool ?? false
            self.achievements[1].isComplete = achievement2IsComplete
            let achievement3IsComplete = data["achievement3IsComplete"] as? Bool ?? false
            self.achievements[2].isComplete = achievement3IsComplete
            self.cpc = cpc
            self.cps = cps
            
            self.currentDay = currentDay
            self.firebaseAcquiredCats = data["firebaseAcquiredCats"] as? [String] ?? ["failed at ViewController ViewDidLoad"]
            
            for cat in self.firebaseAcquiredCats {
                if cat == "Gray" {
                    self.acquiredCats.append(Cat(name: "Gray", description: "+5% Autocoin", image: UIImage(named: "Gray")!))
                }
                if cat == "Cool" {
                    self.acquiredCats.append(Cat(name: "Cool", description: "More CpC in Crates", image: UIImage(named: "Cool")!))
                }
                if cat == "Dog" {
                    self.acquiredCats.append(Cat(name: "Dog", description: "Might dig up treasure!", image: UIImage(named: "Dog")!))
                }
                
                if cat == "Easter Egg" {
                    self.acquiredCats.append(Cat(name: "Easter Egg", description: "You found the Easter Egg!", image: UIImage(named: "Easter Egg")!))
                }
                if cat == "Alien Cat" {
                    self.acquiredCats.append(Cat(name: "Alien Cat", description: "x2 CpC", image: UIImage(named: "Alien Cat")!))
                }
                if cat == "Angel Cat" {
                    self.acquiredCats.append(Cat(name: "Angel Cat", description: "x3 CpC", image: UIImage(named: "Angel Cat")!))
                }
                if cat == "Time Cat" {
                    self.acquiredCats.append(Cat(name: "Time Cat", description: "x5 CpC", image: UIImage(named: "Time Cat")!))
                }
                if cat == "Ad Cat" {
                    self.acquiredCats.append(Cat(name: "Ad Cat", description: "More Ad Rewards", image: UIImage(named: "Ad Cat")!))
                }
                if cat == "Gazillionaire Cat" {
                    self.acquiredCats.append(Cat(name: "Gazillionaire Cat", description: "Double Coins from everywhere!", image: UIImage(named: "Gazillionaire Cat")!))
                }
                if cat == "Cat Food Cat" {
                    self.acquiredCats.append(Cat(name: "Cat Food Cat", description: "Cat Food Upgrades +Autocoin", image: UIImage(named: "Cat Food Cat")!))
                }
                if cat == "Gold Cat" {
                    self.acquiredCats.append(Cat(name: "Gold Cat", description: "Ads Give More Gold", image: UIImage(named: "Gold Cat")!))
                }
                if cat == "Salak Cat" {
                    self.acquiredCats.append(Cat(name: "Salak Cat", description: "More Tuna from Crates!", image: UIImage(named: "Salak Cat")!))
                }
                if cat == "Cat-O-Lantern" {
                    self.acquiredCats.append(Cat(name: "Cat-O-Lantern", description: "x2 CpC with a scary twist!", image: UIImage(named: "Cat-O-Lantern")!))
                }
                if cat == "Social Cat" {
                    self.acquiredCats.append(Cat(name: "Social Cat", description: "More Autocoin from crates!", image: UIImage(named: "Social Cat")!))
                }
                
            }
            for cat in self.firebaseAcquiredCats {
                if cat == "Calendar Cat" {
                    self.acquiredCats.append(Cat(name: "Calendar Cat", description: "More CpC the more you collect!", image: UIImage(named: "Calendar Cat")!))
                }
            }
            for cat in self.firebaseAcquiredCats {
                if cat == "Phalanx Cat" {
                    self.acquiredCats.append(Cat(name: "Phalanx Cat", description: "More Autocoin the more you collect!", image: UIImage(named: "Phalanx Cat")!))
                }
            }
            
            print("")
            print(self.firebaseAcquiredCats)
            print("")
            if let selectedCat = data["selectedCat"] as? String {
                self.selectedCat = selectedCat
                DispatchQueue.main.async {
                    self.catImageView.image = UIImage(named: selectedCat)
                }
                
            }
            self.clicks = clicks
            self.adPoints = adPoints
            self.tuna = tuna
            self.phalanx = phalanx
            self.calendar = calendar
            
            
        }
        if coins == 0 {
            dogRewardLabel.text = "Tap the Cat!"
        }
        
        Timer.scheduledTimer(timeInterval: self.timerIncrement, target: self, selector: #selector(self.callcps), userInfo: nil, repeats: true)
        if achievement1IsComplete == true {
            achievements[0].isComplete = true
        }
        if achievement2IsComplete == true {
            achievements[1].isComplete = true
        }
        if achievement3IsComplete == true {
            achievements[2].isComplete = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if coins > 0 {
            dogRewardLabel.text = ""
        }
          zeroTuna()
        
        
        
        if adPoints >= 50 && !acquiredCats.contains(where: { cat in
            return cat.name == "Ad Cat"
        }){
            achievements[2].isComplete = true
            addCat(cat: Cat(name: "Ad Cat", description: "More Ad Rewards", image: UIImage(named: "Ad Cat")!))
            guard let userID = Auth.auth().currentUser?.uid else {return}
            let upgrade = ["achievement3IsComplete" : true]
            UserModel.collection.child(userID).updateChildValues(upgrade)
            
        }
        guard let userID = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(userID).observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String: Any] else {return}
            let adsWatchedToday = data["adsWatchedToday"] as? Int ?? 0
            self.adsWatchedToday = adsWatchedToday
        }
        
        
        
        
    }

    /*func displayReward(text: String) {
        temp = clicks
        while clicks < temp + 5 {
            dogRewardLabel.text = text
        }
        dogRewardLabel.text = ""
    }
    */
    
    
    
    
    
    func getCurrentDay() -> Int {
        return currentDay
    }
    @objc func catDidClick(_ sender: Any) {
        animateCatOnPress()
        //dogRewardLabel.text = ""
        incrementCoins(increment: cpc)
        clicks += 1
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let upgrade = ["clicks" : clicks]
        UserModel.collection.child(userID).updateChildValues(upgrade)
        if selectedCat == "Time Cat"{
            incrementCoins(increment: cpc)
            incrementCoins(increment: cpc)
            incrementCoins(increment: cpc)
            incrementCoins(increment: cpc)
        }
        if selectedCat == "Angel Cat"{
            incrementCoins(increment: cpc)
            incrementCoins(increment: cpc)
        }
        if selectedCat == "Alien Cat"{
            incrementCoins(increment: cpc)
        }
        if selectedCat == "Cat-O-Lantern"{
            incrementCoins(increment: cpc)
        }
        if selectedCat == "Gazillionaire Cat" {
            incrementCoins(increment: cpc)
        }
        if selectedCat == "Calendar Cat" {
            let percent = cpc/4
            let rawCpC: Double = Double(percent * calendar)
            let roundedCpC = round(rawCpC)
            incrementCoins(increment: Int(roundedCpC))
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
            addCat(cat: Cat(name: "Alien Cat", description: "x2 CpC", image: UIImage(named: "Alien Cat")!))
            dogRewardLabel.text = "Alien Cat Earned!"
            guard let userID = Auth.auth().currentUser?.uid else {return}
            let upgrade = ["achievement1IsComplete" : true]
            UserModel.collection.child(userID).updateChildValues(upgrade)
            /*
            if !acquiredCats.contains(where: { cat in
                return cat.name == "Facebook Cat"
            }){
                let alert = UIAlertController(title: "Congrats!", message: "Congrats! You got the alien cat! Share on social media for a cat?", preferredStyle: .alert)
                
                let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
                    let items = [UIImage(named: "Alien Cat")!]
                    let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    ac.completionWithItemsHandler = { activity, completed, items, error in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        if activity! == UIActivity.ActivityType.postToFacebook {
                            alert.dismiss(animated: true) {
                                self.facebookCatReward()
                            }
                        } else {
                            alert.dismiss(animated: true) {
                                self.socialCatReward()
                            }
                        }
                    }
                    self.present(ac, animated: true)
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                
                alert.addAction(shareAction)
                alert.addAction(cancelAction)
                present(alert, animated: true)
            }
             */
        }
            
        if clicks > 9999 && !acquiredCats.contains(where: { cat in
            return cat.name == "Time Cat"
        }){
            
            achievements[1].isComplete = true
            addCat(cat: Cat(name: "Time Cat", description: "x5 CpC", image: UIImage(named: "Time Cat")!))
            dogRewardLabel.text = "Time Cat Earned!"
            guard let userID = Auth.auth().currentUser?.uid else {return}
            let upgrade = ["achievement2IsComplete" : true]
            UserModel.collection.child(userID).updateChildValues(upgrade)
            /*
            if !acquiredCats.contains(where: { cat in
                return cat.name == "Facebook Cat"
            }){
                let alert = UIAlertController(title: "Congrats!", message: "You got the time cat! Share on social media for a cat?", preferredStyle: .alert)
                
                let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
                    let items = [UIImage(named: "Time Cat")!]
                    let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    ac.completionWithItemsHandler = { activity, completed, items, error in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        
                        if activity! == UIActivity.ActivityType.postToFacebook {
                            alert.dismiss(animated: true) {
                                self.facebookCatReward()
                            }
                        } else {
                            alert.dismiss(animated: true) {
                                self.socialCatReward()
                            }
                        }
                    }
                    self.present(ac, animated: true)
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                
                alert.addAction(shareAction)
                alert.addAction(cancelAction)
                present(alert, animated: true)
            }
             */
        }
        
        playSound()
        
    }
    /*
    func facebookCatReward() {
        addCat(cat: Cat(name: "Social Cat", description: "More Autocoin from Crates!", image: UIImage(named: "Social Cat")!))
    }
    func socialCatReward() {
        addCat(cat: Cat(name: "Social Cat", description: "More Autocoin from Crates!", image: UIImage(named: "Social Cat")!))
    }
    */
    func playSound() {
        print("playSound before guard statements")
        guard let url = Bundle.main.url(forResource: "Cat-sound-meow", withExtension: "mp3") else {return}
        guard let url2 = Bundle.main.url(forResource: "dog", withExtension: "mp3") else {return}
        guard let url3 = Bundle.main.url(forResource: "boo", withExtension: "mp3") else {return}
        guard let url5 = Bundle.main.url(forResource: "paper", withExtension: "mp3") else {return}
        guard let url4 = Bundle.main.url(forResource: "strum", withExtension: "wav") else {return}
        print("made it through guard statements")
        if selectedCat == "Dog" {
            do{
                player = try AVAudioPlayer(contentsOf: url2)
                print("dog sound played")
                player?.play()
            
            } catch let error as NSError{print(error.localizedDescription)}
        } else if selectedCat == "Cat-O-Lantern" {
            do{
                player = try AVAudioPlayer(contentsOf: url3)
                player?.play()
                print("boo sound played")
            
            } catch let error as NSError{print(error.localizedDescription)}
        } else if selectedCat == "Salak Cat" {
            do{
                player = try AVAudioPlayer(contentsOf: url4)
                player?.play()
                print("strum sound played")
            
            } catch let error as NSError{print(error.localizedDescription)}
        } else if selectedCat == "Calendar Cat" {
            do{
                player = try AVAudioPlayer(contentsOf: url5)
                player?.play()
                print("paper sound played")
            
            } catch let error as NSError{print(error.localizedDescription)}
        } else {
            do{
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
                print("cat sound played")
            } catch let error as NSError{print(error.localizedDescription)}
        }
        
    }
    
    func roundAndAbbreviate(num: Double) -> String {
        let thousand: Double = Double(num / 1000)
        let million: Double = Double(num / 1000000)
        let billion: Double = Double(num / 1000000000)
        let trillion: Double = Double(num / 1000000000000)
        let quadrillion: Double = Double(num / 1000000000000000)
        if quadrillion >= 1.0 {
            return "\(quadrillion.truncate(places: 2))Q"
        } else if trillion >= 1.0 {
            return "\(trillion.truncate(places: 2))T"
        } else if billion >= 1.0 {
            return "\(billion.truncate(places: 2))B"
        } else if million >= 1.0 {
            return "\(million.truncate(places: 2))M"
        } else if thousand >= 1.0 {
            return "\(thousand.truncate(places: 2))K"
            
        } else {
            return String(Int(num))
        }
        
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
    
    
    @IBAction func logOutButtonDidTouch(_ sender: Any) {
        RootManager.logout()
    }
    @objc func callcps() {
       // DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
       //     self.coins += self.cps
       //     self.resetcoinsVC()
       //     self.callcps()
       // }
        dogRewardLabel.text = ""
        self.coins += cps
        if coins >= 1000000000000000000 {
            let alert = UIAlertController(title: "Congrats!", message: "You have been admitted into the Hall of Fame! Your coins and Autocoin have been reset, but you keep your cats and CpC! Tap the crown icon!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(OKAction)
            present(alert, animated: true)
            //dogRewardLabel.text = "You have been admitted into the Hall of Fame!"
            if let currentUserId = Auth.auth().currentUser?.uid{
                if let hallOfFamer = self.hallOfFame{
                    let hof = hallOfFamer.hof + 1
                    HallOfFamerModel.collection.child(currentUserId).updateChildValues([
                        "hof" : hof
                    ])
                } else {
                    HallOfFamerModel.collection.child(currentUserId).setValue(["username": user!.username, "hof": 1])
                }
                coins = 0
                cps = 0
                coinLabel.text = "Coins: 0"
                UserModel.collection.child(currentUserId).updateChildValues(["coins": 0])
                UserModel.collection.child(currentUserId).updateChildValues(["cps": 0])
                
            }
        }
        if selectedCat == "Gray" {
            let grayCps: Double = (Double(cps) * 0.05)
            incrementCoins(increment: Int(round((grayCps))))
        }
        if selectedCat == "Phalanx Cat" {
            let PhalanxCps: Double = (Double(cps) * 0.25 * Double(phalanx))
            incrementCoins(increment: Int(round((PhalanxCps))))
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
    
    @IBAction func leaderboardButtonDidTouch(_ sender: Any) {
        performSegue(withIdentifier: "leaderboardSegue", sender: nil)
    }
    
    @IBAction func profileButtonDidTouch(_ sender: Any) {
        performSegue(withIdentifier: "profileSegue", sender: nil)
    }
    
    @IBAction func hallOfFameButtonDidTouch(_ sender: Any) {
        performSegue(withIdentifier: "hallOfFameSegue", sender: nil)
    }
    
  //1000000000000000000
    
}
extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
