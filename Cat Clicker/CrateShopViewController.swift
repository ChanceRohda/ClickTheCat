//
//  CrateShopViewController.swift
//  CatClick
//
//  Created by Chance Rohda on 4/20/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
struct Crate {
    var name: String
    var cost: Int
    var tunacost: Int?
    var displayCost: String
    var image: UIImage
    var contents: [String]
    var cpcReward: Int?
    var cpsReward: Int?
    var catReward: Cat
    var coinReward: Int?
    var tunaReward: Int?
    var negativeCoin: Int?
    var negativeCpc: Int?
    
}



class CrateShopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var cratesTableView: UITableView!
    @IBOutlet weak var crateShopTitleLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var tunaLabel: UILabel!
    weak var viewControllerClass: ViewControllerDelegate?
    
    var crates: [Crate] = [Crate(name: "Basic Crate", cost: 1000, tunacost: 0, displayCost: "1000 Coins", image: UIImage(named: "Gray")!, contents: ["coins", "cat", "cps", "tuna", "negCoins", "coins", "cpc"], cpcReward: 1, cpsReward: 13, catReward: Cat(name: "Gray", description: "+5% Autocoin", image: UIImage(named: "Gray")!), coinReward: 1500, tunaReward: 1, negativeCoin: 500), Crate(name: "Cool Crate", cost: 50000, tunacost: 0, displayCost: "50000 Coins", image: UIImage(named: "Cool")!, contents:  ["cps", "cat", "cpc", "tuna", "negCoins", "coins", "cpc"], cpcReward: 20, cpsReward: 770, catReward: Cat(name: "Cool", description: "More CpC in Crates", image: UIImage(named: "Cool")!), coinReward: 60000, tunaReward: 1, negativeCoin: 1000), Crate(name: "Dog Box", cost: 1000000, tunacost: 0, displayCost: "1 Million Coins", image: UIImage(named: "Dog")!, contents: ["cpc", "cat", "cps", "tuna", "negCpc", "cpc", "cpc"], cpcReward: 200, cpsReward: 10000, catReward: Cat(name: "Dog", description: "Might dig up treasure!", image: UIImage(named: "Dog")!), coinReward: 1100000, tunaReward: 3, negativeCoin: 0, negativeCpc: 800), Crate(name: "Roman Crate", cost: 0, tunacost: 50, displayCost: "50 Tuna", image: UIImage(named: "Phalanx Cat")!, contents: ["phalanx", "cpc", "cpc"], cpcReward: 500, catReward: Cat(name: "Phalanx Cat", description: "More Autocoin the more you collect!", image: UIImage(named: "Phalanx Cat")!)), Crate(name: "Musical Crate", cost: 1000000000, tunacost: 0, displayCost: "1 Billion Coins", image: UIImage(named: "Salak Cat")!, contents:  ["cps", "cat", "cpc", "tuna", "coins", "cpc"], cpcReward: 500, cpsReward: 100000, catReward: Cat(name: "Salak Cat", description: "More Tuna in Crates", image: UIImage(named: "Salak Cat")!), coinReward: 1100000000, tunaReward: 6), Crate(name: "Angelic Crate", cost: 10000000000, tunacost: 0, displayCost: "1 Trillion Coins", image: UIImage(named: "Angel Cat")!, contents:  ["cps", "cat", "cpc", "tuna", "coins", "cpc"], cpcReward: 500000000, cpsReward: 100000, catReward: Cat(name: "Angel Cat", description: "x3 CpC", image: UIImage(named: "Angel Cat")!), coinReward: 1100000000000, tunaReward: 10)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshCoins()
        viewControllerClass?.zeroTuna()
        tunaLabel.text = "Tuna: \(viewControllerClass!.getTuna())"
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
            if let tuna = viewControllerClass?.getTuna() {
                if let coins: Int = viewControllerClass?.getCoins() {
                if coins >= purchasedCrate.cost && tuna >= purchasedCrate.tunacost! {
                    let crateContent = purchasedCrate.contents.randomElement()
                    viewControllerClass?.upgrade(coinDecrement: purchasedCrate.cost, cpcIncrement: 0)
                    viewControllerClass?.increaseTuna(amount: (purchasedCrate.tunacost ?? 0) * -1 )
                    tunaLabel.text = "Tuna: \(viewControllerClass!.getTuna())"
                    if crateContent == "cpc" {
                        viewControllerClass?.upgrade(coinDecrement: 0, cpcIncrement: purchasedCrate.cpcReward!)
                        let selectedCat = viewControllerClass?.getSelectedCat()
                        if selectedCat == "Cool" {
                            let percent = 0.5 * Double(purchasedCrate.cpcReward!)
                            round(percent)
                            
                            viewControllerClass?.upgrade(coinDecrement: -1 * Int(percent), cpcIncrement: 0)
                        rewardLabel.text = "\(purchasedCrate.cpcReward! + Int(percent)) Cpc Acquired!"
                        } else {
                            viewControllerClass?.upgrade(coinDecrement: 0, cpcIncrement: purchasedCrate.cpcReward!)
                            rewardLabel.text = "\(purchasedCrate.cpcReward!) Cpc Acquired!"
                        }
                    } else if crateContent == "cps" {
                        if viewControllerClass?.getSelectedCat() == "Social Cat" {
                            viewControllerClass?.increaseCps(amount: purchasedCrate.cpsReward!)
                            viewControllerClass?.increaseCps(amount: purchasedCrate.cpsReward!)
                            rewardLabel.text = "\(purchasedCrate.cpsReward! * 2) Autocoin Acquired!"
                        } else {
                            viewControllerClass?.increaseCps(amount: purchasedCrate.cpsReward!)
                            rewardLabel.text = "\(purchasedCrate.cpsReward!) Autocoin Acquired!"
                        }
                    } else if crateContent == "cat" && !catList.contains(where: { cat in
                        return cat.name == purchasedCrate.catReward.name
                    }){
                        viewControllerClass?.addCat(cat: purchasedCrate.catReward)
                        if purchasedCrate.catReward.name == "Salak Cat" || purchasedCrate.catReward.name == "Angel Cat" {
                            rewardLabel.text = "\(purchasedCrate.catReward.name) Acquired!"
                        } else {
                            rewardLabel.text = "\(purchasedCrate.catReward.name) Cat Acquired!"
                        }
                    } else if crateContent == "coins" {
                        viewControllerClass?.upgrade(coinDecrement: purchasedCrate.coinReward! * -1, cpcIncrement: 0)
                        rewardLabel.text = "\(purchasedCrate.coinReward!) Coins Acquired!"
                    } else if crateContent == "tuna" {
                        if viewControllerClass?.getSelectedCat() != "Salak Cat" {
                            rewardLabel.text = "\(purchasedCrate.tunaReward!) Tuna Acquired!"
                            viewControllerClass?.increaseTuna(amount: purchasedCrate.tunaReward!)
                        } else {
                            rewardLabel.text = "\(purchasedCrate.tunaReward! + 1) Tuna Acquired!"
                            viewControllerClass?.increaseTuna(amount: purchasedCrate.tunaReward! + 1)
                        }
                    } else if crateContent == "negCoins" {
                        viewControllerClass?.upgrade(coinDecrement: purchasedCrate.negativeCoin!, cpcIncrement: 0)
                        rewardLabel.text = "\(purchasedCrate.negativeCoin!) Coins Lost."
                        viewControllerClass?.zeroCoins()
                    } else if crateContent == "negCpC" {
                        viewControllerClass?.upgrade(coinDecrement: 0, cpcIncrement: (purchasedCrate.negativeCpc!) * -1)
                        rewardLabel.text = "\(purchasedCrate.negativeCpc!) Cpc Lost."
                        viewControllerClass?.zeroCpC()
                        
                    } else if crateContent == "phalanx"{
                        viewControllerClass?.addCat(cat: purchasedCrate.catReward)
                        rewardLabel.text = "Phalanx Cat Acquired!"
                        viewControllerClass?.increasePhalanxCount()
                    } else {
                        viewControllerClass?.upgrade(coinDecrement: purchasedCrate.coinReward! * -1, cpcIncrement: 0)
                        rewardLabel.text = "\(purchasedCrate.coinReward!) Coins Acquired!"
                    }
                }
            }
        }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return crates.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(223)
    }
    
    @IBAction func infoButtonDidTouch(_ sender: Any) {
        let alert = UIAlertController(title: "Crate Shop", message: "Buy a crate and get a random reward with a chance of a cat!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    func refreshCoins(){
        if let coins = viewControllerClass?.getCoins(){
            let displayCoins = viewControllerClass?.roundAndAbbreviate(num: Double(coins))
            coinLabel.text = "Coins: \(displayCoins ?? "error")"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                 self.refreshCoins()
             }
        }
    }
    
}
