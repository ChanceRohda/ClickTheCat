//
//  AdViewController.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 7/24/22.
//
struct Prize {
    var type: String
    var amount: Int
}
import FirebaseAuth
import UIKit
import Firebase
import GoogleMobileAds
class AdViewController: UIViewController {
    weak var viewControllerClass: ViewControllerDelegate?
    @IBOutlet weak var rewardImageView: UIImageView!
    @IBOutlet weak var rewardLabel: UILabel!
    var newDailyAdsWatched: Int = 0
    var possiblePrizes: [Prize] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let coins = (viewControllerClass?.getCoins())!
        let autocoin = (viewControllerClass?.getCps())!
        
        for _ in 1...200 {
            possiblePrizes.append(Prize(type: "Cat-o-lantern", amount: 1))
        }
        for _ in 1...70 {
            possiblePrizes.append(Prize(type: "Coins", amount: Int(round(Double(coins/100)))))
            possiblePrizes.append(Prize(type: "Coins", amount: 100))
            possiblePrizes.append(Prize(type: "Coins", amount: Int(round(Double(coins/10)))))
            possiblePrizes.append(Prize(type: "Tuna", amount: 1))
            possiblePrizes.append(Prize(type: "Autocoin", amount: Int(round(Double(autocoin/50)))))
        }
        for _ in 1...40 {
            if (viewControllerClass?.getCoins())! > 10000 {
                possiblePrizes.append(Prize(type: "CpC", amount: 10))
            }
            
            possiblePrizes.append(Prize(type: "Tuna", amount: 5))
            possiblePrizes.append(Prize(type: "Coins", amount: coins))
            possiblePrizes.append(Prize(type: "Autocoin", amount: Int(round(Double(autocoin/10)))))
        }
        possiblePrizes.append(Prize(type: "Tuna", amount: 100))
        possiblePrizes.append(Prize(type: "CpC", amount: 1000))
        possiblePrizes.append(Prize(type: "Coins", amount: coins * 2))
        possiblePrizes.append(Prize(type: "Autocoin", amount: autocoin))

        // Do any additional setup after loading the view.
    }
    
    private var rewardedAd: GADRewardedAd?
    
    func loadRewardedAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID:"ca-app-pub-2692883151832197/5377041102",
                           request: request,
                           completionHandler: { [self] ad, error in
          if let error = error {
            print("Failed to load rewarded ad with error: \(error.localizedDescription)")
            return
          }
          rewardedAd = ad
            self.show()
          print("Rewarded ad loaded.")
        }
        )
      }
    func show() {
        print("the function has not ran yet")
        //print(rewardedAd)
      if let ad = rewardedAd {
          print("the function has ran")
          print(ad)
        ad.present(fromRootViewController: self) {
          let reward = ad.adReward
          print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
            self.viewControllerClass?.increaseAdPoints(increment: 1)
            self.dailyClickAdReward()
            self.getReward()
            
            
        }
      } else {
        print("Ad wasn't ready")
      }
    }
    
    func dailyClickAdReward() {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        DailyAdModel.collection.observeSingleEvent(of: .value) { snapshot in
            guard let currentDailyAdModel = DailyAdModel(snapshot: snapshot) else {
                DailyAdModel.collection.child(userID).updateChildValues(["adsWatched" : 1, "achievement4IsComplete" : false, "startOfDay" : Date().startOfDay.timeIntervalSince1970, "endOfDay" : Date().endOfDay.timeIntervalSince1970])
                return
            }
            if currentDailyAdModel.startOfDay < Date() && currentDailyAdModel.endOfDay > Date() {
                self.newDailyAdsWatched = currentDailyAdModel.adsWatched + 1
                if self.newDailyAdsWatched == 10 {
                    DispatchQueue.main.async {
                        self.rewardLabel.text = "You watched 10 ads! Enjoy your reward!"
                        self.rewardImageView.image = UIImage(named: "Calendar Cat")
                    }
                    DailyAdModel.collection.child(userID).updateChildValues(["achievement4IsComplete": true, "adsWatched" : self.newDailyAdsWatched])
                    DispatchQueue.main.async {
                        self.viewControllerClass?.increaseCalendarCount()
                        self.viewControllerClass?.addCat(cat: Cat(name: "Calendar Cat", description: "More CpC the more you collect!", image: UIImage(named: "Calendar Cat")!))
                    }
                     
                } else {
                    DailyAdModel.collection.child(userID).updateChildValues(["adsWatched" : self.newDailyAdsWatched])
                }
                
            } else {
                DailyAdModel.collection.child(userID).updateChildValues(["adsWatched" : 1, "achievement4IsComplete" : false, "startOfDay" : Date().startOfDay.timeIntervalSince1970, "endOfDay" : Date().endOfDay.timeIntervalSince1970])
            }
        }
    }
    
    
    @IBAction func adButton(_ sender: Any) {
        if newDailyAdsWatched < 10 {
            loadRewardedAd()
        } else {
            rewardLabel.text = "You have reached the daily ad limit. Come back tomorrow!"
        }
    }
    func getReward() {
            let prize = possiblePrizes.randomElement()
            if prize?.type == "Coins" {
                if prize!.amount < 100 {
                    viewControllerClass?.upgrade(coinDecrement: -100, cpcIncrement: 0)
                    if viewControllerClass?.getSelectedCat() == "Ad Cat" || viewControllerClass?.getSelectedCat() == "Gold Cat" || viewControllerClass?.getSelectedCat() == "Gazillionaire Cat"{
                        viewControllerClass?.upgrade(coinDecrement: -100, cpcIncrement: 0)
                    }
                    if viewControllerClass?.getSelectedCat() == "Ad Cat" || viewControllerClass?.getSelectedCat() == "Gold Cat"{
                        rewardLabel.text = "You got \(200) coins!"
                    } else {
                        rewardLabel.text = "You got \(100) coins!"
                    }
                } else {
                viewControllerClass?.upgrade(coinDecrement: prize!.amount * -1, cpcIncrement: 0)
                    if viewControllerClass?.getSelectedCat() == "Ad Cat" || viewControllerClass?.getSelectedCat() == "Gold Cat" || viewControllerClass?.getSelectedCat() == "Gazillionaire Cat"{
                    viewControllerClass?.upgrade(coinDecrement: prize!.amount * -1, cpcIncrement: 0)
                }
                    if viewControllerClass?.getSelectedCat() == "Ad Cat" || viewControllerClass?.getSelectedCat() == "Gold Cat" || viewControllerClass?.getSelectedCat() == "Gazillionaire Cat"{
                        let display1 = viewControllerClass?.roundAndAbbreviate(num: Double(prize!.amount * 2))
                        rewardLabel.text = "You got \(display1 ?? "error") coins!"
                    } else {
                        let display2 = viewControllerClass?.roundAndAbbreviate(num: Double(prize!.amount))
                        rewardLabel.text = "You got \(display2 ?? "error") coins!"
                    }
                
                }
                rewardImageView.image = UIImage(named: "Coin Pile")!
            } else if prize?.type == "Tuna" {
                if viewControllerClass?.getSelectedCat() != "Ad Cat" {
                    rewardLabel.text = "You got \(prize!.amount) tuna!"
                    rewardImageView.image = UIImage(named: "Tuna")!
                    viewControllerClass?.increaseTuna(amount: prize!.amount)
                } else {
                    rewardLabel.text = "You got \(prize!.amount * 2) tuna!"
                    rewardImageView.image = UIImage(named: "Tuna")!
                    viewControllerClass?.increaseTuna(amount: prize!.amount)
                    viewControllerClass?.increaseTuna(amount: prize!.amount)
                }
            } else if prize?.type == "Autocoin" {
                if prize!.amount < 1 {
                    rewardImageView.image = UIImage(named: "Gold Cat")!
                    viewControllerClass?.increaseCps(amount: 1)
                    if viewControllerClass?.getSelectedCat() == "Ad Cat"{
                        viewControllerClass?.increaseCps(amount: 1)
                    }
                    if viewControllerClass?.getSelectedCat() == "Ad Cat"{
                        rewardLabel.text = "You got \(2) autocoin!"
                    } else {
                        rewardLabel.text = "You got \(1) autocoin!"
                    }
                } else {
                viewControllerClass?.increaseCps(amount: prize!.amount)
                if viewControllerClass?.getSelectedCat() == "Ad Cat" {
                    
                }
                rewardLabel.text = "You got \(prize!.amount) autocoin!"
                rewardImageView.image = UIImage(named: "Gold Cat")!
                }
            } else if prize?.type == "CpC" {
                viewControllerClass?.upgrade(coinDecrement: 0, cpcIncrement: prize!.amount)
                if viewControllerClass?.getSelectedCat() == "Ad Cat" {
                    
                }
                rewardLabel.text = "You got \(prize!.amount) CpC!"
                rewardImageView.image = UIImage(named: "CpC+")!
            } else if  prize?.type == "Cat-o-lantern" {
                let catList = viewControllerClass?.getCatList()
                if !catList!.contains(where: { cat in
                    return cat.name == "Cat-O-Lantern"
                }){
                    viewControllerClass?.addCat(cat: Cat(name: "Cat-O-Lantern", description: "x2 CpC", image: UIImage(named: "Cat-O-Lantern")!))
                    rewardLabel.text = "Cat-O-Lantern Acquired!"
                }
            }
        if viewControllerClass?.getAdPoints() == 50 {
            rewardLabel.text = "Ad Cat Earned"
        }
        
    }

}
