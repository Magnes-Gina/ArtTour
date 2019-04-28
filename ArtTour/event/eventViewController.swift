//
//  eventViewController.swift
//  ArtTour
//
//  Created by yikeren on 6/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import PINRemoteImage



class eventViewController: UIViewController,Addmood {

    //@IBOutlet weak var imagetest: UIImageView!
    
    
    @IBAction func cancellAction(_ sender: Any) {
        animatedOut()
    }
    
    
    
    @IBAction func anytimeAction(_ sender: Any) {
        eventtime = "Anytime"
        timeLabel.text = eventtime
        animatedOut()
    }
    
    
    @IBAction func confirmAction(_ sender: Any) {
        //eventtime = String(datePicker.date)
        let df = DateFormatter()
        df.dateFormat = "MMM dd yyyy"
        
        eventtime = df.string(from: datePicker.date)
        print(eventtime)
        timeLabel.text = eventtime
        animatedOut()
    }
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet var myView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var moodLabel: UILabel!
    
    @IBOutlet weak var search: UIButton!
    
    @IBAction func find(_ sender: Any) {
       
        self.performSegue(withIdentifier: "eventresult", sender: self)

    }
    
    var mood = "Anything"
    var eventtime = "Anytime"
    
    func addmood(newmood: String){
        self.mood = newmood
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search.layer.cornerRadius = 5
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.openmood))
        self.moodLabel.addGestureRecognizer(gesture)
        self.moodLabel.isUserInteractionEnabled = true
        self.timeLabel.isUserInteractionEnabled = true
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(self.opendatepicker))
        self.timeLabel.addGestureRecognizer(gesture2)
        self.myView.layer.cornerRadius = 10
        myView.layer.shadowColor = UIColor.gray.cgColor
        myView.layer.shadowOpacity = 1.0
        myView.layer.shadowRadius = 7.0
        myView.layer.masksToBounds = false
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Date().addingTimeInterval(604800)
        //self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        //imagetest.sd_setImage(with: URL(string: "https://img.evbuc.com/https%3A%2F%2Fcdn.evbuc.com%2Fimages%2F56937365%2F250209674674%2F1%2Foriginal.20190217-034235?auto=compress&s=8abc34ce344398c198193afc468dc0fa  "),placeholderImage:UIImage(named: "singer.png"))
        //imagetest.sd_setImage
        // Do any additional setup after loading the view.
       
        //imagetest.pin_updateWithProgress = true
        //imagetest.pin_setImage(from: URL(string:"https://img.evbuc.com/https%3A%2F%2Fcdn.evbuc.com%2Fimages%2F56937365%2F250209674674%2F1%2Foriginal.20190217-034235?auto=compress&s=8abc34ce344398c198193afc468dc0fa"))
    }
    
    @objc func openmood(sender: UITapGestureRecognizer){
        self.performSegue(withIdentifier: "moodsegue", sender: self)
    }
    
    @objc func opendatepicker(sender: UITapGestureRecognizer){
        //
        animatedin()
    }
    
    func animatedin()
    {
        self.view.addSubview(myView)
        myView.center = self.view.center
        myView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        myView.alpha = 0
        UIView.animate(withDuration: 0.4){
            self.myView.alpha = 1
            self.myView.transform = CGAffineTransform.identity
        }
    }
    
    func animatedOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.myView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.myView.alpha = 0
        }){(success:Bool) in
            self.myView.removeFromSuperview()
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        timeLabel.text = eventtime
        moodLabel.text = mood
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moodsegue"{
            let controller: moodViewController = segue.destination as! moodViewController
            controller.delegate = self
        }
        if segue.identifier == "eventresult"{
            let destination: eventTableViewController = segue.destination as! eventTableViewController
            print(eventtime)
            if eventtime != "Anytime"{
                let df = DateFormatter()
                df.dateFormat = "MMM dd yyyy"
                var newdate = df.date(from: eventtime)
                newdate = newdate?.addingTimeInterval(86400)
                let df2 = DateFormatter()
                df2.dateFormat = "yyyy-MM-dd"
                var datestr = df2.string(from: newdate!)
                datestr = "start_date.range_end=" + datestr + "T00:00:00"
                destination.time = datestr
            }
            if mood != "Anything"{
                switch mood{
                case "Music":
                    destination.mood = "categories=103"
                case "Business & Professional":
                    destination.mood = "categories=101"
                case "Food & Drink":
                    destination.mood = "categories=110"
                case "Comunnity & Culture":
                    destination.mood = "categories=113"
                case "Performing & Visual Arts":
                    destination.mood = "categories=105"
                case "Film & Entertainment":
                    destination.mood = "categories=103"
                case "Sports":
                    destination.mood = "categories=104"
                case "Health & Wellness":
                    destination.mood = "categories=107"
                case "Science & Technology":
                    destination.mood = "categories=102"
                case "Travel & Outdoor":
                    destination.mood = "categories=109"
                case "Charity & Causes":
                    destination.mood = "categories=111"
                case "Religion":
                    destination.mood = "categories=114"
                case "Family & Education":
                    destination.mood = "categories=115"
                case "Holiday":
                    destination.mood = "categories=116"
                case "Politics":
                    destination.mood = "categories=112"
                case "Fashion & Beauty":
                    destination.mood = "categories=106"
                case "Home":
                    destination.mood = "categories=117"
                case "Boat & Air":
                    destination.mood = "categories=118"
                case "Hobbies":
                    destination.mood = "categories=119"
                case "School Activities":
                    destination.mood = "categories=120"
                case "Other":
                    destination.mood = "categories=199"
                default:
                    destination.mood = "Anything"
                }
            }
            
        }
    }
 

}
