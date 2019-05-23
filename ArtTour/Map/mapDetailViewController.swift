//
//  mapDetailViewController.swift
//  ArtTour
//
//  Created by yikeren on 16/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView
import CoreData
import SwiftyJSON

class mapDetailViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate{

    
    @IBOutlet weak var visualeffect: UIVisualEffectView!
    var landmark: Landmark?
    var saveds = [SavedLandmark]()
    var likes = [LikeLandmark]()
    var json: JSON?
    var json2: JSON?
    var saved = false
    var like = false
    let locationManger = CLLocationManager()
    let semphore = DispatchSemaphore(value: 0)
    var des : String = ""{
        didSet{
            switch des {
            case "Bunjilaka Aboriginal Cultural Centre":
                self.descriptionLabel.text = "First Peoples was co-curated by the Yulendj Group of Elders, community representatives from across Victoria, and Museum Victoria staff. Yulendj is a Kulin word for knowledge, which describes the deep cultural and historical knowledge that the Yulendj group brought to the exhibition. We thank them for generously sharing their stories and artworks."
                break
            case "Webb Bridge":
                self.descriptionLabel.text = "A competition-winning design for a new pedestrian/cycle bridge over the Yarra river, as part of a public art project, in Melbourne's Docklands area. The brief called for the re-use of the remaining sections of the Webb Dock Rail Bridge, in order to link the Docklands on the north-side to the new residential developments on the south-side. The bridge comprises two distinct sections: the 145m long existing structure and a new curved 80m long ramped link."
                break
            case "The Melbourne Athenaeum Library":
                self.descriptionLabel.text = "Throughout its life, the Melbourne Athenaeum Library has provided Melburnians with access to a hand-picked collection of books and reading material, and made a significant contribution to the cultural fabric of Melbourne over its 175-year history. Today it offers the latest in books, magazines, newspapers, DVDs, audio books and eBooks in a welcoming and relaxing atmosphere."
                break
            case "Sinclair's Cottage":
                self.descriptionLabel.text = "Sinclair's cottage is located on the main Elm avenue in Fitzroy Gardens. A rare example of an Italian Romanesque style as adopted for a gardener's cottage. \nA polychrome brick cottage designed by Melbourne architect Francis Maloney White. In 1866, Melbourne City Council accepted the tender of Thomas Crowson to build the cottage at a cost of 520 pounds.\n A single story house with a gabled entrance porch with overhanging eaves. The walls are of alternating cream and red brickwork, with cream as the dominant colour. Two notable stripped chimneys which dominate the roof are built in alternating red and cream brickwork courses.\nThe stables at the back repeat the fine details of the main house although in a much simpler fashion.\nSinclair's cottage survives virtually intact in now mature Fitzroy Gardens. The essential ornamentation and original polychrome character have been preserved."
                break
            case "Fox Classic Car Collection":
                self.descriptionLabel.text = "The Fox Classic Car Collection contains over 50 of the world’s most rare and prestigious vehicles.  Collected over a 30-year period by trucking businessman Lindsay Fox it contains vehicles previously owned by Ringo Starr, Bing Crosby and Bob Jane to name a few."
                break
            default:
                self.descriptionLabel.text = des
            
                break
            }
            
        }
    }
    var img : String = ""{
        didSet{
            print(img)
            switch img {
            case "Bunjilaka Aboriginal Cultural Centre":
                self.profileImage.image = UIImage(named: "bacc.jpg")
                break
            case "Webb Bridge":
                self.profileImage.image = UIImage(named: "wb.jpg")
                break
            case "The Melbourne Athenaeum Library":
                self.profileImage.image = UIImage(named: "tmal.jpg")
                break
            case "Sinclair's Cottage":
                self.profileImage.image = UIImage(named: "sc.jpg")
                break
            case "Fox Classic Car Collection":
                self.profileImage.image = UIImage(named: "fccc.jpg")
                break
            case "404":
                self.profileImage.image = UIImage(named: "404-permalink.png")
            default:
                self.profileImage.pin_setImage(from: URL(string: img))
                break
            }
            self.visualeffect.effect = nil
            self.visualeffect.removeFromSuperview()
        }
    }
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var savedButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func saved(_ sender: UIButton)
    {
        if !saved{
            //save
            let newlandmark = NSEntityDescription.insertNewObject(forEntityName: "SavedLandmark", into: self.managedObjectContext) as! SavedLandmark
            newlandmark.landmark_id = Int16(landmark!.Landmark_id)
            newlandmark.landmark_name = landmark!.Landmark_name
            newlandmark.landmark_latitude = landmark!.Landmark_latitude
            newlandmark.landmark_longtitude = landmark!.Landmark_longtitude
            newlandmark.category_id = Int16(landmark!.Category_id)
            newlandmark.video = landmark!.video
            do{
                try self.managedObjectContext.save()
                saved = true
                sender.isSelected = true
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedLandmark")
                saveds = try managedObjectContext.fetch(fetchRequest) as! [SavedLandmark]
                CBToast.showToastAction(message: "Saved to visted!")
            }catch{
                fatalError("Fail to save CoreData")
            }
        }else{
            
            for item in saveds{
                if landmark?.Landmark_id == Int(item.landmark_id){
                    print("want to delete")
                    managedObjectContext.delete(item)
                    do{
                        try self.managedObjectContext.save()
                        saved = false
                        savedButton.isSelected = false
                        CBToast.showToastAction(message: "Remove form visted!")
                    }catch{
                        fatalError("Fail to save CoreData")
                    }
                    break
                }
            }
        }
    
    }
    
    @IBOutlet weak var youtube: WKYTPlayerView!
    @IBOutlet weak var landmark_name: UILabel!
    @IBOutlet var subview: UIView!
    
    @IBAction func closeButton(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.subview.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.subview.alpha = 0
        }){(success:Bool) in
            self.subview.removeFromSuperview()
        }
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var favouriteButton: UIButton!
    
    @IBAction func favouriteActuin(_ sender: UIButton) {
        if !like{
            //save
            let newlandmark = NSEntityDescription.insertNewObject(forEntityName: "LikeLandmark", into: self.managedObjectContext) as! LikeLandmark
            newlandmark.landmark_id = Int16(landmark!.Landmark_id)
            newlandmark.landmark_name = landmark!.Landmark_name
            newlandmark.landmark_latitude = landmark!.Landmark_latitude
            newlandmark.landmark_longtitude = landmark!.Landmark_longtitude
            newlandmark.category_id = Int16(landmark!.Category_id)
            newlandmark.video = landmark!.video
            do{
                try self.managedObjectContext.save()
                like = true
                sender.isSelected = true
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LikeLandmark")
                likes = try managedObjectContext.fetch(fetchRequest) as! [LikeLandmark]
                CBToast.showToastAction(message: "Saved to favourite!")
            }catch{
                fatalError("Fail to save CoreData")
            }
        }else{
            
            for item in likes{
                if landmark?.Landmark_id == Int(item.landmark_id){
                    print("want to delete")
                    managedObjectContext.delete(item)
                    do{
                        try self.managedObjectContext.save()
                        like = false
                        favouriteButton.isSelected = false
                        CBToast.showToastAction(message: "Remove form favourite!")
                    }catch{
                        fatalError("Fail to save CoreData")
                    }
                    break
                }
            }
        }
    }
    
    
    @IBAction func ReadMore(_ sender: Any) {
        self.performSegue(withIdentifier: "wikimore", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? wikimoreViewController{
            destination.str = self.descriptionLabel.text!
        }
        if let destination  = segue.destination as? landmarkreimageViewController{
            destination.img = self.profileImage.image!
        }
    }
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var myMapView: GMSMapView!
    @IBOutlet weak var linklabel: UITextView!
    
    @IBAction func carbutton(_ sender: Any) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            let resultAlertController = UIAlertController(title: "Warning", message: nil, preferredStyle: .alert)
            
            resultAlertController.addAction(UIAlertAction(title: "Yes", style: .default) {_ in
                let locationtemp = self.locationManger.location?.coordinate
                UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(self.landmark!.Landmark_latitude),\(self.landmark!.Landmark_longtitude)&travelmode=driving")!, options: [:], completionHandler: nil)
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
                UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(self.landmark!.Landmark_latitude),\(self.landmark!.Landmark_longtitude)&travelmode=driving")!, options: [:], completionHandler: nil)
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
    
    
    @IBAction func walkbutton(_ sender: Any) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            let resultAlertController = UIAlertController(title: "Warning", message: nil, preferredStyle: .alert)
            
            resultAlertController.addAction(UIAlertAction(title: "Yes", style: .default) {_ in
                let locationtemp = self.locationManger.location?.coordinate
                UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(self.landmark!.Landmark_latitude),\(self.landmark!.Landmark_longtitude)&travelmode=walking")!, options: [:], completionHandler: nil)
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
                UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(self.landmark!.Landmark_latitude),\(self.landmark!.Landmark_longtitude)&travelmode=walking")!, options: [:], completionHandler: nil)
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
    
    
    @IBAction func bikeButton(_ sender: Any) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            let resultAlertController = UIAlertController(title: "Warning", message: nil, preferredStyle: .alert)
            
            resultAlertController.addAction(UIAlertAction(title: "Yes", style: .default) {_ in
                let locationtemp = self.locationManger.location?.coordinate
                UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(self.landmark!.Landmark_latitude),\(self.landmark!.Landmark_longtitude)&travelmode=bicycling")!, options: [:], completionHandler: nil)
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
                UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(self.landmark!.Landmark_latitude),\(self.landmark!.Landmark_longtitude)&travelmode=bicycling")!, options: [:], completionHandler: nil)
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
    
    
    @IBAction func publictransitButton(_ sender: Any) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            let resultAlertController = UIAlertController(title: "Warning", message: nil, preferredStyle: .alert)
            
            resultAlertController.addAction(UIAlertAction(title: "Yes", style: .default) {_ in
                let locationtemp = self.locationManger.location?.coordinate
                UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(self.landmark!.Landmark_latitude),\(self.landmark!.Landmark_longtitude)&travelmode=transit")!, options: [:], completionHandler: nil)
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
                UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=\(locationtemp!.latitude),\(locationtemp!.longitude)&destination=\(self.landmark!.Landmark_latitude),\(self.landmark!.Landmark_longtitude)&travelmode=transit")!, options: [:], completionHandler: nil)
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
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var car: UIButton!
    
    @IBOutlet weak var walk: UIButton!
    
    @IBOutlet weak var bike: UIButton!
    
    @IBOutlet weak var publictransit: UIButton!
    @IBAction func videoaction(_ sender: Any) {
        self.view.addSubview(subview)
        subview.center = self.view.center
        subview.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        subview.alpha = 0
        UIView.animate(withDuration: 0.5){
            self.subview.alpha = 1
            self.subview.transform = CGAffineTransform.identity
        }
    }
    
    private var managedObjectContext: NSManagedObjectContext
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let splits = landmark!.video.components(separatedBy: ";")
        youtube.load(withVideoId: splits[0])
        linklabel.text = splits[1]
        linklabel.isScrollEnabled = false
        linklabel.isEditable = false
        subview.layer.cornerRadius = 10
        car.layer.cornerRadius = car.frame.height / 2
        bike.layer.cornerRadius = car.frame.height / 2
        walk.layer.cornerRadius = car.frame.height / 2
        publictransit.layer.cornerRadius = car.frame.height / 2
        landmark_name.text = landmark!.Landmark_name
        getCategroy()
        self.backButton.layer.cornerRadius = self.backButton.frame.height / 2
        let camera = GMSCameraPosition.camera(withLatitude: landmark!.Landmark_latitude, longitude: landmark!.Landmark_longtitude, zoom: 15.0)
        myMapView.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: landmark!.Landmark_latitude, longitude: landmark!.Landmark_longtitude)
        marker.map = myMapView
        myMapView.selectedMarker = marker
        myMapView.settings.scrollGestures = false
        myMapView.settings.zoomGestures = false
        myMapView.settings.tiltGestures = false
        myMapView.settings.rotateGestures = false
        self.view.bringSubviewToFront(backButton)
        getData2()
        getData()
        locationManger.distanceFilter = 100
        checkLocationServices()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.opengoogle))
        self.myMapView.addGestureRecognizer(gesture)
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(self.imgreview))
        self.profileImage.isUserInteractionEnabled = true
        self.profileImage.addGestureRecognizer(gesture2)
        //self.visualeffect.effect = nil
    }
    @objc func imgreview(){
        self.performSegue(withIdentifier: "landmarkimgzoom", sender: self)
    }
    
    
    
    @objc func opengoogle(){
        let resultAlertController = UIAlertController(title: "Warning", message: nil, preferredStyle: .alert)
        
        resultAlertController.addAction(UIAlertAction(title: "Yes", style: .default) {_ in
            UIApplication.shared.open(URL(string: "http://www.google.com/maps/search/?api=1&query=\(self.landmark!.Landmark_latitude),\(self.landmark!.Landmark_longtitude)")!, options: [:], completionHandler: nil)
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
    
    func check(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedLandmark")
        do{
            saveds = try managedObjectContext.fetch(fetchRequest) as! [SavedLandmark]
            for item in saveds{
                if landmark?.Landmark_id == Int(item.landmark_id){
                    saved = true
                    savedButton.isSelected = true
                    print("find saved!")
                    break
                }
            }
        }catch{
            fatalError("Fail to load CoreData")
        }
    }
    
    func check2(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LikeLandmark")
        do{
            likes = try managedObjectContext.fetch(fetchRequest) as! [LikeLandmark]
            for item in likes{
                if landmark?.Landmark_id == Int(item.landmark_id){
                    like = true
                    favouriteButton.isSelected = true
                    print("find saved!")
                    break
                }
            }
        }catch{
            fatalError("Fail to load CoreData")
        }
    }
    
    func getCategroy(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Category")
        do {
            let tempCat = try managedObjectContext.fetch(fetchRequest) as! [Category]
            for item in tempCat{
                if landmark!.Category_id == Int(item.category_id) {
                    categoryLabel.text = "Category: \(item.category_name!)"
                    break
                }
                
            }
        }
        catch {
            fatalError("Fail to load list CoreData")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //
        super.viewWillAppear(animated)
        check()
        check2()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //
        super.viewWillDisappear(animated)
    
    }
    
    func getData(){
        let stryrl = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=pageimages&piprop=original&titles=\(landmark!.Landmark_name)"
        let newstr = stryrl.replacingOccurrences(of: " ", with: "+")
        guard let downloadURL = URL(string: newstr) else {
            
            return
        }
        URLSession.shared.dataTask(with: downloadURL) { (data, urlResponse, error) in
            //CBToast.showToastAction(message: "Download Data!")
            guard let data = data, error == nil,urlResponse != nil else {
                print("wrong")
                return
            }
            do{
                self.json2 = try JSON(data: data)
                if self.json2!["query"]["pages"]["-1"] == nil{
                    //print(self.json2!["query"]["pages"][0])
                    let jsontemp = self.json2!["query"]["pages"]
                    for (_,subjson):(String,JSON) in jsontemp{
                        //print(subjson["extract"].string!)
                        DispatchQueue.main.async{
                            if subjson["original"]["source"] == nil{
                                self.img = "404"
                            }else{
                                self.img = subjson["original"]["source"].string!
                            }
                            
                        }
                    }
                    
                }else{
                    DispatchQueue.main.async{
                        self.img = "404"
                    }
                }
            }catch let error as NSError{
                print("error: \(error)")
            }
            }.resume()
    }
    
    func getData2(){
        let stryrl = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&titles=\(landmark!.Landmark_name)"
        let newstr = stryrl.replacingOccurrences(of: " ", with: "+")
        guard let downloadURL = URL(string: newstr) else {
            
            return
        }
        URLSession.shared.dataTask(with: downloadURL) { (data, urlResponse, error) in
            //CBToast.showToastAction(message: "Download Data!")
            guard let data = data, error == nil,urlResponse != nil else {
                print("wrong")
                return
            }
            do{
                self.json = try JSON(data: data)
                if self.json!["query"]["pages"]["-1"] == nil{
                    //print(self.json2!["query"]["pages"][0])
                    let jsontemp = self.json!["query"]["pages"]
                    for (_,subjson):(String,JSON) in jsontemp{
                        //print(subjson["extract"].string!)
                        DispatchQueue.main.async{
                            self.des = subjson["extract"].string!
                        }
                    }
                    
                }else{
                    DispatchQueue.main.async{
                        self.des = self.landmark!.Landmark_name
                    }
                }
            }catch let error as NSError{
                print("error: \(error)")
            }
            }.resume()
    }
    
    
    func displayMessage(_ message: String,_ title: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:
            UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
