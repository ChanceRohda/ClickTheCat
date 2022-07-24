//
//  ShopViewController.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 3/21/22.
//

import UIKit

struct Upgrade {
    var cost: Int
    var autocoin: Int
    var image: UIImage
    var name: String
}


class ShopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upgrades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let upgradeItem = upgrades[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeTableViewCell", for: indexPath) as! UpgradeTableViewCell
        cell.upgradeImageView.image = upgradeItem.image
        cell.upgradeNameLabel.text = upgradeItem.name
        cell.upgradeCostLabel.text = "Cost: \(upgradeItem.cost)"
        cell.upgradeAutocoinLabel.text = "\(upgradeItem.autocoin) Autocoin"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coins = viewControllerClass?.getCoins()
        var purchasedUpgrade = upgrades[indexPath.row]
        if coins! >= purchasedUpgrade.cost {
            viewControllerClass?.upgrade(coinDecrement: purchasedUpgrade.cost, cpcIncrement: 0)
            viewControllerClass?.increaseCps(amount: purchasedUpgrade.autocoin)
            var selectedCat = viewControllerClass?.getSelectedCat()
            if selectedCat == "Cat Food Cat" && purchasedUpgrade.name.contains("Food"){
                viewControllerClass?.increaseCps(amount: purchasedUpgrade.autocoin)
            }
            
        }
    }
    
    @IBOutlet weak var coinLabel: UILabel!
    
    @IBOutlet weak var upgradeTableView: UITableView!
    weak var viewControllerClass: ViewControllerDelegate?
    
    
    
    
    var upgrades: [Upgrade] = [Upgrade(cost: 10, autocoin: 1, image: UIImage(named: "Cat Food Cat")!, name: "Cat Food 1")]
    
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
        upgradeTableView.dataSource = self
        upgradeTableView.delegate = self
        //explodeButton.tintColor = UIColor.white
        }
        // Do any additional setup after loading the view.
    override func viewWillDisappear(_ animated: Bool) {
        viewControllerClass?.resetcoinsVC()
    }
    
    
}
