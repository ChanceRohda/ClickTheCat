//
//  CrateShopViewController.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 4/20/22.
//

import UIKit

class CrateShopViewController: UIViewController {

    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    weak var viewControllerClass: ViewControllerDelegate?
    func refreshCoins(){
        if let coins = viewControllerClass?.getCoins(){
        coinLabel.text = "Coins: \(coins)"
    }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshCoins()
        rewardLabel.text = " "
        // Do any additional setup after loading the view.
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        viewControllerClass?.resetcoinsVC()
    }
    
    @IBAction func basicCrateButtonDidTouch(_ sender: Any) {
        if var coins = viewControllerClass?.getCoins(){
            if coins >= 1000 {
                coins -= 1000
                refreshCoins()
                print("Basic crate has been bought.")
                let basicContents = ["coins", "cat", "cpc", "tuna", "negative"]
                if let basicCrateContent: String = basicContents.randomElement(){
                    if basicCrateContent == "coins"{
                        coins += 1500
                        rewardLabel.text = "1500 Coins acquired!"
                        refreshCoins()
                    } else if basicCrateContent == "cat"{
                        print("Gray cat acquired. Code this in please.")
                        rewardLabel.text = "Gray Cat acquired!"
                    } else if basicCrateContent == "cpc" {
                        viewControllerClass?.upgrade(coinDecrement: 0, cpcIncrement: 130)
                        rewardLabel.text = "130 CpC acquired!"
                    } else if basicCrateContent == "negative"{
                        coins -= 500
                        if coins < 0 {
                            coins = 0
                        }
                        rewardLabel.text = "500 coins lost."
                        refreshCoins()
                    } else {
                        print("5 tuna acquired. Code this in please.")
                        rewardLabel.text = "5 tuna acquired!"
                    }
                    
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
