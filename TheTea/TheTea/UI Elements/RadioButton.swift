//
//  RadioButton.swift
//  TheTea
//
//  Created by Stephen Thomas on 1/14/19.
//  Copyright © 2019 The Tea LLC. All rights reserved.
//

import UIKit

class RadioButton: UIButton {
    static let preferedSize: CGFloat = 24
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.checkMark.alpha = self.isSelected ? 1 : 0
            }
        }
    }
    private let checkMark = UIImageView(image: UIImage(named: "checkMark"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 4
        
        checkMark.translatesAutoresizingMaskIntoConstraints = false
        checkMark.alpha = 0
        checkMark.isUserInteractionEnabled = false
        addSubview(checkMark)
        
        checkMark.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
        checkMark.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
        checkMark.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        checkMark.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6).isActive = true
        addTarget(self, action: #selector(toggle), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func toggle() {
        isSelected = !isSelected
    }
}
