//
//  Extension+UIViewController.swift
//  Cat Clicker
//
//  Created by Gwinyai Nyatsoka on 28/12/2022.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    
}
