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
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBAction func collectionAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "progressSegue", sender: self)
    }
    
    
    
    @IBOutlet var choiceView: UIView!
    @IBAction func downButton(_ sender: Any) {
        buskerButton.isSelected = false
        bellsButton.isSelected = false
        alllandmarkbutton.isSelected = false
        allartworkbutton.isSelected = false
        othersbutton.isSelected = false
        bridgebutton.isSelected = false
        gallerybutton.isSelected = false
        fountaionButton.isSelected = false
        indigenousButton.isSelected = false
        memorialButton.isSelected = false
        publicbuildingButton.isSelected = false
        sculptureButton.isSelected = false
        bellbool = false
        othersbool = false
        bridgebool = false
        gallerybool = false
        fountainbool = false
        indigenousbool = false
        memorialbool = false
        publicbuildingbool = false
        scilpturebool = false
        allbuskerbool = false
        alllandmarkbool = false
        allartworkbool = false
        animatedOut()
    }
    
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var collectionButton: UIButton!
    
    var gallerybool = false
    var bridgebool = false
    var bellbool = false
    var fountainbool = false
    var indigenousbool = false
    var memorialbool = false
    var publicbuildingbool = false
    var scilpturebool = false
    var othersbool = false
    var allartworkbool = false
    var alllandmarkbool = false
    var allbuskerbool = false
    
    @IBOutlet weak var buskerButton: UIButton!
    @IBOutlet weak var alllandmarkbutton: UIButton!
    @IBOutlet weak var allartworkbutton: UIButton!
    @IBOutlet weak var othersbutton: UIButton!
    @IBOutlet weak var bridgebutton: UIButton!
    @IBOutlet weak var publicbuildingButton: UIButton!
    @IBOutlet weak var memorialButton: UIButton!
    @IBOutlet weak var indigenousButton: UIButton!
    @IBOutlet weak var fountaionButton: UIButton!
    @IBOutlet weak var bellsButton: UIButton!
    @IBOutlet weak var gallerybutton: UIButton!
    @IBOutlet weak var sculptureButton: UIButton!
    
    
    @IBAction func sculptureaction(_ sender: UIButton) {
        if sender.isSelected{
            scilpturebool = false
            sender.isSelected = false
        }else{
            scilpturebool = true
            allbuskerbool = false
            alllandmarkbool = false
            allartworkbool = false
            buskerButton.isSelected = false
            alllandmarkbutton.isSelected = false
            allartworkbutton.isSelected = false
            sender.isSelected = true
        }
    }
    
    
    @IBAction func galleryaction(_ sender: UIButton) {
        if sender.isSelected{
            gallerybool = false
            sender.isSelected = false
        }else{
            gallerybool = true
            allbuskerbool = false
            alllandmarkbool = false
            allartworkbool = false
            buskerButton.isSelected = false
            alllandmarkbutton.isSelected = false
            allartworkbutton.isSelected = false
            sender.isSelected = true
        }
    }
    
    
    @IBAction func bellsaction(_ sender: UIButton) {
        if sender.isSelected{
            bellbool = false
            sender.isSelected = false
        }else{
            bellbool = true
            allbuskerbool = false
            alllandmarkbool = false
            allartworkbool = false
            buskerButton.isSelected = false
            alllandmarkbutton.isSelected = false
            allartworkbutton.isSelected = false
            sender.isSelected = true
        }
    }
    
    
    @IBAction func fountaionaction(_ sender: UIButton) {
        if sender.isSelected{
            fountainbool = false
            sender.isSelected = false
        }else{
            fountainbool = true
            allbuskerbool = false
            alllandmarkbool = false
            allartworkbool = false
            buskerButton.isSelected = false
            alllandmarkbutton.isSelected = false
            allartworkbutton.isSelected = false
            sender.isSelected = true
        }
    }
    
    
    @IBAction func indigenousaction(_ sender: UIButton) {
        if sender.isSelected{
            indigenousbool = false
            sender.isSelected = false
        }else{
            indigenousbool = true
            allbuskerbool = false
            alllandmarkbool = false
            allartworkbool = false
            buskerButton.isSelected = false
            alllandmarkbutton.isSelected = false
            allartworkbutton.isSelected = false
            sender.isSelected = true
        }
    }
    
    
    @IBAction func memorialaction(_ sender: UIButton) {
        if sender.isSelected{
            memorialbool = false
            sender.isSelected = false
        }else{
            memorialbool = true
            allbuskerbool = false
            alllandmarkbool = false
            allartworkbool = false
            buskerButton.isSelected = false
            alllandmarkbutton.isSelected = false
            allartworkbutton.isSelected = false
            sender.isSelected = true
        }
    }
    
    
    @IBAction func publicbuildingaction(_ sender: UIButton) {
        if sender.isSelected{
            publicbuildingbool = false
            sender.isSelected = false
        }else{
            publicbuildingbool = true
            allbuskerbool = false
            alllandmarkbool = false
            allartworkbool = false
            buskerButton.isSelected = false
            alllandmarkbutton.isSelected = false
            allartworkbutton.isSelected = false
            sender.isSelected = true
        }
    }
    
    
    @IBAction func bridgeaction(_ sender: UIButton) {
        if sender.isSelected{
            bridgebool = false
            sender.isSelected = false
        }else{
            bridgebool = true
            allbuskerbool = false
            alllandmarkbool = false
            allartworkbool = false
            buskerButton.isSelected = false
            alllandmarkbutton.isSelected = false
            allartworkbutton.isSelected = false
            sender.isSelected = true
        }
    }
    
    
    @IBAction func othersaction(_ sender: UIButton) {
        if sender.isSelected{
            othersbool = false
            sender.isSelected = false
        }else{
            othersbool = true
            allbuskerbool = false
            alllandmarkbool = false
            allartworkbool = false
            buskerButton.isSelected = false
            alllandmarkbutton.isSelected = false
            allartworkbutton.isSelected = false
            sender.isSelected = true
        }
    }
    
    
    @IBAction func allarworkaction(_ sender: UIButton) {
        if sender.isSelected{
            allartworkbool = false
            sender.isSelected = false
        }else{
            allartworkbool = true
            
            bellbool = false
            othersbool = false
            bridgebool = false
            gallerybool = false
            fountainbool = false
            indigenousbool = false
            memorialbool = false
            publicbuildingbool = false
            scilpturebool = false
            allbuskerbool = false
            alllandmarkbool = false
            
            alllandmarkbutton.isSelected = false
            buskerButton.isSelected = false
            bellsButton.isSelected = false
            othersbutton.isSelected = false
            bridgebutton.isSelected = false
            gallerybutton.isSelected = false
            fountaionButton.isSelected = false
            indigenousButton.isSelected = false
            memorialButton.isSelected = false
            publicbuildingButton.isSelected = false
            sculptureButton.isSelected = false
            sender.isSelected = true
        }
    }
    
    
    
    @IBAction func busker(_ sender: UIButton) {
        if sender.isSelected{
            allbuskerbool = false
            sender.isSelected = false
        }else{
            allbuskerbool = true
            
            bellbool = false
            othersbool = false
            bridgebool = false
            gallerybool = false
            fountainbool = false
            indigenousbool = false
            memorialbool = false
            publicbuildingbool = false
            scilpturebool = false
            alllandmarkbool = false
            allartworkbool = false
            
            alllandmarkbutton.isSelected = false
            allartworkbutton.isSelected = false
            bellsButton.isSelected = false
            othersbutton.isSelected = false
            bridgebutton.isSelected = false
            gallerybutton.isSelected = false
            fountaionButton.isSelected = false
            indigenousButton.isSelected = false
            memorialButton.isSelected = false
            publicbuildingButton.isSelected = false
            sculptureButton.isSelected = false
            sender.isSelected = true
        }
    }
    
    
    
    @IBAction func alllandmarkbutton(_ sender: UIButton) {
        if sender.isSelected{
            alllandmarkbool = false
            sender.isSelected = false
        }else{
            alllandmarkbool = true
            
            bellbool = false
            othersbool = false
            bridgebool = false
            gallerybool = false
            fountainbool = false
            indigenousbool = false
            memorialbool = false
            publicbuildingbool = false
            scilpturebool = false
            allbuskerbool = false
            allartworkbool = false
            
            buskerButton.isSelected = false
            allartworkbutton.isSelected = false
            bellsButton.isSelected = false
            othersbutton.isSelected = false
            bridgebutton.isSelected = false
            gallerybutton.isSelected = false
            fountaionButton.isSelected = false
            indigenousButton.isSelected = false
            memorialButton.isSelected = false
            publicbuildingButton.isSelected = false
            sculptureButton.isSelected = false
            sender.isSelected = true
        }
    }
    
    
    
    @IBAction func confirmaction(_ sender: UIButton) {
        if !gallerybool && !bridgebool && !bellbool && !fountainbool && !indigenousbool && !memorialbool && !publicbuildingbool && !scilpturebool && !othersbool && !allbuskerbool && !allartworkbool && !alllandmarkbool {
            //animatedOut()
            displayMessage("At least choose one filter", "Warning")
        }else{
            let camera = GMSCameraPosition.camera(withLatitude: -37.813624, longitude: 144.964453, zoom: 11.0)
            self.testview.camera = camera
            allartworkbutton.isSelected = false
            alllandmarkbutton.isSelected = false
            buskerButton.isSelected = false
            bellsButton.isSelected = false
            othersbutton.isSelected = false
            bridgebutton.isSelected = false
            gallerybutton.isSelected = false
            fountaionButton.isSelected = false
            indigenousButton.isSelected = false
            memorialButton.isSelected = false
            publicbuildingButton.isSelected = false
            sculptureButton.isSelected = false
            //
            if allbuskerbool || alllandmarkbool || allartworkbool {
                if allbuskerbool {
                    addbusker()
                }else if alllandmarkbool{
                    testview.clear()
                    clusterManager.clearItems()
                    addingmaker()
                }else{
                    testview.clear()
                    clusterManager.clearItems()
                    addingmaker2()
                }
            }else{
                geos = []
                testview.clear()
                clusterManager.clearItems()
                if gallerybool{
                    for landmark in self.landmarks{
                        if landmark.Category_id == 1{
                            self.generatePOIItems(accessibilityLabel: "\(landmark.Landmark_id)", position: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude),title: landmark.Landmark_name,snippet: "Click here for more information!",category: landmark.Category_id)
                            let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude), radius: 70, identifier: landmark.Landmark_name)
                            geoLocation.notifyOnEntry = true
                            geos.append(geoLocation)
                        }
                    }
                }
                if bridgebool{
                    for landmark in self.landmarks{
                        if landmark.Category_id == 2{
                            self.generatePOIItems(accessibilityLabel: "\(landmark.Landmark_id)", position: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude),title: landmark.Landmark_name,snippet: "Click here for more information!",category: landmark.Category_id)
                            let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude), radius: 70, identifier: landmark.Landmark_name)
                            geoLocation.notifyOnEntry = true
                            geos.append(geoLocation)
                        }
                    }
                }
                if othersbool{
                    for landmark in self.landmarks{
                        if landmark.Category_id == 9{
                            self.generatePOIItems(accessibilityLabel: "\(landmark.Landmark_id)", position: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude),title: landmark.Landmark_name,snippet: "Click here for more information!",category: landmark.Category_id)
                            let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(landmark.Landmark_latitude,landmark.Landmark_longtitude), radius: 70, identifier: landmark.Landmark_name)
                            geoLocation.notifyOnEntry = true
                            geos.append(geoLocation)
                        }
                    }
                }
                if bellbool{
                    for item in self.artworktemps{
                        if item.Category_id == 3{
                            self.generatePOIItems(accessibilityLabel: "\(item.ArtWork_id)", position: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude),title: item.ArtWork_name,snippet: "Click here for more information!",category: item.Category_id)
                            let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude), radius: 70, identifier: item.ArtWork_name)
                            geoLocation.notifyOnEntry = true
                            geos.append(geoLocation)
                        }
                    }
                }
                if fountainbool{
                    for item in self.artworktemps{
                        if item.Category_id == 4{
                            self.generatePOIItems(accessibilityLabel: "\(item.ArtWork_id)", position: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude),title: item.ArtWork_name,snippet: "Click here for more information!",category: item.Category_id)
                            let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude), radius: 70, identifier: item.ArtWork_name)
                            geoLocation.notifyOnEntry = true
                            geos.append(geoLocation)
                        }
                    }
                }
                if indigenousbool{
                    for item in self.artworktemps{
                        if item.Category_id == 5{
                            self.generatePOIItems(accessibilityLabel: "\(item.ArtWork_id)", position: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude),title: item.ArtWork_name,snippet: "Click here for more information!",category: item.Category_id)
                            let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude), radius: 70, identifier: item.ArtWork_name)
                            geoLocation.notifyOnEntry = true
                            geos.append(geoLocation)
                        }
                    }
                }
                if memorialbool{
                    for item in self.artworktemps{
                        if item.Category_id == 6{
                            self.generatePOIItems(accessibilityLabel: "\(item.ArtWork_id)", position: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude),title: item.ArtWork_name,snippet: "Click here for more information!",category: item.Category_id)
                            let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude), radius: 70, identifier: item.ArtWork_name)
                            geoLocation.notifyOnEntry = true
                            geos.append(geoLocation)
                        }
                    }
                }
                if publicbuildingbool{
                    for item in self.artworktemps{
                        if item.Category_id == 7{
                            self.generatePOIItems(accessibilityLabel: "\(item.ArtWork_id)", position: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude),title: item.ArtWork_name,snippet: "Click here for more information!",category: item.Category_id)
                            let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude), radius: 70, identifier: item.ArtWork_name)
                            geoLocation.notifyOnEntry = true
                            geos.append(geoLocation)
                        }
                    }
                }
                if scilpturebool{
                    for item in self.artworktemps{
                        if item.Category_id == 8{
                            self.generatePOIItems(accessibilityLabel: "\(item.ArtWork_id)", position: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude),title: item.ArtWork_name,snippet: "Click here for more information!",category: item.Category_id)
                            let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(item.ArtWork_latitude,item.ArtWork_longtitude), radius: 70, identifier: item.ArtWork_name)
                            geoLocation.notifyOnEntry = true
                            geos.append(geoLocation)
                        }
                    }
                }
                self.clusterManager.cluster()
            }
            //
            bellbool = false
            othersbool = false
            bridgebool = false
            gallerybool = false
            fountainbool = false
            indigenousbool = false
            memorialbool = false
            publicbuildingbool = false
            scilpturebool = false
            allbuskerbool = false
            alllandmarkbool = false
            allartworkbool = false
            animatedOut()
        }
    }
    
    
    @IBAction func allaction(_ sender: UIButton) {
        let camera = GMSCameraPosition.camera(withLatitude: -37.813624, longitude: 144.964453, zoom: 11.0)
        self.testview.camera = camera
        buskerButton.isSelected = false
        bellsButton.isSelected = false
        alllandmarkbutton.isSelected = false
        allartworkbutton.isSelected = false
        othersbutton.isSelected = false
        bridgebutton.isSelected = false
        gallerybutton.isSelected = false
        fountaionButton.isSelected = false
        indigenousButton.isSelected = false
        memorialButton.isSelected = false
        publicbuildingButton.isSelected = false
        sculptureButton.isSelected = false
        //
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
        
        //
        bellbool = false
        othersbool = false
        bridgebool = false
        gallerybool = false
        fountainbool = false
        indigenousbool = false
        memorialbool = false
        publicbuildingbool = false
        scilpturebool = false
        allbuskerbool = false
        alllandmarkbool = false
        allartworkbool = false
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
        marker11.title = "Busker Area 111"
        marker11.snippet = "South Melbourne Markets"
        marker11.icon = UIImage(named: "singer.png")
        marker11.map = testview
        makers.append(marker11)
    }
    
    
    @IBAction func reload(_ sender: Any) {
        testview.clear()
        clusterManager.clearItems()
        addingmaker()
    }
    
    
    @IBAction func center(_ sender: Any) {
        centerViewOnUserLocation()
        CBToast.showToastAction(message: "All landmarks and artworks are in the city area")
    }
    
    
    @IBAction func refresh(_ sender: Any) {
        animatedIn()
    }
    
    @IBOutlet weak var Settting: UIButton!
    @IBOutlet weak var testview: GMSMapView!
    var clusterManager: GMUClusterManager!
    let locationManger = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sendSubviewToBack(testview)
        self.backgroundView.layer.cornerRadius = 10
        self.backgroundView.alpha = 0.5
        self.choiceView.layer.cornerRadius = 30
        self.button2.layer.cornerRadius = (self.button2.frame.height / 3.14)
        self.button3.layer.cornerRadius = (self.button3.frame.height / 3.14)
        self.collectionButton.layer.cornerRadius = (self.collectionButton.frame.height / 3.14)
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
        //let newmark = store.object(forKey: "landmark")
        
        getData()
        getData2()
        addingmaker()
        choiceView.layer.cornerRadius = 5
        
    }
    
    func animatedIn(){
        //self.view.addSubview(choiceView)
        ispop = true
        let window = UIApplication.shared.keyWindow
        //window?.addSubview(choiceView)
        let height: CGFloat = 350
        let y = (window?.frame.height)! - height - 83
        let newframe2 = CGRect(x: 0, y:(window?.frame.height)! , width: (window?.frame.width)!, height: 350)
        let newframe = CGRect(x: 0, y: y, width: (window?.frame.width)!, height: 350)
        choiceView.frame = newframe2

        choiceView.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.choiceView.alpha = 1
            self.choiceView.frame = newframe
            self.view.addSubview(self.choiceView)
        }, completion: nil)
    }
    
    func animatedOut() {
        ispop = false
        let window = UIApplication.shared.keyWindow
        //window?.addSubview(choiceView)
        let height: CGFloat = 350
        let y = (window?.frame.height)! - height - 85
        let newframe2 = CGRect(x: 0, y:(window?.frame.height)! , width: (window?.frame.width)!, height: 350)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.choiceView.alpha = 0
            self.choiceView.frame = newframe2
            
        }){sucess in
            self.choiceView.removeFromSuperview()
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if let item2 = marker.userData as? POIItem{
            if item2.category == 1 || item2.category == 2 || item2.category == 9 {
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
    }
    
   
    //func locat
    
    func evaluateClosetRegions(){
        var allDistance : [Double] = []
        
        //Calulate distance of each region's center to currentLocation
        if geos.count != 0 {
            for region in geos{
                let circularRegion = region as! CLCircularRegion
                let distance = locationManger.location!.distance(from: CLLocation(latitude: circularRegion.center.latitude, longitude: circularRegion.center.longitude))
                allDistance.append(distance)
            }
            // a Array of Tuples
            
            let distanceOfEachRegionToCurrentLocation = zip(geos, allDistance)
            
            //sort and get 20 closest
            let twentyNearbyRegions = distanceOfEachRegionToCurrentLocation
                .sorted{ tuple1, tuple2 in return tuple1.1 < tuple2.1 }
                .prefix(1)
            
            for region in twentyNearbyRegions{
                let temp: CLCircularRegion = region.0
                if temp.contains(locationManger.location!.coordinate){
                    if temp.identifier != nowlandmark.identifier{
                        if ispop {
                            animatedOut()
                        }
                        displayMessage("You are near the \(temp.identifier)", "Landmark Notification ")
                        notificationCreated(message: "You are near the \(temp.identifier)", title: "Location Notification")
                        nowlandmark = temp
                    }
                }else{
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
        
        /*let update = GMSCameraUpdate.setCamera(newCamra)
        self.testview.moveCamera(update)*/
        self.testview.animate(to: newCamra)
        return true
    }
    
    /*func clusterManager(_ clusterManager: GMUClusterManager, didTap clusterItem: GMUClusterItem) -> Bool {
        let newCamra = GMSCameraPosition.camera(withTarget: clusterItem.position, zoom: 18.0)
        let update = GMSCameraUpdate.setCamera(newCamra)
        self.testview.moveCamera(update)
        if let item = clusterItem as? POIItem{
            
            let marker = GMSMarker(position: item.position)
            marker.title = item.title!
            marker.snippet = item.snippet!
            self.testview.selectedMarker = marker
            self.testview.
        }
        //self.testview.selectedMarker = selectedm!
        return true
    }*/
    
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
            print("test123455")
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
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
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
        print("2333333")
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ArtWork")
        do {
            artworks = try managedObjectContext.fetch(fetchRequest) as! [ArtWork]
            for item in artworks{
                print("hhhhhh")
                let temp = artworktemp(ArtWork_id: Int(item.artist_id), ArtWork_name: item.artwork_name!, ArtWork_address: item.artwork_address!, ArtWork_structure: item.artwork_structure!, ArtWork_description: item.artwork_description!, ArtWork_date: Int(item.artwork_date), ArtWork_latitude: item.artwork_latitude, ArtWork_longtitude: item.artwork_longtitude, Artist_id: Int(item.artist_id), Category_id: Int(item.category_id))
                artworktemps.append(temp)
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
            self.testview.camera = camera
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        }else{
            //show alert that user dont have location service
        }
    }
    
    func displayMessage(_ message: String,_ title: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:
            UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            testview.isMyLocationEnabled = true
            centerViewOnUserLocation()
            locationManger.startUpdatingLocation()
            break
        case .authorizedWhenInUse:
            testview.isMyLocationEnabled = true
            centerViewOnUserLocation()
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


