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

struct Landmark: Decodable {
    let Id: Int
    let Theme: String
    let SubTheme: String
    let FeatureName: String
    let latitude: Double
    let longtitude: Double
}

class POIItem: NSObject,GMUClusterItem{
    var position: CLLocationCoordinate2D
    var name: String!
    var title: String!
    var snippet: String!
    
    init(position: CLLocationCoordinate2D,name: String,title:String,snippet:String) {
        self.position = position
        self.name = name
        self.title = title
        self.snippet = snippet
    }
}

class MapViewController: UIViewController,GMSMapViewDelegate,GMUClusterManagerDelegate,CLLocationManagerDelegate,GMUClusterRendererDelegate {
    let semaphore = DispatchSemaphore(value: 0)
    final let url = URL(string: "https://k2r7nrgvl1.execute-api.ap-southeast-2.amazonaws.com/iteration1/landmark")
    var landmarks = [Landmark]()
    var geos : [CLCircularRegion] = []
    var makers: [GMSMarker] = []
    var nowlandmark = CLCircularRegion(center: CLLocationCoordinate2DMake(-37.5,110), radius: 70, identifier: "test")
    let store = UserDefaults.standard
    
    @IBAction func clear(_ sender: Any) {
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
    }
    
    
    @IBAction func refresh(_ sender: Any) {
        landmarks = []
        getData()
        //self.semaphore.wait()
        if makers.count == 0{
            clusterManager.clearItems()
            addingmaker()
            //self.semaphore.signal()
        }
        
    }
    
    @IBOutlet weak var Settting: UIButton!
    @IBOutlet weak var testview: GMSMapView!
    var clusterManager: GMUClusterManager!
    let locationManger = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sendSubviewToBack(testview)
        /*var bgTask = UIBackgroundTaskIdentifier(rawValue: <#Int#>)
        bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(bgTask)
        })*/
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
        semaphore.wait()
        addingmaker()
        //store.set("what",forKey: "landmark")
        //self.semaphore.signal()
        
        
    }
    
    
    
    func addingmaker()
    {
        var index = 0
        for landmark in self.landmarks{
            self.generatePOIItems(accessibilityLabel: "Item\(index)", position: CLLocationCoordinate2DMake(landmark.latitude,landmark.longtitude),title: landmark.FeatureName,snippet: landmark.SubTheme)
            let geoLocation = CLCircularRegion(center: CLLocationCoordinate2DMake(landmark.latitude,landmark.longtitude), radius: 70, identifier: landmark.FeatureName)
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
                        
                        displayMessage("You are near the \(temp.identifier)", "Landmark Notification ")
                        notificationCreated(message: "test", title: "test")
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
    
    func generatePOIItems(accessibilityLabel: String,position: CLLocationCoordinate2D,title:String,snippet:String){
        let item = POIItem(position: position, name: accessibilityLabel,title: title,snippet: snippet)
        
        self.clusterManager.add(item)
        
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let item = marker.userData as? POIItem {
            marker.title = item.title
            marker.snippet = item.snippet
            mapView.selectedMarker = marker
        }else if let item = marker.userData as? GMUCluster{
            CBToast.showToastAction(message: "Zoom Map to explore more landmark!")
        }else{
            mapView.selectedMarker = marker
            print("test123455")
        }
        return true
    }
    
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        if let temp = (marker.userData as? POIItem){
            marker.iconView = UIImageView(image: UIImage(named: "shrine-remembrance.png"))
            
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
        guard let downloadURL = url else { return }
        URLSession.shared.dataTask(with: downloadURL) { (data, urlResponse, error) in
           CBToast.showToastAction(message: "Download Data!")
            guard let data = data, error == nil,urlResponse != nil else {
                print("wrong")
                return
            }
            do{
                self.landmarks = try JSONDecoder().decode([Landmark].self,from: data)
                self.semaphore.signal()
                
            }catch let error as NSError{
                print("error: \(error)")
            }
        }.resume()
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
            displayMessage("Our location request has been dined", "Denied Alert")
            break
        case .restricted:
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


