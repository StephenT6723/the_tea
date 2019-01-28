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
    var cta = "" {
        didSet {
            ctaButton.setTitle(cta, for: .normal)
        }
    }
    private let titleLabel = UILabel()
    let ctaButton = UIButton()
    let xIcon = UIButton()
    private let selectedTitleLabel = UILabel()
    let priceLabel = UILabel()
    let textField = UITextField()
    let button = UIButton()
    let textView = UITextView()
    var selectedColor = UIColor.primaryCTA() {
        didSet {
            selectedTitleLabel.textColor = selectedColor
            textField.tintColor = selectedColor
        }
    }
    var deSelectedColor = UIColor.lightCopy() {
        didSet {
            titleLabel.textColor = deSelectedColor
            ctaButton.setTitleColor(deSelectedColor, for: .normal)
            divider.backgroundColor = deSelectedColor
        }
    }
    private let errorIconContainer = UIView()
    private let errorIcon = UIImageView(image: UIImage(named: "errorIcon"))
    private let errorLabel = UILabel()
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
        
        ctaButton.translatesAutoresizingMaskIntoConstraints = false
        ctaButton.titleLabel?.font = UIFont.cta()
        ctaButton.setTitleColor(UIColor.lightCopy(), for: .normal)
        addSubview(ctaButton)
        
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
        
        errorIconContainer.translatesAutoresizingMaskIntoConstraints = false
        errorIconContainer.backgroundColor = UIColor(red:1, green:0.42, blue:0.42, alpha:1)
        errorIconContainer.layer.cornerRadius = 10
        errorIconContainer.alpha = 0
        addSubview(errorIconContainer)
        
        errorIcon.translatesAutoresizingMaskIntoConstraints = false
        errorIcon.contentMode = .scaleAspectFit
        errorIconContainer.addSubview(errorIcon)
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.font = UIFont.inputFieldTitle()
        errorLabel.textColor = .white
        errorLabel.alpha = 0
        addSubview(errorLabel)
        
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
        textView.backgroundColor = .clear
        addSubview(textView)
        
        xIcon.translatesAutoresizingMaskIntoConstraints = false
        xIcon.setImage(UIImage(named: "xIcon"), for: .normal)
        xIcon.alpha = 0
        addSubview(xIcon)
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        addSubview(divider)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        addSubview(button)
        
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        ctaButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        ctaButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        xIcon.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        xIcon.bottomAnchor.constraint(equalTo: textField.bottomAnchor).isActive = true
        
        textField.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        priceWidthConstraint = priceLabel.widthAnchor.constraint(equalToConstant: 0)
        priceWidthConstraint.isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        errorIconContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        errorIconContainer.widthAnchor.constraint(equalToConstant: 20).isActive = true
        errorIconContainer.heightAnchor.constraint(equalToConstant: 20).isActive = true
        errorIconContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        errorIcon.centerXAnchor.constraint(equalTo: errorIconContainer.centerXAnchor).isActive = true
        errorIcon.centerYAnchor.constraint(equalTo: errorIconContainer.centerYAnchor).isActive = true
        
        errorLabel.leadingAnchor.constraint(equalTo: errorIconContainer.trailingAnchor, constant: 10).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: errorIconContainer.centerYAnchor).isActive = true
        
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
        
        setSelected(false, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setSelected(_ selected: Bool, animated: Bool) {
        dividerHeightConstraint.constant = selected ? 2 : 1
        UIView.animate(withDuration: animated ? 0.3: 0) {
            self.selectedTitleLabel.alpha = selected ? 1 : 0
            self.divider.backgroundColor = selected ? self.selectedColor : self.deSelectedColor
            self.layoutIfNeeded()
        }
    }
    
    func showError(text: String) {
        if text.count == 0 {
            return
        }
        
        errorLabel.text = text
        UIView.animate(withDuration: 0.3, animations: {
            self.errorIconContainer.alpha = 1
            self.errorLabel.alpha = 1
            self.textField.alpha = 0
        }) { (complete) in
            UIView.animate(withDuration: 0.3, delay: 2, options: .curveEaseInOut, animations: {
                self.errorIconContainer.alpha = 0
                self.errorLabel.alpha = 0
                self.textField.alpha = 1
            }, completion: nil)
        }
    }
    
    //MARK: Text Field Delegate

    func textFieldDidBeginEditing(_ textField: UITextField) {
        setSelected(true, animated: true)
        if type == .price {
            textField.text = ""
        }
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
