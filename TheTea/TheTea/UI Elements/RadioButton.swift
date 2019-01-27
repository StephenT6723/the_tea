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
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.selectedDot.alpha = self.isSelected ? 1 : 0
            }
        }
    }
    private let selectedDot = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 4
        
        selectedDot.translatesAutoresizingMaskIntoConstraints = false
        selectedDot.layer.cornerRadius = 4
        selectedDot.backgroundColor = UIColor.primaryCTA()
        selectedDot.alpha = 0
        selectedDot.isUserInteractionEnabled = false
        addSubview(selectedDot)
        
        selectedDot.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        selectedDot.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2).isActive = true
        selectedDot.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        selectedDot.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        
        addTarget(self, action: #selector(toggle), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func toggle() {
        isSelected = !isSelected
    }
}
