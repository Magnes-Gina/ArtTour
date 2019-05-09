//
//  sortViewController.swift
//  ArtTour
//
//  Created by yikeren on 10/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
protocol Addsort {
    func addsort(newmood: String)
}

class sortViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var delegate: Addsort?
    var sortby = "Default"
    let str = ["Default","Date","Date(Reverse)","Distance","Distance(Reverse)"]
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return str.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sortcell") as! sortTableViewCell
        cell.sortLabel!.text = str[indexPath.row]
        if str[indexPath.row] == sortby{
            cell.sortLabel!.textColor = UIColor.red
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate!.addsort(newmood: str[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
