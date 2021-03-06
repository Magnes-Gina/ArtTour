//
//  ReInstructionViewController.swift
//  ArtTour
//
//  Created by yikeren on 27/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class ReInstructionViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    var images: [String] = ["guide4.jpeg","guide1.jpeg","guide3.jpeg","guide2.jpeg"]
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }

}
