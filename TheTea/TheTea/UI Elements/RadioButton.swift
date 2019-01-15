//
//  RadioButton.swift
//  TheTea
//
//  Created by Stephen Thomas on 1/14/19.
//  Copyright © 2019 The Tea LLC. All rights reserved.
//

import UIKit

class RadioButton: UIButton {
    static let preferedSize: CGFloat = 16
    
    private let selectedDot = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 4
        
        selectedDot.translatesAutoresizingMaskIntoConstraints = false
        selectedDot.layer.cornerRadius = 4
        selectedDot.backgroundColor = UIColor.primaryCTA()
        addSubview(selectedDot)
        
        selectedDot.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        selectedDot.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2).isActive = true
        selectedDot.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        selectedDot.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
