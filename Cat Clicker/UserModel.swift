//
//  UserModel.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 8/7/22.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
struct UserModel {
    var id: String
    var username: String
    var coins: Int
    var calendar: Int
    var tuna: Int
    var firebaseAcquiredCats: [String] = []
    var selectedCat: String
    var clicks: Int
    var adPoints: Int
    var cpc: Int
    var gazAvailable: Bool
    var cps: Int
    var avatar: URL?
    var phalanx: Int
    var upgradeNumber: Int
    var achievement1IsComplete = false
    var achievement2IsComplete = false
    var achievement3IsComplete = false
    static let collection = Database.database().reference().child("users")
    init?(snapshot : DataSnapshot){
        guard let data = snapshot.value as? [String: Any] else {return nil}
        guard let username = data["username"] as? String else {return nil}
        self.id = snapshot.key
        self.username = username
        firebaseAcquiredCats = data["firebaseAcquiredCats"] as? [String] ?? ["Orange"]
        
        self.achievement1IsComplete = data["achievement1IsComplete"] as? Bool ?? false
        self.achievement2IsComplete = data["achievement2IsComplete"] as? Bool ?? false
        self.achievement3IsComplete = data["achievement3IsComplete"] as? Bool ?? false
        print("")
        print(self.firebaseAcquiredCats)
        print("")
        self.calendar = data["calendar"] as? Int ?? 0
        self.phalanx = data["phalanx"] as? Int ?? 0
        self.selectedCat = data["selectedCat"] as? String ?? "Orange"
        self.coins = data["coins"] as? Int ?? 0
        self.tuna = data["tuna"] as? Int ?? 0
        self.clicks = data["clicks"] as? Int ?? 0
        self.adPoints = data["adPoints"] as? Int ?? 0
        self.cpc = data["cpc"] as? Int ?? 1
        self.cps = data["cps"] as? Int ?? 0
        self.gazAvailable = data["gazAvailable"] as? Bool ?? false
        self.upgradeNumber = data["upgradeNumber"] as? Int ?? 1
        if let avatar = data["avatar"] as? String,
            let avatarURL = URL(string: avatar){
            self.avatar = avatarURL
        }
        
    }
    init?(data : [String : Any], userKey : String){
        guard let username = data["username"] as? String else {return nil}
        self.id = userKey
        self.username = username
        self.calendar = data["calendar"] as? Int ?? 0
        self.phalanx = data["phalanx"] as? Int ?? 0
        self.selectedCat = data["selectedCat"] as? String ?? "Orange"
        self.coins = data["coins"] as? Int ?? 0
        self.tuna = data["tuna"] as? Int ?? 0
        self.clicks = data["clicks"] as? Int ?? 0
        self.adPoints = data["adPoints"] as? Int ?? 0
        self.cpc = data["cpc"] as? Int ?? 1
        self.cps = data["cps"] as? Int ?? 0
        self.gazAvailable = data["gazAvailable"] as? Bool ?? false
        firebaseAcquiredCats = data["firebaseAcquiredCats"] as? [String] ?? ["Orange"]
        self.achievement1IsComplete = data["achievement1IsComplete"] as? Bool ?? false
        self.achievement2IsComplete = data["achievement2IsComplete"] as? Bool ?? false
        self.achievement3IsComplete = data["achievement3IsComplete"] as? Bool ?? false
        print("")
        print(self.firebaseAcquiredCats)
        print("")
        self.upgradeNumber = data["upgradeNumber"] as? Int ?? 1
        if let avatar = data["avatar"] as? String,
            let avatarURL = URL(string: avatar){
            self.avatar = avatarURL
        }
    }
}
