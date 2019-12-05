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
    
    @IBOutlet weak var rent: UITextField!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    let currentUser = Auth.auth().currentUser!
    
    let db = Database.database().reference()
    
    let storeRef = Storage.storage().reference()
    
    let imagePicker = UIImagePickerController()
    
    var userPickedImage: UIImage!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        viewSetup(colour: UIColor.darkGray, borderWidth: 1, cornerRadius: 5)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        print("=")
        print("=")
        print("=")
        print("=")
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
        
        rent.layer.borderColor = colour.cgColor
        
        rent.layer.borderWidth = borderWidth
        
        rent.layer.cornerRadius = cornerRadius
        
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
            
            userPickedImage = userPicked.resizeWithWidth(width: 359)!
            
            carImage.backgroundColor = UIColor.white
            
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func selectCarImage(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func submitButton(_ sender: UIButton) {
        
        let db = Database.database().reference().child("carsForRentAll")
        
        db.removeAllObservers()
                
        if !carModel.text!.isEmpty && !regYear.text!.isEmpty && !location.text!.isEmpty && !rent.text!.isEmpty && userPickedImage != nil {
            
            
            let uuid = UUID().uuidString
            
            let myCarsLoc = self.db.child("myCarsForRent/\(self.currentUser.uid)/\(uuid)")
            
            let allRentCarLoc = self.db.child("carsForRentAll/\(uuid)")
            
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
                        
                    }
                    print(percentComplete)
                }
            }
            
            showAlert(title: "Successful", message: "", style: 1)
            
            myCarsLoc.child("carModel").setValue(carModel.text)
            
            myCarsLoc.child("regYear").setValue(regYear.text)
            
            myCarsLoc.child("location").setValue(location.text)
            
            myCarsLoc.child("message").setValue(anyMessage.text)
            
            myCarsLoc.child("availability").setValue("available")

            myCarsLoc.child("rent").setValue(rent.text)
            
            allRentCarLoc.child("carModel").setValue(carModel.text)
            
            allRentCarLoc.child("regYear").setValue(regYear.text)
            
            allRentCarLoc.child("location").setValue(location.text)
            
            allRentCarLoc.child("message").setValue(anyMessage.text)

            allRentCarLoc.child("availability").setValue("available")
            
            allRentCarLoc.child("rent").setValue(rent.text)
            
            
            userPickedImage = nil
            
            self.loadView()
            
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




extension UIImage {
    
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        
        imageView.contentMode = .scaleAspectFit
        
        imageView.image = self
        
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        imageView.layer.render(in: context)
        
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        
        UIGraphicsEndImageContext()
        
        return result
    }
    
    
    
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        
        imageView.contentMode = .scaleAspectFit
        
        imageView.image = self
        
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        imageView.layer.render(in: context)
        
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        
        UIGraphicsEndImageContext()
        
        return result
    }
}
