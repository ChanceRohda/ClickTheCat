//
//  CrateShopViewController.swift
//  CatClick
//
//  Created by Chance Rohda on 4/20/22.
//

import UIKit

struct Crate {
    var name: String
    var cost: Int
    var displayCost: String
    var image: UIImage
    var contents: [String]
    var cpcReward: Int?
    var cpsReward: Int?
    var catReward: Cat
    var coinReward: Int
    var tunaReward: Int?
    var negativeCoin: Int?
    var negativeCpc: Int?
}

// Keywords: cpc, tuna, cps, coins, negCoins, negCpC

class CrateShopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return crates.count
    }
    @IBOutlet weak var cratesTableView: UITableView!
    @IBOutlet weak var crateShopTitleLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    weak var viewControllerClass: ViewControllerDelegate?
    var tuna = 0
    var crates: [Crate] = [Crate(name: "Basic Crate", cost: 1000, displayCost: "1000 Coins", image: UIImage(named: "Gray")!, contents: ["coins", "cat", "cpc", "tuna", "negCoins", "negCoins", "Coins", "cpc"], cpcReward: 130, catReward: Cat(name: "Gray", description: "+5% CpC", image: UIImage(named: "Gray")!), coinReward: 1500, tunaReward: 1, negativeCoin: 500), Crate(name: "Cool Crate", cost: 50000, displayCost: "50000 Coins", image: UIImage(named: "Cool")!, contents:  ["cps", "cat", "cpc", "tuna", "negCoins", "negCoins", "Coins", "cpc"], cpcReward: 7700, cpsReward: 20, catReward: Cat(name: "Cool", description: "More CpC in Crates", image: UIImage(named: "Cool")!), coinReward: 60000, tunaReward: 1, negativeCoin: 1000), Crate(name: "Dog Box", cost: 1000000, displayCost: "1 Million Coins", image: UIImage(named: "Dog")!, contents: ["cpc", "cat", "cps", "tuna", "negCpc", "negCpc", "cps", "cpc"], cpcReward: 10000, cpsReward: 2000, catReward: Cat(name: "Dog", description: "Might dig up treasure!", image: UIImage(named: "Dog")!), coinReward: 1100000, tunaReward: 5, negativeCoin: 0, negativeCpc: 800)]
    
    
    func refreshCoins(){
        if let coins = viewControllerClass?.getCoins(){
        coinLabel.text = "Coins: \(coins)"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                 self.refreshCoins()
             }
    }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshCoins()
        rewardLabel.text = "Buy a Crate!"
        crateShopTitleLabel.text = "Crate Shop"
        cratesTableView.dataSource = self
        cratesTableView.delegate = self
        // Do any additional setup after loading the view.
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        viewControllerClass?.resetcoinsVC()
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let crateItem = crates[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CrateTableViewCell", for: indexPath) as! CrateTableViewCell
        cell.crateImageView.image = crateItem.image
        cell.crateNameLabel.text = crateItem.name
        cell.crateCostLabel.text = "Cost: \(crateItem.displayCost)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let purchasedCrate = crates[indexPath.row]
        if let catList = viewControllerClass?.getCatList(){
        if let coins: Int = viewControllerClass?.getCoins() {
            if coins >= purchasedCrate.cost {
                let crateContent = purchasedCrate.contents.randomElement()
                viewControllerClass?.upgrade(coinDecrement: purchasedCrate.cost, cpcIncrement: 0)
                if crateContent == "cpc" {
                    viewControllerClass?.upgrade(coinDecrement: 0, cpcIncrement: purchasedCrate.cpcReward!)
                    let selectedCat = viewControllerClass?.getSelectedCat()
                    if selectedCat == "Cool" {
                        let percent = 0.1 * Double(purchasedCrate.cpcReward!)
                        round(percent)
                        
                        viewControllerClass?.upgrade(coinDecrement: -1 * Int(percent), cpcIncrement: 0)
                    rewardLabel.text = "\(purchasedCrate.cpcReward! + Int(percent)) Cpc Acquired!"
                    } else {
                        viewControllerClass?.upgrade(coinDecrement: 0, cpcIncrement: purchasedCrate.cpcReward!)
                        rewardLabel.text = "\(purchasedCrate.cpcReward!) Cpc Acquired!"
                    }
                } else if crateContent == "cps" {
                    viewControllerClass?.increaseCps(amount: purchasedCrate.cpsReward!)
                    rewardLabel.text = "\(purchasedCrate.cpsReward!) Autocoin Acquired!"
                } else if crateContent == "cat" && !catList.contains(where: { cat in
                    return cat.name == purchasedCrate.catReward.name
                }){
                    viewControllerClass?.addCat(cat: purchasedCrate.catReward)
                    rewardLabel.text = "\(purchasedCrate.catReward.name) Cat Acquired!"
                } else if crateContent == "coins" {
                    viewControllerClass?.upgrade(coinDecrement: purchasedCrate.coinReward * -1, cpcIncrement: 0)
                    rewardLabel.text = "\(purchasedCrate.coinReward) Coins Acquired!"
                } else if crateContent == "tuna" {
                    rewardLabel.text = "\(purchasedCrate.tunaReward!) Tuna Acquired!"
                } else if crateContent == "negCoins" {
                    viewControllerClass?.upgrade(coinDecrement: purchasedCrate.negativeCoin!, cpcIncrement: 0)
                    rewardLabel.text = "\(purchasedCrate.negativeCoin!) Coins Lost."
                } else if crateContent == "negCpC" {
                    viewControllerClass?.upgrade(coinDecrement: 0, cpcIncrement: (purchasedCrate.negativeCpc!) * -1)
                    rewardLabel.text = "\(purchasedCrate.negativeCpc!) Cpc Lost."
                } else {
                    viewControllerClass?.upgrade(coinDecrement: purchasedCrate.coinReward * -1, cpcIncrement: 0)
                    rewardLabel.text = "\(purchasedCrate.coinReward) Coins Acquired!"
                }
        }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(200)
    }
}
}
