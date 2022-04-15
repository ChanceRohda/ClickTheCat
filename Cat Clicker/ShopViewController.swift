//
//  ShopViewController.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 3/21/22.
//

import UIKit

class ShopViewController: UIViewController{
    
    @IBOutlet weak var coinLabel: UILabel!
    
    
    weak var viewControllerClass: ViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let coins = viewControllerClass?.getCoins(){
        coinLabel.text = "Coins: \(coins)"
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func explodeButtonDidTouch(_ sender: Any) {
        
    }
    
    
    
            // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
