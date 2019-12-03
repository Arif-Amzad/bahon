//
//  topTabBarController.swift
//  bahon
//
//  Created by Arif Amzad on 3/12/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit

class TopTabBarController: UITabBarController {
    
    
    @IBOutlet weak var TopTab: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        UIApplication.shared.statusBarFrame.size.height
        TopTab.frame = CGRect(x: 0, y:  TopTab.frame.size.height, width: TopTab.frame.size.width, height: TopTab.frame.size.height)
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
