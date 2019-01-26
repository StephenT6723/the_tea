//
//  PrimaryCTA.swift
//  TheTea
//
//  Created by Stephen Thomas on 9/18/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

class PrimaryCTA: UIButton {
    static let preferedHeight: CGFloat = 34.0
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? UIColor.primaryCTA() : UIColor.lightCopy()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        backgroundColor = UIColor.primaryCTA()
        layer.cornerRadius = 6
        setTitleColor(.white, for: .normal)
        setTitleColor(UIColor.lightCopy(), for: .highlighted)
        titleLabel?.font = UIFont.headerTwo()
        
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.16).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 6
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
