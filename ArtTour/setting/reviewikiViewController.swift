//
//  reviewikiViewController.swift
//  ArtTour
//
//  Created by yikeren on 12/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class reviewikiViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UITextView!
    var str: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = str!
        descriptionLabel.isEditable = false
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
