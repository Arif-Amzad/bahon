//
//  extension.swift
//  bahon
//
//  Created by Arif Amzad on 19/12/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        view.addGestureRecognizer(tapGesture)
        
    }
    
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    
}
