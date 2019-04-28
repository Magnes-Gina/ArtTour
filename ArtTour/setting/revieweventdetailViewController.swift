//
//  revieweventdetailViewController.swift
//  ArtTour
//
//  Created by yikeren on 29/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import CoreData

class revieweventdetailViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var likeButton: UIButton!
    
    
    
    @IBOutlet weak var readDetail: UITextView!
    
    @IBAction func downaction(_ sender: Any) {
        animatedOut()
    }
    
    @IBOutlet var addItemView: UIView!
    @IBAction func likeAction(_ sender: Any) {
        managedObjectContext.delete(event!)
        do{
            try managedObjectContext.save()
            CBToast.showToastAction(message: "Successfully Delete!")
            self.navigationController?.popViewController(animated: true)
        }catch{
            fatalError("can not delete")
        }
    }
    
    @IBOutlet weak var image: UIImageView!
    
    
    @IBOutlet weak var backbutton: UIButton!
    
    var events = [Event2]()
    
    @IBOutlet weak var link: UITextView!
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func check(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Event2")
        do {
            events = try managedObjectContext.fetch(fetchRequest) as! [Event2]
            var boolflag = true
            for item in events{
                if Int(event!.eventid) == Int(item.eventid){
                    boolflag = false
                    break
                }
            }
            if boolflag{
                self.navigationController?.popViewController(animated: true)
                CBToast.showToastAction(message: "This event is deleted ")
            }
        }
        catch {
            fatalError("Fail to load list CoreData")
        }
    }
    
    
    @IBAction func bycarAction(_ sender: Any) {
        let locationtemp = locationManger.location?.coordinate
        
        UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(event!.latitude),\(event!.longtitude)&travelmode=driving")!, options: [:], completionHandler: nil)
    }
    
    @IBOutlet weak var bycarButton: UIButton!
    
    
    @IBAction func byWalkAction(_ sender: Any) {
        let locationtemp = locationManger.location?.coordinate
        UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(event!.latitude),\(event!.longtitude)&travelmode=walking")!, options: [:], completionHandler: nil)
    }
    
    @IBOutlet weak var bywalkbutton: UIButton!
    
    
    @IBAction func bybikeAction(_ sender: Any) {
        let locationtemp = locationManger.location?.coordinate
        UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(event!.latitude),\(event!.longtitude)&travelmode=bicycling")!, options: [:], completionHandler: nil)
    }
    
    
    @IBOutlet weak var bybikeButton: UIButton!
    
    
    @IBAction func bypublicAction(_ sender: Any) {
        let locationtemp = locationManger.location?.coordinate
        UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(event!.latitude),\(event!.longtitude)&travelmode=transit")!, options: [:], completionHandler: nil)
    }
    
    @IBOutlet weak var byPublicButton: UIButton!
    
    
    
    @IBAction func readMore(_ sender: Any) {
       animatedIn()
    }
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var address: UILabel!
    var event: Event2?
    @IBOutlet weak var endDate: UILabel!
    
    @IBOutlet weak var eventdescription: UILabel!
    @IBOutlet weak var eventmap: GMSMapView!
    @IBOutlet weak var venue: UILabel!
    let locationManger = CLLocationManager()
    
    
    private var managedObjectContext: NSManagedObjectContext
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    func animatedIn(){
        self.view.addSubview(addItemView)
        addItemView.center = self.view.center
        addItemView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addItemView.alpha = 0
        UIView.animate(withDuration: 1){
            self.addItemView.alpha = 1
            self.addItemView.transform = CGAffineTransform.identity
        }
    }
    
    func animatedOut(){
        UIView.animate(withDuration: 0.4, animations: {
            self.addItemView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.addItemView.alpha = 0
        }) {(sucess: Bool) in
            self.addItemView.removeFromSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addItemView.layer.cornerRadius = 10
        self.backbutton.layer.cornerRadius = (self.backbutton.frame.height / 2)
        image.pin_setImage(from: URL(string: event!.imgurl!))
        link.isEditable = false
        link.text = event!.link!
        link.dataDetectorTypes = .link
        eventdescription.text = event!.about!
        readDetail.text = event!.about!
        readDetail.isEditable = false
        eventTitle.text = event!.eventname
        eventDate.text = event!.startdate!
        
        endDate.text = event!.enddate ?? "Unknown"
        venue.text = event!.location!
        address.text = event!.address!
        let camera = GMSCameraPosition.camera(withLatitude: event!.latitude, longitude: event!.longtitude, zoom: 15.0)
        eventmap.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: event!.latitude, longitude: event!.longtitude)
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
        
        UIApplication.shared.open(URL(string: "http://www.google.com/maps/search/?api=1&query=\(event!.latitude),\(event!.longtitude)")!, options: [:], completionHandler: nil)
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
    
}
