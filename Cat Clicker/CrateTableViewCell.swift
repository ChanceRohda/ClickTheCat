//
//  CrateTableViewCell.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 6/25/22.
//

import UIKit

class CrateTableViewCell: UITableViewCell {

    @IBOutlet weak var crateImageView: UIImageView!
    @IBOutlet weak var crateNameLabel: UILabel!
    @IBOutlet weak var crateCostLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
