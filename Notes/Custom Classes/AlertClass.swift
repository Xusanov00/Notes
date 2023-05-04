//
//  AlertClass.swift
//  Notes
//
//  Created by Ali on 02/05/23.
//

import Foundation
import UIKit

class Alert {
    
    class func alertView(title: String? = nil, message: String? = nil, style: UIAlertController.Style, actions: [UIAlertAction]) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        for action in actions {
            alert.addAction(action)
        }
        
        return alert
    }
    
}

