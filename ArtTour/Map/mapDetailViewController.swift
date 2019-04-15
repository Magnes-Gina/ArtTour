//
//  mapDetailViewController.swift
//  ArtTour
//
//  Created by yikeren on 16/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class mapDetailViewController: UIViewController {

    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
