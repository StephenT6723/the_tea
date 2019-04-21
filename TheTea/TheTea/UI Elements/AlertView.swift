//
//  AlertView.swift
//  TheTea
//
//  Created by Stephen Thomas on 2/9/19.
//  Copyright © 2019 The Tea LLC. All rights reserved.
//

import UIKit

class AlertView: UIView {
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    let primaryCTA = PrimaryCTA(frame: CGRect())
    let secondaryCTA = UIButton()
    
    
    init(title: String, message: String) {
        super.init(frame: CGRect())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
