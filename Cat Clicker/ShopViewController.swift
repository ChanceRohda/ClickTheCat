//
//  ShopViewController.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 3/21/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
struct Upgrade {
    var cost: Int
    var autocoin: Int
    var image: UIImage
    var name: String
    var displayCost: String
    var displayAutocoin: String
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
        cell.upgradeCostLabel.text = "Cost: \(upgradeItem.displayCost)"
        if upgradeItem.name != "Gazillionaire Cat" {
        cell.upgradeAutocoinLabel.text = "\(upgradeItem.displayAutocoin) Autocoin"
        } else {
            cell.upgradeAutocoinLabel.text = upgradeItem.displayAutocoin
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coins = viewControllerClass?.getCoins()
        var purchasedUpgrade = UpgradesManager.shared.upgrades[indexPath.row]
        if coins! >= purchasedUpgrade.cost {
            if purchasedUpgrade.name != "Gazillionaire Cat" {
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
            } else {
                viewControllerClass?.upgrade(coinDecrement: purchasedUpgrade.cost, cpcIncrement: 0)
                viewControllerClass?.addCat(cat: Cat(name: "Gazillionaire Cat", description: "Double Coins from everywhere!", image: UIImage(named: "Gazillionaire Cat")!))
                UpgradesManager.shared.upgrades.remove(at: 16)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
   
    @IBOutlet weak var coinLabel: UILabel!
    
    @IBOutlet weak var upgradeTableView: UITableView!
    weak var viewControllerClass: ViewControllerDelegate?

    func refreshCoins(){
        if let coins = viewControllerClass?.getCoins(){
            let displayCoins = viewControllerClass?.roundAndAbbreviate(num: Double(coins))
            coinLabel.text = "Coins: \(displayCoins ?? "error")"
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
        //for i in 1...30 {
        //    createUpgrade()
        //}
         
        guard let userID = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(userID).observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String: Any] else {return}
            guard let upgradeNumber = data["upgradeNumber"] as? Int else {return}
            if upgradeNumber == 0 {
                self.createUpgrade()
            } else {
            UpgradesManager.shared.upgrades.removeAll()
                UpgradesManager.shared.biggestUpgrade = 1
                for _ in 1...upgradeNumber {
                self.createUpgrade()
            }
                guard let userID = Auth.auth().currentUser?.uid else {return}
                let upgradeNumber = UpgradesManager.shared.upgrades.count
                let upgrade = ["upgradeNumber" : upgradeNumber]
                UserModel.collection.child(userID).updateChildValues(upgrade)
            }
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
        if UpgradesManager.shared.upgrades.count < 16 {
            let biggestUpgrade = UpgradesManager.shared.biggestUpgrade
            let displayCost = (viewControllerClass!.roundAndAbbreviate(num: Double(biggestUpgrade * 10)))
            let displayAutocoin = (viewControllerClass!.roundAndAbbreviate(num: Double(biggestUpgrade)))
            UpgradesManager.shared.upgrades.append(Upgrade(cost: biggestUpgrade * 10, autocoin: biggestUpgrade, image: UIImage(named: "Cat Food Cat")!, name: "Cat Food \(UpgradesManager.shared.upgrades.count + 1)", displayCost: displayCost, displayAutocoin: displayAutocoin))
        UpgradesManager.shared.biggestUpgrade *= 10
            
            
            
        //upgradeTableView.reloadData()
        } else {
            let catList = viewControllerClass?.getCatList()
            if !catList!.contains(where: { cat in
                 return cat.name == "Gazillionaire Cat"
             }){
                if !UpgradesManager.shared.upgrades.contains(where: { upgrade in
                    return upgrade.name == "Gazillionaire Cat"
                }){
                UpgradesManager.shared.upgrades.append(Upgrade(cost: 10000000000000000, autocoin: 0, image: UIImage(named: "Gazillionaire Cat")!, name: "Gazillionaire Cat", displayCost: "10Q", displayAutocoin: "Double Coins from Everywhere!"))
                }
             }
        }
        upgradeTableView.reloadData()
    }
}
