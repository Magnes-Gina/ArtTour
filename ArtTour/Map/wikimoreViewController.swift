//
//  wikimoreViewController.swift
//  ArtTour
//
//  Created by yikeren on 12/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class wikimoreViewController: UIViewController {

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBOutlet weak var textarea: UITextView!
    
    var str: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        textarea.text = str!
        textarea.isEditable = false
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
