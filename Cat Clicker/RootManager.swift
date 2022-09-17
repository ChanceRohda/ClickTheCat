//
//  File.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 8/7/22.
//

import Foundation
import UIKit
import FirebaseAuth
class RootManager {
    
    static func login() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let catClickVC = mainStoryboard.instantiateViewController(withIdentifier: "ViewController")
        let navVC = UINavigationController(rootViewController: catClickVC)
        UIApplication.shared.windows.first?.rootViewController = navVC
    }
    static func logout() {
        try? Auth.auth().signOut()
        let authStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let authRootVC = authStoryboard.instantiateViewController(withIdentifier: "AuthRootViewController")
        let navVC = UINavigationController(rootViewController: authRootVC)
        UIApplication.shared.windows.first?.rootViewController = navVC
    }
    
}
