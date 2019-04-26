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
    
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var savedButton: UIButton!
    @IBAction func saved(_ sender: Any) {
    
    
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
        // Do any additional setup after loading the view.
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
