//
//  reviewartworkdetailViewController.swift
//  ArtTour
//
//  Created by yikeren on 29/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import CoreData

class reviewartworkdetailViewController: UIViewController {

    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var profileimg: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var categorylabel: UILabel!
    @IBOutlet weak var addresslabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var structurelabel: UILabel!
    
    
    @IBAction func moreaction(_ sender: Any) {
        if artwork!.ArtWork_description == "0"{
            displayMessage("This Artwork doesn't have anny more information", "Sorry")
        }else{
            print(artwork!.ArtWork_description)
            UIApplication.shared.open(URL(string: "\(artwork!.ArtWork_description)")!, options: [:], completionHandler: nil)
        }
    }
    
    func displayMessage(_ message: String,_ title: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:
            UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func deleteaction(_ sender: Any) {
        if source! == 0{
            managedObjectContext.delete(artwork2!)
            do{
                try managedObjectContext.save()
                self.navigationController?.popViewController(animated: true)
            }catch{
                fatalError("can not delete")
            }
        }else{
            managedObjectContext.delete(artwork3!)
            do{
                try managedObjectContext.save()
                self.navigationController?.popViewController(animated: true)
            }catch{
                fatalError("can not delete")
            }
        }
        
    }
    
    func check(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedArtWork")
        do {
            let saved = try managedObjectContext.fetch(fetchRequest) as! [SavedArtWork]
            var boolflag = true
            for item in saved{
                if Int(artwork!.ArtWork_id) == Int(item.artwork_id){
                    boolflag = false
                    break
                }
            }
            if boolflag{
                self.navigationController?.popViewController(animated: true)
                CBToast.showToastAction(message: "This artwork is deleted ")
            }
        }
        catch {
            fatalError("Fail to load list CoreData")
        }
    }
    
    var artists: [Artist]?
    var categories: [Category]?
    var artwork: artworktemp?
    var artwork2: SavedArtWork?
    var artwork3: LikeArtWork?
    var source: Int?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deleteButton.layer.cornerRadius = 5
        if Int(artwork!.Category_id) == 8{
            profileimg.image = UIImage(named: "smallsculpture.png")
        }
        if Int(artwork!.Category_id) == 7{
            profileimg.image = UIImage(named: "smallpublicbuilding.png")
        }
        if Int(artwork!.Category_id) == 6{
            profileimg.image =  UIImage(named: "smallmemorial.png")
        }
        if Int(artwork!.Category_id) == 5{
            profileimg.image =  UIImage(named: "smallindigenous.png")
        }
        if Int(artwork!.Category_id) == 4{
            profileimg.image = UIImage(named: "smallfountain.png")
        }
        if Int(artwork!.Category_id) == 3{
            profileimg.image = UIImage(named: "smallbell.png")
        }
        getArtist()
        for item in categories!{
            if item.category_id == artwork!.Category_id{
                categorylabel.text = item.category_name!
                break
            }
        }
        if Int(artwork!.ArtWork_date) == 0{
            datelabel.text = "Unknown"
        }else{
            datelabel.text = "\(Int(artwork!.ArtWork_date))"
        }
        structurelabel.text = artwork!.ArtWork_structure
        addresslabel.text = artwork!.ArtWork_address
        namelabel.text = artwork!.ArtWork_name
        // Do any additional setup after loading the view.
    }
    
    func getArtist(){
        let fetchRequest2 = NSFetchRequest<NSManagedObject>(entityName: "Artist")
        do{
            artists = try managedObjectContext.fetch(fetchRequest2) as! [Artist]
            for item in artists!{
                if Int(artwork!.Artist_id) == Int(item.artist_id){
                    artistLabel.text = item.artist_name
                    break
                }
            }
        }catch{
            fatalError("Fail to load CoreData")
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
