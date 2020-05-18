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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.delegate = self
        
        carTableView.register(UINib(nibName: "VehicleListViewCell", bundle: nil), forCellReuseIdentifier: "VehicleListViewCellXIB")
        
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")

        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)

        carTableView.addSubview(refreshControl)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)
        retrieveData()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    
    @objc func refresh(sender:AnyObject) {

        carListArray.removeAll()

        retrieveData()
        refreshControl.endRefreshing()

        carTableView.reloadData()
            }
    

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return carListArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleListViewCellXIB", for: indexPath) as! VehicleListViewCell
        
        print("=========================")
        print(indexPath.row)
        print(carListArray.count)

        
        cell.vehicleName.text = carListArray[indexPath.row].vehicleName
        
        cell.vehicleRegYear.text = carListArray[indexPath.row].vehicleRegYear
        
        cell.availavility.text = carListArray[indexPath.row].availability
        
        cell.vehicleImage.image = carListArray[indexPath.row].vehicleImgage

        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "CarDetailsViewController") as! CarDetailsViewController
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        destinationVC.carImageimg = carListArray[indexPath.row].vehicleImgage
        
        destinationVC.carModelString = carListArray[indexPath.row].vehicleName
        
        destinationVC.locationString = carListArray[indexPath.row].location
        
        destinationVC.messageString = carListArray[indexPath.row].message
        
        destinationVC.rentString = carListArray[indexPath.row].rent
        

        destinationVC.regYearString = carListArray[indexPath.row].vehicleRegYear
        
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//
//        return true
//    }
    
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//
//            carListArray.remove(at: indexPath.item)
//
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//    }
    
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

                    print("Image showedd")
                }
                else{
                                    
                    print("Image showing error ======= \(String(describing: error))")
                }
                
                carList.vehicleName = snapshotValue["carModel"]!

                carList.vehicleRegYear = snapshotValue["regYear"]!
                
                carList.availability = snapshotValue["availability"]!
                
                carList.location = snapshotValue["location"]!
                
                carList.rent = snapshotValue["rent"]!

                carList.message = snapshotValue["message"]!
                
                carList.folder = snapshotValue["folder"]!

                self.carListArray.append(carList)
                
                self.carTableView.reloadData()
            }
            

            
            print("======================================       \(self.carListArray.count)")
            
//            DispatchQueue.main.async {
//
//                self.carTableView.reloadData()
//            }
            
            
            
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
}



