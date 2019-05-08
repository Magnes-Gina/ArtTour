//
//  CollectionProgressViewController.swift
//  ArtTour
//
//  Created by yikeren on 27/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import CoreData

class CollectionProgressViewController: UIViewController {

    @IBOutlet var collectionOuterView: UIView!
    @IBOutlet weak var landmarkLabel: UILabel!
    @IBOutlet weak var artworkLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    var effect:UIVisualEffect!
    
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    var totalsavedLandmark = 0
    var totalsavedArtwork = 0
    var totallandmark = 0
    var totalartwork = 0
    
    private var managedObjectContext: NSManagedObjectContext
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(backButton)
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        collectionOuterView.layer.cornerRadius = 15
        collectionOuterView.layer.shadowColor = UIColor.gray.cgColor
        collectionOuterView.layer.shadowOpacity = 1.0
        collectionOuterView.layer.shadowRadius = 7.0
        collectionOuterView.layer.masksToBounds = false
        check1()
        check2()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animatedIn()
    }
    
    func animatedIn(){
        self.view.addSubview(collectionOuterView)
        collectionOuterView.center = self.view.center
        collectionOuterView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        collectionOuterView.alpha = 0
        UIView.animate(withDuration: 0.5){
            self.visualEffectView.effect = self.effect
            self.collectionOuterView.alpha = 1
            self.collectionOuterView.transform = CGAffineTransform.identity
        }
    }
    
    func check1(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedLandmark")
        let fetchRequest2 = NSFetchRequest<NSManagedObject>(entityName: "Landmark2")
        do{
            let saveds = try managedObjectContext.fetch(fetchRequest) as! [SavedLandmark]
            let saveds2 = try managedObjectContext.fetch(fetchRequest2) as! [Landmark2]
            totalsavedLandmark = saveds.count
            totallandmark = saveds2.count
            landmarkLabel.text = "\(totalsavedLandmark) out of \(totallandmark) Landmarks"
        }catch{
            fatalError("cant load core data")
        }
    }
    
    func check2(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedArtWork")
        let fetchRequest2 = NSFetchRequest<NSManagedObject>(entityName: "ArtWork")
        do{
            let saveds = try managedObjectContext.fetch(fetchRequest) as! [SavedArtWork]
            let saveds2 = try managedObjectContext.fetch(fetchRequest2) as! [ArtWork]
            totalsavedArtwork = saveds.count
            totalartwork = saveds2.count
            artworkLabel.text = "\(totalsavedArtwork) out of \(totalartwork) ArtWorks"
        }catch{
            fatalError("cant load core data")
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
