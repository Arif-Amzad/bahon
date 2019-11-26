//
//  AppDelegate.swift
//  bahon
//
//  Created by Arif Amzad on 17/11/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let userDefaults = UserDefaults.standard

    var newViewController: UIViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
    
        FirebaseApp.configure()
        
        Database.database().isPersistenceEnabled = true
        
        //setRootViewController()
        
        window?.makeKeyAndVisible()
        //Switcher.updateRootVC()
            
        return true
    }
    
    
    
    func setRootViewController() {
                
        if Auth.auth().currentUser == nil {  //user exist
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginNav")
            
            self.window?.rootViewController = vc
            
            newViewController = vc
            
            //UIApplication.shared.keyWindow?.rootViewController = vc
            
            print("-----N---O--------U---S---E---R---1--- ")

        }
        else {
            
            print("-----U---S---E---R---------E---X---I---S---T------ ")
            print((Auth.auth().currentUser?.uid)!)


        }
    }

    
    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
}


extension AppDelegate {
   static var shared: AppDelegate {
      return UIApplication.shared.delegate as! AppDelegate
   }
var rootViewController: UIViewController {
      return window!.rootViewController as! LoginViewController
   }
}



//        if Auth.auth().currentUser != nil {
//          var VC = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! UITabBarController
//          self.navigationController?.pushViewController(VC, animated: true)
//        }
