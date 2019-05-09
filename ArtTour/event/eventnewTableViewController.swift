//
//  eventnewTableViewController.swift
//  ArtTour
//
//  Created by yikeren on 9/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import SwiftyJSON

class eventnewTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet weak var searchBarEvent: UISearchBar!
    
    @IBOutlet weak var myTableView: UITableView!
    var jsonarray: [JSON] = []
    var sortarray: [JSON] = []
    var json: JSON?
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
//        self.navigationController?.navigationBar.layer.borderColor = UIColor.white.cgColor
//        self.navigationController?.navigationBar.layer.borderWidth = 1
    }
    
    @objc func printmessage(){
        print("what fuck")
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
            cell.eventImage.image = UIImage(named: "singer.png")
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
        print(Date())
        print(strtemp)
        print(datetemp!)
        let df2 = DateFormatter()
        df2.dateFormat = "MMM dd yyyy HH:mm:ss"
        let newstr = df2.string(from: datetemp!)
        cell.time.text = newstr
        cell.title.text = temp["name"]["text"].string!
        cell.address.text = temp["venue"]["address"]["localized_address_display"].string ?? "Not clear!"
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
    }


}
