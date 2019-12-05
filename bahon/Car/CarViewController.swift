//
//  CarViewController.swift
//  bahon
//
//  Created by Arif Amzad on 18/11/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit
import Firebase

class CarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate, UISearchBarDelegate {
    
    
    @IBOutlet weak var carTableView: UITableView!
    
    var carListArray: [VehicleList] = [VehicleList]()
    
    let userDefaults = UserDefaults.standard

    var hidesBarsOnSwipe: Bool?
    
    var refreshControl = UIRefreshControl()
    
    var imageArray = [UIImage]()
    
    var imageVar: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.delegate = self
        
        carTableView.register(UINib(nibName: "VehicleListViewCell", bundle: nil), forCellReuseIdentifier: "VehicleListViewCellXIB")
        
        retrieveData()
        
           refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
           refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
           carTableView.addSubview(refreshControl) // not required when using UITableViewController
        

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)
        
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    
    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
        
        carListArray.removeAll()
        
        retrieveData()
        
        refreshControl.endRefreshing()
    }
    

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return carListArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleListViewCellXIB", for: indexPath) as! VehicleListViewCell
        

        cell.vehicleName.text = carListArray[indexPath.row].vehicleName
        
        cell.vehicleRegYear.text = carListArray[indexPath.row].vehicleRegYear
        
        cell.availavility.text = carListArray[indexPath.row].availability
        
        cell.vehicleImage.image = carListArray[indexPath.row].vehicleImgage

        //cell.vehicleImage.image = imageArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "CarDetailsViewController") as! CarDetailsViewController
        
        destinationVC.carImageimg = carListArray[indexPath.row].vehicleImgage
        
        destinationVC.carModelString = carListArray[indexPath.row].vehicleName
        
        destinationVC.locationString = carListArray[indexPath.row].location
        
        destinationVC.messageString = carListArray[indexPath.row].message
        
        destinationVC.rentString = carListArray[indexPath.row].rent
        

        destinationVC.regYearString = carListArray[indexPath.row].vehicleRegYear
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    func retrieveData() {
        
        let db = Database.database().reference().child("carsForRentAll")
        
        let storeCarRef = Storage.storage().reference()
        
        db.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let uuid = snapshot.key
            
            print("========\(uuid)========")
            
            let carList = VehicleList()
            
            storeCarRef.child("images/carImages/\(uuid).png").getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                
                if error == nil {
                    
                    let image = UIImage(data: data!)
                        
                    carList.vehicleImgage = image!
                    
                    //self.imageArray.append(image!)
                    
                    print(image as Any)
                    
                    print("Image showedd")
                }
                else{
                                    
                    print("Image showing error ======= \(String(describing: error))")
                }
            }
            
            carList.vehicleName = snapshotValue["carModel"]!

            carList.vehicleRegYear = snapshotValue["regYear"]!
            
            carList.availability = snapshotValue["availability"]!
            
            carList.location = snapshotValue["location"]!
            
            carList.rent = snapshotValue["rent"]!

            carList.message = snapshotValue["message"]!

            //carList.vehicleImgage =
            
            self.carListArray.append(carList)
            
//            DispatchQueue.main.async {
//
//                self.carTableView.reloadData()
//            }
            
            self.carTableView.reloadData()
            
            //db.removeAllObservers()
        }
    }

    
    
    @IBAction func profileButton(_ sender: UIBarButtonItem) {
        
        if Auth.auth().currentUser != nil {
            
            performSegue(withIdentifier: "profile", sender: self)
        }
        else{
            
            performSegue(withIdentifier: "signIn-addCar", sender: self)
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
    
    
    @IBAction func searchButton(_ sender: UIButton) {
        
        //searchBar.isHidden = false
    }
    
    
    
    @IBAction func locationButton(_ sender: UIButton) {
        
        
    }
    
    
    
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//
//        if tabBarItem.tag == 0 {
//
//
//        }
//        else if tabBarItem.tag == 1 {
//
//        }
//
//    }
    
    
    
    
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if velocity.y > 0 {
            
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                
            }, completion: nil)
        }
        else {
            
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                
            }, completion: nil)
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



