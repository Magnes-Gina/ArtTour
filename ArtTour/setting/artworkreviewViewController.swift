//
//  artworkreviewViewController.swift
//  ArtTour
//
//  Created by yikeren on 28/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import CoreData

class artworkreviewViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if saved.count == 0 && saved2.count == 0{
            self.myTableview.setEmptyView(title: "You havn't visitd any Landmarks or artworks.", message: "Please find them on our Art Map")
        }
        else {
            self.myTableview.restore()
        }
        if section == 0{
            return saved.count
        }else{
            return saved2.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //reviewartworkcell
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewartworkcell", for: indexPath) as! reviewartworkTableViewCell
        if indexPath.section == 0{
            cell.nameLabel.text = saved[indexPath.row].artwork_name
            for item in categorys{
                if saved[indexPath.row].category_id == item.category_id{
                    cell.categoryLabel.text = item.category_name
                    break
                }
            }
            if Int(saved[indexPath.row].category_id) == 8{
                cell.imagecell.image = UIImage(named: "smallsculpture.png")
            }
            if Int(saved[indexPath.row].category_id) == 6{
                cell.imagecell.image  = UIImage(named: "smallmemorial.png")
            }
            if Int(saved[indexPath.row].category_id) == 9{
                cell.imagecell.image  = UIImage(named: "smallfountain.png")
            }
        }else{
            cell.nameLabel.text = saved2[indexPath.row].landmark_name
            for item in categorys{
                if saved2[indexPath.row].category_id == item.category_id{
                    cell.categoryLabel.text = item.category_name
                    break
                }
            }
            if Int(saved2[indexPath.row].category_id) == 1{
                cell.imagecell.image = UIImage(named: "smallgallery.png")
            }
            if Int(saved2[indexPath.row].category_id) == 7{
                cell.imagecell.image  = UIImage(named: "smallpublicbuilding.png")
            }
        }
        return cell
    }
    

    
    @IBOutlet weak var myTableview: UITableView!
    var saved = [SavedArtWork]()
    var saved2 = [SavedLandmark]()
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
        //getdata()
        getdata2()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getdata()
        getdata3()
        self.myTableview.reloadData()
    }
    
    func getdata(){
        saved = [SavedArtWork]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedArtWork")
        do {
            saved = try managedObjectContext.fetch(fetchRequest) as! [SavedArtWork]
            print(saved.count)
        }catch {
            fatalError("Fail to load list CoreData")
        }
    }
    
    func getdata3(){
        saved2 = [SavedLandmark]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedLandmark")
        do {
            saved2 = try managedObjectContext.fetch(fetchRequest) as! [SavedLandmark]
        
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
            if indexPath.section == 0{
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            self.performSegue(withIdentifier: "reviewartworkDetail", sender: self)
        }else{
            self.performSegue(withIdentifier: "visitlandmark", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? reviewartworkdetailViewController{
            destination.categories = categorys
            destination.source = 0
            let temp1 = artworktemp(ArtWork_id: Int(saved[(self.myTableview.indexPathForSelectedRow?.row)!].artwork_id), ArtWork_name: saved[(self.myTableview.indexPathForSelectedRow?.row)!].artwork_name!, ArtWork_address: saved[(self.myTableview.indexPathForSelectedRow?.row)!].artwork_address!, ArtWork_structure: saved[(self.myTableview.indexPathForSelectedRow?.row)!].artwork_structure!, ArtWork_description: saved[(self.myTableview.indexPathForSelectedRow?.row)!].artwork_description!, ArtWork_date: Int(saved[(self.myTableview.indexPathForSelectedRow?.row)!].artwork_date), ArtWork_latitude: saved[(self.myTableview.indexPathForSelectedRow?.row)!].artwork_latitude , ArtWork_longtitude: saved[(self.myTableview.indexPathForSelectedRow?.row)!].artwork_longtitude, Artist_id: Int(saved[(self.myTableview.indexPathForSelectedRow?.row)!].artist_id), Category_id: Int(saved[(self.myTableview.indexPathForSelectedRow?.row)!].category_id))
            destination.artwork2 = saved[(self.myTableview.indexPathForSelectedRow?.row)!]
            destination.artwork = temp1
        }
        if let destination = segue.destination as? reviewlandmarkdetailViewController{
            destination.categorys = categorys
            destination.source = 0
            let temp1 = Landmark(Landmark_id: Int(saved2[(self.myTableview.indexPathForSelectedRow?.row)!].landmark_id), Landmark_name: saved2[(self.myTableview.indexPathForSelectedRow?.row)!].landmark_name!, Landmark_latitude: saved2[(self.myTableview.indexPathForSelectedRow?.row)!].landmark_latitude, Landmark_longtitude: saved2[(self.myTableview.indexPathForSelectedRow?.row)!].landmark_longtitude, Category_id: Int(saved2[(self.myTableview.indexPathForSelectedRow?.row)!].category_id), video: saved2[(self.myTableview.indexPathForSelectedRow?.row)!].video!)
            destination.landmark2 = saved2[(self.myTableview.indexPathForSelectedRow?.row)!]
            destination.landmark = temp1
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

extension UITableView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}
