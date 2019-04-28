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
        if saved.count == 0 {
            self.myTableview.setEmptyView(title: "You don't visit any artworks.", message: "Please save some artworks first.")
        }
        else {
            self.myTableview.restore()
        }
        return saved.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //reviewartworkcell
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewartworkcell", for: indexPath) as! reviewartworkTableViewCell
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
        
        if Int(saved[indexPath.row].category_id) == 7{
            cell.imagecell.image  = UIImage(named: "smallpublicbuilding.png")
        }
        if Int(saved[indexPath.row].category_id) == 6{
            cell.imagecell.image  = UIImage(named: "smallmemorial.png")
        }
        if Int(saved[indexPath.row].category_id) == 5{
            cell.imagecell.image  = UIImage(named: "smallindigenous.png")
        }
        if Int(saved[indexPath.row].category_id) == 4{
            cell.imagecell.image  = UIImage(named: "smallfountain.png")
        }
        if Int(saved[indexPath.row].category_id) == 3{
            cell.imagecell.image  = UIImage(named: "smallbell.png")
        }
        return cell
    }
    

    
    @IBOutlet weak var myTableview: UITableView!
    var saved = [SavedArtWork]()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "reviewartworkDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? reviewartworkdetailViewController{
            //
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
        self.separatorStyle = .singleLine
    }
}
