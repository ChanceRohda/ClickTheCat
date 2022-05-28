//
//  CrateShopViewController.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 4/20/22.
//

import UIKit

class CrateShopViewController: UIViewController {

    
    @IBOutlet weak var crateShopTitleLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    weak var viewControllerClass: ViewControllerDelegate?
    var tuna = 0
    var basicCratePrice = 1000
    var coolCratePrice = 50000
    func refreshCoins(){
        if let coins = viewControllerClass?.getCoins(){
        coinLabel.text = "Coins: \(coins)"
    }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshCoins()
        rewardLabel.text = "Buy a Crate!"
        crateShopTitleLabel.text = "Crate Shop"
        // Do any additional setup after loading the view.
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        viewControllerClass?.resetcoinsVC()
    }
    
    @IBAction func coolCrateButtonDidTouch(_ sender: Any) {
        if let coins = viewControllerClass?.getCoins(){
            if coins >= coolCratePrice {
                viewControllerClass?.upgrade(coinDecrement: coolCratePrice, cpcIncrement: 0)
                refreshCoins()
                var coolContents = ["coins", "cat", "cpc", "tuna", "negative"]
                let selectedCat = viewControllerClass?.getSelectedCat()
                if selectedCat == "Cool" {
                    coolContents.append("cpc")
                }
                if let coolCrateContent: String = coolContents.randomElement(){
                    if let catList = viewControllerClass?.getCatList(){
                    if coolCrateContent == "coins"{
                        viewControllerClass?.upgrade(coinDecrement: -75000 , cpcIncrement: 0)
                        rewardLabel.text = "75000 Coins acquired!"
                        refreshCoins()
                    } else if coolCrateContent == "cat" && !catList.contains(where: { cat in
                        return cat.name == "Cool"
                    }){
                        viewControllerClass?.addCat(cat: Cat(name: "Cool", description: "More CpC in Crates", image: UIImage(named: "Cool")!))
                        rewardLabel.text = "Cool Cat acquired!"
                    } else if coolCrateContent == "cpc" {
                        if selectedCat == "Cool" {
                            viewControllerClass?.upgrade(coinDecrement: 0, cpcIncrement: 7500)
                            rewardLabel.text = "7700 CpC acquired!"
                        } else {
                        viewControllerClass?.upgrade(coinDecrement: 0, cpcIncrement: 7500)
                        rewardLabel.text = "7500 CpC acquired!"
                        }
                    } else if coolCrateContent == "negative"{
                        viewControllerClass?.upgrade(coinDecrement: 5000, cpcIncrement: 0)
                        if let coins = viewControllerClass?.getCoins(){
                            if coins < 0 {
                                viewControllerClass?.zeroCoins()
                                refreshCoins()
                            }
                        }
                        rewardLabel.text = "500 coins lost."
                        refreshCoins()
                    } else {
                        tuna += 50
                        rewardLabel.text = "50 tuna acquired!"
                    }
                    }
                }
            }
        }
    }
    
    @IBAction func basicCrateButtonDidTouch(_ sender: Any) {
        if let coins = viewControllerClass?.getCoins(){
            if coins >= basicCratePrice {
                viewControllerClass?.upgrade(coinDecrement: basicCratePrice, cpcIncrement: 0)
                refreshCoins()
                var basicContents = ["coins", "cat", "cpc", "tuna", "negative"]
                let selectedCat = viewControllerClass?.getSelectedCat()
                if selectedCat == "Cool" {
                    basicContents.append("cpc")
                }
                if let basicCrateContent: String = basicContents.randomElement(){
                    if let catList = viewControllerClass?.getCatList(){
                    if basicCrateContent == "coins"{
                        viewControllerClass?.upgrade(coinDecrement: -1500 , cpcIncrement: 0)
                        rewardLabel.text = "1500 Coins acquired!"
                        refreshCoins()
                    } else if basicCrateContent == "cat" && !catList.contains(where: { cat in
                        return cat.name == "Gray"
                    }){
                        viewControllerClass?.addCat(cat: Cat(name: "Gray", description: "+50 CpC", image: UIImage(named: "Gray")!))
                        rewardLabel.text = "Gray Cat acquired!"
                    } else if basicCrateContent == "cpc" {
                        if selectedCat == "Cool" {
                            viewControllerClass?.upgrade(coinDecrement: 0, cpcIncrement: 150)
                            rewardLabel.text = "150 CpC acquired!"
                        } else {
                        viewControllerClass?.upgrade(coinDecrement: 0, cpcIncrement: 130)
                        rewardLabel.text = "130 CpC acquired!"
                        }
                    } else if basicCrateContent == "negative"{
                        viewControllerClass?.upgrade(coinDecrement: 500, cpcIncrement: 0)
                        if let coins = viewControllerClass?.getCoins(){
                            if coins < 0 {
                                viewControllerClass?.zeroCoins()
                                refreshCoins()
                            }
                        }
                        rewardLabel.text = "500 coins lost."
                        refreshCoins()
                    } else {
                        tuna += 5
                        rewardLabel.text = "5 tuna acquired!"
                    }
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
