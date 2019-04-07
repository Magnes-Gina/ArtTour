//
//  museumTableViewCell.swift
//  ArtTour
//
//  Created by yikeren on 8/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class museumTableViewCell: UITableViewCell {


    @IBOutlet weak var imageview: UIImageView!
    
    
    @IBOutlet weak var title: UILabel!
    
    
    @IBOutlet weak var type: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
