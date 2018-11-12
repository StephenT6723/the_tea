//
//  LoginViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/16/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit
import FBSDKLoginKit

enum AuthType: Int {
    case register
    case signIn
}

class LoginViewController: UIViewController {
    private let modeSelectSegmentedControl = UISegmentedControl()
    private let emailInputField = InputField()
    private let usernameInputField = InputField()
    private let passwordInputField = InputField()
    private let confirmPasswordInputField = InputField()
    
    private let submitContainer = UIView()
    private let submitButton = PrimaryCTA(frame: CGRect())
    
    private let textFieldHeight: CGFloat = 48.0
    private var usernameTopConstraint = NSLayoutConstraint()
    private var confirmPasswordTopConstraint = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "WELCOME"
        edgesForExtendedLayout = UIRectEdge()
        view.backgroundColor = UIColor.lightBackground()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTouched))
        navigationItem.leftBarButtonItem = cancelButton
        
        modeSelectSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        modeSelectSegmentedControl.insertSegment(withTitle: "ENLIST", at: 0, animated: false)
        modeSelectSegmentedControl.insertSegment(withTitle: "SIGN IN", at: 1, animated: false)
        modeSelectSegmentedControl.selectedSegmentIndex = 0
        modeSelectSegmentedControl.addTarget(self, action: #selector(modeChanged), for: .valueChanged)
        modeSelectSegmentedControl.tintColor = UIColor.primaryCTA()
        modeSelectSegmentedControl.setTitleTextAttributes([.font :UIFont.cta() as Any], for: .normal)
        view.addSubview(modeSelectSegmentedControl)
        
        emailInputField.translatesAutoresizingMaskIntoConstraints = false
        emailInputField.textField.placeholder = "EMAIL"
        emailInputField.textField.autocapitalizationType = .none
        emailInputField.textField.addTarget(self, action: #selector(updateSubmitButton), for: .editingChanged)
        view.addSubview(emailInputField)
        
        usernameInputField.translatesAutoresizingMaskIntoConstraints = false
        usernameInputField.textField.placeholder = "USERNAME"
        usernameInputField.textField.autocapitalizationType = .words
        usernameInputField.textField.addTarget(self, action: #selector(updateSubmitButton), for: .editingChanged)
        usernameInputField.showDivider = false
        view.insertSubview(usernameInputField, belowSubview: emailInputField)
        
        passwordInputField.translatesAutoresizingMaskIntoConstraints = false
        passwordInputField.textField.placeholder = "PASSWORD"
        passwordInputField.textField.isSecureTextEntry = true
        passwordInputField.textField.autocapitalizationType = .none
        passwordInputField.textField.addTarget(self, action: #selector(updateSubmitButton), for: .editingChanged)
        view.addSubview(passwordInputField)
        
        confirmPasswordInputField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordInputField.textField.placeholder = "CONFIRM PASSWORD"
        confirmPasswordInputField.textField.autocapitalizationType = .none
        confirmPasswordInputField.textField.isSecureTextEntry = true
        confirmPasswordInputField.textField.addTarget(self, action: #selector(updateSubmitButton), for: .editingChanged)
        confirmPasswordInputField.showDivider = false
        view.insertSubview(confirmPasswordInputField, belowSubview: passwordInputField)
        
        modeSelectSegmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        modeSelectSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        emailInputField.topAnchor.constraint(equalTo: modeSelectSegmentedControl.bottomAnchor, constant: 20).isActive = true
        emailInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        emailInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        emailInputField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        usernameTopConstraint = usernameInputField.topAnchor.constraint(equalTo: emailInputField.bottomAnchor)
        usernameTopConstraint.isActive = true
        usernameInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        usernameInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        usernameInputField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        passwordInputField.topAnchor.constraint(equalTo: usernameInputField.bottomAnchor, constant: 20).isActive = true
        passwordInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        passwordInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        passwordInputField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        confirmPasswordTopConstraint = confirmPasswordInputField.topAnchor.constraint(equalTo: passwordInputField.bottomAnchor)
        confirmPasswordTopConstraint.isActive = true
        confirmPasswordInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        confirmPasswordInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        confirmPasswordInputField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        //SUBMIT
        
        submitContainer.translatesAutoresizingMaskIntoConstraints = false
        submitContainer.backgroundColor = .white
        submitContainer.layer.masksToBounds = false
        submitContainer.layer.shadowColor = UIColor.black.cgColor
        submitContainer.layer.shadowOpacity = 0.1
        submitContainer.layer.shadowRadius = 5
        submitContainer.layer.shouldRasterize = true
        submitContainer.layer.rasterizationScale = UIScreen.main.scale
        view.addSubview(submitContainer)
        
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonTouched), for: .touchUpInside)
        submitContainer.addSubview(submitButton)
        
        submitContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        submitContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        submitContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        submitContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        submitButton.leadingAnchor.constraint(equalTo: submitContainer.leadingAnchor, constant: 20).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: submitContainer.trailingAnchor, constant: -20).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: submitContainer.bottomAnchor, constant: -20).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: CGFloat(PrimaryCTA.preferedHeight)).isActive = true
    }
    
    //MARK: Actions
    
    @objc func cancelButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func modeChanged() {
        let selectedType = self.selectedType()
        if selectedType == .register {
            usernameTopConstraint.constant = 0
            usernameInputField.alpha = 1
            emailInputField.showDivider = true
            
            confirmPasswordTopConstraint.constant = 0
            confirmPasswordInputField.alpha = 1
            passwordInputField.showDivider = true
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            usernameTopConstraint.constant = -1 * textFieldHeight
            
            confirmPasswordTopConstraint.constant = -1 * textFieldHeight
            
            UIView.animate(withDuration: 0.3, animations: {
                self.usernameInputField.alpha = 0
                self.confirmPasswordInputField.alpha = 0
                self.view.layoutIfNeeded()
            }) { (complete: Bool) in
                self.emailInputField.showDivider = false
                self.passwordInputField.showDivider = false
            }
        }
    }
    
    @objc func updateSubmitButton() {
        /*
        let enabled = dataUpdated()
        
        submitButton.isEnabled = enabled
        navigationItem.rightBarButtonItem?.isEnabled = enabled */
    }
    
    @objc func submitButtonTouched() {
        print("sumbit")
    }
    
    //MARK: Helpers
    
    func selectedType() -> AuthType {
        return AuthType(rawValue: modeSelectSegmentedControl.selectedSegmentIndex) ?? .register
    }
}
