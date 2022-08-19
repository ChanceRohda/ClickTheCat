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
import UIKit
import GoogleMobileAds
class AdViewController: UIViewController {
    weak var viewControllerClass: ViewControllerDelegate?
    @IBOutlet weak var rewardImageView: UIImageView!
    @IBOutlet weak var rewardLabel: UILabel!
    var possiblePrizes: [Prize] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let coins = (viewControllerClass?.getCoins())!
        let autocoin = (viewControllerClass?.getCps())!
        
        
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
        possiblePrizes.append(Prize(type: "CpC", amount: 100))
        possiblePrizes.append(Prize(type: "Coins", amount: coins * 2))
        possiblePrizes.append(Prize(type: "Autocoin", amount: autocoin))

        // Do any additional setup after loading the view.
    }
    
    private var rewardedAd: GADRewardedAd?
    
    func loadRewardedAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID:"ca-app-pub-3940256099942544/1712485313",
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
      if let ad = rewardedAd {
        ad.present(fromRootViewController: self) {
          let reward = ad.adReward
          print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
            self.viewControllerClass?.increaseAdPoints(increment: 1)
            self.getReward()
            
            
        }
      } else {
        print("Ad wasn't ready")
      }
    }
    @IBAction func adButton(_ sender: Any) {
        loadRewardedAd()
        
    }
    func getReward() {
            let prize = possiblePrizes.randomElement()
            if prize?.type == "Coins" {
                if prize!.amount < 100 {
                    viewControllerClass?.upgrade(coinDecrement: -100, cpcIncrement: 0)
                    if viewControllerClass?.getSelectedCat() == "Ad Cat" || viewControllerClass?.getSelectedCat() == "Gold Cat"{
                        viewControllerClass?.upgrade(coinDecrement: -100, cpcIncrement: 0)
                    }
                    if viewControllerClass?.getSelectedCat() == "Ad Cat" || viewControllerClass?.getSelectedCat() == "Gold Cat"{
                        rewardLabel.text = "You got \(200) coins!"
                    } else {
                        rewardLabel.text = "You got \(100) coins!"
                    }
                } else {
                viewControllerClass?.upgrade(coinDecrement: prize!.amount * -1, cpcIncrement: 0)
                if viewControllerClass?.getSelectedCat() == "Ad Cat" || viewControllerClass?.getSelectedCat() == "Gold Cat"{
                    viewControllerClass?.upgrade(coinDecrement: prize!.amount * -1, cpcIncrement: 0)
                }
                    if viewControllerClass?.getSelectedCat() == "Ad Cat" || viewControllerClass?.getSelectedCat() == "Gold Cat"{
                        let display1 = viewControllerClass?.roundAndAbbreviate(num: Double(prize!.amount * 2))
                        rewardLabel.text = "You got \(display1 ?? "error") coins!"
                    } else {
                        let display2 = viewControllerClass?.roundAndAbbreviate(num: Double(prize!.amount))
                        rewardLabel.text = "You got \(display2 ?? "error") coins!"
                    }
                
                }
                rewardImageView.image = UIImage(named: "Coin Pile")!
            } else if prize?.type == "Tuna" {
                rewardLabel.text = "You got \(prize!.amount) tuna!"
                rewardImageView.image = UIImage(named: "Tuna")!
                viewControllerClass?.increaseTuna(amount: prize!.amount)
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
            }
        if viewControllerClass?.getAdPoints() == 50 {
            rewardLabel.text = "Ad Cat Earned"
        }
        
    }

}
