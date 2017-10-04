//
//  SegmentControl.swift
//  TheGaySegmentControl
//
//  Created by Stephen Thomas on 10/3/17.
//  Copyright © 2017 The Gay Agenda. All rights reserved.
//

import UIKit

class SegmentedControl: UIControl {
    private let dividerColor = UIColor.white
    private let selectedColor = UIColor.white
    private let deselectedColor = UIColor.lightBrandCopy()
    private let font = UIFont.cta()
    
    var items = [String]() {
        didSet {
            updateContent()
        }
    }
    
    var buttons = [UIButton]()
    var selectedIndex = 0 {
        didSet {
            if selectedIndex < buttons.count{
                buttonTapped(sender: buttons[selectedIndex])
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateContent() {
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
            addSubview(button)
            
            if buttons.count == 0 {
                button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
                
                button.setTitleColor(selectedColor, for: .normal)
            } else {
                let divider = UIView()
                divider.translatesAutoresizingMaskIntoConstraints = false
                divider.backgroundColor = dividerColor
                addSubview(divider)
                
                let previousButton = buttons[currentIndex - 1]
                divider.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor).isActive = true
                divider.topAnchor.constraint(equalTo: topAnchor).isActive = true
                divider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                divider.widthAnchor.constraint(equalToConstant: 1).isActive = true
                
                button.leadingAnchor.constraint(equalTo: divider.trailingAnchor).isActive = true
                button.widthAnchor.constraint(equalTo: previousButton.widthAnchor).isActive = true
                
                button.setTitleColor(deselectedColor, for: .normal)
            }
            
            button.topAnchor.constraint(equalTo: topAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            
            if currentIndex == items.count - 1 {
                button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            }
            
            currentIndex += 1
            
            buttons.append(button)
        }
    }
    
    func buttonTapped(sender: UIButton) {
        for button in buttons {
            button.setTitleColor(deselectedColor, for: .normal)
        }
        
        sender.setTitleColor(selectedColor, for: .normal)
        
        if let buttonIndex = buttons.index(of: sender) {
            if selectedIndex != buttonIndex {
                selectedIndex = buttonIndex
                sendActions(for: .valueChanged)
            }
        }
    }
}
