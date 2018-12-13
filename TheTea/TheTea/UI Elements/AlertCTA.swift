//
//  AlertCTA.swift
//  TheTea
//
//  Created by Stephen Thomas on 10/4/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

class AlertCTA: UIButton {
    static let preferedHeight: CGFloat = 40.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
        layer.cornerRadius = 8
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.cta()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
