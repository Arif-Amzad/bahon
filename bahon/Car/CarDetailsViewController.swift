//
//  CarDetailsViewController.swift
//  bahon
//
//  Created by Arif Amzad on 5/12/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit

class CarDetailsViewController: UIViewController {
    
    @IBOutlet weak var carImage: UIImageView!
    
    @IBOutlet weak var availability: UILabel!
    
    @IBOutlet weak var carModel: UILabel!
    
    @IBOutlet weak var regYear: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var message: UITextView!
    
    @IBOutlet weak var rent: UILabel!
    
    var carModelString: String = "loading"
    
    var regYearString: String = "loading"
    
    var locationString: String = "loading"
    
    var messageString: String = "loading"
    
    var rentString: String = "loading"
    
    var carImageimg: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carModel.text = carModelString
        
        regYear.text = regYearString
        
        location.text = locationString
        
        rent.text = "\(rentString) taka per day"
        
        message.text = messageString
        
        carImage.image = carImageimg

        self.navigationController?.setNavigationBarHidden(false, animated: true)

        
        
    }
    
    
    
    func messageNow(phoneNumber: String){
        
        let sms: String = "sms:\(phoneNumber)&body=Hello I want to take your car."
        
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    }
    
    
    
    func callNumber(phoneNumber: String) {

        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {

            let application:UIApplication = UIApplication.shared
            
            if (application.canOpenURL(phoneCallURL)) {
                
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                     application.openURL(phoneCallURL as URL)

                }
            }
        }
    }
    
    
    
    
    
    
    
    
    @IBAction func bookNowBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "Contact with Owner", message: "This is his working time, you can leave a message", preferredStyle: .alert)
        
        let callAction = UIAlertAction(title: "Message now", style: .default, handler: { UIAlertAction in self.messageNow(phoneNumber: "")
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { UIAlertAction in
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)
        
        alert.addAction(callAction)
        
        present(alert, animated: true, completion: nil)
        
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
