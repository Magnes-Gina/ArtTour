//
//  mapDetailViewController.swift
//  ArtTour
//
//  Created by yikeren on 16/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView


class mapDetailViewController: UIViewController {

    
    var landmark: Landmark?
    
    
    @IBOutlet weak var savedButton: UIButton!
    @IBAction func saved(_ sender: Any) {
    
    
    }
    
    @IBOutlet weak var youtube: WKYTPlayerView!
    @IBOutlet weak var landmark_name: UILabel!
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        youtube.load(withVideoId: landmark!.video)
        landmark_name.text = landmark!.Landmark_name
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //
        super.viewWillDisappear(animated)
    
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
