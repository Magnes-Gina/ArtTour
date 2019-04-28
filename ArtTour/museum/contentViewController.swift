//
//  contentViewController.swift
//  ArtTour
//
//  Created by yikeren on 28/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class contentViewController: UIViewController {

    
    @IBOutlet weak var contentText: UITextView!
    
    var str = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentText.isEditable = false
        contentText.attributedText = str.htmlToAttributedString
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

extension String{
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else {return NSAttributedString()}
        do{
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
    
    var htmlToString: String{
        return htmlToAttributedString?.string ?? ""
    }
}
