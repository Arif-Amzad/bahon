//
//  CarDetailsViewController.swift
//  bahon
//
//  Created by Arif Amzad on 24/11/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit

class CarDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        hidesBottomBarWhenPushed = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        hidesBottomBarWhenPushed = true


    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
