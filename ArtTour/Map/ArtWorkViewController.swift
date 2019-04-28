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
    
    var saved = false
    @IBOutlet weak var savedButton: UIButton!
    
    
    @IBAction func savedAction(_ sender: UIButton) {
        if !saved{
            //save
            let newartwork = NSEntityDescription.insertNewObject(forEntityName: "SavedArtWork", into: self.managedObjectContext) as! SavedArtWork
            newartwork.artwork_id = Int16(artwork!.ArtWork_id)
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
                savedButton.setTitle("Cancell Save", for: .normal)
                savedButton.backgroundColor = UIColor.lightGray
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedArtWork")
                saveds = try managedObjectContext.fetch(fetchRequest) as! [SavedArtWork]
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
    }
    
    func check(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedArtWork")
        do{
            saveds = try managedObjectContext.fetch(fetchRequest) as! [SavedArtWork]
            for item in saveds{
                if artwork!.ArtWork_id == Int(item.artwork_id){
                    saved = true
                    savedButton.setTitle("Cancell Save", for: .normal)
                    savedButton.backgroundColor = UIColor.lightGray
                    print("find saved!")
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
        // Do any additional setup after loading the view.
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
