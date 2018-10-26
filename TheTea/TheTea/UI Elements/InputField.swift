//
//  InputField.swift
//  TheTea
//
//  Created by Stephen Thomas on 10/4/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

enum InputFieldType {
    case textField
    case textView
    case button
}

class InputField: UIView {
    static let textFieldHeight: CGFloat = 48.0
    var type = InputFieldType.textField {
        didSet {
            switch type {
            case .textField:
                textField.alpha = 1
                label.alpha = 0
                button.alpha = 0
                textView.alpha = 0
            case .textView:
                textField.alpha = 0
                label.alpha = 0
                button.alpha = 0
                textView.alpha = 1
            case .button:
                textField.alpha = 0
                label.alpha = 1
                button.alpha = 1
                textView.alpha = 0
            }
        }
    }
    let label = UILabel()
    let button = UIButton()
    let textField = UITextField()
    let textView = UITextView()
    private let divider = UIView()
    var showDivider = true {
        didSet {
            divider.isHidden = !showDivider
        }
    }
    private let accessoryContainer = UIView()
    var accessoryView = UIView() {
        didSet {
            updateAccessoryView(newView: accessoryView)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.body()
        textField.textColor = UIColor.primaryCopy()
        addSubview(textField)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.body()
        label.textColor = UIColor.primaryCopy()
        label.alpha = 0
        addSubview(label)
        
        accessoryContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(accessoryContainer)
        
        accessoryView = UIView()
        accessoryView.widthAnchor.constraint(equalToConstant: 0).isActive = true
        updateAccessoryView(newView: accessoryView)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        addSubview(button)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = UIColor.lightCopy()
        textView.isScrollEnabled = false
        textView.alpha = 0
        textView.font = .body()
        addSubview(textView)
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = UIColor.dividers()
        addSubview(divider)
        
        textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: accessoryContainer.leadingAnchor, constant: -10).isActive = true
        textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: accessoryContainer.leadingAnchor, constant: -10).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        accessoryContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        accessoryContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        accessoryContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        textView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        divider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        divider.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateAccessoryView(newView: UIView) {
        for view in accessoryContainer.subviews {
            view.removeFromSuperview()
        }
        
        newView.translatesAutoresizingMaskIntoConstraints = false
        accessoryContainer.addSubview(newView)
        
        newView.leadingAnchor.constraint(equalTo: accessoryContainer.leadingAnchor, constant: 0).isActive = true
        newView.trailingAnchor.constraint(equalTo: accessoryContainer.trailingAnchor, constant: 0).isActive = true
        newView.centerYAnchor.constraint(equalTo: accessoryContainer.centerYAnchor).isActive = true
    }
}
