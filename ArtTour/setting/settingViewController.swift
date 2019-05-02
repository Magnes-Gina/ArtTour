//
//  settingViewController.swift
//  ArtTour
//
//  Created by yikeren on 27/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import CoreData


class settingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let url = URL(string: "https://k2r7nrgvl1.execute-api.ap-southeast-2.amazonaws.com/iteration1/landmark")
    let url2 = URL(string: "https://k2r7nrgvl1.execute-api.ap-southeast-2.amazonaws.com/iteration2/category")
    let url3 = URL(string: "https://k2r7nrgvl1.execute-api.ap-southeast-2.amazonaws.com/iteration2/artist")
    let url4 = URL(string: "https://k2r7nrgvl1.execute-api.ap-southeast-2.amazonaws.com/iteration2/artwork")
    var landmarks = [Landmark]()
    var tempcats = [tempcat]()
    var artiststemp = [artisttemp]()
    var artworks = [artworktemp]()
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let sections = ["Saved","Instruction","Refresh"]
    let items = [["Landmarks","ArtWorks","Events"],["InstructionPage"],["Reload"]]
    let images = [["landmarksetting.png","artworksetting.png","eventsetting.png"],["instructions.png"],["reloadsetting.png"]]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! settingTableViewCell
        cell.CellLable.text = items[indexPath.section][indexPath.row]
        cell.cellImage.image = UIImage(named: images[indexPath.section][indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 66
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if items[indexPath.section][indexPath.row] == "InstructionPage"{
            self.performSegue(withIdentifier: "reins", sender: self)
        }
        if items[indexPath.section][indexPath.row] == "Landmarks" {
            self.performSegue(withIdentifier: "reviewlandmark", sender: self)
        }
        if items[indexPath.section][indexPath.row] == "ArtWorks" {
            self.performSegue(withIdentifier: "reviewlartwork", sender: self)
        }
        if items[indexPath.section][indexPath.row] == "Events" {
            self.performSegue(withIdentifier: "reviewevent", sender: self)
        }
        if items[indexPath.section][indexPath.row] == "Reload" {
            indicator.isHidden = false
            indicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            getData()
            semaphore.wait()
            UIApplication.shared.endIgnoringInteractionEvents()
            CBToast.showToastAction(message: "Refresh Map landmarks and artwork data!")
            indicator.isHidden = true
            indicator.stopAnimating()
            /*UIApplication.shared.open(URL(string: "http://www.google.com/maps/dir/?api=1&origin=-37.886561,145.091904&destination=-37.885062,145.078586&travelmode=driving")!, options: [:], completionHandler: nil)*/
            
        }
    }

    private var managedObjectContext: NSManagedObjectContext?
    
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    let semaphore = DispatchSemaphore(value: 0)
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        // Do any additional setup after loading the view.
        self.view.bringSubviewToFront(self.indicator)
        indicator.isHidden = true
        //UIApplication.shared.beginIgnoringInteractionEvents()
        //UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func getData(){
        guard let downloadURL = url else { return }
        URLSession.shared.dataTask(with: downloadURL) { (data, urlResponse, error) in
            //CBToast.showToastAction(message: "Download Data!")
            guard let data = data, error == nil,urlResponse != nil else {
                print("wrong")
                return
            }
            do{
                self.landmarks = try JSONDecoder().decode([Landmark].self,from: data)
                let fetchrequestT = NSFetchRequest<NSFetchRequestResult>(entityName: "Landmark2")
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchrequestT)
                try self.managedObjectContext?.execute(batchDeleteRequest)
                for item in self.landmarks{
                    let newlandmark = NSEntityDescription.insertNewObject(forEntityName: "Landmark2", into: self.managedObjectContext!) as! Landmark2
                    newlandmark.landmark_id = Int16(item.Landmark_id)
                    newlandmark.landmark_name = item.Landmark_name
                    newlandmark.landmark_latitude = item.Landmark_latitude
                    newlandmark.landmark_longtitude = item.Landmark_longtitude
                    newlandmark.category_id = Int16(item.Category_id)
                    newlandmark.video = item.video
                    try self.managedObjectContext?.save()
                    
                }
                self.getData2()
                
            }catch let error as NSError{
                print("error: \(error)")
            }
            }.resume()
    }
    
    func getData2(){
        guard let downloadURL = url2 else { return }
        URLSession.shared.dataTask(with: downloadURL) { (data, urlResponse, error) in
            //CBToast.showToastAction(message: "Download Data!")
            guard let data = data, error == nil,urlResponse != nil else {
                print("wrong")
                return
            }
            do{
                self.tempcats = try JSONDecoder().decode([tempcat].self,from: data)
                let fetchrequestT = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchrequestT)
                try self.managedObjectContext?.execute(batchDeleteRequest)
                for item in self.tempcats{
                    let newCategory = NSEntityDescription.insertNewObject(forEntityName: "Category", into: self.managedObjectContext!) as! Category
                    newCategory.category_id = Int16(item.Category_id)
                    newCategory.category_name = item.Category_name
                    try self.managedObjectContext?.save()
                    
                }
                self.getData3()
                
            }catch let error as NSError{
                print("error: \(error)")
            }
            }.resume()
    }
    
    func getData3(){
        guard let downloadURL = url3 else { return }
        URLSession.shared.dataTask(with: downloadURL) { (data, urlResponse, error) in
            //CBToast.showToastAction(message: "Download Data!")
            guard let data = data, error == nil,urlResponse != nil else {
                print("wrong")
                return
            }
            do{
                self.artiststemp = try JSONDecoder().decode([artisttemp].self,from: data)
                let fetchrequestT = NSFetchRequest<NSFetchRequestResult>(entityName: "Artist")
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchrequestT)
                try self.managedObjectContext?.execute(batchDeleteRequest)
                for item in self.artiststemp{
                    let newArtist = NSEntityDescription.insertNewObject(forEntityName: "Artist", into: self.managedObjectContext!) as! Artist
                    newArtist.artist_id = Int16(item.Artist_id)
                    newArtist.artist_name = item.Artist_name
                    //print(item.Artist_id)
                    try self.managedObjectContext?.save()
                    
                }
                self.getData4()
                
            }catch let error as NSError{
                print("error: \(error)")
            }
            }.resume()
    }
    
    func getData4(){
        guard let downloadURL = url4 else { return }
        URLSession.shared.dataTask(with: downloadURL) { (data, urlResponse, error) in
            //CBToast.showToastAction(message: "Download Data!")
            guard let data = data, error == nil,urlResponse != nil else {
                print("wrong")
                return
            }
            do{
                self.artworks = try JSONDecoder().decode([artworktemp].self,from: data)
                let fetchrequestT = NSFetchRequest<NSFetchRequestResult>(entityName: "ArtWork")
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchrequestT)
                try self.managedObjectContext?.execute(batchDeleteRequest)
                for item in self.artworks{
                    let newartwork = NSEntityDescription.insertNewObject(forEntityName: "ArtWork", into: self.managedObjectContext!) as! ArtWork
                    newartwork.artwork_id = Int16(item.ArtWork_id)
                    newartwork.artwork_name = item.ArtWork_name
                    newartwork.artwork_address = item.ArtWork_address
                    newartwork.artwork_structure = item.ArtWork_structure
                    newartwork.artwork_description = item.ArtWork_description
                    newartwork.artwork_latitude = item.ArtWork_latitude
                    newartwork.artwork_longtitude = item.ArtWork_longtitude
                    newartwork.artist_id = Int16(item.Artist_id)
                    newartwork.category_id = Int16(item.Category_id)
                    newartwork.artwork_date = Int16(item.ArtWork_date)
                    //print(item.ArtWork_id)
                    try self.managedObjectContext?.save()
                    
                }
                self.semaphore.signal()
            }catch let error as NSError{
                print("error: \(error)")
            }
            }.resume()
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
