//
//  moodTableViewCell.swift
//  ArtTour
//
//  Created by yikeren on 28/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class moodTableViewCell: UITableViewCell {

    
    @IBOutlet weak var moodLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
