//
//  DailyAdModel.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 11/12/22.
//
import Foundation
import FirebaseDatabase
struct DailyAdModel {
    var id: String
    var startOfDay: Date
    var endOfDay: Date
    var adsWatched: Int
    var achievement4IsComplete: Bool = false
    
    static let collection = Database.database().reference().child("dailyAdModel")
    init?(snapshot : DataSnapshot){
        guard let data = snapshot.value as? [String: Any] else {return nil}
        guard let startOfDaySinceEpoch = data["startOfDay"] as? Double else {return nil}
        self.startOfDay = Date(timeIntervalSince1970: startOfDaySinceEpoch)
        guard let endOfDaySinceEpoch = data["endOfDay"] as? Double else {return nil}
        self.endOfDay = Date(timeIntervalSince1970: endOfDaySinceEpoch)
        guard let adsWatched = data["adsWatched"] as? Int else {return nil}
        self.adsWatched = adsWatched
        if let achievement4IsComplete = data["achievement4IsComplete"] as? Bool{
            self.achievement4IsComplete = achievement4IsComplete
        }
        self.id = snapshot.key
    }
    init?(data : [String : Any], userKey : String){
        guard let startOfDaySinceEpoch = data["startOfDay"] as? Double else {return nil}
        self.startOfDay = Date(timeIntervalSince1970: startOfDaySinceEpoch)
        guard let endOfDaySinceEpoch = data["endOfDay"] as? Double else {return nil}
        self.endOfDay = Date(timeIntervalSince1970: endOfDaySinceEpoch)
        guard let adsWatched = data["adsWatched"] as? Int else {return nil}
        self.adsWatched = adsWatched
        self.id = userKey
    }
}
