//
//  EditProfileView.swift
//  TheTea
//
//  Created by Stephen Thomas on 2/6/19.
//  Copyright © 2019 The Tea LLC. All rights reserved.
//

import UIKit

class EditProfileView: UIView {
    let titleLabel = UILabel()
    
    let nameTitleLabel = UILabel()
    let nameTextField = UITextField()
    
    let emailTitleLabel = UILabel()
    let emailTextField = UITextField()
    
    let saveButton = PrimaryCTA()
    let cancelButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 6
        backgroundColor = .white
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Montserrat-Bold", size: 20)
        titleLabel.textColor = UIColor(red:0.19, green:0.21, blue:0.27, alpha:1)
        titleLabel.text = "Edit Profile"
        addSubview(titleLabel)
        
        nameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTitleLabel.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        nameTitleLabel.textColor = UIColor(red:0.19, green:0.21, blue:0.27, alpha:0.48)
        nameTitleLabel.text = "NAME"
        addSubview(nameTitleLabel)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        nameTextField.textColor = UIColor(red:0.19, green:0.21, blue:0.27, alpha:1)
        nameTextField.returnKeyType = .done
        nameTextField.autocorrectionType = .no
        nameTextField.autocapitalizationType = .words
        nameTextField.tintColor = UIColor.primaryCTA()
        nameTextField.delegate = self
        addSubview(nameTextField)
        
        emailTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTitleLabel.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        emailTitleLabel.textColor = UIColor(red:0.19, green:0.21, blue:0.27, alpha:0.48)
        emailTitleLabel.text = "EMAIL ADDRESS"
        addSubview(emailTitleLabel)
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        emailTextField.textColor = UIColor(red:0.19, green:0.21, blue:0.27, alpha:1)
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .done
        emailTextField.autocapitalizationType = .none
        emailTextField.tintColor = UIColor.primaryCTA()
        emailTextField.delegate = self
        addSubview(emailTextField)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Save Changes", for: .normal)
        addSubview(saveButton)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.lightCopy(), for: .normal)
        cancelButton.titleLabel?.font = UIFont.cta()
        addSubview(cancelButton)
        
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        nameTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        nameTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        nameTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        nameTextField.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 6).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        emailTitleLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
        emailTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        emailTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: emailTitleLabel.bottomAnchor, constant: 6).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        saveButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        saveButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 50).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: PrimaryCTA.preferedHeight).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 178).isActive = true
        
        cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 10).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension EditProfileView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
