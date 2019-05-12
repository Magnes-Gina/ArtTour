//
//  systemViewController.swift
//  ArtTour
//
//  Created by yikeren on 13/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class systemViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    let licences = ["License CC BY 4.0","License CC BY-SA 3.0"]
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var myswitch: UISwitch!
   
    @IBAction func closeNotification(_ sender: UISwitch) {
        if myswitch.isOn{
            print("open")
            UserDefaults.standard.set(false, forKey: "notify")
            displayMessage("You will recieve any notification when you close to landmarks and Artwroks","Alert")
        }else{
            print("close")
            UserDefaults.standard.set(true, forKey: "notify")
            displayMessage("You will not recieve any notification when you close to landmarks and Artwroks","Warning")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.isScrollEnabled = false
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        if !UserDefaults.standard.bool(forKey: "notify"){
            myswitch.isOn = true
        }else{
            myswitch.isOn = false
        }
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return licences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "licence", for: indexPath) as! licenceTableViewCell
        cell.nameLabel.text = licences[indexPath.row]
        cell.arrow.image = UIImage(named: "right-arrow-angle.png")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }

    func displayMessage(_ message: String,_ title: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:
            UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Open source licenses"
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
