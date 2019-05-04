//
//  reviewlandmarkViewController.swift
//  ArtTour
//
//  Created by yikeren on 27/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import CoreData

class reviewlandmarkViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if saved.count == 0 {
            self.myTableview.setEmptyView(title: "You havn't saved any landmarks.", message: "Please search landmarks and save first!")
        }
        else {
            self.myTableview.restore()
        }
        
        return saved.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewlandmarkcell", for: indexPath) as! landmarkTableViewCell
        cell.nameLabel.text = saved[indexPath.row].landmark_name
        for item in categorys{
            if saved[indexPath.row].category_id == item.category_id{
                cell.categoryLabel.text = item.category_name
                break
            }
        }
        if Int(saved[indexPath.row].category_id) == 9{
            cell.cellimage.image = UIImage(named: "shrine-remembrance.png")
        }
        
        if Int(saved[indexPath.row].category_id) == 2{
            cell.cellimage.image  = UIImage(named: "smallbridge.png")
        }
        if Int(saved[indexPath.row].category_id) == 1{
            cell.cellimage.image  = UIImage(named: "smallgallery.png")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "reviewlandmarkdetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? reviewlandmarkdetailViewController{
            
            destination.landmark = saved[(self.myTableview.indexPathForSelectedRow?.row)!]
            destination.categorys = categorys
            
        }
    }
    
    @IBOutlet weak var myTableview: UITableView!
    var saved = [SavedLandmark]()
    var categorys = [Category]()
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
        getdata()
        getdata2()
        //self.myTableview.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getdata()
        self.myTableview.reloadData()
    }
    
    func getdata(){
        saved = [SavedLandmark]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedLandmark")
        do {
            saved = try managedObjectContext.fetch(fetchRequest) as! [SavedLandmark]
            print(saved.count)
        }catch {
            fatalError("Fail to load list CoreData")
        }
    }
    
    func getdata2(){
        categorys = [Category]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Category")
        do {
            categorys = try managedObjectContext.fetch(fetchRequest) as! [Category]
        }catch {
            fatalError("Fail to load list CoreData")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            managedObjectContext.delete(saved[(indexPath.row)])
            do{
                try managedObjectContext.save()
                getdata()
                self.myTableview.deleteRows(at: [indexPath], with: .automatic)
            }catch{
                fatalError("can not save to coredata")
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
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

