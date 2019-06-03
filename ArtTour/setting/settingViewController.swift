//
//  settingViewController.swift
//  ArtTour
//
//  Created by yikeren on 27/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import CoreData


class settingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    var landmarks = [Landmark]()
    var tempcats = [tempcat]()
    var artiststemp = [artisttemp]()
    var artworks = [artworktemp]()
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    // title and section for different table list
    let sections = ["Landmarks and Artworks","Events","Instruction","Setting"]
    let items = [["Visited","Favourite"],["Likes"],["Help"],["Setting"]]
    let images = [["hide.png","favourites.png"],["eventsetting.png"],["instructions.png"],["gear.png"]]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! settingTableViewCell
        cell.CellLable.text = items[indexPath.section][indexPath.row]
        cell.cellImage.image = UIImage(named: images[indexPath.section][indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 66
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    //different action for different table cell touch
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if items[indexPath.section][indexPath.row] == "Help"{
            self.performSegue(withIdentifier: "reins", sender: self)
        }
        if items[indexPath.section][indexPath.row] == "Visited" {
            self.performSegue(withIdentifier: "reviewlartwork", sender: self)
        }
        if items[indexPath.section][indexPath.row] == "Favourite" {
            self.performSegue(withIdentifier: "reviewlandmark", sender: self)
        }
        if items[indexPath.section][indexPath.row] == "Likes" {
            self.performSegue(withIdentifier: "reviewevent", sender: self)
        }
        if items[indexPath.section][indexPath.row] == "Setting" {
            self.performSegue(withIdentifier: "setting", sender: self)
        }
    }

    private var managedObjectContext: NSManagedObjectContext?
    
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    let semaphore = DispatchSemaphore(value: 0)
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        // Do any additional setup after loading the view.
        self.view.bringSubviewToFront(self.indicator)
        indicator.isHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //clear all the select when this view appear
        if let selectionIndexPath = self.myTableView.indexPathForSelectedRow{
            self.myTableView.deselectRow(at: selectionIndexPath, animated: true)
            
        }
    }
}
