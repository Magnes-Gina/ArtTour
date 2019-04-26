//
//  testViewController.swift
//  ArtTour
//
//  Created by yikeren on 8/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import CoreData
struct tempcat: Decodable {
    let Category_id: Int
    let Category_name: String
}

struct artisttemp: Decodable {
    let artist_id: Int
    let artist_name: String
}

struct artworktemp: Decodable{
    let artwork_id: Int
    let artwork_name: String
    let artwork_address: String
    let artwork_structure: String
    let artwork_description: String
    let artwork_date: Int
    let artwork_latitude: Double
    let artwork_longtitude: Double
    let artist_id: Int
    let Category_id: Int
}

class testViewController: UIViewController,UIScrollViewDelegate{

    let url = URL(string: "https://k2r7nrgvl1.execute-api.ap-southeast-2.amazonaws.com/iteration1/landmark")
    let url2 = URL(string: "https://k2r7nrgvl1.execute-api.ap-southeast-2.amazonaws.com/iteration2/category")
    let url3 = URL(string: "https://k2r7nrgvl1.execute-api.ap-southeast-2.amazonaws.com/iteration2/artist")
    let url4 = URL(string: "https://k2r7nrgvl1.execute-api.ap-southeast-2.amazonaws.com/iteration2/artwork")
    var landmarks = [Landmark]()
    var tempcats = [tempcat]()
    var artiststemp = [artisttemp]()
    var artworks = [artworktemp]()
    
    private var managedObjectContext: NSManagedObjectContext?
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    var images: [String] = ["guide1.jpeg","guide2.jpeg","guide3.jpeg"]
    var frame = CGRect(x:0,y:0,width: 0,height: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.numberOfPages = images.count
        for index in 0..<images.count{
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            let imgView = UIImageView(frame: frame)
            imgView.image = UIImage(named: images[index])
            self.scrollView.addSubview(imgView)
        }
        // Do any additional setup after loading the view.
        scrollView.contentSize = CGSize(width:(scrollView.frame.size.width * CGFloat(images.count)),height: scrollView.frame.size.height)
        scrollView.delegate = self
        self.view.sendSubviewToBack(scrollView)
        getData()
        getData2()
    }
    //test
    
    
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
                for item in self.tempcats{
                    let newCategory = NSEntityDescription.insertNewObject(forEntityName: "Category", into: self.managedObjectContext!) as! Category
                    newCategory.category_id = Int16(item.Category_id)
                    newCategory.category_name = item.Category_name
                    try self.managedObjectContext?.save()
                }
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
                for item in self.artiststemp{
                    let newArtist = NSEntityDescription.insertNewObject(forEntityName: "Artist", into: self.managedObjectContext!) as! Artist
                    newArtist.artist_id = Int16(item.artist_id)
                    newArtist.artist_name = item.artist_name
                    try self.managedObjectContext?.save()
                }
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
                for item in self.artworks{
                    let newartwork = NSEntityDescription.insertNewObject(forEntityName: "ArtWork", into: self.managedObjectContext!) as! ArtWork
                    newartwork.artwork_id = Int16(item.artwork_id)
                    newartwork.artwork_name = item.artwork_name
                    newartwork.artwork_address = item.artwork_address
                    newartwork.artwork_structure = item.artwork_structure
                    newartwork.artwork_description = item.artwork_description
                    newartwork.artwork_latitude = item.artwork_latitude
                    newartwork.artwork_longtitude = item.artwork_longtitude
                    newartwork.artist_id = Int16(item.artist_id)
                    newartwork.category_id = Int16(item.Category_id)
                    newartwork.artwork_date = Int16(item.artwork_date)
                    try self.managedObjectContext?.save()
                }
            }catch let error as NSError{
                print("error: \(error)")
            }
            }.resume()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //
        var pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
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
