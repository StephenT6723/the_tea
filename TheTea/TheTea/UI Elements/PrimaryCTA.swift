//
//  PrimaryCTA.swift
//  TheTea
//
//  Created by Stephen Thomas on 9/18/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

class PrimaryCTA: UIButton {
    static let preferedHeight: CGFloat = 40.0
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? UIColor.primaryCTA() : UIColor.lightCopy()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.primaryCTA()
        layer.cornerRadius = 8
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.cta()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
