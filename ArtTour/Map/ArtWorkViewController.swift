//
//  ArtWorkViewController.swift
//  ArtTour
//
//  Created by yikeren on 27/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import CoreData

class ArtWorkViewController: UIViewController {

    var artwork: artworktemp?
    
    var saveds = [SavedArtWork]()
    
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBAction func moreAction(_ sender: Any) {
        if artwork!.ArtWork_description == "0"{
            displayMessage("This ArtWork Doesn't have more information", "Sorry")
        }else{
            UIApplication.shared.open(URL(string: "\(artwork!.ArtWork_description)")!, options: [:], completionHandler: nil)
        }
    }
    
    func loaddata(){
        if artwork!.Category_id == 8{
            profile.image = UIImage(named: "smallsculpture.png")
        }
        if artwork!.Category_id == 6{
            profile.image =  UIImage(named: "smallmemorial.png")
        }
        if artwork!.Category_id == 9{
            profile.image = UIImage(named: "smallfountain.png")
        }
        namelabel.text = artwork!.ArtWork_name
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Category")
        do{
            let temp = try managedObjectContext.fetch(fetchRequest) as! [Category]
            for item in temp{
                if artwork!.Category_id == Int(item.category_id){
                    categoryLabel.text = item.category_name
                    break
                }
            }
        }catch{
            fatalError("Fail to load CoreData")
        }
        
        addressLabel.text = artwork!.ArtWork_address
        let fetchRequest2 = NSFetchRequest<NSManagedObject>(entityName: "Artist")
        do{
            let temp2 = try managedObjectContext.fetch(fetchRequest2) as! [Artist]
            for item in temp2{
                if artwork!.Artist_id == Int(item.artist_id){
                    artistLabel.text = item.artist_name
                    break
                }
            }
        }catch{
            fatalError("Fail to load CoreData")
        }
        
        yearlabel.text = "\(artwork!.ArtWork_date)"
        if artwork!.ArtWork_date == 0{
            yearlabel.text = "Unkown"
        }
        structureLabel.text = artwork!.ArtWork_structure
    }
    
    @IBOutlet weak var profile: UIImageView!
    
    @IBOutlet weak var namelabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    
    @IBOutlet weak var yearlabel: UILabel!
    
    @IBOutlet weak var structureLabel: UILabel!
    
    var saved = false
    @IBOutlet weak var savedButton: UIButton!
    
    
    @IBAction func savedAction(_ sender: UIButton) {
        if !saved{
            //save
            let newartwork = NSEntityDescription.insertNewObject(forEntityName: "SavedArtWork", into: self.managedObjectContext) as! SavedArtWork
            newartwork.artwork_id = Int16(artwork!.ArtWork_id)
            print("find saved!\(artwork!.ArtWork_id)")
            newartwork.artwork_name = artwork?.ArtWork_name
            newartwork.artwork_address = artwork?.ArtWork_address
            newartwork.artwork_structure = artwork?.ArtWork_structure
            newartwork.artwork_description = artwork?.ArtWork_description
            newartwork.artwork_latitude = artwork!.ArtWork_latitude
            newartwork.artwork_longtitude = artwork!.ArtWork_longtitude
            newartwork.artist_id = Int16(artwork!.Artist_id)
            newartwork.category_id = Int16(artwork!.Category_id)
            newartwork.artwork_date = Int16(artwork!.ArtWork_date)
            //print(item.ArtWork_id)
            do{
                try self.managedObjectContext.save()
                saved = true
                savedButton.setTitle("Delete from list", for: .normal)
                savedButton.backgroundColor = UIColor.red
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedArtWork")
                saveds = try managedObjectContext.fetch(fetchRequest) as! [SavedArtWork]
                CBToast.showToastAction(message: "Save successfully!")
            }catch{
                fatalError("Fail to save CoreData")
            }
        }else{
            
            for item in saveds{
                if artwork?.ArtWork_id == Int(item.artwork_id){
                    print("want to delete")
                    managedObjectContext.delete(item)
                    do{
                        try self.managedObjectContext.save()
                        saved = false
                        savedButton.setTitle("Save to Visited", for: .normal)
                        savedButton.backgroundColor = UIColor.black
                        CBToast.showToastAction(message: "Delete successfully!")
                    }catch{
                        fatalError("Fail to save CoreData")
                    }
                    break
                }
            }
        }
    
    }
    
    @IBAction func backbutton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private var managedObjectContext: NSManagedObjectContext
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        check()
        loaddata()
    }
    
    func check(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedArtWork")
        do{
            saveds = try managedObjectContext.fetch(fetchRequest) as! [SavedArtWork]
            for item in saveds{
                if artwork!.ArtWork_id == Int(item.artwork_id){
                    saved = true
                    savedButton.setTitle("Delete from list", for: .normal)
                    savedButton.backgroundColor = UIColor.red
                    print("find saved!\(artwork!.ArtWork_id) and \(Int(item.artwork_id))")
                    break
                }
            }
        }catch{
            fatalError("Fail to load CoreData")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //check()
        savedButton.layer.cornerRadius = 5
        backButton.layer.cornerRadius = 25
        // Do any additional setup after loading the view.
    }
    
    func displayMessage(_ message: String,_ title: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:
            UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
