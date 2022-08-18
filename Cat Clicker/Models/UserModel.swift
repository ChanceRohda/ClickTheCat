//
//  UserModel.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 8/7/22.
//

import Foundation
import UIKit
import Firebase
struct UserModel {
    var username: String
    var coins: Int
    var tuna: Int
    var clicks: Int
    var adPoints: Int
    var cpc: Int
    var cps: Int
    static let collection = Database.database().reference().child("users")
}
