//
//  mapDetailViewController.swift
//  ArtTour
//
//  Created by yikeren on 16/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView
import CoreData

class mapDetailViewController: UIViewController {

    
    var landmark: Landmark?
    var saveds = [SavedLandmark]()
    
    var saved = false
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var savedButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func saved(_ sender: Any) {
        if !saved{
            //save
            let newlandmark = NSEntityDescription.insertNewObject(forEntityName: "SavedLandmark", into: self.managedObjectContext) as! SavedLandmark
            newlandmark.landmark_id = Int16(landmark!.Landmark_id)
            newlandmark.landmark_name = landmark!.Landmark_name
            newlandmark.landmark_latitude = landmark!.Landmark_latitude
            newlandmark.landmark_longtitude = landmark!.Landmark_longtitude
            newlandmark.category_id = Int16(landmark!.Category_id)
            newlandmark.video = landmark!.video
            do{
                try self.managedObjectContext.save()
                saved = true
                savedButton.setTitle("Delete from list", for: .normal)
                savedButton.backgroundColor = UIColor.red
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedLandmark")
                saveds = try managedObjectContext.fetch(fetchRequest) as! [SavedLandmark]
                CBToast.showToastAction(message: "Save successfully!")
            }catch{
                fatalError("Fail to save CoreData")
            }
        }else{
            
            for item in saveds{
                if landmark?.Landmark_id == Int(item.landmark_id){
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
    
    @IBOutlet weak var youtube: WKYTPlayerView!
    @IBOutlet weak var landmark_name: UILabel!
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    
    private var managedObjectContext: NSManagedObjectContext
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        youtube.load(withVideoId: landmark!.video)
        landmark_name.text = landmark!.Landmark_name
        getCategroy()
        self.backButton.layer.cornerRadius = 25
        self.savedButton.layer.cornerRadius = 5
        //check()
        // Do any additional setup after loading the view.
    }
    
    func check(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedLandmark")
        do{
            saveds = try managedObjectContext.fetch(fetchRequest) as! [SavedLandmark]
            for item in saveds{
                if landmark?.Landmark_id == Int(item.landmark_id){
                    saved = true
                    savedButton.setTitle("Delete from list", for: .normal)
                    savedButton.backgroundColor = UIColor.red
                    print("find saved!")
                    break
                }
            }
        }catch{
            fatalError("Fail to load CoreData")
        }
    }
    
    func getCategroy(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Category")
        do {
            let tempCat = try managedObjectContext.fetch(fetchRequest) as! [Category]
            for item in tempCat{
                if landmark!.Category_id == Int(item.category_id) {
                    categoryLabel.text = "Category: \(item.category_name!)"
                    break
                }
                
            }
        }
        catch {
            fatalError("Fail to load list CoreData")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //
        super.viewWillAppear(animated)
        check()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //
        super.viewWillDisappear(animated)
    
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
