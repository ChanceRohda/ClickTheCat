//
//  AuthRootViewController.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 8/6/22.
//

import UIKit

class AuthRootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInButtonDidTouch(_ sender: Any) {
        performSegue(withIdentifier: "logInSegue", sender: nil)
    }
 
    @IBAction func createAccountButtonDidTouch(_ sender: Any) {
        performSegue(withIdentifier: "createAccountSegue", sender: nil)
    }
}
