//
//  BusViewController.swift
//  bahon
//
//  Created by Arif Amzad on 5/12/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit
import Firebase

class BusViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signOutButton(_ sender: Any) {
        
                let firebaseAuth = Auth.auth()
                do {
                  try firebaseAuth.signOut()
                    
                    //performSegue(withIdentifier: "goToLogin", sender: self)

                    //let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //            var VC = (self.storyboard?.instantiateViewController(withIdentifier: "Login"))!
        //            self.navigationController?.pushViewController(VC, animated: true)

                    print("Signing out................................")
                } catch let signOutError as NSError {

                  print ("Error signing out: %@", signOutError)
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
