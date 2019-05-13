//
//  moodViewController.swift
//  ArtTour
//
//  Created by yikeren on 28/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

protocol Addmood {
    func addmood(newmood: String)
}

class moodViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moodcell") as! moodTableViewCell
        cell.moodLabel.text = items[indexPath.row]
        return cell
    }
    
    var items = ["Anything","Music","Comunnity & Culture","Performing & Visual Arts","Film & Entertainment","Sports","Travel & Outdoor","Religion","Family & Education","Holiday","Fashion & Beauty","Home","Boat & Air","Hobbies","Other"]
    
    var delegate: Addmood?
    
    @IBOutlet weak var myTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableview.delegate = self
        myTableview.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate!.addmood(newmood: items[indexPath.row])
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
