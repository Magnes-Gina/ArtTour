//
//  reviewlandmarkdetailViewController.swift
//  ArtTour
//
//  Created by yikeren on 29/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView
import CoreData
import SwiftyJSON

class reviewlandmarkdetailViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    
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
            self.view.sendSubviewToBack(visualeffect)
        }
    }

    @IBOutlet weak var youtubeView: WKYTPlayerView!
    
    @IBOutlet weak var namelabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deletefromlist(_ sender: Any) {
        if source! == 0{
            managedObjectContext.delete(landmark2!)
            do{
                try managedObjectContext.save()
                self.navigationController?.popViewController(animated: true)
            }catch{
                fatalError("can not delete")
            }
        }else{
            managedObjectContext.delete(landmark3!)
            do{
                try managedObjectContext.save()
                self.navigationController?.popViewController(animated: true)
            }catch{
                fatalError("can not delete")
            }
        }
        
    }
    
    @IBOutlet var subView: UIView!
    
    @IBAction func down(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.subView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.subView.alpha = 0
        }){(success:Bool) in
            self.subView.removeFromSuperview()
        }
    }
    
    @IBOutlet weak var downButton: UIButton!
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var backbutton: UIButton!
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    @IBOutlet weak var linklabel: UITextView!
    
    @IBOutlet weak var myMapView: GMSMapView!
    
    
    @IBOutlet weak var carButton: UIButton!
    
    
    @IBOutlet weak var walkButton: UIButton!
    
    
    @IBOutlet weak var bikeButton: UIButton!
    
    @IBOutlet weak var visualeffect: UIVisualEffectView!
    
    @IBOutlet weak var publicButton: UIButton!
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func videoaction(_ sender: Any) {
        self.view.addSubview(subView)
        subView.center = self.view.center
        subView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        subView.alpha = 0
        UIView.animate(withDuration: 0.5){
            self.subView.alpha = 1
            self.subView.transform = CGAffineTransform.identity
        }
    }
    
    
    @IBAction func car(_ sender: Any) {
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
            displayMessage("Our location request has been dined", "Denied Alert")
            break
        case .restricted:
            displayMessage("Our location request has been Restricted", "Restricted Alert")
            break
        @unknown default:
            break
        }
    }
    
    @IBAction func walk(_ sender: Any) {
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
            displayMessage("Our location request has been dined", "Denied Alert")
            break
        case .restricted:
            displayMessage("Our location request has been Restricted", "Restricted Alert")
            break
        @unknown default:
            break
        }
    }
    
    @IBAction func bike(_ sender: Any) {
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
            displayMessage("Our location request has been dined", "Denied Alert")
            break
        case .restricted:
            displayMessage("Our location request has been Restricted", "Restricted Alert")
            break
        @unknown default:
            break
        }
    }
    
    @IBAction func publictransit(_ sender: Any) {
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
            displayMessage("Our location request has been dined", "Denied Alert")
            break
        case .restricted:
            displayMessage("Our location request has been Restricted", "Restricted Alert")
            break
        @unknown default:
            break
        }
    }
    
    
    @IBAction func readmore(_ sender: Any) {
        self.performSegue(withIdentifier: "wikireview", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination  = segue.destination as? reviewikiViewController{
            destination.str = self.descriptionLabel.text
        }
    }
    
    var landmark:Landmark?
    var landmark2:SavedLandmark?
    var landmark3: LikeLandmark?
    var categorys: [Category]?
    var source: Int?;
    let locationManger = CLLocationManager()
    private var managedObjectContext: NSManagedObjectContext
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        namelabel.text = landmark?.Landmark_name
        for item in categorys!{
            if Int(item.category_id) == landmark?.Category_id {
                categoryLabel.text = item.category_name!
                break
            }
        }
        let splits = landmark!.video.components(separatedBy: ";")
        
        youtubeView.load(withVideoId: splits[0])
        self.deleteButton.layer.cornerRadius = 5
        self.linklabel.text = splits[1]
        self.linklabel.isEditable = false
        self.linklabel.isScrollEnabled = false
        self.view.bringSubviewToFront(backbutton)
        self.backbutton.layer.cornerRadius = self.backbutton.frame.height / 2
        myMapView.delegate = self
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
        carButton.layer.cornerRadius = carButton.frame.height / 2
        bikeButton.layer.cornerRadius = carButton.frame.height / 2
        walkButton.layer.cornerRadius = carButton.frame.height / 2
        publicButton.layer.cornerRadius = carButton.frame.height / 2
        getData()
        getData2()
        locationManger.distanceFilter = 100
        checkLocationServices()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.opengoogle))
        self.myMapView.addGestureRecognizer(gesture)
        // Do any additional setup after loading the view.
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
            displayMessage("Our location request has been dined", "Denied Alert")
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
        do {
            let saved = try managedObjectContext.fetch(fetchRequest) as! [SavedLandmark]
            var boolflag = true
            for item in saved{
                if Int(landmark!.Landmark_id) == Int(item.landmark_id){
                    boolflag = false
                    break
                }
            }
            if boolflag{
                self.navigationController?.popViewController(animated: true)
                CBToast.showToastAction(message: "This landmark is deleted ")
            }
        }
        catch {
            fatalError("Fail to load list CoreData")
        }
    }
    
    func check2(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LikeLandmark")
        do {
            let saved = try managedObjectContext.fetch(fetchRequest) as! [LikeLandmark]
            var boolflag = true
            for item in saved{
                if Int(landmark!.Landmark_id) == Int(item.landmark_id){
                    boolflag = false
                    break
                }
            }
            if boolflag{
                self.navigationController?.popViewController(animated: true)
                CBToast.showToastAction(message: "This landmark is deleted ")
            }
        }
        catch {
            fatalError("Fail to load list CoreData")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
        if source == 0{
            check()
        }else{
            check2()
        }
        
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
                var json2 = try JSON(data: data)
                if json2["query"]["pages"]["-1"] == nil{
                    //print(self.json2!["query"]["pages"][0])
                    let jsontemp = json2["query"]["pages"]
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
                        self.img = self.landmark!.Landmark_name
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
                var json = try JSON(data: data)
                if json["query"]["pages"]["-1"] == nil{
                    //print(self.json2!["query"]["pages"][0])
                    let jsontemp = json["query"]["pages"]
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
