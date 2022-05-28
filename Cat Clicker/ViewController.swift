//
//  ViewController.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 3/12/22.
//

import UIKit

protocol ViewControllerDelegate: AnyObject {
    func upgrade(coinDecrement: Int, cpcIncrement: Int)
    func getCoins() -> Int
    func resetcoinsVC()
    func addCat(cat: Cat)
    func getCatList() -> [Cat]
    func zeroCoins()
    func changeSelectedCat(cat: Cat)
    func getSelectedCat() -> String
}


class ViewController: UIViewController, ViewControllerDelegate {
    
    
    var coins: Int = 0
    var acquiredCats = [Cat(name: "Orange", description: "Does Nothing", image: UIImage(named: "Orange")!)]
    var selectedCat = "Orange"
    var cpc: Int = 1
    @IBOutlet weak var catButton: UIButton!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    func getSelectedCat() -> String {
        return selectedCat
    }
    func zeroCoins() {
        coins = 0
    }
    func getCatList() -> [Cat] {
        return acquiredCats
    }
    func addCat(cat: Cat) {
        acquiredCats.append(cat)
    }
    func resetcoinsVC() {
        coinLabel.text = "Coins: \(coins)"
    }
    func getCoins() -> Int{
        return coins
    }
    func upgrade(coinDecrement: Int, cpcIncrement: Int) {
        coins -= coinDecrement
        cpc += cpcIncrement
    }
    func incrementCoins(increment: Int) {
        coins += increment
        coinLabel.text = "Coins: \(coins)"
    }
    func changeSelectedCat(cat: Cat) {
        selectedCat = cat.name
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ShopViewController {
            destinationVC.viewControllerClass = self
        }
        if let destinationVC = segue.destination as? CrateShopViewController {
            destinationVC.viewControllerClass = self
        }
        if let destinationVC = segue.destination as? catMenuViewController {
            destinationVC.acquiredCats = acquiredCats
            
            destinationVC.viewControllerClass = self
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        catButton.setImage(UIImage(named: selectedCat), for: .normal)
    }

    @IBAction func catDidClick(_ sender: Any) {
        incrementCoins(increment: cpc)
        if selectedCat == "Gray" {
            incrementCoins(increment: 50)
        }
    }
    
    @IBAction func shopButtonDidClick(_ sender: Any) {
        performSegue(withIdentifier: "shopSegue", sender: nil)
    }
    
    @IBAction func crateShopButtonDidClick(_ sender: Any) {
        performSegue(withIdentifier: "crateShopSegue", sender: nil)
    }
    
        
    
    
    @IBAction func catMenuButtonDidClick(_ sender: Any) {
        performSegue(withIdentifier: "catMenuSegue", sender: nil)
    }
}

