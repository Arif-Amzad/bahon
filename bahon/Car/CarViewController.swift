//
//  CarViewController.swift
//  bahon
//
//  Created by Arif Amzad on 18/11/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit
import Firebase

class CarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let userDefaults = UserDefaults.standard

    

    override func viewDidLoad() {
        super.viewDidLoad()

        if Auth.auth().currentUser != nil {
            
            navigationItem .setLeftBarButton(nil, animated: false)
            navigationItem.leftBarButtonItem?.title = "Profile"
            
            //loadView()
            
            self.loadView()
        }

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        if Auth.auth().currentUser != nil {
//
//            navigationItem.leftBarButtonItem?.title = "Profile"
//        }
        
    }
    
    

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell") as! VehicleTableViewCell
        
        cell.vehicleName.text = "Toyota Premio"
        
        cell.vehicleRegYear.text = "2018"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "CarDetailsViewController") as! CarDetailsViewController

        
        self.navigationController?.pushViewController(destinationVC, animated: true)
        
                
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "signIn-addCar" {
            
            
        }
    }
    
    
    
    @IBAction func addCarButton(_ sender: UIBarButtonItem) {
        
        if Auth.auth().currentUser == nil {
            
            performSegue(withIdentifier: "signIn-addCar", sender: nil)
        }
        else {
            
            performSegue(withIdentifier: "addItem", sender: nil)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func signout(_ sender: UIButton) {
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            
            self.userDefaults.set(false, forKey: "userExists")
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
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
