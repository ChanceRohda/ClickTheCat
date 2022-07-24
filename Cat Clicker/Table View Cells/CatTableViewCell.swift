//
//  CatTableViewCell.swift
//  Cat Clicker
//
//  Created by Chance Rohda on 5/15/22.
//

import UIKit

class CatTableViewCell: UITableViewCell {

    @IBOutlet weak var catNameLabel: UILabel!
    
    @IBOutlet weak var catImageView: UIImageView!
    
    @IBOutlet weak var catDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
