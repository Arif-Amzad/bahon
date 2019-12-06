//
//  SwipeTableVC.swift
//  bahon
//
//  Created by Arif Amzad on 6/12/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.rowHeight = 80.0
        
        tableView.register(UINib(nibName: "VehicleListViewCell", bundle: nil), forCellReuseIdentifier: "VehicleListViewCellXIB")
        
        //tableView.separatorStyle = .none
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleListViewCellXIB", for: indexPath) as! VehicleListViewCell
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        //cell.delegate = self
         
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil}
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            self.updateMdel(at: indexPath)
        }
        
        deleteAction.image = UIImage(named: "icondelete")
        
        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var option = SwipeOptions()
        
        option.expansionStyle = .destructive
        
        option.transitionStyle = .border
        
        return option
    }
    
    func updateMdel(at indexPath: IndexPath){
        
        print("Item deleted from superclass") // this will be printed only from subclass not here
    }

}
