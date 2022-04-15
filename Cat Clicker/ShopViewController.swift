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
    func refreshCoins(){
        if let coins = viewControllerClass?.getCoins(){
        coinLabel.text = "Coins: \(coins)"
    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshCoins()
        }
        // Do any additional setup after loading the view.
    override func viewWillDisappear(_ animated: Bool) {
        viewControllerClass?.resetcoinsVC()
    }
    @IBAction func wellFedButtonDidTouch(_ sender: Any) {
        if let coins = viewControllerClass?.getCoins(){
        if  coins >= 10 {
            viewControllerClass?.upgrade(coinDecrement: 10, cpcIncrement: 1)
        }
        refreshCoins()
    }
    }
    
    @IBAction func explodeButtonDidTouch(_ sender: Any) {
        if let coins = viewControllerClass?.getCoins(){
        if  coins >= 500 {
            viewControllerClass?.upgrade(coinDecrement: 500, cpcIncrement: 100)
        }
        refreshCoins()
    }
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
