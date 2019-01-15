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

class LoginViewController: UIViewController, UITextFieldDelegate {
    private var selectedType:AuthType?
    
    private let backgroundImageView = UIImageView(image: UIImage(named: "jdfj"))
    
    private let modeSelectSegmentedControl = UISegmentedControl()
    private let emailErrorLabel = UILabel()
    private let emailInputField = LegacyInputField()
    private let usernameInputField = LegacyInputField()
    private let passwordInputField = LegacyInputField()
    private let confirmPasswordInputField = LegacyInputField()
    private let usernameErrorLabel = UILabel()
    private let passwordErrorLabel = UILabel()
    
    private let submitContainer = UIView()
    private let submitButton = UIButton()
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    private let textFieldHeight: CGFloat = 48.0
    private var emailTopConstraint = NSLayoutConstraint()
    private var usernameTopConstraint = NSLayoutConstraint()
    private var passwordTopConstraint = NSLayoutConstraint()
    private var confirmPasswordTopConstraint = NSLayoutConstraint()
    
    private let modeChangeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "WELCOME"
        view.backgroundColor = .blue
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        
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
        
        emailErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        emailErrorLabel.numberOfLines = 0
        emailErrorLabel.font = UIFont.body()
        emailErrorLabel.textColor = .red
        view.addSubview(emailErrorLabel)
        
        emailInputField.translatesAutoresizingMaskIntoConstraints = false
        emailInputField.textField.placeholder = "EMAIL"
        emailInputField.textField.autocapitalizationType = .none
        emailInputField.textField.addTarget(self, action: #selector(updateSubmitButton), for: .editingChanged)
        emailInputField.textField.delegate = self
        view.addSubview(emailInputField)
        
        usernameInputField.translatesAutoresizingMaskIntoConstraints = false
        usernameInputField.textField.placeholder = "USERNAME"
        usernameInputField.textField.autocapitalizationType = .words
        usernameInputField.textField.addTarget(self, action: #selector(updateSubmitButton), for: .editingChanged)
        usernameInputField.showDivider = false
        usernameInputField.textField.delegate = self
        view.insertSubview(usernameInputField, belowSubview: emailInputField)
        
        usernameErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameErrorLabel.numberOfLines = 0
        usernameErrorLabel.font = UIFont.body()
        usernameErrorLabel.textColor = .red
        view.addSubview(usernameErrorLabel)
        
        passwordInputField.translatesAutoresizingMaskIntoConstraints = false
        passwordInputField.textField.placeholder = "PASSWORD"
        passwordInputField.textField.isSecureTextEntry = true
        passwordInputField.textField.autocapitalizationType = .none
        passwordInputField.textField.delegate = self
        passwordInputField.textField.addTarget(self, action: #selector(updateSubmitButton), for: .editingChanged)
        view.addSubview(passwordInputField)
        
        confirmPasswordInputField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordInputField.textField.placeholder = "CONFIRM PASSWORD"
        confirmPasswordInputField.textField.autocapitalizationType = .none
        confirmPasswordInputField.textField.isSecureTextEntry = true
        confirmPasswordInputField.textField.delegate = self
        confirmPasswordInputField.textField.addTarget(self, action: #selector(updateSubmitButton), for: .editingChanged)
        confirmPasswordInputField.showDivider = false
        view.insertSubview(confirmPasswordInputField, belowSubview: passwordInputField)
        
        passwordErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordErrorLabel.numberOfLines = 0
        passwordErrorLabel.font = UIFont.body()
        passwordErrorLabel.textColor = .red
        view.addSubview(passwordErrorLabel)
        
        modeSelectSegmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        modeSelectSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        emailErrorLabel.topAnchor.constraint(equalTo: modeSelectSegmentedControl.bottomAnchor, constant: 20).isActive = true
        emailErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emailErrorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        emailTopConstraint = emailInputField.topAnchor.constraint(equalTo: emailErrorLabel.bottomAnchor, constant: 10)
        emailTopConstraint.isActive = true
        emailInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        emailInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        emailInputField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        usernameTopConstraint = usernameInputField.topAnchor.constraint(equalTo: emailInputField.bottomAnchor)
        usernameTopConstraint.isActive = true
        usernameInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        usernameInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        usernameInputField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        usernameErrorLabel.topAnchor.constraint(equalTo: usernameInputField.bottomAnchor, constant: 10).isActive = true
        usernameErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        usernameErrorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        passwordTopConstraint = passwordInputField.topAnchor.constraint(equalTo: usernameInputField.bottomAnchor, constant: 40)
        passwordTopConstraint.isActive = true
        passwordInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        passwordInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        passwordInputField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        confirmPasswordTopConstraint = confirmPasswordInputField.topAnchor.constraint(equalTo: passwordInputField.bottomAnchor)
        confirmPasswordTopConstraint.isActive = true
        confirmPasswordInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        confirmPasswordInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        confirmPasswordInputField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        passwordErrorLabel.topAnchor.constraint(equalTo: confirmPasswordInputField.bottomAnchor, constant: 10).isActive = true
        passwordErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        passwordErrorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        //SUBMIT
        
        submitContainer.translatesAutoresizingMaskIntoConstraints = false
        submitContainer.backgroundColor = .white
        submitContainer.layer.masksToBounds = false
        submitContainer.layer.shadowColor = UIColor.black.cgColor
        submitContainer.layer.shadowOpacity = 0.1
        submitContainer.layer.shadowRadius = 5
        submitContainer.layer.shouldRasterize = true
        submitContainer.layer.rasterizationScale = UIScreen.main.scale
        submitContainer.alpha = 0
        view.addSubview(submitContainer)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        submitContainer.addSubview(activityIndicator)
        
        
        
        submitContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        submitContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        submitContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        submitContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        
        activityIndicator.centerXAnchor.constraint(equalTo: submitContainer.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: submitContainer.centerYAnchor).isActive = true
        
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.backgroundColor = .white
        submitButton.setTitleColor(UIColor.primaryCTA(), for: .normal)
        submitButton.titleLabel?.font = UIFont.cta()
        submitButton.layer.cornerRadius = 5
        submitButton.addTarget(self, action: #selector(submitButtonTouched), for: .touchUpInside)
        view.addSubview(submitButton)
        
        modeChangeButton.translatesAutoresizingMaskIntoConstraints = false
        modeChangeButton.setTitle("Already have an account?  Log In", for: .normal)
        modeChangeButton.setTitleColor(.white, for: .normal)
        modeChangeButton.titleLabel?.font = UIFont.cta()
        modeChangeButton.addTarget(self, action: #selector(modeChangeButtonTouched), for: .touchUpInside)
        view.addSubview(modeChangeButton)
        
        submitButton.leadingAnchor.constraint(equalTo: submitContainer.leadingAnchor, constant: 40).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: submitContainer.trailingAnchor, constant: -40).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: modeChangeButton.topAnchor, constant: -20).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        modeChangeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        modeChangeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        modeChangeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        modeChangeButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        //DEBUG
        
        emailInputField.textField.text = "slt6723@gmail.com"
        passwordInputField.textField.text = "abc12345678"
        confirmPasswordInputField.textField.text = "abc12345678"
        
        
        //SETUP
        
        updateEmailError(text: "", animated: false)
        updateUsernameError(text: "", animated: false)
        updatePasswordError(text: "", animated: false)
        updateSubmitButton()
        self.updateLoader(visible: false, animated: false)
    }
    
    //MARK: Actions
    
    @objc func modeChangeButtonTouched() {
        guard let previousType = selectedType else {
            selectedType = .signIn
            modeChanged()
            return
        }
        
        selectedType = previousType == .signIn ? .register : .signIn
        modeChanged()
    }
    
    @objc func cancelButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func modeChanged() {
        updateEmailError(text: "", animated: true)
        updateUsernameError(text: "", animated: true)
        updatePasswordError(text: "", animated: true)
        if selectedType == .register {
            confirmPasswordTopConstraint.constant = 0
            confirmPasswordInputField.alpha = 1
            passwordInputField.showDivider = true
            
            usernameTopConstraint.constant = 0
            usernameInputField.alpha = 1
            emailInputField.showDivider = true
            
            submitButton.setTitle("SIGN UP", for: .normal)
            modeChangeButton.setTitle("Already have an account? Log In", for: .normal)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            confirmPasswordTopConstraint.constant = -1 * textFieldHeight
            usernameTopConstraint.constant = -1 * textFieldHeight
            
            submitButton.setTitle("LOG IN", for: .normal)
            modeChangeButton.setTitle("Dont have an account? Sign Up", for: .normal)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.confirmPasswordInputField.alpha = 0
                self.usernameInputField.alpha = 0
                self.view.layoutIfNeeded()
            }) { (complete: Bool) in
                self.passwordInputField.showDivider = false
                self.emailInputField.showDivider = false
            }
        }
        updateSubmitButton()
    }
    
    @objc func updateSubmitButton() {
        var enabled = true
        
        if (emailInputField.textField.text?.count == 0) ||
            (selectedType == .register && usernameInputField.textField.text?.count == 0) ||
            (passwordInputField.textField.text?.count ?? 0 == 0) ||
            (selectedType == .register && confirmPasswordInputField.textField.text?.count ?? 0 == 0) {
            enabled = false
        }
        
        submitButton.isEnabled = enabled
    }
    
    @objc func submitButtonTouched() {
        let email = emailInputField.textField.text ?? ""
        let username = usernameInputField.textField.text ?? ""
        let password = passwordInputField.textField.text ?? ""
        let emailValid = MemberDataManager.isValidEmail(email: email)
        let usernameValid = MemberDataManager.isValidUsername(username: username) || selectedType == .signIn
        let passwordsMatch = passwordInputField.textField.text ?? "" == confirmPasswordInputField.textField.text ?? "" || selectedType == .signIn
        let passwordValid = MemberDataManager.isValidPassword(password: password)
        
        var emailError = ""
        var usernameError = ""
        var passwordError = ""
        
        if !emailValid {
            emailError = "Please enter a valid e-mail address"
        }
        if !usernameValid {
            usernameError = "Your username must be at least \(MemberDataManager.minUsernameLength) characters"
        }
        if !passwordsMatch {
            passwordError = "Your passwords do not match"
        }
        if !passwordValid {
            passwordError = "Your password must be at least \(MemberDataManager.minPasswordLength) characters"
        }
        
        updateEmailError(text: emailError, animated: true)
        updateUsernameError(text: usernameError, animated: true)
        updatePasswordError(text: passwordError, animated: true)
        
        if emailValid && usernameValid && passwordsMatch && passwordValid {
            updateLoader(visible: true, animated: true)
            if selectedType == .signIn {
                MemberDataManager.loginMember(email: email, password: password, onSuccess: {
                    self.dismiss(animated: true, completion: nil)
                }) { (error) in
                    self.updateLoader(visible: false, animated: true)
                    guard let description = error?.localizedDescription else {
                        return
                    }
                    self.updateEmailError(text: description, animated: true)
                }
            } else {
                MemberDataManager.createMember(email: email, username: username, password: password, onSuccess: {
                    self.dismiss(animated: true, completion: nil)
                }) { (error) in
                    self.updateLoader(visible: false, animated: true)
                    guard let description = error?.localizedDescription else {
                        return
                    }
                    self.updateEmailError(text: description, animated: true)
                }
            }
        }
    }
    
    func updateLoader(visible: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.5 : 0) {
            self.submitButton.alpha = visible ? 0 : 1
            self.activityIndicator.alpha = visible ? 1 : 0
        }
    }
    
    //MARK: Helpers
    
    func updateEmailError(text: String, animated: Bool) {
        if text.count > 0 {
            emailTopConstraint.constant = 10
            emailErrorLabel.text = text
            UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
                self.emailErrorLabel.alpha = 1
                
                self.view.layoutIfNeeded()
            })
        } else {
            emailTopConstraint.constant =  emailErrorLabel.bounds.height * -1
            UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
                self.emailErrorLabel.alpha = 0
                
                self.view.layoutIfNeeded()
            }) { (complete: Bool) in
                self.emailErrorLabel.text = ""
                self.emailTopConstraint.constant =  0
            }
        }
    }
    
    func updateUsernameError(text: String, animated: Bool) {
        if text.count > 0 {
            passwordTopConstraint.constant = 60
            usernameErrorLabel.text = text
            UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
                self.usernameErrorLabel.alpha = 1
                
                self.view.layoutIfNeeded()
            })
        } else {
            passwordTopConstraint.constant =  40
            UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
                self.usernameErrorLabel.alpha = 0
                
                self.view.layoutIfNeeded()
            }) { (complete: Bool) in
                self.usernameErrorLabel.text = ""
            }
        }
    }
    
    func updatePasswordError(text: String, animated: Bool) {
        if text.count > 0 {
            passwordErrorLabel.text = text
            UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
                self.passwordErrorLabel.alpha = 1
            })
        } else {
            UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
                self.passwordErrorLabel.alpha = 0
            }) { (complete: Bool) in
                self.passwordErrorLabel.text = ""
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        submitButtonTouched()
        return true
    }
}
