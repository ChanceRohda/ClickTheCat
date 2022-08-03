//
//  Upgrades.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 8/3/22.
//

import Foundation
import UIKit

enum CostOrder {
    case ascending, descending
}


class UpgradesManager {
    static let shared = UpgradesManager()
    var costOrder: CostOrder = .ascending
    
    private init() {}
    var upgrades: [Upgrade] = [Upgrade(cost: 10, autocoin: 1, image: UIImage(named: "Cat Food Cat")!, name: "Cat Food 1"), Upgrade(cost: 100, autocoin: 10, image: UIImage(named: "Cat Food Cat")!, name: "Cat Food 2")]
    func sortByCostAscending() {
        costOrder = .ascending
        upgrades.sort { upgrades1, upgrades2 in
            upgrades1.cost > upgrades2.cost
        }
    }
    func sortByCostDescending() {
        costOrder = .descending
        upgrades.sort { upgrades1, upgrades2 in
            upgrades1.cost < upgrades2.cost
        }
    }
}
