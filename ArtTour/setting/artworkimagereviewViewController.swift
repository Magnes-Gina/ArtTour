//
//  artworkimagereviewViewController.swift
//  ArtTour
//
//  Created by yikeren on 14/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class artworkimagereviewViewController: UIViewController ,EFImageViewZoomDelegate {
    
    @IBOutlet weak var backbutton: UIButton!
    
    var img : UIImage?
    @IBAction func backaction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var zoominage: EFImageViewZoom!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(backbutton)
        self.backbutton.layer.cornerRadius = self.backbutton.frame.height / 2
        self.zoominage._delegate = self
        self.zoominage.image = img!
        self.zoominage.contentMode = .left
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
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
