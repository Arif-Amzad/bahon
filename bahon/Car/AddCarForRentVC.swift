//
//  CarDetailsViewController.swift
//  bahon
//
//  Created by Arif Amzad on 24/11/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit
import Firebase

class AddCarForRentVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var carImage: UIButton!
    
    @IBOutlet weak var anyMessage: UITextView!
    
    @IBOutlet weak var carModel: UITextField!
    
    @IBOutlet weak var regYear: UITextField!
    
    @IBOutlet weak var location: UITextField!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    let currentUser = Auth.auth().currentUser!
    
    let db = Database.database().reference()
    
    let storeRef = Storage.storage().reference()
    
    let imagePicker = UIImagePickerController()
    
    var userPickedImage: UIImage!
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.setNavigationBarHidden(false, animated: true)

        imagePicker.delegate = self
        
        viewSetup(colour: UIColor.darkGray, borderWidth: 1, cornerRadius: 5)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        print("=")
        print("=")
        print("=")
        print("=")
        print(userPickedImage)
        print("=")
        print("=")
        print("=")
        print("=")

    }
    
    
    
    @objc func keyboardWillShow(sender: NSNotification){
        
        self.view.frame.origin.y = -150
    }
    
    @objc func keyboardWillHide(sender: NSNotification){
        
        self.view.frame.origin.y = 0
    }
    
    
    
    func viewSetup(colour: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat){
        
        carModel.layer.borderColor = colour.cgColor
        
        carModel.layer.borderWidth = borderWidth
        
        carModel.layer.cornerRadius = cornerRadius
        
        regYear.layer.borderColor = colour.cgColor
        
        regYear.layer.borderWidth = borderWidth
        
        regYear.layer.cornerRadius = cornerRadius

        location.layer.borderColor = colour.cgColor
        
        location.layer.borderWidth = borderWidth
        
        location.layer.cornerRadius = cornerRadius
        
        anyMessage.layer.borderColor = colour.cgColor
            
        anyMessage.layer.borderWidth = borderWidth
        
        anyMessage.layer.cornerRadius = cornerRadius
    }
    
    
    //MARK:- Default source selection, camera or gallery
    func sourceSelectionForUploadingPhoto(){
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let alertController = UIAlertController.init(title: nil, message: "Device has no camera.", preferredStyle: .alert)

            let okAction = UIAlertAction.init(title: "Alright", style: .default, handler: {(alert: UIAlertAction!) in
            })

            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            imagePicker.sourceType = .photoLibrary
        }
        else {
            
            imagePicker.sourceType = .camera
        }
    }
    
        
    //MARK:- Picking image for profile photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
        if let userPicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            carImage.setImage(userPicked, for: .normal)
            
            print(info)
            
            userPickedImage = userPicked
            
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func selectCarImage(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func submitButton(_ sender: UIButton) {
                
        if !carModel.text!.isEmpty && !regYear.text!.isEmpty && !location.text!.isEmpty && userPickedImage != nil {
            
            
            let uuid = UUID().uuidString
            
            let locRef = self.db.child("carsForRent/\(self.currentUser.uid)/\(uuid)")
            
            let carImageRef = storeRef.child("images/carImages")
            
            if let data = userPickedImage.pngData() {
                
                let uploadUserProfileTask = carImageRef.child("\(uuid).png").putData(data, metadata: nil) { (metadata, error) in
                    
                    if error != nil {
                        
                        print("Error occured \(String(describing: error))")
                    }
                }
                
                _ = uploadUserProfileTask.observe(.progress) { (snapshot) in
                    
                    let percentComplete =  Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                    
                    self.progressBar.progress = Float(percentComplete)
                    
                    if Float(percentComplete) < 1.0 {
                        
                        self.navigationController?.navigationBar.isHidden = true
                    }
                    else {
                        
                        self.navigationController?.navigationBar.isHidden = false
                        
                        self.loadView()
                    }
                    print(percentComplete)
                }
            }
            
            locRef.child("carModel").setValue(carModel.text)
            
            locRef.child("regYear").setValue(regYear.text)
            
            locRef.child("location").setValue(location.text)
            
            locRef.child("message").setValue(anyMessage.text)
            
            showAlert(title: "Successful", message: "", style: 1)
            
            
            
            
            
            userPickedImage = nil
            
            viewSetup(colour: UIColor.darkGray, borderWidth: 1, cornerRadius: 5)
            
        }
        else{
            
            showAlert(title: "Error!", message: "Please Fill all value", style: 0)
        }
    }
    
    
    
    func showAlert(title: String, message: String, style: Int){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style(rawValue: style)!)
        
        self.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

            alert.dismiss(animated: true, completion: nil)
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
