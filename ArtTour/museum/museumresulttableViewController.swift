//
//  museumresulttableViewController.swift
//  ArtTour
//
//  Created by yikeren on 8/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import SwiftyJSON
import PINRemoteImage


class museumresulttableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var pagecount: Int?
    var jsonarray: [JSON]?
    var json: JSON?
    var json2: JSON?
    var count: Int?
    var nowpage = 1
    var resultText: String?
    var originalurl: String?
    var tempphoto: UIImage?
    var des : String = "Unkown"{
        didSet{
            self.descriptionLabel.text = des
        }
    }
    let semaphore = DispatchSemaphore(value: 0)
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var titlelabel: UILabel!
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        print(pagecount!)
        print("the result is: \(resultText!)")
        self.titlelabel.text = resultText!
        count = jsonarray!.count
        self.photo.image = tempphoto!
        getData2()
        print(3333)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getData(requestUrl: String){
        
        guard let downloadURL = URL(string: requestUrl) else { return }
        URLSession.shared.dataTask(with: downloadURL) { (data, urlResponse, error) in
            //CBToast.showToastAction(message: "Download Data!")
            guard let data = data, error == nil,urlResponse != nil else {
                print("wrong")
                return
            }
            do{
                self.json = try JSON(data: data)
                self.count = self.count!+self.json!.count
                self.jsonarray = self.jsonarray! + self.json!.arrayValue
                //self.jsonarray = []+self.json!.arrayValue
                self.semaphore.signal()
                print("the first page has items of \(self.jsonarray!.count)")
            }catch let error as NSError{
                print("error: \(error)")
            }
            }.resume()
    }
    
    func getData2(){
        let stryrl = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&titles=\(self.resultText!)"
        let newstr = stryrl.replacingOccurrences(of: " ", with: "+")
        guard let downloadURL = URL(string: newstr) else {
                print(55555)
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
                            self.des = subjson["extract"].string!
                        }
                    }
                    
                }else{
                    print(self.json2!["query"]["pages"]["-1"]["title"].string!)
                }
            }catch let error as NSError{
                print("error: \(error)")
            }
            }.resume()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return count!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Articles, items related to this landmark"
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "museumidentifier", for: indexPath) as! museumTableViewCell
        let temp = jsonarray![indexPath.row]
        if temp["media"][0]["thumbnail"]["uri"].string == nil {
            cell.imageview.image = UIImage(named: "404-permalink.png")
            
        }else{
            cell.imageview.pin_setImage(from: URL(string: temp["media"][0]["thumbnail"]["uri"].string!))
        }
        cell.imageview.layer.masksToBounds = true
        cell.imageview.layer.cornerRadius = 20
        cell.title.text = temp["displayTitle"].string!
        cell.type.text = temp["recordType"].string!.uppercased()
        switch cell.type.text!{
        case "article".uppercased():
            cell.type.textColor = UIColor.blue
            break
        case "item".uppercased():
            cell.type.textColor = UIColor.red
            break
        case "specimen".uppercased():
            cell.type.textColor = UIColor.purple
            break
        case "species".uppercased():
            cell.type.textColor = UIColor.green
            break
        default:
            break
        }
        if temp["dateModified"].string == nil {
            cell.dateModified.text = "Not Clear"
            
        }else{
            var strtemp = temp["dateModified"].string!
            strtemp = strtemp.replacingOccurrences(of: "T", with: " ")
            strtemp = strtemp.replacingOccurrences(of: "Z", with: "")
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let datetemp = df.date(from: strtemp)
            let df2 = DateFormatter()
            df2.dateFormat = "MMM dd yyyy HH:mm:ss"
            let newstr = df2.string(from: datetemp!)
            cell.dateModified.text = newstr
            //cell.dateModified.text = temp["dateModified"].string!
        }
        // Configure the cell...
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "mDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? mDetailViewController{
            
            let temp = jsonarray![(self.myTableView.indexPathForSelectedRow?.row)!]
            destination.json = temp
        }
        if let destination = segue.destination as? descriptionViewController{
            destination.desString = self.descriptionLabel.text!
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //
        if indexPath.row == count! - 1{
            if nowpage < pagecount!{
                nowpage += 1
                let pageString = "\(originalurl!)&page=\(nowpage)"
                getData(requestUrl: pageString)
                semaphore.wait()
                self.myTableView.reloadData()
            }
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
