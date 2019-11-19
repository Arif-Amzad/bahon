//
//  VehicleTableViewCell.swift
//  bahon
//
//  Created by Arif Amzad on 18/11/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit

class VehicleTableViewCell: UITableViewCell {

    
    @IBOutlet weak var vehicleImage: UIImageView!
    
    @IBOutlet weak var vehicleRegYear: UILabel!
    
    @IBOutlet weak var vehicleName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
