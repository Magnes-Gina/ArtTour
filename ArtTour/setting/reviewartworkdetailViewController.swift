//
//  reviewartworkdetailViewController.swift
//  ArtTour
//
//  Created by yikeren on 29/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import CoreData

class reviewartworkdetailViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate{

    
    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var profileimg: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var categorylabel: UILabel!
    @IBOutlet weak var addresslabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var structurelabel: UILabel!
    let locationManger = CLLocationManager()
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func moreaction(_ sender: Any) {
        if artwork!.ArtWork_description == "0"{
            displayMessage("This Artwork doesn't have anny more information", "Sorry")
        }else{
            print(artwork!.ArtWork_description)
            let split = artwork!.ArtWork_description.components(separatedBy: ";")
            UIApplication.shared.open(URL(string: split[0])!, options: [:], completionHandler: nil)
        }
    }
    
    @IBOutlet weak var myMapView: GMSMapView!
    
    @IBOutlet weak var car: UIButton!
    @IBOutlet weak var bike: UIButton!
   
    @IBOutlet weak var publictransit: UIButton!
    @IBOutlet weak var walk: UIButton!
    
    @IBAction func caraction(_ sender: Any) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            let resultAlertController = UIAlertController(title: "Warning", message: nil, preferredStyle: .alert)
            
            resultAlertController.addAction(UIAlertAction(title: "Yes", style: .default) {_ in
                let locationtemp = self.locationManger.location?.coordinate
                UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(self.artwork!.ArtWork_latitude),\(self.artwork!.ArtWork_longtitude)&travelmode=driving")!, options: [:], completionHandler: nil)
            })
            resultAlertController.addAction(UIAlertAction(title: "No", style: .default) {_ in
                resultAlertController.dismiss(animated: true, completion: nil)
            })
            resultAlertController.message = "Do you want to leave this APP and go to Google Map?"
            present(resultAlertController,animated: true,completion: nil)
            break
        case .authorizedWhenInUse:
            let resultAlertController = UIAlertController(title: "Warning", message: nil, preferredStyle: .alert)
            
            resultAlertController.addAction(UIAlertAction(title: "Yes", style: .default) {_ in
                let locationtemp = self.locationManger.location?.coordinate
                UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(self.artwork!.ArtWork_latitude),\(self.artwork!.ArtWork_longtitude)&travelmode=driving")!, options: [:], completionHandler: nil)
            })
            resultAlertController.addAction(UIAlertAction(title: "No", style: .default) {_ in
                resultAlertController.dismiss(animated: true, completion: nil)
            })
            resultAlertController.message = "Do you want to leave this APP and go to Google Map?"
            present(resultAlertController,animated: true,completion: nil)
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
    
    
    @IBAction func walkaction(_ sender: Any) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            let resultAlertController = UIAlertController(title: "Warning", message: nil, preferredStyle: .alert)
            
            resultAlertController.addAction(UIAlertAction(title: "Yes", style: .default) {_ in
                let locationtemp = self.locationManger.location?.coordinate
                UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(self.artwork!.ArtWork_latitude),\(self.artwork!.ArtWork_longtitude)&travelmode=walking")!, options: [:], completionHandler: nil)
            })
            resultAlertController.addAction(UIAlertAction(title: "No", style: .default) {_ in
                resultAlertController.dismiss(animated: true, completion: nil)
            })
            resultAlertController.message = "Do you want to leave this APP and go to Google Map?"
            present(resultAlertController,animated: true,completion: nil)
            break
        case .authorizedWhenInUse:
            let resultAlertController = UIAlertController(title: "Warning", message: nil, preferredStyle: .alert)
            
            resultAlertController.addAction(UIAlertAction(title: "Yes", style: .default) {_ in
                let locationtemp = self.locationManger.location?.coordinate
                UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(self.artwork!.ArtWork_latitude),\(self.artwork!.ArtWork_longtitude)&travelmode=waliking")!, options: [:], completionHandler: nil)
            })
            resultAlertController.addAction(UIAlertAction(title: "No", style: .default) {_ in
                resultAlertController.dismiss(animated: true, completion: nil)
            })
            resultAlertController.message = "Do you want to leave this APP and go to Google Map?"
            present(resultAlertController,animated: true,completion: nil)
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
    
    
    @IBAction func bikeAction(_ sender: Any) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            let resultAlertController = UIAlertController(title: "Warning", message: nil, preferredStyle: .alert)
            
            resultAlertController.addAction(UIAlertAction(title: "Yes", style: .default) {_ in
                let locationtemp = self.locationManger.location?.coordinate
                UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(self.artwork!.ArtWork_latitude),\(self.artwork!.ArtWork_longtitude)&travelmode=bicycling")!, options: [:], completionHandler: nil)
            })
            resultAlertController.addAction(UIAlertAction(title: "No", style: .default) {_ in
                resultAlertController.dismiss(animated: true, completion: nil)
            })
            resultAlertController.message = "Do you want to leave this APP and go to Google Map?"
            present(resultAlertController,animated: true,completion: nil)
            break
        case .authorizedWhenInUse:
            let resultAlertController = UIAlertController(title: "Warning", message: nil, preferredStyle: .alert)
            
            resultAlertController.addAction(UIAlertAction(title: "Yes", style: .default) {_ in
                let locationtemp = self.locationManger.location?.coordinate
                UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(self.artwork!.ArtWork_latitude),\(self.artwork!.ArtWork_longtitude)&travelmode=bicycling")!, options: [:], completionHandler: nil)
            })
            resultAlertController.addAction(UIAlertAction(title: "No", style: .default) {_ in
                resultAlertController.dismiss(animated: true, completion: nil)
            })
            resultAlertController.message = "Do you want to leave this APP and go to Google Map?"
            present(resultAlertController,animated: true,completion: nil)
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
    
    @IBAction func publicaction(_ sender: Any) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            let resultAlertController = UIAlertController(title: "Warning", message: nil, preferredStyle: .alert)
            
            resultAlertController.addAction(UIAlertAction(title: "Yes", style: .default) {_ in
                let locationtemp = self.locationManger.location?.coordinate
                UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(self.artwork!.ArtWork_latitude),\(self.artwork!.ArtWork_longtitude)&travelmode=transit")!, options: [:], completionHandler: nil)
            })
            resultAlertController.addAction(UIAlertAction(title: "No", style: .default) {_ in
                resultAlertController.dismiss(animated: true, completion: nil)
            })
            resultAlertController.message = "Do you want to leave this APP and go to Google Map?"
            present(resultAlertController,animated: true,completion: nil)
            break
        case .authorizedWhenInUse:
            let resultAlertController = UIAlertController(title: "Warning", message: nil, preferredStyle: .alert)
            
            resultAlertController.addAction(UIAlertAction(title: "Yes", style: .default) {_ in
                let locationtemp = self.locationManger.location?.coordinate
                UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(self.artwork!.ArtWork_latitude),\(self.artwork!.ArtWork_longtitude)&travelmode=transit")!, options: [:], completionHandler: nil)
            })
            resultAlertController.addAction(UIAlertAction(title: "No", style: .default) {_ in
                resultAlertController.dismiss(animated: true, completion: nil)
            })
            resultAlertController.message = "Do you want to leave this APP and go to Google Map?"
            present(resultAlertController,animated: true,completion: nil)
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
    
    
    @IBAction func deleteaction(_ sender: Any) {
        if source! == 0{
            managedObjectContext.delete(artwork2!)
            do{
                try managedObjectContext.save()
                self.navigationController?.popViewController(animated: true)
            }catch{
                fatalError("can not delete")
            }
        }else{
            managedObjectContext.delete(artwork3!)
            do{
                try managedObjectContext.save()
                self.navigationController?.popViewController(animated: true)
            }catch{
                fatalError("can not delete")
            }
        }
        
    }
    
    func check(){
        if source == 0{
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedArtWork")
            do {
                let saved = try managedObjectContext.fetch(fetchRequest) as! [SavedArtWork]
                var boolflag = true
                for item in saved{
                    if Int(artwork!.ArtWork_id) == Int(item.artwork_id){
                        boolflag = false
                        break
                    }
                }
                if boolflag{
                    self.navigationController?.popViewController(animated: true)
                    CBToast.showToastAction(message: "This artwork is deleted ")
                }
            }
            catch {
                fatalError("Fail to load list CoreData")
            }
        }else{
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LikeArtWork")
            do {
                let saved = try managedObjectContext.fetch(fetchRequest) as! [LikeArtWork]
                var boolflag = true
                for item in saved{
                    if Int(artwork!.ArtWork_id) == Int(item.artwork_id){
                        boolflag = false
                        break
                    }
                }
                if boolflag{
                    self.navigationController?.popViewController(animated: true)
                    CBToast.showToastAction(message: "This artwork is deleted ")
                }
            }
            catch {
                fatalError("Fail to load list CoreData")
            }
        }
        
    }
    
    var artists: [Artist]?
    var categories: [Category]?
    var artwork: artworktemp?
    var artwork2: SavedArtWork?
    var artwork3: LikeArtWork?
    var source: Int?
    
    private var managedObjectContext: NSManagedObjectContext
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        check()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deleteButton.layer.cornerRadius = 5
        self.car.layer.cornerRadius = self.car.frame.height / 2
        self.bike.layer.cornerRadius = self.car.frame.height / 2
        self.walk.layer.cornerRadius = self.car.frame.height / 2
        self.backbutton.layer.cornerRadius = self.backbutton.frame.height / 2
        self.view.bringSubviewToFront(backbutton)
        self.publictransit.layer.cornerRadius = self.car.frame.height / 2
        myMapView.delegate = self
        let camera = GMSCameraPosition.camera(withLatitude: artwork!.ArtWork_latitude, longitude: artwork!.ArtWork_longtitude, zoom: 15.0)
        myMapView.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: artwork!.ArtWork_latitude, longitude: artwork!.ArtWork_longtitude)
        marker.map = myMapView
        myMapView.selectedMarker = marker
        myMapView.settings.scrollGestures = false
        myMapView.settings.zoomGestures = false
        myMapView.settings.tiltGestures = false
        myMapView.settings.rotateGestures = false
        if artwork!.ArtWork_description == "0"{
            self.profileimg.image = UIImage(named: "404-permalink.png")
        }else{
            let split = artwork!.ArtWork_description.components(separatedBy: ";")
            self.profileimg.pin_setImage(from: URL(string: split[1]))
        }
        getArtist()
        for item in categories!{
            if item.category_id == artwork!.Category_id{
                categorylabel.text = item.category_name!
                break
            }
        }
        if Int(artwork!.ArtWork_date) == 0{
            datelabel.text = "Unknown"
        }else{
            datelabel.text = "\(Int(artwork!.ArtWork_date))"
        }
        structurelabel.text = artwork!.ArtWork_structure
        addresslabel.text = artwork!.ArtWork_address
        namelabel.text = artwork!.ArtWork_name
        locationManger.distanceFilter = 100
        checkLocationServices()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.opengoogle))
        self.myMapView.addGestureRecognizer(gesture)
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(self.review))
        self.profileimg.isUserInteractionEnabled = true
        self.profileimg.addGestureRecognizer(gesture2)
        // Do any additional setup after loading the view.
    }
    @objc func review(){
        self.performSegue(withIdentifier: "review2", sender: self)
    }
    
    @objc func opengoogle(){
        let resultAlertController = UIAlertController(title: "Warning", message: nil, preferredStyle: .alert)
        
        resultAlertController.addAction(UIAlertAction(title: "Yes", style: .default) {_ in
            UIApplication.shared.open(URL(string: "http://www.google.com/maps/search/?api=1&query=\(self.artwork!.ArtWork_latitude),\(self.artwork!.ArtWork_longtitude)")!, options: [:], completionHandler: nil)
        })
        resultAlertController.addAction(UIAlertAction(title: "No", style: .default) {_ in
            resultAlertController.dismiss(animated: true, completion: nil)
        })
        resultAlertController.message = "Do you want to leave this APP and go to Google Map?"
        present(resultAlertController,animated: true,completion: nil)
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
    
    func getArtist(){
        let fetchRequest2 = NSFetchRequest<NSManagedObject>(entityName: "Artist")
        do{
            artists = try managedObjectContext.fetch(fetchRequest2) as! [Artist]
            for item in artists!{
                if Int(artwork!.Artist_id) == Int(item.artist_id){
                    artistLabel.text = item.artist_name
                    break
                }
            }
        }catch{
            fatalError("Fail to load CoreData")
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? review2ViewController{
            destination.img = self.profileimg.image!
        }
        
    }
 

}
