//
//  ProfileViewController.swift
//  bahon
//
//  Created by Arif Amzad on 3/12/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userEmail: UILabel!
        
    @IBOutlet weak var addressBox: UITextField!
    
    @IBOutlet weak var phoneBox: UITextField!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var imageButtonOutlet: UIButton!
    
    var count: Int = 0
    
    let db = Database.database().reference().child("users")
    
    let currentUser = Auth.auth().currentUser
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProfile()
        
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = false
        
        addressBox.isUserInteractionEnabled = false
        
        phoneBox.isUserInteractionEnabled = false
    }
    
    
    
    func loadProfile(){
        
        let uid = (Auth.auth().currentUser?.uid)!
        
        let email = Auth.auth().currentUser?.email
        
        let db = Database.database().reference().child("users").child(uid)
        
        db.observeSingleEvent(of: .value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            print(value!)
            
            self.userName.text = value!["name"] as? String
            
            self.userEmail.text = email
            
            self.addressBox.text = value!["address"] as? String
            
            self.phoneBox.text = value!["phone"] as? String
        }
        
    }
    
    
    func defaultSourceSelection(){
        
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
    
    
    
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        
        

    }
    
        
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imageName = UUID().uuidString
        
        let storageRef = Storage.storage().reference().child("\(imageName).png")
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            imageButtonOutlet.setImage(userPickedImage, for: .normal)
            
            
            if let uploadData = userPickedImage.pngData() {
                 
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if error != nil {
                         
                        print("error")
                    }
                    else {
                         
                         print("===========metaData \(metadata)")
                    }
                }
             }
            
            print(info)
            
            imagePicker.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    
    
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

            count = count + 1
            
        }
        else {
            
            editButton.setTitle("Edit Info", for: .normal)
            
            editButton.backgroundColor = UIColor.darkGray
            
            addressBox.isUserInteractionEnabled = false
            
            phoneBox.isUserInteractionEnabled = false

            count = count + 1
            
            db.child("\(currentUser!.uid)/phone").setValue(phoneBox.text)
            
            db.child("\(currentUser!.uid)/address").setValue(addressBox.text)
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
