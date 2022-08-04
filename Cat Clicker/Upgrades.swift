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
    var biggestUpgrade: Int = 10
    private init() {}
    var upgrades: [Upgrade] = [Upgrade(cost: 10, autocoin: 1, image: UIImage(named: "Cat Food Cat")!, name: "Cat Food 1")]
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
