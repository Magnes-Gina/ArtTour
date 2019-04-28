//
//  settingTableViewCell.swift
//  ArtTour
//
//  Created by yikeren on 27/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class settingTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cellImage: UIImageView!
    
    
    @IBOutlet weak var CellLable: UILabel!
    
    
    @IBOutlet weak var Arrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
