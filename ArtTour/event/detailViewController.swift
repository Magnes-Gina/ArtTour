//
//  detailViewController.swift
//  ArtTour
//
//  Created by yikeren on 7/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import SwiftyJSON

class detailViewController: UIViewController {

    
    @IBOutlet weak var image: UIImageView!
    
    
    @IBOutlet weak var backbutton: UIButton!
    
    
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var link: UITextView!
    @IBOutlet weak var eventdescription: UITextView!
    @IBOutlet weak var eventmap: GMSMapView!
    @IBOutlet weak var venue: UILabel!
    
    var json: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(json!["name"]["text"].string!)
        self.backbutton.layer.cornerRadius = (self.backbutton.frame.height / 2)
        image.pin_setImage(from: URL(string: (json!["logo"]["original"]["url"].string!)))
        link.isEditable = false
        link.text = json!["url"].string!
        eventdescription.isEditable = false
        eventdescription.text = json!["description"]["text"].string!
        eventTitle.text = json!["name"]["text"].string!
        eventDate.text = json!["start"]["local"].string!
        venue.text = json!["venue"]["name"].string!
        address.text = json!["venue"]["address"]["localized_address_display"].string!
        print(Double(json!["venue"]["latitude"].string!)!)
        print(Double(json!["venue"]["latitude"].string!)!)
        let camera = GMSCameraPosition.camera(withLatitude: Double(json!["venue"]["latitude"].string!)!, longitude: Double(json!["venue"]["longitude"].string!)!, zoom: 15.0)
        eventmap.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: Double(json!["venue"]["latitude"].string!)!, longitude: Double(json!["venue"]["longitude"].string!)!)
        marker.map = eventmap
        eventmap.settings.scrollGestures = false
        eventmap.settings.zoomGestures = false
        eventmap.settings.tiltGestures = false
        eventmap.settings.rotateGestures = false
        
        // Do any additional setup after loading the view.
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
