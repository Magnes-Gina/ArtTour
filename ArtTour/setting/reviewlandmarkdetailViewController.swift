//
//  reviewlandmarkdetailViewController.swift
//  ArtTour
//
//  Created by yikeren on 29/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView
import CoreData

class reviewlandmarkdetailViewController: UIViewController {

    @IBOutlet weak var youtubeView: WKYTPlayerView!
    
    @IBOutlet weak var namelabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deletefromlist(_ sender: Any) {
        if source! == 0{
            managedObjectContext.delete(landmark2!)
            do{
                try managedObjectContext.save()
                self.navigationController?.popViewController(animated: true)
            }catch{
                fatalError("can not delete")
            }
        }else{
            managedObjectContext.delete(landmark3!)
            do{
                try managedObjectContext.save()
                self.navigationController?.popViewController(animated: true)
            }catch{
                fatalError("can not delete")
            }
        }
        
    }
    
    var landmark:Landmark?
    var landmark2:SavedLandmark?
    var landmark3: LikeLandmark?
    var categorys: [Category]?
    var source: Int?;
    private var managedObjectContext: NSManagedObjectContext
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        namelabel.text = landmark?.Landmark_name
        for item in categorys!{
            if Int(item.category_id) == landmark?.Category_id {
                categoryLabel.text = item.category_name!
                break
            }
        }
        let splits = landmark!.video.components(separatedBy: ";")
        
        youtubeView.load(withVideoId: splits[0])
        self.deleteButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        check()
    }
    
    func check(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedLandmark")
        do {
            let saved = try managedObjectContext.fetch(fetchRequest) as! [SavedLandmark]
            var boolflag = true
            for item in saved{
                if Int(landmark!.Landmark_id) == Int(item.landmark_id){
                    boolflag = false
                    break
                }
            }
            if boolflag{
                self.navigationController?.popViewController(animated: true)
                CBToast.showToastAction(message: "This landmark is deleted ")
            }
        }
        catch {
            fatalError("Fail to load list CoreData")
        }
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
