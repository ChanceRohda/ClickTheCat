//
//  Extension+Date.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 11/12/22.
//

import Foundation

//ca-app-pub-2692883151832197~9789348545

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
}
