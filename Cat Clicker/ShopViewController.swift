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
        let purchasedUpgrade = UpgradesManager.shared.upgrades[indexPath.row]
        if coins! >= purchasedUpgrade.cost {
            if purchasedUpgrade.name != "Gazillionaire Cat" {
                if purchasedUpgrade.cost == UpgradesManager.shared.biggestUpgrade * 10 {
                    createUpgrade()
                }
            
                viewControllerClass?.upgrade(coinDecrement: purchasedUpgrade.cost, cpcIncrement: 0)
                viewControllerClass?.increaseCps(amount: purchasedUpgrade.autocoin)
                let selectedCat = viewControllerClass?.getSelectedCat()
                if selectedCat == "Cat Food Cat" && purchasedUpgrade.name.contains("Food"){
                    let extraCpC = round(0.2 * Double(purchasedUpgrade.cost))
                    viewControllerClass?.increaseCps(amount: Int(extraCpC))
                    viewControllerClass?.increaseCps(amount: purchasedUpgrade.autocoin)
                }
            } else {
                viewControllerClass?.upgrade(coinDecrement: purchasedUpgrade.cost, cpcIncrement: 0)
                viewControllerClass?.addCat(cat: Cat(name: "Gazillionaire Cat", description: "Double Coins from everywhere!", image: UIImage(named: "Gazillionaire Cat")!))
                UpgradesManager.shared.upgrades.remove(at: 8)
                
                guard let userID = Auth.auth().currentUser?.uid else {return}
                let upgrade = ["gazAvailable" : false]
                UserModel.collection.child(userID).updateChildValues(upgrade)
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
            guard var upgradeNumber = data["upgradeNumber"] as? Int else {return}
            let gazAvailable = data["gazAvailable"] as? Bool
            if upgradeNumber == 0 {
                upgradeNumber = 1
                let upgrade = ["upgradeNumber" : upgradeNumber]
                UserModel.collection.child(userID).updateChildValues(upgrade)
            }
            UpgradesManager.shared.upgrades.removeAll()
                UpgradesManager.shared.biggestUpgrade = 1
                for _ in 1...upgradeNumber {
                    print("ran that one function. you know what im talking about")
                self.createUpgrade()
            }
            if gazAvailable == true {
                self.createUpgrade()
            }
                guard let userID = Auth.auth().currentUser?.uid else {return}
                //let upgradeNumber = UpgradesManager.shared.upgrades.count
                let upgrade = ["upgradeNumber" : upgradeNumber]
                UserModel.collection.child(userID).updateChildValues(upgrade)
            
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
    

    @IBAction func infoButtonDidTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Shop", message: "Buy upgrades and get autocoin! You get coins equal to your autocoin every 5 seconds.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func createUpgrade() {
        if UpgradesManager.shared.upgrades.count < 8 {
            print("created upgrade")
            let biggestUpgrade = UpgradesManager.shared.biggestUpgrade
            let displayCost = (viewControllerClass!.roundAndAbbreviate(num: Double(biggestUpgrade * 100)))
            let displayAutocoin = (viewControllerClass!.roundAndAbbreviate(num: Double(biggestUpgrade)))
            UpgradesManager.shared.upgrades.append(Upgrade(cost: biggestUpgrade * 100, autocoin: biggestUpgrade, image: UIImage(named: "Cat Food Cat")!, name: "Cat Food \(UpgradesManager.shared.upgrades.count + 1)", displayCost: displayCost, displayAutocoin: displayAutocoin))
        UpgradesManager.shared.biggestUpgrade *= 10
            guard let userID = Auth.auth().currentUser?.uid else {return}
            let upgrade = ["upgradeNumber" : UpgradesManager.shared.upgrades.count]
            UserModel.collection.child(userID).updateChildValues(upgrade)
            
            
        upgradeTableView.reloadData()
        } else {
            let catList = viewControllerClass?.getCatList()
            if !catList!.contains(where: { cat in
                 return cat.name == "Gazillionaire Cat"
             }){
                if !UpgradesManager.shared.upgrades.contains(where: { upgrade in
                    return upgrade.name == "Gazillionaire Cat"
                }){
                    guard let userID = Auth.auth().currentUser?.uid else {return}
                    let upgrade = ["gazAvailable" : true]
                    UserModel.collection.child(userID).updateChildValues(upgrade)
                UpgradesManager.shared.upgrades.append(Upgrade(cost: 1000000000000000, autocoin: 0, image: UIImage(named: "Gazillionaire Cat")!, name: "Gazillionaire Cat", displayCost: "1Q", displayAutocoin: "Double Coins from Everywhere!"))
                }
             }
        }
        upgradeTableView.reloadData()
    }
}
