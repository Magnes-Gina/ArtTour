//
//  eventViewController.swift
//  ArtTour
//
//  Created by yikeren on 6/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import PINRemoteImage

class eventViewController: UIViewController {

    //@IBOutlet weak var imagetest: UIImageView!
    
    
    
    
    
    @IBOutlet weak var search: UIButton!
    
    @IBAction func find(_ sender: Any) {
       
        self.performSegue(withIdentifier: "eventresult", sender: self)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search.layer.cornerRadius = 5
       
        //self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        //imagetest.sd_setImage(with: URL(string: "https://img.evbuc.com/https%3A%2F%2Fcdn.evbuc.com%2Fimages%2F56937365%2F250209674674%2F1%2Foriginal.20190217-034235?auto=compress&s=8abc34ce344398c198193afc468dc0fa  "),placeholderImage:UIImage(named: "singer.png"))
        //imagetest.sd_setImage
        // Do any additional setup after loading the view.
       
        //imagetest.pin_updateWithProgress = true
        //imagetest.pin_setImage(from: URL(string:"https://img.evbuc.com/https%3A%2F%2Fcdn.evbuc.com%2Fimages%2F56937365%2F250209674674%2F1%2Foriginal.20190217-034235?auto=compress&s=8abc34ce344398c198193afc468dc0fa"))
            }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
