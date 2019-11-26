//
//  Switcher.swift
//  bahon
//
//  Created by Arif Amzad on 26/11/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Switcher{
    
    static func updateRootVC(){
        
        var rootVC: UIViewController?
        
        if Auth.auth().currentUser != nil {
            
            //rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ID") as! ViewController
            print("User Exist")
        }
        
        else {
            
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Login") as! LoginViewController
            
            print("No user")
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = rootVC
    }
}
