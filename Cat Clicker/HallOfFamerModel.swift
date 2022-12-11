//
//  HallOfFamerModel.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 10/30/22.
//

import Foundation
import FirebaseDatabase
struct HallOfFamerModel {
    var id: String
    var username: String
    var hof: Int
    static let collection = Database.database().reference().child("hallOfFame")
    init?(snapshot : DataSnapshot){
        guard let data = snapshot.value as? [String: Any] else {return nil}
        guard let username = data["username"] as? String else {return nil}
        guard let hof = data["hof"] as? Int else {return nil}
        self.username = username
        self.hof = hof
        self.id = snapshot.key
    }
    init?(data : [String : Any], userKey : String){
        guard let username = data["username"] as? String else {return nil}
        guard let hof = data["hof"] as? Int else {return nil}
        self.id = userKey
        self.username = username
        self.hof = hof
    }
}
