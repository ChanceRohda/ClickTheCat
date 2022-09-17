//
//  TutorialViewController.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 8/16/22.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var count = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "Gray")
        label.text = "My name is Gray! Welcome to CatClick!"
        
    }
    @IBAction func nextButtonDidTouch(_ sender: Any) {
        count += 1
        if count == 2 {
            label.text = "A recent science discovery showed that certain cats summon coins when tapped!"
            imageView.image = UIImage(named: "Gold Cat")
        } else if count == 3 {
            label.text = "Feeding these cats makes them produce coins on their own, creatively dubbed Autocoin."
            imageView.image = UIImage(named: "Cat Food Cat")
        } else if count == 4 {
            label.text = "And special training allows them to summon more coins per tap, called CpC."
            imageView.image = UIImage(named: "CpC+")
        } else if count == 5 {
            label.text = "You can get cats from crates, achievements, or four-digit codes in the Cat Menu."
            imageView.image = UIImage(named: "Code CC")
        } else if count == 6 {
            label.text = "Your mission is to purchase upgrades and become the richest in the world!"
            imageView.image = UIImage(named: "Coin Pile")
        } else if count == 7 {
            label.text = "Good Luck!"
            imageView.image = UIImage(named: "Gray")
        } else {
            RootManager.login()
        }
    }
    
}
