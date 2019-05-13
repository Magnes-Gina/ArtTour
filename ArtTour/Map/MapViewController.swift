//
//  MapViewController.swift
//  ArtTour
//
//  Created by yikeren on 2/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import UserNotifications
import CoreData

struct Landmark: Decodable {
    let Landmark_id: Int
    let Landmark_name: String
    let Landmark_latitude: Double
    let Landmark_longtitude: Double
    let Category_id: Int
    let video: String
}

class POIItem: NSObject,GMUClusterItem{
    var position: CLLocationCoordinate2D
    var name: String!
    var title: String!
    var snippet: String!
    var category: Int!
    
    init(position: CLLocationCoordinate2D,name: String,title:String,snippet:String,category: Int) {
        self.position = position
        self.name = name
        self.title = title
        self.snippet = snippet
        self.category = category
    }
}

class MapViewController: UIViewController,GMSMapViewDelegate,GMUClusterManagerDelegate,CLLocationManagerDelegate,GMUClusterRendererDelegate {
    let semaphore = DispatchSemaphore(value: 0)
    final let url = URL(string: "https://k2r7nrgvl1.execute-api.ap-southeast-2.amazonaws.com/iteration1/landmark")
    var ispop = false
    var landmarks = [Landmark]()
    var landmarks2 = [Landmark2]()
    var artworks = [ArtWork]()
    var artworktemps = [artworktemp]()
    var activealert: UIAlertController?
    var likelandmarks = [Landmark]()
    var likelandmarks2 = [SavedLandmark]()
    var likeartworks = [SavedArtWork]()
    var likeartworktemps = [artworktemp]()
    var selectedm:GMSMarker?
    var geos : [CLCircularRegion] = []
    var makers: [GMSMarker] = []
    var nowlandmark = CLCircularRegion(center: CLLocationCoordinate2DMake(-37.5,110), radius: 70, identifier: "test")
    let store = UserDefaults.standard
    var selectlandmark: Landmark?
    var selectArtWork: artworktemp?
    private var managedObjectContext: NSManagedObjectContext
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    @IBOutlet weak var backgroundView2: UIView!
    
    @IBOutlet var instructionView: UIView!
    
    @IBOutlet weak var gotButton: UIButton!
    
    @IBAction func gotit(_ sender: Any) {
        animatedOut2()
        
        self.button2.isEnabled = true
        self.button3.isEnabled = true
        self.collectionButton.isEnabled = true
        self.testview.settings.scrollGestures = true
        self.testview.settings.zoomGestures = true
        self.testview.settings.tiltGestures = true
        self.testview.settings.rotateGestures = true
    }
    
    func insreuctionin(){
        self.view.addSubview(instructionView)
        self.button2.isEnabled = false
        self.button3.isEnabled = false
        self.collectionButton.isEnabled = false
        self.testview.settings.scrollGestures = false
        self.testview.settings.zoomGestures = false
        self.testview.settings.tiltGestures = false
        self.testview.settings.rotateGestures = false
        instructionView.center = self.view.center
        instructionView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        instructionView.alpha = 0
        UIView.animate(withDuration: 0.5){
            self.instructionView.alpha = 1
            self.instructionView.transform = CGAffineTransform.identity
        }
    }
    
    
    func animatedOut2(){
        UIView.animate(withDuration: 0.4, animations: {
            self.instructionView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.instructionView.alpha = 0
        }) {(sucess: Bool) in
            self.instructionView.removeFromSuperview()
        }
    }
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var resultaroundLabel: UILabel!
    
    @IBOutlet weak var applaybutton: UIButton!
    
    
    @IBOutlet weak var selectAllButton: UIButton!
    
    @IBAction func visitedButton(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        }else{
            buskerButton.isSelected = false
            notVisitedButton.isSelected = false
            sender.isSelected = true
        }
    }
    
    @IBOutlet weak var visited: UIButton!
    
    
    
    @IBAction func notvisitedAction(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        }else{
            buskerButton.isSelected = false
            visited.isSelected = false
            sender.isSelected = true
        }
    }
    
    
    @IBOutlet weak var notVisitedButton: UIButton!
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBAction func collectionAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "progressSegue", sender: self)
    }

    @IBOutlet var choiceView: UIView!
    @IBAction func downButton(_ sender: Any) {
        
        animatedOut()
    }
    
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var collectionButton: UIButton!
    
    var gallerybool = false
    var memorialbool = false
    var publicbuildingbool = false
    var scilpturebool = false
    var othersbool = false
    var allbuskerbool = false
    var visitebool = false
    var notvisitbool = false
    
    @IBOutlet weak var buskerButton: UIButton!
    @IBOutlet weak var othersbutton: UIButton!
    @IBOutlet weak var publicbuildingButton: UIButton!
    @IBOutlet weak var memorialButton: UIButton!
    @IBOutlet weak var gallerybutton: UIButton!
    @IBOutlet weak var sculptureButton: UIButton!
    
    
    @IBAction func sculptureaction(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        }else{
            buskerButton.isSelected = false
            sender.isSelected = true
        }
    }
    
    
    @IBAction func galleryaction(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        }else{
            buskerButton.isSelected = false
            sender.isSelected = true
        }
    }
    
    
    @IBAction func memorialaction(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        }else{
            buskerButton.isSelected = false
            sender.isSelected = true
        }
    }
    
    
    @IBAction func publicbuildingaction(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        }else{
            buskerButton.isSelected = false
            sender.isSelected = true
        }
    }

    
    
    @IBAction func othersaction(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        }else{
            buskerButton.isSelected = false
            sender.isSelected = true
        }
    }

    @IBAction func busker(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        }else{
            othersbutton.isSelected = false
            gallerybutton.isSelected = false
            notVisitedButton.isSelected = false
            visited.isSelected = false
            memorialButton.isSelected = false
            publicbuildingButton.isSelected = false
            sculptureButton.isSelected = false
            sender.isSelected = true
        }
    }

    @IBAction func confirmaction(_ sender: UIButton) {
        if !gallerybutton.isSelected && !memorialButton.isSelected && !publicbuildingButton.isSelected && !sculptureButton.isSelected && !othersbutton.isSelected && !buskerButton.isSelected {
            //animatedOut()
            displayMessage("At least choose one Category", "Warning")
        }else{
            let camera = GMSCameraPosition.camera(withLatitude: -37.813624, longitude: 144.964453, zoom: 11.0)
            self.testview.camera = camera
            //
            if  buskerButton.isSelected{
                allbuskerbool = true
                othersbool = false
                scilpturebool = false
                publicbuildingbool = false
                memorialbool = false
                gallerybool = false
                visitebool = false
                notvisitbool = false
                addbusker()
            }else{
                allbuskerbool = false
                geos = []
                testview.clear()
                clusterManager.clearItems()
                if !visited.isSelected && !notVisitedButton.isSelected{
                    visitebool = false
                    notvisitbool = false
                    if gallerybutton.isSelected{
                        gallerybool = true
                        for landmark in self.landmarks{
                            if landmark.Category_id == 1{
                                self.generatePOIItems(accessibilityLabel: "\(landmark.Landmark_id)", position: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude),title: landmark.Landmark_name,snippet: "Click here for more information!",category: landmark.Category_id)
                                let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude), radius: 70, identifier: landmark.Landmark_name)
                                geoLocation.notifyOnEntry = true
                                geos.append(geoLocation)
                            }
                        }
                    }else{
                        gallerybool = false
                    }
                    if othersbutton.isSelected{
                        othersbool = true
                        for item in self.artworktemps{
                            if item.Category_id == 9{
                                self.generatePOIItems(accessibilityLabel: "\(item.ArtWork_id)", position: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude),title: item.ArtWork_name,snippet: "Click here for more information!",category: item.Category_id)
                                let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude), radius: 70, identifier: item.ArtWork_name)
                                geoLocation.notifyOnEntry = true
                                geos.append(geoLocation)
                            }
                        }
                    }else{
                        othersbool = false
                    }
                    if memorialButton.isSelected{
                        memorialbool = true
                        for item in self.artworktemps{
                            if item.Category_id == 6{
                                self.generatePOIItems(accessibilityLabel: "\(item.ArtWork_id)", position: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude),title: item.ArtWork_name,snippet: "Click here for more information!",category: item.Category_id)
                                let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude), radius: 70, identifier: item.ArtWork_name)
                                geoLocation.notifyOnEntry = true
                                geos.append(geoLocation)
                            }
                        }
                    }else{
                        memorialbool = false
                    }
                    if publicbuildingButton.isSelected{
                        publicbuildingbool = true
                        for landmark in self.landmarks{
                            if landmark.Category_id == 7{
                                self.generatePOIItems(accessibilityLabel: "\(landmark.Landmark_id)", position: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude),title: landmark.Landmark_name,snippet: "Click here for more information!",category: landmark.Category_id)
                                let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude), radius: 70, identifier: landmark.Landmark_name)
                                geoLocation.notifyOnEntry = true
                                geos.append(geoLocation)
                            }
                        }
                    }else{
                        publicbuildingbool = false
                    }
                    if sculptureButton.isSelected{
                        scilpturebool = true
                        for item in self.artworktemps{
                            if item.Category_id == 8{
                                self.generatePOIItems(accessibilityLabel: "\(item.ArtWork_id)", position: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude),title: item.ArtWork_name,snippet: "Click here for more information!",category: item.Category_id)
                                let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude), radius: 70, identifier: item.ArtWork_name)
                                geoLocation.notifyOnEntry = true
                                geos.append(geoLocation)
                            }
                        }
                    }else{
                        scilpturebool = false
                    }
                }else{
                    getData3()
                    getData4()
                    allbuskerbool = false
                    if visited.isSelected{
                        visitebool = true
                        notvisitbool = false
                        if gallerybutton.isSelected{
                            gallerybool = true
                            for landmark in self.likelandmarks{
                                if landmark.Category_id == 1{
                                    self.generatePOIItems(accessibilityLabel: "\(landmark.Landmark_id)", position: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude),title: landmark.Landmark_name,snippet: "Click here for more information!",category: landmark.Category_id)
                                    let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude), radius: 70, identifier: landmark.Landmark_name)
                                    geoLocation.notifyOnEntry = true
                                    geos.append(geoLocation)
                                }
                            }
                        }else{
                            gallerybool = false
                        }
                        if othersbutton.isSelected{
                            othersbool = true
                            for item in self.likeartworktemps{
                                if item.Category_id == 9{
                                    self.generatePOIItems(accessibilityLabel: "\(item.ArtWork_id)", position: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude),title: item.ArtWork_name,snippet: "Click here for more information!",category: item.Category_id)
                                    let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude), radius: 70, identifier: item.ArtWork_name)
                                    geoLocation.notifyOnEntry = true
                                    geos.append(geoLocation)
                                }
                            }
                        }else{
                            othersbool = false
                        }
                        if memorialButton.isSelected{
                            memorialbool = true
                            for item in self.likeartworktemps{
                                if item.Category_id == 6{
                                    self.generatePOIItems(accessibilityLabel: "\(item.ArtWork_id)", position: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude),title: item.ArtWork_name,snippet: "Click here for more information!",category: item.Category_id)
                                    let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude), radius: 70, identifier: item.ArtWork_name)
                                    geoLocation.notifyOnEntry = true
                                    geos.append(geoLocation)
                                }
                            }
                        }else{
                            memorialbool = false
                        }
                        if publicbuildingButton.isSelected{
                            publicbuildingbool = true
                            for landmark in self.likelandmarks{
                                if landmark.Category_id == 7{
                                    self.generatePOIItems(accessibilityLabel: "\(landmark.Landmark_id)", position: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude),title: landmark.Landmark_name,snippet: "Click here for more information!",category: landmark.Category_id)
                                    let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude), radius: 70, identifier: landmark.Landmark_name)
                                    geoLocation.notifyOnEntry = true
                                    geos.append(geoLocation)
                                }
                            }
                        }else{
                            publicbuildingbool = false
                        }
                        if sculptureButton.isSelected{
                            scilpturebool = true
                            for item in self.likeartworktemps{
                                if item.Category_id == 8{
                                    self.generatePOIItems(accessibilityLabel: "\(item.ArtWork_id)", position: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude),title: item.ArtWork_name,snippet: "Click here for more information!",category: item.Category_id)
                                    let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude), radius: 70, identifier: item.ArtWork_name)
                                    geoLocation.notifyOnEntry = true
                                    geos.append(geoLocation)
                                }
                            }
                        }else{
                            scilpturebool = false
                        }
                    }
                    if notVisitedButton.isSelected{
                        notvisitbool = true
                        visitebool = false
                        if gallerybutton.isSelected{
                            gallerybool = true
                            for landmark in self.landmarks{
                                if landmark.Category_id == 1{
                                    if !likelandmarks.contains(where: {$0.Landmark_id == landmark.Landmark_id}){
                                        self.generatePOIItems(accessibilityLabel: "\(landmark.Landmark_id)", position: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude),title: landmark.Landmark_name,snippet: "Click here for more information!",category: landmark.Category_id)
                                        let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude), radius: 70, identifier: landmark.Landmark_name)
                                        geoLocation.notifyOnEntry = true
                                        geos.append(geoLocation)
                                    }
                                }
                            }
                        }else{
                            gallerybool = false
                        }
                        if othersbutton.isSelected{
                            othersbool = true
                            for item in self.artworktemps{
                                if item.Category_id == 9{
                                    if !likeartworktemps.contains(where: {$0.ArtWork_name == item.ArtWork_name}){
                                        self.generatePOIItems(accessibilityLabel: "\(item.ArtWork_id)", position: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude),title: item.ArtWork_name,snippet: "Click here for more information!",category: item.Category_id)
                                        let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude), radius: 70, identifier: item.ArtWork_name)
                                        geoLocation.notifyOnEntry = true
                                        geos.append(geoLocation)
                                    }
                                }
                            }
                        }else{
                            othersbool = false
                        }
                        if memorialButton.isSelected{
                            memorialbool = true
                            for item in self.artworktemps{
                                if item.Category_id == 6{
                                    if !likeartworktemps.contains(where: {$0.ArtWork_name == item.ArtWork_name}){
                                        self.generatePOIItems(accessibilityLabel: "\(item.ArtWork_id)", position: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude),title: item.ArtWork_name,snippet: "Click here for more information!",category: item.Category_id)
                                        let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude), radius: 70, identifier: item.ArtWork_name)
                                        geoLocation.notifyOnEntry = true
                                        geos.append(geoLocation)
                                    }
                                }
                            }
                        }else{
                            memorialbool = false
                        }
                        if publicbuildingButton.isSelected{
                            publicbuildingbool = true
                            for landmark in self.landmarks{
                                if landmark.Category_id == 7{
                                    if !likelandmarks.contains(where: {$0.Landmark_id == landmark.Landmark_id}){
                                        self.generatePOIItems(accessibilityLabel: "\(landmark.Landmark_id)", position: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude),title: landmark.Landmark_name,snippet: "Click here for more information!",category: landmark.Category_id)
                                        let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude), radius: 70, identifier: landmark.Landmark_name)
                                        geoLocation.notifyOnEntry = true
                                        geos.append(geoLocation)
                                    }
                                }
                            }
                        }else{
                            publicbuildingbool = false
                        }
                        if sculptureButton.isSelected{
                            scilpturebool = true
                            for item in self.artworktemps{
                                if item.Category_id == 8{
                                    if !likeartworktemps.contains(where: {$0.ArtWork_name == item.ArtWork_name}){
                                        self.generatePOIItems(accessibilityLabel: "\(item.ArtWork_id)", position: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude),title: item.ArtWork_name,snippet: "Click here for more information!",category: item.Category_id)
                                        let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude), radius: 70, identifier: item.ArtWork_name)
                                        geoLocation.notifyOnEntry = true
                                        geos.append(geoLocation)
                                    }
                                }
                            }
                        }else{
                            scilpturebool = false
                        }
                    }
                }
                self.clusterManager.cluster()
            }
            checkaround()
            animatedOut()
        }
    }
    
    
    @IBAction func allaction(_ sender: UIButton) {
        let camera = GMSCameraPosition.camera(withLatitude: -37.813624, longitude: 144.964453, zoom: 11.0)
        self.testview.camera = camera
        geos = []
        testview.clear()
        clusterManager.clearItems()
        for landmark in self.landmarks{
            self.generatePOIItems(accessibilityLabel: "\(landmark.Landmark_id)", position: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude),title: landmark.Landmark_name,snippet: "Click here for more information!",category: landmark.Category_id)
            let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude), radius: 70, identifier: landmark.Landmark_name)
            geoLocation.notifyOnEntry = true
            geos.append(geoLocation)
            
        }
        for item in self.artworktemps{
            self.generatePOIItems(accessibilityLabel: "\(item.ArtWork_name)", position: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude),title: item.ArtWork_name,snippet: "Click here for more information!",category: item.Category_id)
            let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude), radius: 70, identifier: item.ArtWork_name)
            geoLocation.notifyOnEntry = true
            geos.append(geoLocation)
            
        }
        self.clusterManager.cluster()
        othersbool = true
        gallerybool = true
        memorialbool = true
        publicbuildingbool = true
        scilpturebool = true
        allbuskerbool = false
        visitebool = false
        notvisitbool = false
        checkaround()
        animatedOut()
    }
    
    
    
    func addbusker(){
        clusterManager.clearItems()
        geos = [];
        nowlandmark = CLCircularRegion(center: CLLocationCoordinate2DMake(-37.5,110), radius: 70, identifier: "test")
        testview.clear()
        makers = []
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2DMake(-37.818617, 144.965049)
        marker1.title = "Busker Area 1"
        marker1.snippet = "Filinders Street Station Tunnels"
        marker1.icon = UIImage(named: "singer.png")
        marker1.map = testview
        makers.append(marker1)
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2DMake(-37.819004, 144.968362)
        marker2.title = "Busker Area 2"
        marker2.snippet = "SouthBank"
        marker2.icon = UIImage(named: "singer.png")
        marker2.map = testview
        makers.append(marker2)
        let marker3 = GMSMarker()
        marker3.position = CLLocationCoordinate2DMake(-37.810033, 144.964106)
        marker3.title = "Busker Area 3"
        marker3.snippet = "Swanston Street"
        marker3.icon = UIImage(named: "singer.png")
        marker3.map = testview
        makers.append(marker3)
        let marker4 = GMSMarker()
        marker4.position = CLLocationCoordinate2DMake(-37.817751, 144.969056)
        marker4.title = "Busker Area 4"
        marker4.snippet = "Federation Square"
        marker4.icon = UIImage(named: "singer.png")
        marker4.map = testview
        makers.append(marker4)
        let marker5 = GMSMarker()
        marker5.position = CLLocationCoordinate2DMake(-37.854104, 144.992959)
        marker5.title = "Busker Area 5"
        marker5.snippet = "Chapel Street"
        marker5.icon = UIImage(named: "singer.png")
        marker5.map = testview
        makers.append(marker5)
        let marker6 = GMSMarker()
        marker6.position = CLLocationCoordinate2DMake(-37.774289, 144.962256)
        marker6.title = "Busker Area 6"
        marker6.snippet = "Buckley Square, Burnswick"
        marker6.icon = UIImage(named: "singer.png")
        marker6.map = testview
        makers.append(marker6)
        let marker7 = GMSMarker()
        marker7.position = CLLocationCoordinate2DMake(-37.807368, 144.956785)
        marker7.title = "Busker Area 7"
        marker7.snippet = "Victoria Markets"
        marker7.icon = UIImage(named: "singer.png")
        marker7.map = testview
        makers.append(marker7)
        let marker8 = GMSMarker()
        marker8.position = CLLocationCoordinate2DMake(-37.731904, 144.963527)
        marker8.title = "Busker Area 8"
        marker8.snippet = "Batman Markets"
        marker8.icon = UIImage(named: "singer.png")
        marker8.map = testview
        makers.append(marker8)
        let marker9 = GMSMarker()
        marker9.position = CLLocationCoordinate2DMake(-37.812946, 144.963658)
        marker9.title = "Busker Area 9"
        marker9.snippet = "Bourke Street Mall"
        marker9.icon = UIImage(named: "singer.png")
        marker9.map = testview
        makers.append(marker9)
        let marker10 = GMSMarker()
        marker10.position = CLLocationCoordinate2DMake(-37.809983, 144.962800)
        marker10.title = "Busker Area 10"
        marker10.snippet = "Melbourne Central"
        marker10.icon = UIImage(named: "singer.png")
        marker10.map = testview
        makers.append(marker10)
        let marker11 = GMSMarker()
        marker11.position = CLLocationCoordinate2DMake(-37.832169, 144.956573)
        marker11.title = "Busker Area 11"
        marker11.snippet = "South Melbourne Markets"
        marker11.icon = UIImage(named: "singer.png")
        marker11.map = testview
        makers.append(marker11)
    }
    
    

    
    
    @IBAction func center(_ sender: Any) {
        centerViewOnUserLocation()
        CBToast.showToastAction(message: "All landmarks and artworks are in the city area")
    }
    
    
    @IBAction func refresh(_ sender: Any) {
        animatedIn()
    }
    @IBOutlet weak var testview: GMSMapView!
    var clusterManager: GMUClusterManager!
    let locationManger = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sendSubviewToBack(testview)
        self.backgroundView.layer.cornerRadius = 10
        self.backgroundView.alpha = 1
        backgroundView.layer.shadowColor = UIColor.gray.cgColor
        backgroundView.layer.shadowOpacity = 0.3
        backgroundView.layer.shadowRadius = 5.0
        backgroundView.layer.masksToBounds = false
        
        self.backgroundView2.layer.cornerRadius = 10
        self.backgroundView2.alpha = 1
        backgroundView2.layer.shadowColor = UIColor.gray.cgColor
        backgroundView2.layer.shadowOpacity = 0.3
        backgroundView2.layer.shadowRadius = 5.0
        backgroundView2.layer.masksToBounds = false
        self.choiceView.layer.cornerRadius = 30
        
        
        self.instructionView.layer.cornerRadius = 10
        
        self.instructionView.layer.shadowColor = UIColor.lightGray.cgColor
        self.instructionView.layer.shadowOpacity = 0.8
        self.instructionView.layer.shadowRadius = 5.0
        self.gotButton.layer.cornerRadius = 10
        insreuctionin()
        
        
        self.applaybutton.layer.cornerRadius = 10
        self.selectAllButton.layer.cornerRadius = 10
        self.visited.layer.cornerRadius = 10
        self.visited.layer.borderWidth = 1
        self.visited.layer.borderColor = UIColor.black.cgColor
        self.notVisitedButton.layer.cornerRadius = 10
        self.notVisitedButton.layer.borderWidth = 1
        self.notVisitedButton.layer.borderColor = UIColor.black.cgColor
        self.button2.layer.cornerRadius = (self.button2.frame.height / 2)
        self.button3.layer.cornerRadius = (self.button3.frame.height / 2)
        self.collectionButton.layer.cornerRadius = (self.collectionButton.frame.height / 2)
        locationManger.requestAlwaysAuthorization()
        //locationManger.startMonitoringSignificantLocationChanges()
        locationManger.distanceFilter = 100
        checkLocationServices()
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: testview, clusterIconGenerator: iconGenerator)
        renderer.delegate = self
        clusterManager = GMUClusterManager(map: testview, algorithm: algorithm, renderer: renderer)
        clusterManager.cluster()
        clusterManager.setDelegate(self, mapDelegate: self)
        getData()
        getData2()
        getData3()
        getData4()
        addingmaker3()
        choiceView.layer.cornerRadius = 5
        //checkaround()
    }
    
    func animatedIn(){
        if othersbool{
            othersbutton.isSelected = true
        }
        if publicbuildingbool{
            publicbuildingButton.isSelected = true
        }
        if allbuskerbool{
            buskerButton.isSelected = true
        }
        if gallerybool{
            gallerybutton.isSelected = true
        }
        if memorialbool{
            memorialButton.isSelected = true
        }
        if scilpturebool{
            sculptureButton.isSelected = true
        }
        if visitebool{
            visited.isSelected = true
        }
        if notvisitbool{
            notVisitedButton.isSelected = true
        }
        ispop = true
        let window = UIApplication.shared.keyWindow
        let height: CGFloat = 445
        let y = (window?.frame.height)! - height - 83
        let newframe2 = CGRect(x: 0, y:(window?.frame.height)! , width: (window?.frame.width)!, height: height)
        let newframe = CGRect(x: 0, y: y, width: (window?.frame.width)!, height: height)
        choiceView.frame = newframe2

        choiceView.alpha = 0
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.choiceView.alpha = 1
            self.choiceView.frame = newframe
            self.view.addSubview(self.choiceView)
        }, completion: nil)
    }
    
    func animatedOut() {
        ispop = false
        gallerybutton.isSelected = false
        memorialButton.isSelected = false
        sculptureButton.isSelected = false
        buskerButton.isSelected = false
        publicbuildingButton.isSelected = false
        othersbutton.isSelected = false
        visited.isSelected = false
        notVisitedButton.isSelected = false
        let window = UIApplication.shared.keyWindow
        let height: CGFloat = 445
        let newframe2 = CGRect(x: 0, y:(window?.frame.height)! , width: (window?.frame.width)!, height: height)
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.choiceView.alpha = 0
            self.choiceView.frame = newframe2
        }){sucess in
            self.choiceView.removeFromSuperview()
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let item2 = marker.userData as? POIItem{
            if item2.category == 1 || item2.category == 7 {
                for item in landmarks{
                    if marker.title == item.Landmark_name{
                        selectlandmark = item
                    }
                }
                self.performSegue(withIdentifier: "mapDetail", sender: self)
            }else{
                for item in artworktemps{
                    if marker.title == item.ArtWork_name{
                        
                        selectArtWork = item
                    }
                }
                self.performSegue(withIdentifier: "artworkDetail", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? mapDetailViewController{
            destination.landmark = selectlandmark
        }
        if let destination = segue.destination as? ArtWorkViewController{
            destination.artwork = selectArtWork
        }
    }
    
    
    
    func addingmaker()
    {
        var index = 0
        geos = []
        for landmark in self.landmarks{
            self.generatePOIItems(accessibilityLabel: "Item\(index)", position: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude),title: landmark.Landmark_name,snippet: "Click here for more information!",category: landmark.Category_id)
            let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude), radius: 70, identifier: landmark.Landmark_name)
            geoLocation.notifyOnEntry = true
            geos.append(geoLocation)
            
            index += 1
        }
        self.clusterManager.cluster()
    }
    
    func addingmaker3(){
        var index = 0
        geos = []
        for landmark in self.landmarks{
            self.generatePOIItems(accessibilityLabel: "Item\(index)", position: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude),title: landmark.Landmark_name,snippet: "Click here for more information!",category: landmark.Category_id)
            let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude), radius: 70, identifier: landmark.Landmark_name)
            geoLocation.notifyOnEntry = true
            geos.append(geoLocation)
            
            index += 1
        }
        for item in self.artworktemps{
            self.generatePOIItems(accessibilityLabel: "Item\(index)", position: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude),title: item.ArtWork_name,snippet: "click here for more information!",category: item.Category_id)
            let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude), radius: 70, identifier: item.ArtWork_name)
            geoLocation.notifyOnEntry = true
            geos.append(geoLocation)
            
            index += 1
        }
        self.clusterManager.cluster()
    }
    
    func addingmaker2()
    {
        var index = 0
        geos = []
        for item in self.artworktemps{
            self.generatePOIItems(accessibilityLabel: "Item\(index)", position: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude),title: item.ArtWork_name,snippet: "click here for more information!",category: item.Category_id)
            let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude), radius: 70, identifier: item.ArtWork_name)
            geoLocation.notifyOnEntry = true
            geos.append(geoLocation)
            
            index += 1
        }
        self.clusterManager.cluster()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        evaluateClosetRegions()
        print(locationManger.location)
        checkaround()
    }
    
   
    func checkaround(){
        if allbuskerbool{
            resultLabel.text = "11 results found!"
            var count = 0
            for marker in makers{
                let distance = locationManger.location!.distance(from: CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude))
                if distance <= 1000{
                    count = count + 1
                }
            }
            resultaroundLabel.text = "\(count) results around you within 1KM"
        }else{
            resultLabel.text = "\(geos.count) results found!"
            var count = 0
            for geo in geos{
                print(locationManger.location)
                let distance = locationManger.location!.distance(from: CLLocation(latitude: geo.center.latitude, longitude: geo.center.longitude))
                if distance <= 1000{
                    count = count + 1
                }
            }
            resultaroundLabel.text = "\(count) results around you within 1KM"
        }
    }
    
    func evaluateClosetRegions(){
        var allDistance : [Double] = []
        if geos.count != 0 {
            for region in geos{
                let circularRegion = region
                let distance = locationManger.location!.distance(from: CLLocation(latitude: circularRegion.center.latitude, longitude: circularRegion.center.longitude))
                allDistance.append(distance)
            }
            let distanceOfEachRegionToCurrentLocation = zip(geos, allDistance)
            let twentyNearbyRegions = distanceOfEachRegionToCurrentLocation
                .sorted{ tuple1, tuple2 in return tuple1.1 < tuple2.1 }
                .prefix(1)
            
            for region in twentyNearbyRegions{
                let temp: CLCircularRegion = region.0
                if temp.contains(locationManger.location!.coordinate){
                    if temp.identifier != nowlandmark.identifier{
                        if !UserDefaults.standard.bool(forKey: "notify"){
                            if ispop {
                                animatedOut()
                            }
                            displayMessage("You are near the \(temp.identifier)", "Landmark Notification ")
                            notificationCreated(message: "You are near the \(temp.identifier)", title: "Location Notification")
                            nowlandmark = temp
                        }
                        
                    }
                }else{
                    print(UserDefaults.standard.bool(forKey: "notify"))
                    print("Not in any region!")
                }
                break
            }
        }
        
    }
   /* func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("-------------------------------------")
        displayMessage("You are near the \(region.identifier)", "Landmark Notification ")
    }*/
    
    
    
    /*func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print(region.identifier)
    }*/
    
    func generatePOIItems(accessibilityLabel: String,position: CLLocationCoordinate2D,title:String,snippet:String,category: Int){
        let item = POIItem(position: position, name: accessibilityLabel,title: title,snippet: snippet,category: category)
        
        self.clusterManager.add(item)
        
    }
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        let newCamra = GMSCameraPosition.camera(withTarget: cluster.position, zoom: self.testview.camera.zoom + 2)
        self.testview.animate(to: newCamra)
        return true
    }
    

    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let item = marker.userData as? POIItem {
            let newCamra = GMSCameraPosition.camera(withTarget: item.position, zoom: self.testview.camera.zoom)
            self.testview.animate(to: newCamra)
            marker.title = item.title
            marker.snippet = item.snippet
            mapView.selectedMarker = marker
           
            
        }else if let item = marker.userData as? GMUCluster{
          
        }else{
            mapView.selectedMarker = marker
            
        }
        return true
    }
    
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        if let temp = (marker.userData as? POIItem){
            if temp.category! == 9{
                marker.iconView = UIImageView(image: UIImage(named: "shrine-remembrance.png"))
            }
            if temp.category! == 8{
                marker.iconView = UIImageView(image: UIImage(named: "smallsculpture.png"))
            }
            if temp.category! == 7{
                marker.iconView = UIImageView(image: UIImage(named: "smallpublicbuilding.png"))
            }
            if temp.category! == 6{
                marker.iconView = UIImageView(image: UIImage(named: "smallmemorial.png"))
            }
            if temp.category! == 5{
                marker.iconView = UIImageView(image: UIImage(named: "smallindigenous.png"))
            }
            if temp.category! == 4{
                marker.iconView = UIImageView(image: UIImage(named: "smallfountain.png"))
            }
            if temp.category! == 3{
                marker.iconView = UIImageView(image: UIImage(named: "smallbell.png"))
            }
            if temp.category! == 2{
                marker.iconView = UIImageView(image: UIImage(named: "smallbridge.png"))
            }
            if temp.category! == 1{
                marker.iconView = UIImageView(image: UIImage(named: "smallgallery.png"))
            }
        
            
        }
    }
    
    func addmarker(title: String,snippet: String,lat:Double,lon:Double){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        marker.title = title
        marker.snippet = snippet
        marker.map = testview
        testview.delegate = self
    }
    
    func setupLocationManager() {
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManger.allowsBackgroundLocationUpdates = true
        locationManger.pausesLocationUpdatesAutomatically = false
    }
    
    func getData(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Landmark2")
        do {
            landmarks2 = try managedObjectContext.fetch(fetchRequest) as! [Landmark2]
            for item in landmarks2{
                let temp = Landmark(Landmark_id: Int(item.landmark_id), Landmark_name: item.landmark_name!, Landmark_latitude: item.landmark_latitude, Landmark_longtitude: item.landmark_longtitude, Category_id: Int(item.category_id), video: item.video!)
                landmarks.append(temp)
            }
        }
        catch {
            fatalError("Fail to load list CoreData")
        }
    }
    
    func getData2(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ArtWork")
        do {
            artworks = try managedObjectContext.fetch(fetchRequest) as! [ArtWork]
            for item in artworks{
                let temp = artworktemp(ArtWork_id: Int(item.artwork_id), ArtWork_name: item.artwork_name!, ArtWork_address: item.artwork_address!, ArtWork_structure: item.artwork_structure!, ArtWork_description: item.artwork_description!, ArtWork_date: Int(item.artwork_date), ArtWork_latitude: item.artwork_latitude, ArtWork_longtitude: item.artwork_longtitude, Artist_id: Int(item.artist_id), Category_id: Int(item.category_id))
                artworktemps.append(temp)
            }
        }
        catch {
            fatalError("Fail to load list CoreData5555")
        }
    }
    
    func getData3(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedLandmark")
        do {
            likelandmarks = []
            likelandmarks2 = try managedObjectContext.fetch(fetchRequest) as! [SavedLandmark]
            for item in likelandmarks2{
                let temp = Landmark(Landmark_id: Int(item.landmark_id), Landmark_name: item.landmark_name!, Landmark_latitude: item.landmark_latitude, Landmark_longtitude: item.landmark_longtitude, Category_id: Int(item.category_id), video: item.video!)
                likelandmarks.append(temp)
            }
        }
        catch {
            fatalError("Fail to load list CoreData")
        }
    }
    
    func getData4(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedArtWork")
        do {
            likeartworktemps = []
            likeartworks = try managedObjectContext.fetch(fetchRequest) as! [SavedArtWork]
            for item in likeartworks{
                let temp = artworktemp(ArtWork_id: Int(item.artist_id), ArtWork_name: item.artwork_name!, ArtWork_address: item.artwork_address!, ArtWork_structure: item.artwork_structure!, ArtWork_description: item.artwork_description!, ArtWork_date: Int(item.artwork_date), ArtWork_latitude: item.artwork_latitude, ArtWork_longtitude: item.artwork_longtitude, Artist_id: Int(item.artist_id), Category_id: Int(item.category_id))
                likeartworktemps.append(temp)
            }
        }
        catch {
            fatalError("Fail to load list CoreData5555")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManger.location?.coordinate {
            let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 13.0)
            self.testview.animate(to: camera)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            print(5555555555555)
            setupLocationManager()
            checkLocationAuthorization()
        }else{
            //show alert that user dont have location service
        }
    }
    
    func displayMessage(_ message: String,_ title: String) {
        if activealert != nil{
            activealert?.dismiss(animated: false, completion: nil)
        }
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:
            UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        activealert = alertController
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            testview.isMyLocationEnabled = true
            let camera = GMSCameraPosition.camera(withLatitude: -37.813624, longitude: 144.964453, zoom: 11.0)
            self.testview.animate(to: camera)
            locationManger.startUpdatingLocation()
            break
        case .authorizedWhenInUse:
            testview.isMyLocationEnabled = true
            let camera = GMSCameraPosition.camera(withLatitude: -37.813624, longitude: 144.964453, zoom: 11.0)
            
            self.testview.animate(to: camera)
            locationManger.startUpdatingLocation()
            break
        case .notDetermined:
            locationManger.requestAlwaysAuthorization()
            break
        case .denied:
            if ispop {
                animatedOut()
            }
            displayMessage("Our location request has been dined", "Denied Alert")
            break
        case .restricted:
            if ispop {
                animatedOut()
            }
            displayMessage("Our location request has been Restricted", "Restricted Alert")
            break
        @unknown default:
            break
        }
    }
 
    func notificationCreated(message: String,title: String){
        let content = UNMutableNotificationContent()
        content.body =  message
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest.init(identifier: title,content: content,trigger: nil)
        let center = UNUserNotificationCenter.current()
        center.add(request){ (error) in
            
        }
    }


}


