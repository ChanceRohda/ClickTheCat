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
    
    @IBOutlet weak var orderByCostButton: UIButton!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UpgradesManager.shared.upgrades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let upgradeItem = UpgradesManager.shared.upgrades[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeTableViewCell", for: indexPath) as! UpgradeTableViewCell
        cell.upgradeImageView.image = upgradeItem.image
        cell.upgradeNameLabel.text = upgradeItem.name
        cell.upgradeCostLabel.text = "Cost: \(upgradeItem.cost)"
        cell.upgradeAutocoinLabel.text = "\(upgradeItem.autocoin) Autocoin"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coins = viewControllerClass?.getCoins()
        var purchasedUpgrade = UpgradesManager.shared.upgrades[indexPath.row]
        if coins! >= purchasedUpgrade.cost {
            if purchasedUpgrade.cost == UpgradesManager.shared.biggestUpgrade {
                createUpgrade()
            }
            
            viewControllerClass?.upgrade(coinDecrement: purchasedUpgrade.cost, cpcIncrement: 0)
            viewControllerClass?.increaseCps(amount: purchasedUpgrade.autocoin)
            var selectedCat = viewControllerClass?.getSelectedCat()
            if selectedCat == "Cat Food Cat" && purchasedUpgrade.name.contains("Food"){
                let extraCpC = round(0.2 * Double(purchasedUpgrade.cost))
                viewControllerClass?.increaseCps(amount: Int(extraCpC))
                viewControllerClass?.increaseCps(amount: purchasedUpgrade.autocoin)
            }
            
        }
    }
   
    @IBOutlet weak var coinLabel: UILabel!
    
    @IBOutlet weak var upgradeTableView: UITableView!
    weak var viewControllerClass: ViewControllerDelegate?
    
    
    
    
    
    
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
        for i in 1...30 {
            createUpgrade()
        }
        }
        // Do any additional setup after loading the view.
    override func viewWillDisappear(_ animated: Bool) {
        viewControllerClass?.resetcoinsVC()
    }
    
    @IBAction func orderByCostButtonDidTouch(_ sender: Any) {
        switch UpgradesManager.shared.costOrder {
        case .ascending:
            UpgradesManager.shared.sortByCostDescending()
            orderByCostButton.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        case .descending:
            UpgradesManager.shared.sortByCostAscending()
            orderByCostButton.setImage(UIImage(systemName: "arrow.down.circle.fill"), for: .normal)
        }
        upgradeTableView.reloadData()
        
    }
    func createUpgrade() {
        if UpgradesManager.shared.upgrades.count < 17 {
        let biggestUpgrade = UpgradesManager.shared.biggestUpgrade
        
         UpgradesManager.shared.upgrades.append(Upgrade(cost: biggestUpgrade * 10, autocoin: biggestUpgrade, image: UIImage(named: "Cat Food Cat")!, name: "Cat Food \(UpgradesManager.shared.upgrades.count + 1)"))
       
        UpgradesManager.shared.biggestUpgrade *= 10
        upgradeTableView.reloadData()
    }
    }
}
