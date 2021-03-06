//
//  revieweventViewController.swift
//  ArtTour
//
//  Created by yikeren on 29/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import CoreData

class revieweventViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    // set the number of cell will be display
    //if the table is empty, display placeholder text
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if events.count == 0 {
            self.myTableview.setEmptyView(title: "Find something to do!", message: "Nothing else planned...yet")
        }
        else {
            self.myTableview.restore()
        }
        return events.count
    }
    
    //custormise the cell of table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventreviewcell", for: indexPath) as! revieweventTableViewCell
        cell.addresslabel.text = events[indexPath.row].address
        cell.namelabel.text = events[indexPath.row].eventname
        cell.timelabel.text = events[indexPath.row].startdate
        if events[indexPath.row].imgurl == "none"{
            cell.logoimg.image = UIImage(named: "singer.png")
        }else{
            cell.logoimg.pin_setImage(from: URL(string: events[indexPath.row].imgurl!))
        }
        cell.logoimg.layer.masksToBounds = true
        cell.logoimg.layer.cornerRadius = 20
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            managedObjectContext.delete(events[(indexPath.row)])
            do{
                try managedObjectContext.save()
                getdata()
                self.myTableview.deleteRows(at: [indexPath], with: .automatic)
            }catch{
                fatalError("can not save to coredata")
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "revieweventdetail", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func getdata(){
        events = [Event2]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Event2")
        do {
            events = try managedObjectContext.fetch(fetchRequest) as! [Event2]
        }catch {
            fatalError("Fail to load list CoreData")
        }
    }

    
    var events = [Event2]()
    @IBOutlet weak var myTableview: UITableView!
    private var managedObjectContext: NSManagedObjectContext
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableview.delegate = self
        myTableview.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getdata()
        self.myTableview.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? revieweventdetailViewController{
            destination.event = events[(self.myTableview.indexPathForSelectedRow?.row)!]
        }
    }
 

}
