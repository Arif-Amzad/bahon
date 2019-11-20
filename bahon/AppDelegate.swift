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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        setRootViewController()

        window?.makeKeyAndVisible()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        //setRootViewController()
    }

    
    func setRootViewController() {
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
    
        if Auth.auth().currentUser != nil {  //user exist
            
            let nav = storyboard.instantiateViewController(withIdentifier: "signUpID")
            
            self.window?.rootViewController = nav
            
            print("-----U---S---E---R---------E---X---I---S---T------ ")
            print(Auth.auth().currentUser?.uid as Any)
        }
        else {
            
            let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginStoryboardId") as! LoginViewController
            //self.setRootViewController(vc, animated: true, completion: nil)
            
            //navigationController.viewControllers = [vc]
            //self.window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
            
            print("-----N---O--------U---S---E---R---1--- ")
            print(Auth.auth().currentUser?.uid as Any)

        }
    }

}


extension AppDelegate {
   static var shared: AppDelegate {
      return UIApplication.shared.delegate as! AppDelegate
   }
var rootViewController: ViewController {
      return window!.rootViewController as! ViewController
   }
}

