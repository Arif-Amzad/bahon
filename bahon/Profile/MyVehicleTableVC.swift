//
//  MyVeicleTableVC.swift
//  bahon
//
//  Created by Arif Amzad on 6/12/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit
import SwipeCellKit
import RealmSwift
import Firebase

class MyVehicleTableVC: UITableViewController {
    
    let currentUser = Auth.auth().currentUser!
    
    var refresh = UIRefreshControl()
    
    let realm = try! Realm()
    
    var carListArray = [VehicleList]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        tableView.register(UINib(nibName: "VehicleListViewCell", bundle: nil), forCellReuseIdentifier: "VehicleListViewCellXIB")
        
        retrieveData()
        
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresh.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        
        tableView.addSubview(refresh) // not required when using UITableViewController
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let db = Database.database().reference().child("myCarsForRent").child("\(currentUser.uid)")

        db.removeAllObservers()
    }
    
    
    
    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
        
        carListArray.removeAll()
        
        retrieveData()
        
        refresh.endRefreshing()
    }

    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return carListArray.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = super.tableView(tableView, cellForRowAt: indexPath)
//
//        cell.textLabel?.text = "arif amzad"
        

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleListViewCellXIB", for: indexPath) as! VehicleListViewCell

        cell.vehicleName.text = carListArray[indexPath.row].vehicleName

        cell.vehicleRegYear.text = carListArray[indexPath.row].vehicleRegYear

        cell.availavility.text = carListArray[indexPath.row].availability

        cell.vehicleImage.image = carListArray[indexPath.row].vehicleImgage

        print("=============printed============")

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            deleteCarFromApp(forUUID: carListArray[indexPath.row].folder)
            
            carListArray.remove(at: indexPath.item)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            

            
            //carListArray.removeAll()
            
            //retrieveData()
        }
    }
    
    
    //MARK: - Delete data from swipe
    func deleteCarFromApp(forUUID: String) {
        
        let dbRef1 = Database.database().reference().child("myCarsForRent").child(currentUser.uid)
    
        dbRef1.child(forUUID).removeValue { (error, dataRef) in
            
            if error != nil {
                
                print("Ad Can not be removed right now")
            }
            else {
                print("Ad Successfully removed \(dataRef)")
            }
        }
        
        let dbRef2 = Database.database().reference().child("carsForRentAll")
        
        dbRef2.child(forUUID).removeValue { (error, dataRef) in
            
            if error != nil {
                
                print("Ad Can not be removed right now")
            }
            else {
                
                print("Ad Successfully removed \(dataRef)")
            }
        }
        
        
        
        
        let imageRef = Storage.storage().reference().child("images/carImages/\(forUUID).png")
        
        imageRef.delete { (error) in
            
            if error != nil {
                
                print("Image can not be deleted now \(String(describing: error))")
            }
            else {
                print("Successfully deleted image from firebase")
            }
        }
    }
    
    
    
    
    
    func retrieveData() {
        
        let db = Database.database().reference().child("myCarsForRent")
        
        let storeCarRef = Storage.storage().reference()
                    
        db.child("\(currentUser.uid)").observe(.childAdded) { (snapshot) in
            
            if snapshot.exists() {
                
                print("=======have child=======")

    
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
                }
                
                carList.vehicleName = snapshotValue["carModel"]!

                carList.vehicleRegYear = snapshotValue["regYear"]!
                
                carList.availability = snapshotValue["availability"]!
                
                carList.location = snapshotValue["location"]!
                
                carList.rent = snapshotValue["rent"]!

                carList.message = snapshotValue["message"]!
                
                carList.folder = snapshotValue["folder"]!
                
                self.carListArray.append(carList)
                
    //            DispatchQueue.main.async {
    //
    //                self.carTableView.reloadData()
    //            }
                
                self.tableView.reloadData()
                
                //db.removeAllObservers()

                
            }
            else{
                print("=======No child=======")
                
            }
            
        }
    }
}
