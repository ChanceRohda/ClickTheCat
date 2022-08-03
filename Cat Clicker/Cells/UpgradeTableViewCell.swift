//
//  UpgradeTableViewCell.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 7/8/22.
//

import UIKit

class UpgradeTableViewCell: UITableViewCell {

    @IBOutlet weak var upgradeImageView: UIImageView!
    @IBOutlet weak var upgradeNameLabel: UILabel!
    @IBOutlet weak var upgradeCostLabel: UILabel!
    @IBOutlet weak var upgradeAutocoinLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
