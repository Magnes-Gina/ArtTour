//
//  museumTableViewController.swift
//  ArtTour
//
//  Created by yikeren on 8/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import SwiftyJSON
import PINRemoteImage


class museumTableViewController: UITableViewController {

    var pagecount: Int?
    var jsonarray: [JSON]?
    var json: JSON?
    var count: Int?
    var nowpage = 1
    var resultText: String?
    var originalurl: String?
    let semaphore = DispatchSemaphore(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        print(pagecount!)
        print("the result is: \(resultText!)")
        self.navigationItem.title = resultText!
        count = jsonarray!.count
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return count!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "museumidentifier", for: indexPath) as! museumTableViewCell
        let temp = jsonarray![indexPath.row]
        if temp["media"][0]["thumbnail"]["uri"].string == nil {
            cell.imageview.image = UIImage(named: "singer.png")
            
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "mDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? mDetailViewController{
            
            let temp = jsonarray![(self.tableView.indexPathForSelectedRow?.row)!]
            destination.json = temp
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //
        if indexPath.row == count! - 1{
            if nowpage < pagecount!{
                nowpage += 1
                let pageString = "\(originalurl!)&page=\(nowpage)"
                getData(requestUrl: pageString)
                semaphore.wait()
                self.tableView.reloadData()
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
