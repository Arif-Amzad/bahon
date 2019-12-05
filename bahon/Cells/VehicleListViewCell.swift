//
//  VehicleListViewCell.swift
//  bahon
//
//  Created by Arif Amzad on 5/12/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit

class VehicleListViewCell: UITableViewCell {
    
    
    @IBOutlet weak var vehicleImage: UIImageView!
    
    @IBOutlet weak var vehicleName: UILabel!
    
    @IBOutlet weak var vehicleRegYear: UILabel!
    
    @IBOutlet weak var availavility: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
