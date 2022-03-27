//
//  ViewController.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 3/12/22.
//

import UIKit

class ViewController: UIViewController {
    var coins: Int = 0
    var level: Int = 1
    var cost: Int = 1
    @IBOutlet weak var catButton: UIButton!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //catButton.currentImage = UIImage(named: "cat")
    }

    @IBAction func catDidClick(_ sender: Any) {
        coins += level
        coinLabel.text = "Coins: \(coins)"
    }
    @IBAction func upgradeButtonDidClick(_ sender: Any) {
        if coins >= (level * 2) {
            coins -= (level * 2)
            coinLabel.text = "Coins: \(coins)"
            level += 1
            costLabel.text = "Upgrade 1 Cost: \(cost)"
        }
        
    }
    
    @IBAction func shopButtonDidClick(_ sender: Any) {
        performSegue(withIdentifier: "shopSegue", sender: nil)
    }
    
    
}

