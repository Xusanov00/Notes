//
//  AkiraTextView.swift
//  Notes
//
//  Created by Ali on 26/04/23.
//

import UIKit

class AkiraTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.layer.cornerRadius = 8.0
        
        // Border color
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        
        // Text shadow
        self.layer.shadowColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 2.0
        self.textColor = UIColor.blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Установить индентацию текста
        self.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    
    
}

