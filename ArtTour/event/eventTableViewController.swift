//
//  eventTableViewController.swift
//  ArtTour
//
//  Created by yikeren on 6/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import SwiftyJSON

/*struct  pagination: Decodable{
    let object_count: Int
    let page_number: Int
    let page_size: Int
    let page_count: Int
    let has_more_items: Bool
}

struct augmented_location: Decodable{
    let city: String
    let region: String
    let country: String
}

struct loction: Decodable{
    let latitude: Double
    let augmented_location: augmented_location
    let within: Double
    let longtitude: Double
    let address: String
}

struct name: Decodable{
    let text: String
    let html: String
}

struct description: Decodable{
    let text: String
    let html: String
}

struct start: Decodable{
    let timezone: String
    let local: String
    let utc: String
}

struct end: Decodable{
    let timezone: String
    let local: String
    let utc: String
}

struct address: Decodable{
    let address_1: String?
    let address_2: String?
    let city: String
    let region: String
    let postal_code: Int
    let country: String
    let latitude: Double
    let longtitude: Double
    let localized_address_display: String
    let localized_area_display: String
    let localized_multi_line_address_display: [String?]
}

struct venue: Decodable{
    let address: address
    let resource_uri: String
    let id: Int
    let age_restriction: String?
    let capactiy: String?
    let name: String
    let latitude: Double
    let longtitude: Double
    
}

struct top_left: Decodable{
    let x: Int
    let y: Int
}

struct crop_mask: Decodable{
    let top_left: top_left
    let width: Int
    let height: Int
}

struct original: Decodable{
    let url: String
    let width: Int
    let height: Int
}

struct logo: Decodable{
    let crop_mask: crop_mask
    let original: original
    let id: Int
    let url: String
    let aspect_ratio: Int
    let edge_color: String?
    let edge_color_set: Bool
}

struct event: Decodable{
    let name: name
    let description: description
    let start: start
    let end: end
    let organization_id: Int?
    let created: String
    let changed: String
    let published: String
    let capacity: String?
    let capacity_is_custom: String?
    let status: String
    let currency: String
    let listed: Bool
    let shareable: Bool
    let online_event: Bool
    let tx_time_limit: Int
    let hide_start_date: Bool
    let hide_end_date: Bool
    let locale: String
    let is_locked: Bool
    let privacy_setting: String
    let is_series: Bool
    let is_series_parent: Bool
    let inventory_type: String
    let is_reserved_seating: Bool
    let show_pick_a_seat: Bool
    let show_seatmap_thumbnail: Bool
    let show_colors_in_seatmap_thumbnail: Bool
    let source: String
    let is_free: Bool
    let version: String
    let summary: String
    let logo_id: Int?
    let organizer_id: Int?
    let venue_id: Int
    let category_id: Int
    let subcategory_id: Int?
    let format_id: Int
    let resource_uri: String
    let is_externally_ticketed: Bool
    let series_id: Int
    let venue: venue
    let logo: logo
}

struct jsonobject: Decodable{
    let pagination: pagination
    let events: [event?]
    let location: loction
}*/

class eventTableViewController: UITableViewController {
    
    //var jsonObject: jsonobject?
    var jsonarray: [JSON] = []
    var json: JSON?
    var count = 0
    var limit = 50
    var page = 0
    var pagenow = 1;
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
        self.tableView.dataSource = self
        self.tableView.delegate = self
        //self.tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "eventIdentifier")
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
        self.tableView.reloadData()
        //count = json!["pagination"]["object_count"].int!
        page = json!["pagination"]["page_count"].int!
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("---------------------")
        print(count)
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventIdentifier", for: indexPath) as! EventTableViewCell
        //let tempEvent = jsonObject!.events[indexPath.row]
        //jsonarray = json!["events"]
        let temp = jsonarray[indexPath.row]
        if temp["logo"]["url"].string == nil{
            cell.eventImage.image = UIImage(named: "singer.png")
        }else{
            cell.eventImage.pin_setImage(from: URL(string: temp["logo"]["url"].string!))
        }
        cell.eventImage.layer.masksToBounds = true
        cell.eventImage.layer.cornerRadius = 20
        //print(temp["start"]["local"].string!)
        //print(indexPath.row)
        var strtemp = temp["start"]["local"].string!
        strtemp = strtemp.replacingOccurrences(of: "T", with: " ")
        
        let locale = NSLocale.current
        let formatter: String = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: locale)!
        if formatter.contains("a"){
            print("sssssssssss")
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let datetemp = df.date(from: strtemp)
            print(Date())
            print(strtemp)
            print(datetemp!)
            let df2 = DateFormatter()
            df2.dateFormat = "MMM dd yyyy h:mm:ss a"
            let newstr = df2.string(from: datetemp!)
            cell.time.text = newstr
        }else{
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd hh:mm:ss"
            let datetemp = df.date(from: strtemp)
            print(Date())
            print(strtemp)
            print(datetemp!)
            let df2 = DateFormatter()
            df2.dateFormat = "MMM dd yyyy hh:mm:ss"
            let newstr = df2.string(from: datetemp!)
            cell.time.text = newstr
        }
        
        //cell.time.text = "NONE"
        cell.title.text = temp["name"]["text"].string!
        cell.address.text = temp["venue"]["address"]["localized_address_display"].string!
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //
        if indexPath.row == count - 1{
            if pagenow < page{
                /*var data: [JSON] = []
                data = data + json!["events"].arrayValue
                print(data[0]["name"]["text"].string!)*/
                
                pagenow += 1
                let pageString = "\(requesturl)&page=\(pagenow)"
                /*let spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: 40)
                self.tableView.tableFooterView = spinner
                self.tableView.tableFooterView?.isHidden = false*/
                getData(requestUrl: pageString)
                semaphore.wait()
                //self.tableView.tableFooterView?.isHidden = true
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150
    }
    
    /*func getpageData(pagenum: Int){
        let pagestring = "\(requesturl)&page=\(pagenum)"
        URLSession.shared.dataTask(with: pagestring) { (data, urlResponse, error) in
            CBToast.showToastAction(message: "Download page Data!")
            guard let data = data, error == nil,urlResponse != nil else {
                print("wrong")
                return
            }
            do{
                /*self.json = try JSON(data: data)
                print("the total count is: \(self.json!["events"].count)")
                self.count = self.json!["events"].count
                self.jsonarray = self.jsonarray + self.json!["events"].arrayValue
                self.semaphore.signal()*/
                /*DispatchQueue.main.async {
                 self.tableView.reloadData()
                 }*/
                
            }catch let error as NSError{
                print("error: \(error)")
            }
            }.resume()
    
    }*/
    
    func getData(requestUrl: String){
        guard let downloadURL = URL(string: requestUrl) else { return }
        URLSession.shared.dataTask(with: downloadURL) { (data, urlResponse, error) in
            CBToast.showToastAction(message: "Download Data!")
            guard let data = data, error == nil,urlResponse != nil else {
                print("wrong")
                return
            }
            do{
                //let response = urlResponse as? HTTPURLResponse
                //print("------------------------------------------")
                //print(response?.allHeaderFields["X-Frame-Options"])
                self.json = try JSON(data: data)
               
                self.count = self.count+self.json!["events"].count
                 print("the total count is: \(self.count)")
                self.jsonarray = self.jsonarray + self.json!["events"].arrayValue
                self.semaphore.signal()
                /*DispatchQueue.main.async {
                    self.tableView.reloadData()
                }*/
                
            }catch let error as NSError{
                print("error: \(error)")
            }
            }.resume()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailedEvent", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? detailViewController{
            
                let temp = jsonarray[(self.tableView.indexPathForSelectedRow?.row)!]
                destination.json = temp
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
   
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
