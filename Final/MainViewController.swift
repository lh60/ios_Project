//
//  MainViewController.swift
//  Final
//
//  Created by Lily on 12/14/21.
//

import UIKit
import CoreML
import Vision // change formate for swift to read

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate { // calling imports

    
    //Steps to implement a delegate:
    //1. create an object
    let imagePicker = UIImagePickerController()
    
    let result : [VNClassificationObservation] = []  // an empty array with type VNClassificationObservation

    @IBOutlet weak var imageView: UIImageView!
    
    
    // links to about page
    @IBAction func goAbout() {

            guard let vc = storyboard?.instantiateViewController(withIdentifier: "about_vc")as? AboutViewController else {
                    return
            }
            //gets rid of the default apple presentation thing, it does not fill the screen
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            
            present(vc, animated: true, completion: nil)

    }
    
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        //3. Implement its functions
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                
                present(imagePicker, animated: true, completion: nil)
                
                
            }
            
            
            override func viewDidLoad() {
                    super.viewDidLoad()
                    //2. Initialize the delegate in View Did load
                    imagePicker.delegate = self //self create spreate objects
                    
                }
                

            //selecting the image to put to the screen
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
                //1.Select the image
                if let image = info[.originalImage]as? UIImage{
                    
                    //Display the selected image on the screen
                    imageView.image = image //who.what = value
                    
                    //Dismiss imagePicker after capturing the image
                    imagePicker.dismiss(animated: true, completion: nil)
                    
                    //2.Convert this image from UImage data type into CIImage
                    guard let ciImage = CIImage(image: image) else {return}
                    
                    //3.Detect (CIImage)
                    detect(image : ciImage)
                }
            }
                    
                
                
                
                //Detect function:
                //1.Model
                //2.Request
                //3.Result
                //4.Handler

                
                func detect(image : CIImage){
                    //intialize Model
                    if let model = try? VNCoreMLModel(for : trashorNo().model){
                        
                        //Request the Result
                        let request = VNCoreMLRequest(model: model, completionHandler: { (request,error) in
                            
                            //Results 
                            guard let results = request.results as? [VNClassificationObservation],let topResult = results.first else{return}
                            
                            if topResult.identifier.contains("cardboard"){
                                
                                //main thread
                                DispatchQueue.main.async {
                                    self.navigationItem.title = "Cardboard"
                                }
                            }
                            else if topResult.identifier.contains("glass"){
                                DispatchQueue.main.async {
                                    self.navigationItem.title = "Glass"
                                }
                            }
                            else if topResult.identifier.contains("metal"){
                                DispatchQueue.main.async {
                                    self.navigationItem.title = "Metal"
                                }
                            }
                            else if topResult.identifier.contains("paper"){
                                DispatchQueue.main.async {
                                    self.navigationItem.title = "Paper"
                                }
                            }
                            else if topResult.identifier.contains("plastic"){
                                DispatchQueue.main.async {
                                    self.navigationItem.title = "Plastic"
                                }
                            }
                            else {
                                DispatchQueue.main.async {
                                    self.navigationItem.title = "Trash"
                                }
                            }
                        
                    })
                        
                    //Handler
                    let handler = VNImageRequestHandler(ciImage : image)
                    do {
                        try handler.perform([request])
                    }
                    
                    catch{
                        print(error)
                    }
                    
            }
            
        }
}

