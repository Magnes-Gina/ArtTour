//
//  ArtWorkViewController.swift
//  ArtTour
//
//  Created by yikeren on 27/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import CoreData

class ArtWorkViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate{

    var artwork: artworktemp?
    
    var saveds = [SavedArtWork]()
    var likes = [LikeArtWork]()
    let locationManger = CLLocationManager()
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBOutlet weak var favouriteButton: UIButton!
    
    @IBAction func favouriteAction(_ sender: Any) {
        if !liked{
            //save
            let newartwork = NSEntityDescription.insertNewObject(forEntityName: "LikeArtWork", into: self.managedObjectContext) as! LikeArtWork
            newartwork.artwork_id = Int16(artwork!.ArtWork_id)
            newartwork.artwork_name = artwork?.ArtWork_name
            newartwork.artwork_address = artwork?.ArtWork_address
            newartwork.artwork_structure = artwork?.ArtWork_structure
            newartwork.artwork_description = artwork?.ArtWork_description
            newartwork.artwork_latitude = artwork!.ArtWork_latitude
            newartwork.artwork_longtitude = artwork!.ArtWork_longtitude
            newartwork.artist_id = Int16(artwork!.Artist_id)
            newartwork.category_id = Int16(artwork!.Category_id)
            newartwork.artwork_date = Int16(artwork!.ArtWork_date)
            //print(item.ArtWork_id)
            do{
                try self.managedObjectContext.save()
                liked = true
                favouriteButton.isSelected = true
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LikeArtWork")
                likes = try managedObjectContext.fetch(fetchRequest) as! [LikeArtWork]
                CBToast.showToastAction(message: "Saved to favourite!")
            }catch{
                fatalError("Fail to save CoreData")
            }
        }else{
            
            for item in likes{
                if artwork?.ArtWork_id == Int(item.artwork_id){
                    print("want to delete")
                    managedObjectContext.delete(item)
                    do{
                        try self.managedObjectContext.save()
                        liked = false
                        favouriteButton.isSelected = false
                        CBToast.showToastAction(message: "Remove from favourite!")
                    }catch{
                        fatalError("Fail to save CoreData")
                    }
                    break
                }
            }
        }
    }
    
    
    @IBOutlet weak var myMapView: GMSMapView!
    
    
    @IBOutlet weak var car: UIButton!
    @IBOutlet weak var bike: UIButton!
    @IBOutlet weak var publictransport: UIButton!
    
    @IBAction func publictransit(_ sender: Any) {
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
            displayMessage("Our location request has been denied", "Location")
            break
        case .restricted:
            displayMessage("Our location request has been Restricted", "Restricted Alert")
            break
        @unknown default:
            break
        }
    }
    
    
    @IBAction func bikeaction(_ sender: Any) {
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
            displayMessage("Our location request has been denied", "Location")
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
                UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(self.artwork!.ArtWork_latitude),\(self.artwork!.ArtWork_longtitude)&travelmode=walking")!, options: [:], completionHandler: nil)
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
            displayMessage("Our location request has been denied", "Location")
            break
        case .restricted:
            displayMessage("Our location request has been Restricted", "Restricted Alert")
            break
        @unknown default:
            break
        }
    }
    
    
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
            displayMessage("Our location request has been denied", "Location")
            break
        case .restricted:
            displayMessage("Our location request has been Restricted", "Restricted Alert")
            break
        @unknown default:
            break
        }
    }
    
    @IBOutlet weak var walk: UIButton!
    @IBAction func moreAction(_ sender: Any) {
        if artwork!.ArtWork_description == "0"{
            displayMessage("This ArtWork Doesn't have more information", "Sorry")
        }else{
            let newstr = artwork!.ArtWork_description
            let split = newstr.components(separatedBy: ";")
            UIApplication.shared.open(URL(string: "\(split[0])")!, options: [:], completionHandler: nil)
        }
    }
    
    func loaddata(){

        namelabel.text = artwork!.ArtWork_name
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Category")
        do{
            let temp = try managedObjectContext.fetch(fetchRequest) as! [Category]
            for item in temp{
                if artwork!.Category_id == Int(item.category_id){
                    categoryLabel.text = item.category_name
                    break
                }
            }
        }catch{
            fatalError("Fail to load CoreData")
        }
        
        addressLabel.text = artwork!.ArtWork_address
        let fetchRequest2 = NSFetchRequest<NSManagedObject>(entityName: "Artist")
        do{
            let temp2 = try managedObjectContext.fetch(fetchRequest2) as! [Artist]
            for item in temp2{
                if artwork!.Artist_id == Int(item.artist_id){
                    artistLabel.text = item.artist_name
                    break
                }
            }
        }catch{
            fatalError("Fail to load CoreData")
        }
        
        yearlabel.text = "\(artwork!.ArtWork_date)"
        if artwork!.ArtWork_date == 0{
            yearlabel.text = "Unkown"
        }
        structureLabel.text = artwork!.ArtWork_structure
    }
    
    @IBOutlet weak var profile: UIImageView!
    
    @IBOutlet weak var namelabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    
    @IBOutlet weak var yearlabel: UILabel!
    
    @IBOutlet weak var structureLabel: UILabel!
    
    var saved = false
    var liked = false
    @IBOutlet weak var savedButton: UIButton!
    
    
    @IBAction func savedAction(_ sender: UIButton) {
        if !saved{
            //save
            let newartwork = NSEntityDescription.insertNewObject(forEntityName: "SavedArtWork", into: self.managedObjectContext) as! SavedArtWork
            newartwork.artwork_id = Int16(artwork!.ArtWork_id)
            print("find saved!\(artwork!.ArtWork_id)")
            newartwork.artwork_name = artwork?.ArtWork_name
            newartwork.artwork_address = artwork?.ArtWork_address
            newartwork.artwork_structure = artwork?.ArtWork_structure
            newartwork.artwork_description = artwork?.ArtWork_description
            newartwork.artwork_latitude = artwork!.ArtWork_latitude
            newartwork.artwork_longtitude = artwork!.ArtWork_longtitude
            newartwork.artist_id = Int16(artwork!.Artist_id)
            newartwork.category_id = Int16(artwork!.Category_id)
            newartwork.artwork_date = Int16(artwork!.ArtWork_date)
            //print(item.ArtWork_id)
            do{
                try self.managedObjectContext.save()
                saved = true
                savedButton.isSelected = true
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedArtWork")
                saveds = try managedObjectContext.fetch(fetchRequest) as! [SavedArtWork]
                CBToast.showToastAction(message: "Savd to visited")
            }catch{
                fatalError("Fail to save CoreData")
            }
        }else{
            
            for item in saveds{
                if artwork?.ArtWork_id == Int(item.artwork_id){
                    print("want to delete")
                    managedObjectContext.delete(item)
                    do{
                        try self.managedObjectContext.save()
                        saved = false
                        savedButton.isSelected = false
                        CBToast.showToastAction(message: "Remove from visited")
                    }catch{
                        fatalError("Fail to save CoreData")
                    }
                    break
                }
            }
        }
    
    }
    
    @IBAction func backbutton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private var managedObjectContext: NSManagedObjectContext
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        check()
        check2()
    }
    
    func check(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedArtWork")
        do{
            saveds = try managedObjectContext.fetch(fetchRequest) as! [SavedArtWork]
            for item in saveds{
                if artwork!.ArtWork_id == Int(item.artwork_id){
                    saved = true
                    savedButton.isSelected = true
                    print("find saved!\(artwork!.ArtWork_id) and \(Int(item.artwork_id))")
                    break
                }
            }
        }catch{
            fatalError("Fail to load CoreData")
        }
    }
    
    func check2(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LikeArtWork")
        do{
            likes = try managedObjectContext.fetch(fetchRequest) as! [LikeArtWork]
            for item in likes{
                if artwork!.ArtWork_id == Int(item.artwork_id){
                    liked = true
                    favouriteButton.isSelected = true
                    print("find saved!\(artwork!.ArtWork_id) and \(Int(item.artwork_id))")
                    break
                }
            }
        }catch{
            fatalError("Fail to load CoreData")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //check()
        
        loaddata()
        savedButton.layer.cornerRadius = 5
        backButton.layer.cornerRadius = backButton.frame.height / 2
        car.layer.cornerRadius = car.frame.height / 2
        bike.layer.cornerRadius = car.frame.height / 2
        walk.layer.cornerRadius = car.frame.height / 2
        publictransport.layer.cornerRadius = car.frame.height / 2
        self.myMapView.delegate = self
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
            self.profile.image = UIImage(named: "404-permalink.png")
        }else{
            let newstr = artwork!.ArtWork_description
            let split = newstr.components(separatedBy: ";")
            print(split[1])
            self.profile.pin_setImage(from: URL(string: split[1]))
        }
        self.view.bringSubviewToFront(backButton)
        locationManger.distanceFilter = 100
        checkLocationServices()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.opengoogle))
        self.myMapView.addGestureRecognizer(gesture)
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(self.imgreview))
        self.profile.isUserInteractionEnabled = true
        self.profile.addGestureRecognizer(gesture2)
        // Do any additional setup after loading the view.
    }
    
    @objc func imgreview(){
        print("succeesfull click")
        self.performSegue(withIdentifier: "imgreview", sender: self)
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
            displayMessage("Our location request has been denied", "Location")
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  let destination = segue.destination as? artworkimageViewController{
            destination.img = self.profile.image!
        }
    }
 

}
