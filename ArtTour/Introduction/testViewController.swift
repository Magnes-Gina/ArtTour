//
//  testViewController.swift
//  ArtTour
//
//  Created by yikeren on 8/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

struct tempcat: Decodable {
    let Category_id: Int
    let Category_name: String
}

struct artisttemp: Decodable {
    let Artist_id: Int
    let Artist_name: String
}

struct artworktemp: Decodable{
    let ArtWork_id: Int
    let ArtWork_name: String
    let ArtWork_address: String
    let ArtWork_structure: String
    let ArtWork_description: String
    let ArtWork_date: Int
    let ArtWork_latitude: Double
    let ArtWork_longtitude: Double
    let Artist_id: Int
    let Category_id: Int
}

class testViewController: UIViewController,UIScrollViewDelegate,CLLocationManagerDelegate{

    // REST API for our AWS server
    let url = URL(string: "https://k2r7nrgvl1.execute-api.ap-southeast-2.amazonaws.com/iteration3/landmark")
    let url2 = URL(string: "https://k2r7nrgvl1.execute-api.ap-southeast-2.amazonaws.com/iteration3/category")
    let url3 = URL(string: "https://k2r7nrgvl1.execute-api.ap-southeast-2.amazonaws.com/iteration3/artist")
    let url4 = URL(string: "https://k2r7nrgvl1.execute-api.ap-southeast-2.amazonaws.com/iteration3/artwork")
    //API key you need when you use REST API above
    let apiKey = "sVtkX3jZgIyCT3vJrQml5C87EXtef3TaUrkaX1Bf"
    var landmarks = [Landmark]()
    var tempcats = [tempcat]()
    var artiststemp = [artisttemp]()
    var artworks = [artworktemp]()
    
    private var managedObjectContext: NSManagedObjectContext?
    private var managedObjectContext2: NSManagedObjectContext?
    private var managedObjectContext3: NSManagedObjectContext?
    private var managedObjectContext4: NSManagedObjectContext?
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        // set up multiple managedObjectContext for multiple threading downloading data by HTTP request
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        managedObjectContext2 = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext2?.parent = managedObjectContext
        managedObjectContext3 = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext3?.parent = managedObjectContext
        managedObjectContext4 = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext4?.parent = managedObjectContext
        super.init(coder: aDecoder)!
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    var images: [String] = ["guide4.jpeg","guide1.jpeg","guide3.jpeg","guide2.jpeg"]
    var frame = CGRect(x:0,y:0,width: 0,height: 0)
    //let semaphore = DispatchSemaphore(value: 0)
    let locationManger = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.numberOfPages = images.count
        for index in 0..<images.count{
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            let imgView = UIImageView(frame: frame)
            imgView.image = UIImage(named: images[index])
            self.scrollView.addSubview(imgView)
        }
        locationManger.requestAlwaysAuthorization()
        locationManger.distanceFilter = 100
        checkLocationServices()
        // Do any additional setup after loading the view.
        scrollView.contentSize = CGSize(width:(scrollView.frame.size.width * CGFloat(images.count)),height: scrollView.frame.size.height)
        scrollView.delegate = self
        self.view.sendSubviewToBack(scrollView)
        //call method for downloading data
        getData()
        getData2()
        getData3()
        getData4()
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
    
    func getData(){
        var downloadURL = URLRequest(url: url!)
        downloadURL.setValue(self.apiKey,forHTTPHeaderField:"X-API-KEY" )
        URLSession.shared.dataTask(with: downloadURL) { (data: Data?, urlResponse:URLResponse?, error:Error?) in
            guard let data = data, error == nil,urlResponse != nil else {
                print("wrong")
                return
            }
            do{
                self.landmarks = try JSONDecoder().decode([Landmark].self,from: data)
                for item in self.landmarks{
                    let newlandmark = NSEntityDescription.insertNewObject(forEntityName: "Landmark2", into: self.managedObjectContext!) as! Landmark2
                    newlandmark.landmark_id = Int16(item.Landmark_id)
                    newlandmark.landmark_name = item.Landmark_name
                    newlandmark.landmark_latitude = item.Landmark_latitude
                    newlandmark.landmark_longtitude = item.Landmark_longtitude
                    newlandmark.category_id = Int16(item.Category_id)
                    newlandmark.video = item.video
                    try self.managedObjectContext?.save()
                }
            }catch let error as NSError{
                print("error: \(error)")
            }
            }.resume()
    }
    
    func getData2(){
        var downloadURL = URLRequest(url: url2!)
        downloadURL.setValue(self.apiKey,forHTTPHeaderField:"X-API-KEY" )
        URLSession.shared.dataTask(with: downloadURL) { (data, urlResponse, error) in
            guard let data = data, error == nil,urlResponse != nil else {
                print("wrong")
                return
            }
            do{
                self.tempcats = try JSONDecoder().decode([tempcat].self,from: data)
                for item in self.tempcats{
                    let newCategory = NSEntityDescription.insertNewObject(forEntityName: "Category", into: self.managedObjectContext2!) as! Category
                    newCategory.category_id = Int16(item.Category_id)
                    newCategory.category_name = item.Category_name
                    try self.managedObjectContext2?.save()
                }
            }catch let error as NSError{
                print("error: \(error)")
            }
            }.resume()
    }
    
    func getData3(){
        var downloadURL = URLRequest(url: url3!)
        downloadURL.setValue(self.apiKey,forHTTPHeaderField:"X-API-KEY" )
        URLSession.shared.dataTask(with: downloadURL) { (data, urlResponse, error) in
            guard let data = data, error == nil,urlResponse != nil else {
                print("wrong")
                return
            }
            do{
                self.artiststemp = try JSONDecoder().decode([artisttemp].self,from: data)
                for item in self.artiststemp{
                    let newArtist = NSEntityDescription.insertNewObject(forEntityName: "Artist", into: self.managedObjectContext3!) as! Artist
                    newArtist.artist_id = Int16(item.Artist_id)
                    newArtist.artist_name = item.Artist_name
                    print(item.Artist_id)
                    try self.managedObjectContext3?.save()
                }
            }catch let error as NSError{
                print("error: \(error)")
            }
            }.resume()
    }
    
    func getData4(){
        var downloadURL = URLRequest(url: url4!)
        downloadURL.setValue(self.apiKey,forHTTPHeaderField:"X-API-KEY" )
        URLSession.shared.dataTask(with: downloadURL) { (data, urlResponse, error) in
            guard let data = data, error == nil,urlResponse != nil else {
                print("wrong")
                return
            }
            do{
                self.artworks = try JSONDecoder().decode([artworktemp].self,from: data)
                for item in self.artworks{
                    let newartwork = NSEntityDescription.insertNewObject(forEntityName: "ArtWork", into: self.managedObjectContext4!) as! ArtWork
                    newartwork.artwork_id = Int16(item.ArtWork_id)
                    newartwork.artwork_name = item.ArtWork_name
                    newartwork.artwork_address = item.ArtWork_address
                    newartwork.artwork_structure = item.ArtWork_structure
                    newartwork.artwork_description = item.ArtWork_description
                    newartwork.artwork_latitude = item.ArtWork_latitude
                    newartwork.artwork_longtitude = item.ArtWork_longtitude
                    newartwork.artist_id = Int16(item.Artist_id)
                    newartwork.category_id = Int16(item.Category_id)
                    newartwork.artwork_date = Int16(item.ArtWork_date)
                    print(newartwork.artwork_id)
                    try self.managedObjectContext4?.save()
                    
                }
                try self.managedObjectContext?.save()
            }catch let error as NSError{
                print("error: \(error)")
            }
            }.resume()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
    func displayMessage(_ message: String,_ title: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:
            UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    

}
