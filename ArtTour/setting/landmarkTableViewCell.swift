//
//  landmarkTableViewCell.swift
//  ArtTour
//
//  Created by yikeren on 27/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class landmarkTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cellimage: UIImageView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
