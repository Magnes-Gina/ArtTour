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
    
    @IBOutlet var downgesture: UITapGestureRecognizer!
    
    @IBOutlet weak var segmentcontrol: UISegmentedControl!
    
    @IBAction func segmentaction(_ sender: Any) {
        switch segmentcontrol.selectedSegmentIndex {
        case 0:
            container1.isHidden = false
            container2.isHidden = true
        case 1:
            container1.isHidden = true
            container2.isHidden = false
        default:
            break
        }
    }
    
    
    @IBOutlet weak var artButton: UIButton!
    
    
    @IBAction func artAction(_ sender: UIButton) {
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
            buskerButton.isSelected = false
            sender.isSelected = true
        }
    }
    
    
    
    @IBOutlet weak var container1: UIView!
    
    @IBOutlet weak var container2: UIView!
    
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
    var artbool = false
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
            artButton.isSelected = false
            sender.isSelected = true
        }
    }
    
    
    @IBAction func galleryaction(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        }else{
            buskerButton.isSelected = false
            artButton.isSelected = false
            sender.isSelected = true
        }
    }
    
    
    @IBAction func memorialaction(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        }else{
            buskerButton.isSelected = false
            artButton.isSelected = false
            sender.isSelected = true
        }
    }
    
    
    @IBAction func publicbuildingaction(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        }else{
            buskerButton.isSelected = false
            artButton.isSelected = false
            sender.isSelected = true
        }
    }

    
    
    @IBAction func othersaction(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        }else{
            buskerButton.isSelected = false
            artButton.isSelected = false
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
            artButton.isSelected = false
            sender.isSelected = true
        }
    }

    @IBAction func confirmaction(_ sender: UIButton) {
        if !gallerybutton.isSelected && !memorialButton.isSelected && !publicbuildingButton.isSelected && !sculptureButton.isSelected && !othersbutton.isSelected && !buskerButton.isSelected && !artButton.isSelected{
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
                artbool = false
                addbusker()
            }else{
                if artButton.isSelected{
                    allbuskerbool = false
                    othersbool = false
                    scilpturebool = false
                    publicbuildingbool = false
                    memorialbool = false
                    gallerybool = false
                    visitebool = false
                    notvisitbool = false
                    artbool = true
                    addbusker2()
                }else{
                    allbuskerbool = false
                    artbool = false
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
        artbool = false
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
        marker1.title = "Busking site 1"
        marker1.snippet = "Filinders Street Station Tunnels"
        marker1.icon = UIImage(named: "singer.png")
        marker1.map = testview
        makers.append(marker1)
        let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(marker1.position.latitude,marker1.position.longitude), radius: 70, identifier: marker1.title!)
        geoLocation.notifyOnEntry = true
        geos.append(geoLocation)
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2DMake(-37.819004, 144.968362)
        marker2.title = "Busking site 2"
        marker2.snippet = "SouthBank"
        marker2.icon = UIImage(named: "singer.png")
        marker2.map = testview
        makers.append(marker2)
        let geoLocation2 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker2.position.latitude,marker2.position.longitude), radius: 70, identifier: marker2.title!)
        geoLocation2.notifyOnEntry = true
        geos.append(geoLocation2)
        let marker3 = GMSMarker()
        marker3.position = CLLocationCoordinate2DMake(-37.810033, 144.964106)
        marker3.title = "Busking site 3"
        marker3.snippet = "Swanston Street"
        marker3.icon = UIImage(named: "singer.png")
        marker3.map = testview
        makers.append(marker3)
        let geoLocation3 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker3.position.latitude,marker3.position.longitude), radius: 70, identifier: marker3.title!)
        geoLocation3.notifyOnEntry = true
        geos.append(geoLocation3)
        let marker4 = GMSMarker()
        marker4.position = CLLocationCoordinate2DMake(-37.817751, 144.969056)
        marker4.title = "Busking site 4"
        marker4.snippet = "Federation Square"
        marker4.icon = UIImage(named: "singer.png")
        marker4.map = testview
        makers.append(marker4)
        let geoLocation4 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker4.position.latitude,marker4.position.longitude), radius: 70, identifier: marker4.title!)
        geoLocation4.notifyOnEntry = true
        geos.append(geoLocation4)
        let marker5 = GMSMarker()
        marker5.position = CLLocationCoordinate2DMake(-37.854104, 144.992959)
        marker5.title = "Busking site 5"
        marker5.snippet = "Chapel Street"
        marker5.icon = UIImage(named: "singer.png")
        marker5.map = testview
        makers.append(marker5)
        let geoLocation5 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker5.position.latitude,marker5.position.longitude), radius: 70, identifier: marker5.title!)
        geoLocation5.notifyOnEntry = true
        geos.append(geoLocation5)
        let marker6 = GMSMarker()
        marker6.position = CLLocationCoordinate2DMake(-37.774289, 144.962256)
        marker6.title = "Busking site 6"
        marker6.snippet = "Buckley Square, Burnswick"
        marker6.icon = UIImage(named: "singer.png")
        marker6.map = testview
        makers.append(marker6)
        let geoLocation6 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker6.position.latitude,marker6.position.longitude), radius: 70, identifier: marker6.title!)
        geoLocation6.notifyOnEntry = true
        geos.append(geoLocation6)
        let marker7 = GMSMarker()
        marker7.position = CLLocationCoordinate2DMake(-37.807368, 144.956785)
        marker7.title = "Busking site 7"
        marker7.snippet = " Queen Victoria Markets"
        marker7.icon = UIImage(named: "singer.png")
        marker7.map = testview
        makers.append(marker7)
        let geoLocation7 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker7.position.latitude,marker7.position.longitude), radius: 70, identifier: marker7.title!)
        geoLocation7.notifyOnEntry = true
        geos.append(geoLocation7)
        let marker8 = GMSMarker()
        marker8.position = CLLocationCoordinate2DMake(-37.731904, 144.963527)
        marker8.title = "Busking site 8"
        marker8.snippet = "Batman Markets"
        marker8.icon = UIImage(named: "singer.png")
        marker8.map = testview
        makers.append(marker8)
        let geoLocation8 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker8.position.latitude,marker8.position.longitude), radius: 70, identifier: marker8.title!)
        geoLocation8.notifyOnEntry = true
        geos.append(geoLocation8)
        let marker9 = GMSMarker()
        marker9.position = CLLocationCoordinate2DMake(-37.812946, 144.963658)
        marker9.title = "Busking site 9"
        marker9.snippet = "Bourke Street Mall"
        marker9.icon = UIImage(named: "singer.png")
        marker9.map = testview
        makers.append(marker9)
        let geoLocation9 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker9.position.latitude,marker9.position.longitude), radius: 70, identifier: marker9.title!)
        geoLocation9.notifyOnEntry = true
        geos.append(geoLocation9)
        let marker10 = GMSMarker()
        marker10.position = CLLocationCoordinate2DMake(-37.809983, 144.962800)
        marker10.title = "Busking site 10"
        marker10.snippet = "Melbourne Central"
        marker10.icon = UIImage(named: "singer.png")
        marker10.map = testview
        makers.append(marker10)
        let geoLocation10 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker10.position.latitude,marker10.position.longitude), radius: 70, identifier: marker10.title!)
        geoLocation10.notifyOnEntry = true
        geos.append(geoLocation10)
        let marker11 = GMSMarker()
        marker11.position = CLLocationCoordinate2DMake(-37.832169, 144.956573)
        marker11.title = "Busking site 11"
        marker11.snippet = "South Melbourne Markets"
        marker11.icon = UIImage(named: "singer.png")
        marker11.map = testview
        makers.append(marker11)
        let geoLocation11 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker11.position.latitude,marker11.position.longitude), radius: 70, identifier: marker11.title!)
        geoLocation11.notifyOnEntry = true
        geos.append(geoLocation11)
    }
    
    func addbusker2(){
        clusterManager.clearItems()
        geos = [];
        nowlandmark = CLCircularRegion(center: CLLocationCoordinate2DMake(-37.5,110), radius: 70, identifier: "test")
        testview.clear()
        makers = []
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2DMake(-37.815584, 144.970795)
        marker1.title = "Street Art 1"
        marker1.snippet = "ACDC Lane"
        marker1.icon = UIImage(named: "art.png")
        marker1.map = testview
        makers.append(marker1)
        let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(marker1.position.latitude,marker1.position.longitude), radius: 70, identifier: marker1.title!)
        geoLocation.notifyOnEntry = true
        geos.append(geoLocation)
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2DMake(-37.815537, 144.969190)
        marker2.title = "Street Art 2"
        marker2.snippet = "Duckboard Place"
        marker2.icon = UIImage(named: "art.png")
        marker2.map = testview
        makers.append(marker2)
        let geoLocation2 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker2.position.latitude,marker2.position.longitude), radius: 70, identifier: marker2.title!)
        geoLocation2.notifyOnEntry = true
        geos.append(geoLocation2)
        let marker3 = GMSMarker()
        marker3.position = CLLocationCoordinate2DMake(-37.815087, 144.967052)
        marker3.title = "Street Art 3"
        marker3.snippet = "Beaney Lane"
        marker3.icon = UIImage(named: "art.png")
        marker3.map = testview
        makers.append(marker3)
        let geoLocation3 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker3.position.latitude,marker3.position.longitude), radius: 70, identifier: marker3.title!)
        geoLocation3.notifyOnEntry = true
        geos.append(geoLocation3)
        let marker4 = GMSMarker()
        marker4.position = CLLocationCoordinate2DMake(-37.816570, 144.968519)
        marker4.title = "Street Art 4"
        marker4.snippet = "Hosier aand Rutledge lanes"
        marker4.icon = UIImage(named: "art.png")
        marker4.map = testview
        makers.append(marker4)
        let geoLocation4 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker4.position.latitude,marker4.position.longitude), radius: 70, identifier: marker4.title!)
        geoLocation4.notifyOnEntry = true
        geos.append(geoLocation4)
        let marker5 = GMSMarker()
        marker5.position = CLLocationCoordinate2DMake(-37.816420, 144.963260)
        marker5.title = "Street Art 5"
        marker5.snippet = "Centre Place"
        marker5.icon = UIImage(named: "art.png")
        marker5.map = testview
        makers.append(marker5)
        let geoLocation5 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker5.position.latitude,marker5.position.longitude), radius: 70, identifier: marker5.title!)
        geoLocation5.notifyOnEntry = true
        geos.append(geoLocation5)
        let marker6 = GMSMarker()
        marker6.position = CLLocationCoordinate2DMake(-37.813984, 144.962408)
        marker6.title = "Street Art 6"
        marker6.snippet = "Union Lane"
        marker6.icon = UIImage(named: "art.png")
        marker6.map = testview
        makers.append(marker6)
        let geoLocation6 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker6.position.latitude,marker6.position.longitude), radius: 70, identifier: marker6.title!)
        geoLocation6.notifyOnEntry = true
        geos.append(geoLocation6)
        let marker7 = GMSMarker()
        marker7.position = CLLocationCoordinate2DMake(-37.814968, 144.963479)
        marker7.title = "Street Art 7"
        marker7.snippet = "Presgrave Place"
        marker7.icon = UIImage(named: "art.png")
        marker7.map = testview
        makers.append(marker7)
        let geoLocation7 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker7.position.latitude,marker7.position.longitude), radius: 70, identifier: marker7.title!)
        geoLocation7.notifyOnEntry = true
        geos.append(geoLocation7)
        let marker8 = GMSMarker()
        marker8.position = CLLocationCoordinate2DMake(-37.811901, 144.963416)
        marker8.title = "Street Art 8"
        marker8.snippet = "Tattersalls Lane"
        marker8.icon = UIImage(named: "art.png")
        marker8.map = testview
        makers.append(marker8)
        let geoLocation8 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker8.position.latitude,marker8.position.longitude), radius: 70, identifier: marker8.title!)
        geoLocation8.notifyOnEntry = true
        geos.append(geoLocation8)
        let marker9 = GMSMarker()
        marker9.position = CLLocationCoordinate2DMake(-37.811349, 144.961974)
        marker9.title = "Street Art 9"
        marker9.snippet = "Drewery and Snider lanes"
        marker9.icon = UIImage(named: "art.png")
        marker9.map = testview
        makers.append(marker9)
        let geoLocation9 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker9.position.latitude,marker9.position.longitude), radius: 70, identifier: marker9.title!)
        geoLocation9.notifyOnEntry = true
        geos.append(geoLocation9)
        let marker10 = GMSMarker()
        marker10.position = CLLocationCoordinate2DMake(-37.812366, 144.961428)
        marker10.title = "Street Art 10"
        marker10.snippet = "Caledonian Lane"
        marker10.icon = UIImage(named: "art.png")
        marker10.map = testview
        makers.append(marker10)
        let geoLocation10 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker10.position.latitude,marker10.position.longitude), radius: 70, identifier: marker10.title!)
        geoLocation10.notifyOnEntry = true
        geos.append(geoLocation10)
        let marker11 = GMSMarker()
        marker11.position = CLLocationCoordinate2DMake(-37.814106, 144.960120)
        marker11.title = "Street Art 11"
        marker11.snippet = "Rankins Lane"
        marker11.icon = UIImage(named: "art.png")
        marker11.map = testview
        makers.append(marker11)
        let geoLocation11 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker11.position.latitude,marker11.position.longitude), radius: 70, identifier: marker11.title!)
        geoLocation11.notifyOnEntry = true
        geos.append(geoLocation11)
        let marker12 = GMSMarker()
        marker12.position = CLLocationCoordinate2DMake(-37.813893, 144.959526)
        marker12.title = "Street Art 12"
        marker12.snippet = "Racing Club Lane"
        marker12.icon = UIImage(named: "art.png")
        marker12.map = testview
        makers.append(marker12)
        let geoLocation12 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker12.position.latitude,marker12.position.longitude), radius: 70, identifier: marker12.title!)
        geoLocation12.notifyOnEntry = true
        geos.append(geoLocation12)
        let marker13 = GMSMarker()
        marker13.position = CLLocationCoordinate2DMake(-37.812303, 144.957938)
        marker13.title = "Street Art 13"
        marker13.snippet = "Finlay Alley"
        marker13.icon = UIImage(named: "art.png")
        marker13.map = testview
        makers.append(marker13)
        let geoLocation13 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker13.position.latitude,marker13.position.longitude), radius: 70, identifier: marker13.title!)
        geoLocation13.notifyOnEntry = true
        geos.append(geoLocation13)
        let marker14 = GMSMarker()
        marker14.position = CLLocationCoordinate2DMake(-37.811348, 144.957661)
        marker14.title = "Street Art 14"
        marker14.snippet = "Guildford Lane"
        marker14.icon = UIImage(named: "art.png")
        marker14.map = testview
        makers.append(marker14)
        let geoLocation14 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker14.position.latitude,marker14.position.longitude), radius: 70, identifier: marker14.title!)
        geoLocation14.notifyOnEntry = true
        geos.append(geoLocation14)
        let marker15 = GMSMarker()
        marker15.position = CLLocationCoordinate2DMake(-37.809245, 144.959802)
        marker15.title = "Street Art 15"
        marker15.snippet = "Lilerature Lane"
        marker15.icon = UIImage(named: "art.png")
        marker15.map = testview
        makers.append(marker15)
        let geoLocation15 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker15.position.latitude,marker15.position.longitude), radius: 70, identifier: marker15.title!)
        geoLocation15.notifyOnEntry = true
        geos.append(geoLocation15)
        let marker16 = GMSMarker()
        marker16.position = CLLocationCoordinate2DMake(-37.808403, 144.957192)
        marker16.title = "Street Art 16"
        marker16.snippet = "Blender Lane"
        marker16.icon = UIImage(named: "art.png")
        marker16.map = testview
        makers.append(marker11)
        let geoLocation16 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker16.position.latitude,marker16.position.longitude), radius: 70, identifier: marker16.title!)
        geoLocation16.notifyOnEntry = true
        geos.append(geoLocation16)
        let marker17 = GMSMarker()
        marker17.position = CLLocationCoordinate2DMake(-37.808536, 144.954303)
        marker17.title = "Street Art 11"
        marker17.snippet = "Queen and Franklin Street"
        marker17.icon = UIImage(named: "art.png")
        marker17.map = testview
        makers.append(marker17)
        let geoLocation17 = CLCircularRegion(center: CLLocationCoordinate2DMake(marker17.position.latitude,marker17.position.longitude), radius: 70, identifier: marker17.title!)
        geoLocation17.notifyOnEntry = true
        geos.append(geoLocation17)
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
        container1.isHidden = false
        container2.isHidden = true
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
        self.visited.imageView!.layer.cornerRadius = 10
        self.notVisitedButton.imageView!.layer.cornerRadius = 10
        self.notVisitedButton.layer.cornerRadius = 10
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
        self.container1.layer.cornerRadius = 10
        self.container2.layer.cornerRadius = 10
        //let gesture = UITapGestureRecognizer(target: self, action: #selector(self.downview))
        //downgesture.addTarget(self, action: #selector(self.downview))
        
        //checkaround()
    }
    
    @objc func downview(){
        animatedOut()
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
        if artbool{
            artButton.isSelected = true
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
            self.choiceView.layer.cornerRadius = 15
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
        artButton.isSelected = false
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
        checkaround()
    }
    
   
    func checkaround(){
        if geos.count == 0 || geos.count == 1{
            resultLabel.text = "\(geos.count) result found!"
        }else{
            resultLabel.text = "\(geos.count) results found!"
        }
        var count = 0
        for geo in geos{
            let distance = locationManger.location!.distance(from: CLLocation(latitude: geo.center.latitude, longitude: geo.center.longitude))
            if distance <= 1000{
                count = count + 1
                print(geo.identifier)
            }
        }
        if count == 0 || count == 1{
            resultaroundLabel.text = "\(count) result around you within 1KM"
        }else{
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
                            if allbuskerbool{
                                displayMessage("You are near the \(temp.identifier), there may be buskers here!", "Busking Site Notification ")
                                notificationCreated(message: "You are near the \(temp.identifier), there may be buskers here!", title: "Busking Site Notification")
                                nowlandmark = temp
                            }else{
                                if artbool{
                                    displayMessage("You are near the \(temp.identifier), there may be street art here!", "Street Art Notification ")
                                    notificationCreated(message: "You are near the \(temp.identifier), there may be street art here!", title: "Street Art Notification")
                                    nowlandmark = temp
                                }else{
                                    displayMessage("You are near the \(temp.identifier)", "Attractions Notification ")
                                    notificationCreated(message: "You are near the \(temp.identifier)", title: "Location Notification")
                                    nowlandmark = temp
                                }
                                
                            }
                            
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
           
            
        }else if (marker.userData as? GMUCluster) != nil{
          
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


