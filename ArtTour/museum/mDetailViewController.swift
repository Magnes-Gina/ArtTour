//
//  mDetailViewController.swift
//  ArtTour
//
//  Created by yikeren on 8/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import SwiftyJSON
import PINRemoteImage

class mDetailViewController: UIViewController {

    var json: JSON?
    
    
    @IBAction func readmore(_ sender: Any) {
        self.performSegue(withIdentifier: "contentSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? contentViewController{
            destination.str = newstr
        }
    }
    
    
    
    @IBOutlet weak var contentimage: UIImageView!
    @IBOutlet weak var displaytitle: UILabel!
    @IBOutlet weak var datemodified: UILabel!
    @IBOutlet weak var recordtype: UILabel!
    @IBOutlet weak var authors: UILabel!
   
    @IBOutlet weak var content: UILabel!
    @IBAction func backbutton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var backbuttonItem: UIButton!
    var newstr = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backbuttonItem.layer.cornerRadius = (self.backbuttonItem.frame.height / 2)
        if json!["media"][0]["medium"]["uri"].string == nil{
            contentimage.image = UIImage(named: "404-permalink.png")
        }else{
            contentimage.pin_setImage(from: URL(string: json!["media"][0]["medium"]["uri"].string!))
        }
        displaytitle.text = json!["displayTitle"].string!
        recordtype.text = json!["recordType"].string!.uppercased()
        switch recordtype.text{
        case "article".uppercased():
            recordtype.textColor = UIColor.blue
            break
        case "item".uppercased():
            recordtype.textColor = UIColor.red
            break
        case "specimen".uppercased():
            recordtype.textColor = UIColor.purple
            break
        case "species".uppercased():
            recordtype.textColor = UIColor.green
            break
        default:
            break
        }
        if json!["content"].string != nil {
            newstr = json!["content"].string!
        }else if json!["objectSummary"].string != nil{
            newstr = json!["objectSummary"].string!
        }else if json!["biology"].string != nil{
            newstr = json!["biology"].string!
        }else{
            newstr = "No Description"
        }
        content.attributedText = newstr.htmlToAttributedString
        var str = ""
        if json!["authors"].count != 0 {
            for n in 0...json!["authors"].count{
                str = str + " " + json!["authors"][n]["fullName"].string!
                if n == (json!["authors"].count - 1){
                    break
                }
            }
            authors.text = str
        }else{
            authors.text = "Not Clear"
        }
        if json!["dateModified"].string == nil{
            datemodified.text = "Not Clear"
        }else{
            var strtemp = json!["dateModified"].string!
            strtemp = strtemp.replacingOccurrences(of: "T", with: " ")
            strtemp = strtemp.replacingOccurrences(of: "Z", with: "")
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let datetemp = df.date(from: strtemp)
            let df2 = DateFormatter()
            df2.dateFormat = "MMM dd yyyy HH:mm:ss"
            let newstr = df2.string(from: datetemp!)
            datemodified.text = newstr
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
