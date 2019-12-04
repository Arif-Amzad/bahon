//
//  ProfileViewController.swift
//  bahon
//
//  Created by Arif Amzad on 3/12/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userEmail: UILabel!
        
    @IBOutlet weak var addressBox: UITextField!
    
    @IBOutlet weak var phoneBox: UITextField!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var imageButtonOutlet: UIButton!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    var count: Int = 0
    
    let db = Database.database().reference().child("users")
    
    let currentUser = Auth.auth().currentUser!
    
    let imagePicker = UIImagePickerController()
    
    let storeRef = Storage.storage().reference()

    var userDefaults = UserDefaults.standard
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        loadProfileSettings()
        
        loadProfile()
    }
    
    
    //MARK:- Getting ready the view
    func loadProfile(){
        
        let email = Auth.auth().currentUser?.email
        
        db.child(currentUser.uid).observeSingleEvent(of: .value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            self.userName.text = value!["name"] as? String
            
            self.userEmail.text = email
            
            self.addressBox.text = value!["address"] as? String
            
            self.phoneBox.text = value!["phone"] as? String
            
            let profileImageRef = self.storeRef.child("images/profileImage/\(self.currentUser.uid).png")
            
            profileImageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                
                if error == nil {
                    
                    let image = UIImage(data: data!)
                    
                    self.imageButtonOutlet.setImage(image, for: .normal)
                    
                    //self.imageButtonOutlet.setBackgroundImage(image, for: .normal)
                    
                    print("Image showed")
                }
                else{
                    
                    let alert = UIAlertController(title: "No internet Connection", message: "", preferredStyle: .alert)
                    
                    self.present(alert, animated: true)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

                        alert.dismiss(animated: true, completion: nil)
                    }
                    
                    print("Image showing error\(String(describing: error))")
                }
            }
        }
    }
    
    
    
    func loadProfileSettings(){
        
        imagePicker.allowsEditing = false
        
        addressBox.isUserInteractionEnabled = false
        
        phoneBox.isUserInteractionEnabled = false
        
        imageButtonOutlet.layer.cornerRadius = 0
        
        imageButtonOutlet.layer.borderWidth = 3
        
        imageButtonOutlet.layer.borderColor = UIColor.darkGray.cgColor
        
        imageButtonOutlet.frame = CGRect(x: 120, y: 120, width: 120, height: 120)
        
        imageButtonOutlet.clipsToBounds = true
        
        imageButtonOutlet.layer.cornerRadius = 0.5 * imageButtonOutlet.bounds.size.width
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
                
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            imageButtonOutlet.setImage(userPickedImage, for: .normal)
            
            let userProfileRef = storeRef.child("images/profileImage")
            
            if let data = userPickedImage.pngData() {
                
                let uploadUserProfileTask = userProfileRef.child("\(currentUser.uid).png").putData(data, metadata: nil) { (metadata, error) in
                    
                    if error != nil {
                        
                        print("Error occured \(String(describing: error))")
                    }
                    
//                    guard let metadata = metadata else { print("Error occured\(error)")
//                        return
//                    }
                    //print("download url for profile is \(metadata)")
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
            print(info)
            
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //MARK:- Buttons action of the view
    @IBAction func addImageButton(_ sender: Any) {
        
        //defaultSourceSelection()
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func updateInfo(_ sender: UIButton) {
                
        if (count == 0 || count % 2 == 0) && count != 1 {
            
            editButton.setTitle("Update Info", for: .normal)
            
            editButton.backgroundColor = UIColor.red
        
            addressBox.isUserInteractionEnabled = true
            
            phoneBox.isUserInteractionEnabled = true
            
            addressBox.borderStyle = .roundedRect
            
            phoneBox.borderStyle = .roundedRect

            count = count + 1
        }
        else {
            
            editButton.setTitle("Edit Info", for: .normal)
            
            editButton.backgroundColor = UIColor.darkGray
            
            addressBox.isUserInteractionEnabled = false
            
            phoneBox.isUserInteractionEnabled = false
            
            addressBox.borderStyle = .none
            
            phoneBox.borderStyle = .none

            count = count + 1
            
            db.child("\(currentUser.uid)/phone").setValue(phoneBox.text)
            
            db.child("\(currentUser.uid)/address").setValue(addressBox.text)
        }
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


