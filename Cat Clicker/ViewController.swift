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
}


class ViewController: UIViewController, ViewControllerDelegate {
    
    
    var coins: Int = 0
    
    var cpc: Int = 1
    @IBOutlet weak var catButton: UIButton!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ShopViewController {
            destinationVC.viewControllerClass = self
        }
        if let destinationVC = segue.destination as? CrateShopViewController {
            destinationVC.viewControllerClass = self
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        let cat = UIImage (named: "cat")
        catButton.setImage(cat, for: .normal)
    }

    @IBAction func catDidClick(_ sender: Any) {
        incrementCoins(increment: cpc)
    }
    
    @IBAction func shopButtonDidClick(_ sender: Any) {
        performSegue(withIdentifier: "shopSegue", sender: nil)
    }
    
    @IBAction func crateShopButtonDidClick(_ sender: Any) {
        performSegue(withIdentifier: "crateShopSegue", sender: nil)
    }
    
}

