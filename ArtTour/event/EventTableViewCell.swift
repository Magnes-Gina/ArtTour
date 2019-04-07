//
//  EventTableViewCell.swift
//  ArtTour
//
//  Created by yikeren on 6/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
