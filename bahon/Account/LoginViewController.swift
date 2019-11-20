//
//  LoginViewController.swift
//  bahon
//
//  Created by Arif Amzad on 19/11/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    
    @IBOutlet weak var loginEmail: UITextField!
    
    @IBOutlet weak var loginPassword: UITextField!
    
    //let user: String = ""
    
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
    }
    
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        guard let email = loginEmail.text else {return}
        
        guard let password = loginPassword.text else {return}
        
        
        
        
        Auth.auth().signIn(withEmail: email, password: password) {(user, error) in
            
            if error == nil {
                
                self.performSegue(withIdentifier: "log2home", sender: self)
            }
            else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                               
                 alertController.addAction(defaultAction)
                 self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func signUpButton(_ sender: Any) {
        
        //performSegue(withIdentifier: "signIn2Up", sender: self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    

}
