//
//  SegmentControl.swift
//  TheGaySegmentControl
//
//  Created by Stephen Thomas on 10/3/17.
//  Copyright © 2017 The Gay Agenda. All rights reserved.
//

import UIKit

class SegmentedControl: UIControl {
    private let maxAlpha: CGFloat = 0.9
    private let minAlpha: CGFloat = 0.5
    private let font = UIFont.navTitle()
    private let selector = UIView()
    private var selectorCenterContraint = NSLayoutConstraint()
    
    var items = [String]() {
        didSet {
            updateContent()
        }
    }
    
    private var buttons = [UIButton]()
    var selectedIndex = 0 {
        didSet {
            if selectedIndex < buttons.count {
                buttonTapped(sender: buttons[selectedIndex])
            }
        }
    }
    
    private func updateContent() {
        backgroundColor = .white
        
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:0.16).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 6
        
        for view in subviews {
            view.removeFromSuperview()
        }
        
        buttons = [UIButton]()
        
        var currentIndex = 0
        for item in items {
            let button = UIButton()
            button.setTitle(item, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.titleLabel?.font = font
            button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            button.backgroundColor = .clear
            button.setTitleColor(UIColor.primaryCopy(), for: .normal)
            addSubview(button)
            
            if buttons.count == 0 {
                button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
                button.alpha = maxAlpha
            } else {
                
                let previousButton = buttons[currentIndex - 1]
                
                button.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor).isActive = true
                button.widthAnchor.constraint(equalTo: previousButton.widthAnchor).isActive = true
                button.alpha = minAlpha
            }
            
            button.topAnchor.constraint(equalTo: topAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            
            if currentIndex == items.count - 1 {
                button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            }
            
            currentIndex += 1
            
            buttons.append(button)
        }
        
        let firstButton = buttons[0]
        
        selector.translatesAutoresizingMaskIntoConstraints = false
        addSubview(selector)
        
        selector.heightAnchor.constraint(equalToConstant: 2).isActive = true
        selector.widthAnchor.constraint(equalTo: firstButton.widthAnchor, constant: -40).isActive = true
        selectorCenterContraint = selector.centerXAnchor.constraint(equalTo: firstButton.centerXAnchor)
        selectorCenterContraint.isActive = true
        selector.bottomAnchor.constraint(equalTo: firstButton.bottomAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = selector.bounds
        gradientLayer.colors = [
            UIColor(red:0.94, green:0.53, blue:1, alpha:1).cgColor,
            UIColor(red:0.47, green:0.77, blue:1, alpha:1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        selector.layer.addSublayer(gradientLayer)
    }
    
    @objc func buttonTapped(sender: UIButton) {
        guard let buttonIndex = buttons.index(of: sender) else {
            return
        }
        
        if selectedIndex == buttonIndex {
            return
        }
        
        selectorCenterContraint.isActive = false
        selectorCenterContraint = selector.centerXAnchor.constraint(equalTo: sender.centerXAnchor)
        selectorCenterContraint.isActive = true
        
        UIView.animate(withDuration: 0.3) {
            for button in self.buttons {
                button.alpha = button == sender ? self.maxAlpha : self.minAlpha
            }
            self.layoutIfNeeded()
        }
        
        selectedIndex = buttonIndex
        sendActions(for: .valueChanged)
    }
}
