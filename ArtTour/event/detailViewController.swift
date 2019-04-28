//
//  detailViewController.swift
//  ArtTour
//
//  Created by yikeren on 7/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import SwiftyJSON
import GoogleMaps
import CoreLocation
import CoreData

class detailViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate{

    
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBAction func likeAction(_ sender: Any) {
        if !saveflag{
            let newevent = NSEntityDescription.insertNewObject(forEntityName: "Event2", into: self.managedObjectContext) as! Event2
            newevent.about = eventdescription.text!
            newevent.address = address.text!
            newevent.startdate = eventDate.text!
            newevent.enddate = endDate.text!
            newevent.eventid = Int64(Int(json!["id"].string!)!)
            newevent.eventname = eventTitle.text!
            if json!["logo"]["original"]["url"].string == nil{
                newevent.imgurl = "none"
            }else{
                newevent.imgurl = json!["logo"]["original"]["url"].string!
            }
            
            newevent.latitude = Double(json!["venue"]["latitude"].string!)!
            newevent.longtitude = Double(json!["venue"]["longitude"].string!)!
            newevent.location = venue.text!
            newevent.address = address.text!
            newevent.link = link.text!
            do{
                try self.managedObjectContext.save()
                saveflag = true
                likeButton.backgroundColor = UIColor.red
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Event2")
                events = try managedObjectContext.fetch(fetchRequest) as! [Event2]
                print("saved to coredata")
            }catch{
                fatalError("Fail to save CoreData")
            }
        }else{
            for item2 in events{
                if Int(json!["id"].string!) == Int(item2.eventid){
                    print("want to delete")
                    print(Int(json!["id"].string!)!)
                    print(Int(item2.eventid))
                    do{
                        managedObjectContext.delete(item2)
                        try self.managedObjectContext.save()
                        saveflag = false
                        likeButton.backgroundColor  = UIColor.white
                        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Event2")
                        events = try managedObjectContext.fetch(fetchRequest) as! [Event2]
                       print("total events: \(events.count)")
                    }catch{
                        fatalError("Fail to save CoreData")
                    }
                    break
                }
            }
        }
    }
    
    @IBOutlet weak var image: UIImageView!
    
    
    @IBOutlet weak var backbutton: UIButton!
    
    var events = [Event2]()
    var saveflag = false
    
    @IBOutlet weak var link: UITextView!
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func savedata(){
        
    }
    
    func check(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Event2")
        do {
            events = try managedObjectContext.fetch(fetchRequest) as! [Event2]
            print(events.count)
            var boolflag = true
            for item in events{
                if Int(json!["id"].string!) == Int(item.eventid){
                    saveflag = true
                    boolflag = false
                    likeButton.backgroundColor = UIColor.red
                    break
                }
            }
            if boolflag{
                saveflag = false
                likeButton.backgroundColor = UIColor.white
            }
        }
        catch {
            fatalError("Fail to load list CoreData")
        }
    }
    
    
    @IBAction func bycarAction(_ sender: Any) {
        let locationtemp = locationManger.location?.coordinate
        
        UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(json!["venue"]["latitude"].string!),\(json!["venue"]["longitude"].string!)&travelmode=driving")!, options: [:], completionHandler: nil)
    }
    
    @IBOutlet weak var bycarButton: UIButton!
    
    
    @IBAction func byWalkAction(_ sender: Any) {
        let locationtemp = locationManger.location?.coordinate
        UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(json!["venue"]["latitude"].string!),\(json!["venue"]["longitude"].string!)&travelmode=walking")!, options: [:], completionHandler: nil)
    }
    
    @IBOutlet weak var bywalkbutton: UIButton!
    
    
    @IBAction func bybikeAction(_ sender: Any) {
        let locationtemp = locationManger.location?.coordinate
        UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(json!["venue"]["latitude"].string!),\(json!["venue"]["longitude"].string!)&travelmode=bicycling")!, options: [:], completionHandler: nil)
    }
    
    
    @IBOutlet weak var bybikeButton: UIButton!
    
    
    @IBAction func bypublicAction(_ sender: Any) {
        let locationtemp = locationManger.location?.coordinate
        UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(json!["venue"]["latitude"].string!),\(json!["venue"]["longitude"].string!)&travelmode=transit")!, options: [:], completionHandler: nil)
    }
    
    @IBOutlet weak var byPublicButton: UIButton!
    
    
    
    @IBAction func readMore(_ sender: Any) {
        self.performSegue(withIdentifier: "readmore", sender: self)
    }
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var address: UILabel!
  
    @IBOutlet weak var endDate: UILabel!
    
    @IBOutlet weak var eventdescription: UILabel!
    @IBOutlet weak var eventmap: GMSMapView!
    @IBOutlet weak var venue: UILabel!
    let locationManger = CLLocationManager()
    
    var json: JSON?
    
    private var managedObjectContext: NSManagedObjectContext
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(json!["name"]["text"].string!)
        self.backbutton.layer.cornerRadius = (self.backbutton.frame.height / 2)
        image.pin_setImage(from: URL(string: (json!["logo"]["original"]["url"].string!)))
        link.isEditable = false
        link.text = json!["url"].string!
        link.dataDetectorTypes = .link
        eventdescription.text = json!["description"]["text"].string!
        eventTitle.text = json!["name"]["text"].string!
        var strtemp = json!["start"]["local"].string!
        strtemp = strtemp.replacingOccurrences(of: "T", with: " ")
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let datetemp = df.date(from: strtemp)
        let df2 = DateFormatter()
        df2.dateFormat = "MMM dd yyyy HH:mm:ss"
        let newstr = df2.string(from: datetemp!)
        eventDate.text = newstr
        var strtemp2 = json!["end"]["local"].string!
        strtemp2 = strtemp2.replacingOccurrences(of: "T", with: " ")
        let datetemp2 = df.date(from: strtemp2)
        let newstr2 = df2.string(from: datetemp2!)
        endDate.text = newstr2
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
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.opengoogle))
        self.eventmap.addGestureRecognizer(gesture)
        locationManger.requestAlwaysAuthorization()
        //locationManger.startMonitoringSignificantLocationChanges()
        locationManger.distanceFilter = 100
        checkLocationServices()
        self.bycarButton.layer.cornerRadius = (self.bycarButton.frame.height / 2)
        self.bybikeButton.layer.cornerRadius = (self.bybikeButton.frame.height / 2)
        self.bywalkbutton.layer.cornerRadius = (self.bywalkbutton.frame.height / 2)
        self.byPublicButton.layer.cornerRadius = (self.byPublicButton.frame.height / 2)
        self.likeButton.layer.cornerRadius = (self.likeButton.frame.height / 2)
        // Do any additional setup after loading the view.
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        }else{
            //show alert that user dont have location service
        }
    }
    
    func setupLocationManager() {
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
    
            locationManger.startUpdatingLocation()
            break
        case .authorizedWhenInUse:
            
            locationManger.startUpdatingLocation()
            break
        case .notDetermined:
            locationManger.requestAlwaysAuthorization()
            break
        case .denied:
            displayMessage("Our location request has been dined", "Denied Alert")
            break
        case .restricted:
            displayMessage("Our location request has been Restricted", "Restricted Alert")
            break
        @unknown default:
            break
        }
    }
    
    
    
    func displayMessage(_ message: String,_ title: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:
            UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func opengoogle(sender: UITapGestureRecognizer){
        //UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=-37.886561,145.091904&destination=-37.885062,145.078586&travelmode=driving")!, options: [:], completionHandler: nil)
        
        UIApplication.shared.open(URL(string: "http://www.google.com/maps/search/?api=1&query=\(json!["venue"]["latitude"].string!),\(json!["venue"]["longitude"].string!)")!, options: [:], completionHandler: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        check()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "readmore"{
            let destination: readViewController = segue.destination as! readViewController
            destination.newstr = json!["description"]["text"].string!
        }
    }
 

}
