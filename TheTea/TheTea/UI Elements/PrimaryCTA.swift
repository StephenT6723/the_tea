//
//  PrimaryCTA.swift
//  TheTea
//
//  Created by Stephen Thomas on 9/18/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

class PrimaryCTA: UIButton {
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
    
    class func preferedHeight() -> Double {
        return 40.0
    }
}
