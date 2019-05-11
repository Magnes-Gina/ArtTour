//
//  eventnewTableViewController.swift
//  ArtTour
//
//  Created by yikeren on 9/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation
class eventnewTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,Addsort,CLLocationManagerDelegate {
    
    @IBOutlet weak var searchBarEvent: UISearchBar!
    
    @IBOutlet weak var myTableView: UITableView!
    let locationManger = CLLocationManager()
    var jsonarray: [JSON] = []
    var sortarray: [JSON] = []
    var json: JSON?
    var sortby = "Default"
    var count = 0
    var sortcount = 0
    var limit = 50
    var page = 0
    var pagenow = 1
    var totalcount = 0
    var searchingflag = false
    let semaphore = DispatchSemaphore(value: 0)
    var orinrequesturl = "https://www.eventbriteapi.com/v3/events/search/?token=WEH7N6CEZAQ35WUQE6AM&location.address=Melbourne&expand=venue"
    var requesturl = ""
    var time = "Anytime"
    var mood = "Anything"
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        self.searchBarEvent.delegate = self
        requesturl = orinrequesturl
        if time != "Anytime"{
            requesturl = requesturl + "&" + time
        }
        if mood != "Anything"
        {
            requesturl = requesturl + "&" + mood
        }
        print(requesturl)
        self.getData(requestUrl: requesturl)
        semaphore.wait()
        self.myTableView.reloadData()
        page = json!["pagination"]["page_count"].int!
        totalcount = json!["pagination"]["object_count"].int!
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(printmessage))
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmisskeboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
//        self.searchBarEvent.layer.borderWidth = 1
//        self.searchBarEvent.layer.borderColor = UIColor.white.cgColor
        self.searchBarEvent.backgroundImage = UIImage()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        locationManger.requestAlwaysAuthorization()
        //locationManger.startMonitoringSignificantLocationChanges()
        locationManger.distanceFilter = 100
        checkLocationServices()
        self.view.bringSubviewToFront(searchBarEvent)
        let textFieldInsideSearchBar = searchBarEvent.value(forKey: "searchField") as? UITextField
        
        textFieldInsideSearchBar?.backgroundColor = UIColor.groupTableViewBackground
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectionIndexPath = self.myTableView.indexPathForSelectedRow{
            self.myTableView.deselectRow(at: selectionIndexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "System", size: 20)
        header.textLabel?.textColor = UIColor.black
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
    
    func addsort(newmood: String){
        self.sortby = newmood
        print(sortby)
        switch sortby {
        case "Date":
            sortarray = sortarray.sorted{ (item,item2) -> Bool in
                var strtemp = item["start"]["local"].string!
                var strtemp2 = item2["start"]["local"].string!
                strtemp = strtemp.replacingOccurrences(of: "T", with: " ")
                strtemp2 = strtemp2.replacingOccurrences(of: "T", with: " ")
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let datetemp = df.date(from: strtemp)
                let datetemp2 = df.date(from: strtemp2)
                return datetemp! < datetemp2!
            }
            self.myTableView.reloadData()
            break
        case "Date(Reverse)":
            sortarray = sortarray.sorted{ (item,item2) -> Bool in
                var strtemp = item["start"]["local"].string!
                var strtemp2 = item2["start"]["local"].string!
                strtemp = strtemp.replacingOccurrences(of: "T", with: " ")
                strtemp2 = strtemp2.replacingOccurrences(of: "T", with: " ")
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let datetemp = df.date(from: strtemp)
                let datetemp2 = df.date(from: strtemp2)
                return datetemp! > datetemp2!
            }
            self.myTableView.reloadData()
            break
        case "Distance":
            sortarray = sortarray.sorted{ (item,item2) -> Bool in
                switch CLLocationManager.authorizationStatus() {
                case .notDetermined:
                    locationManger.requestAlwaysAuthorization()
                    return true
                    
                case .denied:
                    displayMessage("Our location request has been dined", "Denied Alert")
                    return true
                case .restricted:
                    displayMessage("Our location request has been Restricted", "Restricted Alert")
                    return true
                default:
                    let cordinate = CLLocation(latitude: Double(item["venue"]["latitude"].string!) as! CLLocationDegrees, longitude: Double(item["venue"]["longitude"].string!) as! CLLocationDegrees)
                    let cordinate2 = CLLocation(latitude: Double(item2["venue"]["latitude"].string!) as! CLLocationDegrees, longitude: Double(item2["venue"]["longitude"].string!) as! CLLocationDegrees)
                    let locationtemp = self.locationManger.location?.coordinate
                    let mycordinate = CLLocation(latitude: locationtemp!.latitude, longitude: locationtemp!.longitude)
                    return cordinate.distance(from: mycordinate) < cordinate2.distance(from: mycordinate)
                }
                
            }
            self.myTableView.reloadData()
            break
        case "Distance(Reverse)":
            sortarray = sortarray.sorted{ (item,item2) -> Bool in
                switch CLLocationManager.authorizationStatus() {
                case .notDetermined:
                    locationManger.requestAlwaysAuthorization()
                    return true
                    
                case .denied:
                    displayMessage("Our location request has been dined", "Denied Alert")
                    return true
                case .restricted:
                    displayMessage("Our location request has been Restricted", "Restricted Alert")
                    return true
                default:
                    let cordinate = CLLocation(latitude: Double(item["venue"]["latitude"].string!) as! CLLocationDegrees, longitude: Double(item["venue"]["longitude"].string!) as! CLLocationDegrees)
                    let cordinate2 = CLLocation(latitude: Double(item2["venue"]["latitude"].string!) as! CLLocationDegrees, longitude: Double(item2["venue"]["longitude"].string!) as! CLLocationDegrees)
                    let locationtemp = self.locationManger.location?.coordinate
                    let mycordinate = CLLocation(latitude: locationtemp!.latitude, longitude: locationtemp!.longitude)
                    return cordinate.distance(from: mycordinate) > cordinate2.distance(from: mycordinate)
                }
                
            }
            self.myTableView.reloadData()
            break
        default:
            if searchBarEvent.text == ""{
                sortarray = jsonarray
                sortcount = sortarray.count
            }else{
                sortarray = jsonarray.filter{ (item) -> Bool in
                    return item["name"]["text"].string!.lowercased().contains(searchBarEvent.text!.lowercased())
                }
                sortcount = sortarray.count
            }
            self.myTableView.reloadData()
            break
        }
    }
    
    @objc func printmessage(){
        self.performSegue(withIdentifier: "sortse", sender: self)
    }
    
    @objc func dissmisskeboard(){
        self.view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sortcount == 0 {
            self.myTableView.setEmptyView(title: "No event found!", message: "Please try something else!")
        }
        else {
            self.myTableView.restore()
        }
        return sortcount
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //
        searchingflag = true
        if searchText == ""{
            sortarray = jsonarray
            sortcount = sortarray.count
        }else{
            sortarray = jsonarray.filter{ (item) -> Bool in
                return item["name"]["text"].string!.lowercased().contains(searchText.lowercased())
            }
            sortcount = sortarray.count
        }
        
        self.myTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarEvent.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        sortarray = jsonarray
        sortcount = sortarray.count
        searchingflag = false
        self.myTableView.reloadData()
        self.searchBarEvent.text = ""
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !searchingflag{
            if totalcount == 1{
                return "1 event"
            }else{
                return "\(totalcount) events"
            }
        }else{
            if self.searchBarEvent.text! == ""{
                return "\(totalcount) events"
            }else{
                if sortarray.count == 1{
                    return "1 event"
                }else{
                    return "\(sortarray.count) events"
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventIdentifier", for: indexPath) as! EventTableViewCell
        let temp = sortarray[indexPath.row]
        if temp["logo"]["url"].string == nil{
            cell.eventImage.image = UIImage(named: "404-permalink.png")
        }else{
            cell.eventImage.pin_setImage(from: URL(string: temp["logo"]["url"].string!))
        }
        cell.eventImage.layer.masksToBounds = true
        cell.eventImage.layer.cornerRadius = 20
        var strtemp = temp["start"]["local"].string!
        strtemp = strtemp.replacingOccurrences(of: "T", with: " ")
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let datetemp = df.date(from: strtemp)
        let df2 = DateFormatter()
        df2.dateFormat = "MMM dd yyyy HH:mm:ss"
        let newstr = df2.string(from: datetemp!)
        cell.time.text = newstr
        cell.title.text = temp["name"]["text"].string!
        cell.address.text = temp["venue"]["address"]["localized_address_display"].string ?? "Unkown"
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //
        if searchBarEvent.text == ""{
            if indexPath.row == count - 1{
                if pagenow < page{
                    pagenow += 1
                    let pageString = "\(requesturl)&page=\(pagenow)"
                    getData(requestUrl: pageString)
                    semaphore.wait()
                    self.myTableView.reloadData()
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150
    }
    
    
    func getData(requestUrl: String){
        guard let downloadURL = URL(string: requestUrl) else { return }
        URLSession.shared.dataTask(with: downloadURL) { (data, urlResponse, error) in
            CBToast.showToastAction(message: "Download Data!")
            guard let data = data, error == nil,urlResponse != nil else {
                print("wrong")
                print("wrong2")
                return
            }
            do{
                self.json = try JSON(data: data)
                print("the total count is: \(self.count)")
                self.jsonarray = self.jsonarray + self.json!["events"].arrayValue
                self.sortarray = self.jsonarray
                self.count = self.jsonarray.count
                self.sortcount = self.count
                self.semaphore.signal()
            }catch let error as NSError{
                print("error: \(error)")
            }
            }.resume()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailedEvent", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? detailViewController{
            
            let temp = sortarray[(self.myTableView.indexPathForSelectedRow?.row)!]
            destination.json = temp
        }
        if let destination = segue.destination as? sortViewController{
            destination.sortby = sortby
            destination.delegate = self
            //
        }
    }
    
    func displayMessage(_ message: String,_ title: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:
            UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }


}
