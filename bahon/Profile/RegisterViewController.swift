//
//  RegisterViewController.swift
//  bahon
//
//  Created by Arif Amzad on 19/11/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    let userDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        
        guard let name = name.text else{return}
        
        guard let email = email.text else{return}
        
        guard let password = password.text else{return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            if error == nil {
                
                let db = Database.database().reference()
                
                let currentUser = Auth.auth().currentUser!
            
                db.child("users/\(currentUser.uid)/name").setValue(name)
                
                self.performSegue(withIdentifier: "afterSignUp", sender: self)
            }
            else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                               
                 alertController.addAction(defaultAction)
                
                 self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func sendDataToDatabase(){
        
        
        
        //let dictonary = ["name": "\(name.text ?? "user name")"]
        
//        db.child(currentUser).setValue(dictonary) {(error, reference) in
//
//            if error == nil {
//
//                print("Data successfully added to database")
//            }
//            else {
//                print("error \(String(describing: error))")
//            }
//
//        }
        
    
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
