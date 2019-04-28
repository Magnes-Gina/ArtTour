//
//  revieweventTableViewCell.swift
//  ArtTour
//
//  Created by yikeren on 29/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class revieweventTableViewCell: UITableViewCell {

    
    @IBOutlet weak var logoimg: UIImageView!
    
    @IBOutlet weak var namelabel: UILabel!
    
    
    @IBOutlet weak var timelabel: UILabel!
    
    
    @IBOutlet weak var addresslabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
