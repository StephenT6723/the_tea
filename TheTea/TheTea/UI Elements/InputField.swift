//
//  InputField.swift
//  TheTea
//
//  Created by Stephen Thomas on 1/13/19.
//  Copyright © 2019 The Tea LLC. All rights reserved.
//

import UIKit

enum InputFieldType {
    case textField
    case price
    case textView
    case button
}

class InputField: UIControl, UITextFieldDelegate, UITextViewDelegate {
    var title = "" {
        didSet {
            titleLabel.text = title
            selectedTitleLabel.text = title
        }
    }
    private let titleLabel = UILabel()
    private let selectedTitleLabel = UILabel()
    private let priceLabel = UILabel()
    let textField = UITextField()
    let button = UIButton()
    let textView = UITextView()
    private let divider = UIView()
    private var dividerHeightConstraint = NSLayoutConstraint()
    private var priceWidthConstraint = NSLayoutConstraint()
    
    var type = InputFieldType.textField {
        didSet {
            switch type {
            case.price:
                priceWidthConstraint.constant = 12
                textField.alpha = 1
                button.alpha = 0
                textView.alpha = 0
            case .textField:
                textField.alpha = 1
                button.alpha = 0
                textView.alpha = 0
            case .textView:
                textField.alpha = 0
                button.alpha = 0
                textView.alpha = 1
            case .button:
                textField.alpha = 1
                button.alpha = 1
                textView.alpha = 0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.inputFieldTitle()
        titleLabel.textColor = UIColor.lightCopy()
        addSubview(titleLabel)
        
        selectedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedTitleLabel.font = UIFont.inputFieldTitle()
        selectedTitleLabel.textColor = UIColor.primaryCTA()
        selectedTitleLabel.alpha = 0
        addSubview(selectedTitleLabel)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = UIFont.inputField()
        priceLabel.textColor = UIColor.primaryCopy()
        priceLabel.text = "$"
        addSubview(priceLabel)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.inputField()
        textField.textColor = UIColor.primaryCopy()
        textField.delegate = self
        addSubview(textField)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = UIColor.primaryCopy()
        textView.isScrollEnabled = false
        textView.alpha = 0
        textView.font = UIFont.inputField()
        textView.delegate = self
        addSubview(textView)
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        addSubview(divider)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        addSubview(button)
        
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        textField.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        priceWidthConstraint = priceLabel.widthAnchor.constraint(equalToConstant: 0)
        priceWidthConstraint.isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -4).isActive = true
        textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 4).isActive = true
        textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        
        divider.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        divider.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        dividerHeightConstraint = divider.heightAnchor.constraint(equalToConstant: 1)
        dividerHeightConstraint.isActive = true
        divider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        setSelected(false, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setSelected(_ selected: Bool, animated: Bool) {
        dividerHeightConstraint.constant = selected ? 2 : 1
        UIView.animate(withDuration: animated ? 0.3: 0) {
            self.selectedTitleLabel.alpha = selected ? 1 : 0
            self.divider.backgroundColor = selected ? UIColor.primaryCTA() : UIColor.lightCopy()
            self.layoutIfNeeded()
        }
    }
    
    //MARK: Text Field Delegate

    func textFieldDidBeginEditing(_ textField: UITextField) {
        setSelected(true, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setSelected(false, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Text View Delegate
    
    func textViewDidChange(_ textView: UITextView) {
        self.sendActions(for: .editingChanged)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        setSelected(true, animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        setSelected(false, animated: true)
    }
    
    
}
