//
//  AdViewController.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 7/24/22.
//

import UIKit
import GoogleMobileAds
class AdViewController: UIViewController {
    weak var viewControllerClass: ViewControllerDelegate?
    @IBOutlet weak var AdPointsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    var adPoints: Int = 0
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
            self.adPoints += 1
            print("Current Ad Points: \(self.adPoints)")
            self.AdPointsLabel.text = "Ad Points: \(self.adPoints)"
        }
      } else {
        print("Ad wasn't ready")
      }
    }
    @IBAction func adButton(_ sender: Any) {
        loadRewardedAd()
        
    }


}
