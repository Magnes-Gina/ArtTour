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
        if saved.count == 0 && saved2.count == 0 {
            self.myTableview.setEmptyView(title: "You havn't saved any landmarks.", message: "Please search landmarks and save first!")
        }
        else {
            self.myTableview.restore()
        }
        if section == 0{
            return saved2.count
        }else{
            return saved.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewlandmarkcell", for: indexPath) as! landmarkTableViewCell
        if indexPath.section == 1{
            cell.nameLabel.text = saved[indexPath.row].landmark_name
            for item in categorys{
                if saved[indexPath.row].category_id == item.category_id{
                    cell.categoryLabel.text = item.category_name
                    break
                }
            }
            if Int(saved2[indexPath.row].category_id) == 1{
                cell.cellimage.image = UIImage(named: "smallgallery.png")
            }
            if Int(saved2[indexPath.row].category_id) == 7{
                cell.cellimage.image  = UIImage(named: "smallpublicbuilding.png")
            }
        }else{
            cell.nameLabel.text = saved2[indexPath.row].artwork_name
            for item in categorys{
                if saved2[indexPath.row].category_id == item.category_id{
                    cell.categoryLabel.text = item.category_name
                    break
                }
            }
            if Int(saved[indexPath.row].category_id) == 8{
                cell.cellimage.image = UIImage(named: "smallsculpture.png")
            }
            if Int(saved[indexPath.row].category_id) == 6{
                cell.cellimage.image  = UIImage(named: "smallmemorial.png")
            }
            if Int(saved[indexPath.row].category_id) == 9{
                cell.cellimage.image  = UIImage(named: "smallfountain.png")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            self.performSegue(withIdentifier: "likeartwork", sender: self)
        }else{
            self.performSegue(withIdentifier: "reviewlandmarkdetail", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? reviewartworkdetailViewController{
            destination.categories = categorys
            destination.source = 1
            let temp1 = artworktemp(ArtWork_id: Int(saved2[(self.myTableview.indexPathForSelectedRow?.row)!].artwork_id), ArtWork_name: saved2[(self.myTableview.indexPathForSelectedRow?.row)!].artwork_name!, ArtWork_address: saved2[(self.myTableview.indexPathForSelectedRow?.row)!].artwork_address!, ArtWork_structure: saved2[(self.myTableview.indexPathForSelectedRow?.row)!].artwork_structure!, ArtWork_description: saved2[(self.myTableview.indexPathForSelectedRow?.row)!].artwork_description!, ArtWork_date: Int(saved2[(self.myTableview.indexPathForSelectedRow?.row)!].artwork_date), ArtWork_latitude: saved2[(self.myTableview.indexPathForSelectedRow?.row)!].artwork_latitude , ArtWork_longtitude: saved2[(self.myTableview.indexPathForSelectedRow?.row)!].artwork_longtitude, Artist_id: Int(saved2[(self.myTableview.indexPathForSelectedRow?.row)!].artist_id), Category_id: Int(saved2[(self.myTableview.indexPathForSelectedRow?.row)!].category_id))
            destination.artwork3 = saved2[(self.myTableview.indexPathForSelectedRow?.row)!]
            destination.artwork = temp1
        }
        if let destination = segue.destination as? reviewlandmarkdetailViewController{
            destination.categorys = categorys
            destination.source = 1
            let temp1 = Landmark(Landmark_id: Int(saved[(self.myTableview.indexPathForSelectedRow?.row)!].landmark_id), Landmark_name: saved[(self.myTableview.indexPathForSelectedRow?.row)!].landmark_name!, Landmark_latitude: saved[(self.myTableview.indexPathForSelectedRow?.row)!].landmark_latitude, Landmark_longtitude: saved[(self.myTableview.indexPathForSelectedRow?.row)!].landmark_longtitude, Category_id: Int(saved[(self.myTableview.indexPathForSelectedRow?.row)!].category_id), video: saved[(self.myTableview.indexPathForSelectedRow?.row)!].video!)
            destination.landmark3 = saved[(self.myTableview.indexPathForSelectedRow?.row)!]
            destination.landmark = temp1
        }
    }
    
    @IBOutlet weak var myTableview: UITableView!
    var saved = [LikeLandmark]()
    var saved2 = [LikeArtWork]()
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
        getdata2()
        //self.myTableview.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getdata()
        getdata3()
        self.myTableview.reloadData()
    }
    
    func getdata(){
        saved = [LikeLandmark]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LikeLandmark")
        do {
            saved = try managedObjectContext.fetch(fetchRequest) as! [LikeLandmark]
            print(saved.count)
        }catch {
            fatalError("Fail to load list CoreData")
        }
    }
    
    func getdata3(){
        saved2 = [LikeArtWork]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LikeArtWork")
        do {
            saved2 = try managedObjectContext.fetch(fetchRequest) as! [LikeArtWork]
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if indexPath.section == 1{
                managedObjectContext.delete(saved[(indexPath.row)])
            }else{
                managedObjectContext.delete(saved2[(indexPath.row)])

            }
            do{
                try managedObjectContext.save()
                getdata()
                getdata3()
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

