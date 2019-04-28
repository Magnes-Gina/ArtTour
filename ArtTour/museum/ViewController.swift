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
    var oringinalurl = "https://collections.museumvictoria.com.au/api/search?query="
    var oringinalurl2 = " "
    var jsonarray: [JSON] = []
    var json: JSON?
    var count = 0
    let semaphore = DispatchSemaphore(value: 0)
    //let labelDector = vision.cloudLabelDector()
    //let cloud
    
    
    
    @IBOutlet weak var button_item: UIButton!
    
    
    @IBOutlet weak var button_landmark: UIButton!
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBAction func itemSearch(_ sender: Any) {
        islandmark = false
        popmenu()
    }
    
    
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
        print(resultsText)
        print(resultsText)
       
    }
    
    
    func getData(requestUrl: String){
        guard let downloadURL = URL(string: requestUrl) else { return }
        URLSession.shared.dataTask(with: downloadURL) { (data, urlResponse, error) in
            //CBToast.showToastAction(message: "Download Data!")
            guard let data = data, error == nil,urlResponse != nil else {
                print("wrong")
                return
            }
            do{
                let response = urlResponse as? HTTPURLResponse
                let pagestr = response?.allHeaderFields["Total-Pages"] as! String
                self.count = Int(pagestr)!
                self.json = try JSON(data: data)
                //self.jsonarray = self.jsonarray + self.json!.arrayValue
                self.jsonarray = []+self.json!.arrayValue
                self.semaphore.signal()
                print("the first page has items of \(self.jsonarray.count)")
            }catch let error as NSError{
                print("error: \(error)")
            }
            }.resume()
    }
    
    
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
        islandmark = true
        popmenu()
        
    }
    
    func detectCloudLabels(image: UIImage?) {
        guard let image = image else { return }
        
        // [START init_label_cloud]
        let labelDetector = vision.cloudLabelDetector()
        // Or, to change the default settings:
        // let labelDetector = Vision.vision().cloudLabelDetector(options: options)
        // [END init_label_cloud]
        // Define the metadata for the image.
        let imageMetadata = VisionImageMetadata()
        imageMetadata.orientation = UIUtilities.visionImageOrientation(from: image.imageOrientation)
        
        // Initialize a VisionImage object with the given UIImage.
        let visionImage = VisionImage(image: image)
        visionImage.metadata = imageMetadata
        
        // [START detect_label_cloud]
        labelDetector.detect(in: visionImage) { labels, error in
            guard error == nil, let labels = labels, !labels.isEmpty else {
                // [START_EXCLUDE]
                let errorString = error?.localizedDescription ?? Constants.detectionNoResultsMessage
                self.resultsText = "Cloud label detection failed with error: \(errorString)"
                self.showResult()
                // [END_EXCLUDE]
                return
            }
            
            // Labeled image
            // START_EXCLUDE
            /*self.resultsText = labels.map { label -> String in
                "Label: \(String(describing: label.label ?? "")), " +
                    "Confidence: \(label.confidence ?? 0), " +
                "EntityID: \(label.entityId ?? "")"
                }.joined(separator: "\n")*/
            print("the total result of labels is: \(labels.count)")
            for label in labels{
                let str = String(describing: label.label!)
                self.resultsText = str
                break
            }
            //self.showResult()
            let newstr = self.resultsText.replacingOccurrences(of: " ", with: "+")
            self.oringinalurl2 = self.oringinalurl+newstr
            print(self.oringinalurl)
            self.getData(requestUrl: self.oringinalurl2)
            self.semaphore.wait()
            self.jump()
            // [END_EXCLUDE]
        }
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.isHidden = true
        self.indicator.stopAnimating()
        self.button_landmark.layer.cornerRadius = 5
        self.button_item.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //
        super.viewWillAppear(animated)
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //
        super.viewWillDisappear(animated)
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? museumTableViewController{
            destination.jsonarray = self.jsonarray
            destination.pagecount = self.count
            destination.count = self.jsonarray.count
            destination.resultText = self.resultsText
            destination.originalurl = self.oringinalurl2
        }
    
    }
    
    func jump(){
        //self.semaphore.signal()
        self.indicator.isHidden = true
        self.indicator.stopAnimating()
        self.performSegue(withIdentifier: "mTable", sender: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //
        self.indicator.isHidden = false
        self.indicator.startAnimating()
        tempImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        //imageview.image = tempImage
        picker.dismiss(animated: true, completion: nil)
        if islandmark {
            detectCloudLandmark(image: tempImage)
            
        }else{
            //
            detectCloudLabels(image:tempImage)
            
            //detectCloudTexts(image:tempImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func popmenu()
    {
        let alertController = UIAlertController(title: nil,message:"Different Chocies for Image",preferredStyle: .actionSheet)
        
        //function for open image library, which get the idea from tutorial file
        let photoAction = UIAlertAction(title: "Photo by Image library", style: .default){
            (action) in
            
            self.picker.sourceType = .savedPhotosAlbum
            self.picker.allowsEditing = false
            self.picker.delegate = self
            self.present(self.picker, animated: true, completion: nil)
        }
        alertController.addAction(photoAction)
        
        //function for open camera, which get the idea from tutorial file
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

/*
 func detectCloudTexts(image: UIImage?) {
 guard let image = image else { return }
 
 // [START config_text_cloud]
 let options = VisionCloudDetectorOptions()
 options.modelType = .latest
 // options.maxResults has no effect with this API
 // [END config_text_cloud]
 // Define the metadata for the image.
 let imageMetadata = VisionImageMetadata()
 imageMetadata.orientation = UIUtilities.visionImageOrientation(from: image.imageOrientation)
 
 // Initialize a VisionImage object with the given UIImage.
 let visionImage = VisionImage(image: image)
 visionImage.metadata = imageMetadata
 
 // [START init_text_cloud]
 
 let cloudDetector = vision.cloudTextRecognizer()
 
 // Or, to use the default settings:
 // let textDetector = vision?.cloudTextDetector()
 // [END init_text_cloud]
 // [START detect_text_cloud]
 cloudDetector.process(visionImage) { texts, error in
 guard error == nil, let texts = texts else {
 // [START_EXCLUDE]
 let errorString = error?.localizedDescription ?? Constants.detectionNoResultsMessage
 self.resultsText = "Cloud text detection failed with error: \(errorString)"
 self.showResult()
 // [END_EXCLUDE]
 return
 }
 
 // Recognized and extracted text
 // [START_EXCLUDE]
 self.resultsText = texts.text ?? ""
 self.showResult()
 
 // [END_EXCLUDE]
 }
 // [END detect_text_cloud]
 }
 
 */



