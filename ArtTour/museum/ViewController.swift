//
//  ViewController.swift
//  ArtTour
//
//  Created by yikeren on 2/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class ViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    let picker = UIImagePickerController()
    var islandmark = true
    var tempImage = UIImage(named: "singer.png")
    lazy var vision = Vision.vision()
    var resultsText = ""
    //Rest API for victoria museum and you just add the key words you want to search after "query="
    var oringinalurl = "https://collections.museumvictoria.com.au/api/search?query="
    var oringinalurl2 = " "
    var jsonarray: [JSON] = []
    var json: JSON?
    var count = 0
    let semaphore = DispatchSemaphore(value: 0)

    @IBOutlet weak var button_item: UIButton!
    @IBOutlet weak var button_landmark: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBAction func itemSearch(_ sender: Any) {
        self.picker.sourceType = .savedPhotosAlbum
        self.picker.allowsEditing = false
        self.picker.delegate = self
        self.present(self.picker, animated: true, completion: nil)
    }
    
    //if the image recognition failed, show the inforamtion below
    private func showResult(){
        let resultAlertController = UIAlertController(title: "Detection Results", message: nil, preferredStyle: .actionSheet)
        resultAlertController.addAction(UIAlertAction(title: "OK, try again", style: .default) {_ in
            resultAlertController.dismiss(animated: true, completion: nil)
        })
        resultAlertController.addAction(UIAlertAction(title: "Find it on map", style: .default) {_ in
            self.tabBarController?.selectedIndex = 1
        })
        resultAlertController.message = resultsText
        self.indicator.isHidden = true
        self.indicator.stopAnimating()
        present(resultAlertController,animated: true,completion: nil)
    }
    
    //method for downloading data according to key word by image recognition
    func getData(requestUrl: String){
        guard let downloadURL = URL(string: requestUrl) else { return }
        URLSession.shared.dataTask(with: downloadURL) { (data, urlResponse, error) in
            guard let data = data, error == nil,urlResponse != nil else {
                print("wrong")
                return
            }
            do{
                let response = urlResponse as? HTTPURLResponse
                let pagestr = response?.allHeaderFields["Total-Pages"] as! String
                self.count = Int(pagestr)!
                self.json = try JSON(data: data)
                self.jsonarray = []+self.json!.arrayValue
                self.semaphore.signal()
                print("the first page has items of \(self.jsonarray.count)")
            }catch let error as NSError{
                print("error: \(error)")
            }
            }.resume()
    }
    
    //main method of image recognition, we sent the image to google server and get the result back
    func detectCloudLandmark(image: UIImage?)
    {
        guard let image = image else {return}
        let imageMetadata = VisionImageMetadata()
        imageMetadata.orientation = UIUtilities.visionImageOrientation(from: image.imageOrientation)
        let visionImage = VisionImage(image: image)
        visionImage.metadata = imageMetadata
        let cloudDetector = vision.cloudLandmarkDetector()
        cloudDetector.detect(in: visionImage) { landmarks,error in
            guard error == nil,let landmarks = landmarks, !landmarks.isEmpty else{
                let errorString = error?.localizedDescription ?? Constants.detectionNoResultsMessage
                self.resultsText = "landmark detection failed with error: \(errorString)"
                self.showResult()
                return
            }
            
            print(landmarks.count)
            for landmark in landmarks{
                let str = String(describing: landmark.landmark!)
                self.resultsText = str
            }
            //self.showResult()
            let newstr = self.resultsText.replacingOccurrences(of: " ", with: "+")
            self.oringinalurl2 = self.oringinalurl+newstr
            self.getData(requestUrl: self.oringinalurl2)
            self.semaphore.wait()
            self.jump()
        }
    }
    
    @IBAction func landmarkDetect(_ sender: Any) {
        popmenu()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.isHidden = true
        self.indicator.stopAnimating()
        self.button_landmark.layer.cornerRadius = 5
        //self.button_item.layer.cornerRadius = 5
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? museumresulttableViewController{
            destination.jsonarray = self.jsonarray
            destination.pagecount = self.count
            destination.count = self.jsonarray.count
            destination.resultText = self.resultsText
            destination.originalurl = self.oringinalurl2
            destination.tempphoto = tempImage
        }
    
    }
    
    func jump(){
        self.indicator.isHidden = true
        self.indicator.stopAnimating()
        self.performSegue(withIdentifier: "mTable", sender: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //
        self.indicator.isHidden = false
        self.indicator.startAnimating()
        tempImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
        detectCloudLandmark(image: tempImage)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //
        picker.dismiss(animated: true, completion: nil)
    }
    
    //pop menu for choose image library or camera
    func popmenu()
    {
        let alertController = UIAlertController(title: nil,message:"Select an image",preferredStyle: .actionSheet)
        
        //function for open image library
        let photoAction = UIAlertAction(title: "Photo by Image library", style: .default){
            (action) in
            
            self.picker.sourceType = .savedPhotosAlbum
            self.picker.allowsEditing = false
            self.picker.delegate = self
            self.present(self.picker, animated: true, completion: nil)
        }
        alertController.addAction(photoAction)
        
        //function for open camera
        let cameraAction = UIAlertAction(title: "Photo by Camera", style: .default){
            (action) in
            
            self.picker.sourceType = .camera
            self.picker.allowsEditing = false
            self.picker.delegate = self
            self.present(self.picker, animated: true, completion: nil)
            
        }
        alertController.addAction(cameraAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default){
            (action) in
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

private enum Constants {
    static let images = ["grace_hopper.jpg", "barcode_128.png", "qr_code.jpg", "beach.jpg",
                         "multi-face.png", "image_has_text.jpg"]
    static let modelExtension = "tflite"
    static let localModelName = "mobilenet"
    static let quantizedModelFilename = "mobilenet_quant_v1_224"
    
    static let detectionNoResultsMessage = "No results returned."
    static let failedToDetectObjectsMessage = "Failed to detect objects in image."
    
    static let labelConfidenceThreshold: Float = 0.75
    static let lineWidth: CGFloat = 3.0
    static let smallDotRadius: CGFloat = 5.0
    static let largeDotRadius: CGFloat = 10.0
    static let lineColor = UIColor.yellow.cgColor
    static let fillColor = UIColor.clear.cgColor
}
