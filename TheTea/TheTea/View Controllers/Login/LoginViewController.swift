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
    private var selectedType:AuthType? = .signIn
    
    private let backgroundImageView = UIImageView(image: UIImage(named: "jdfj"))
    
    private let emailErrorLabel = UILabel()
    private let emailInputField = InputField(frame: CGRect(x: 0, y: 0, width: 0, height: 500))
    private let usernameInputField = InputField(frame: CGRect())
    private let passwordInputField = InputField(frame: CGRect(x: 0, y: 0, width: 300, height: 56))
    private let confirmPasswordInputField = InputField(frame: CGRect())
    private let usernameErrorLabel = UILabel()
    private let passwordErrorLabel = UILabel()
    
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    private let textFieldHeight: CGFloat = 56.0
    private var emailTopConstraint = NSLayoutConstraint()
    private var usernameTopConstraint = NSLayoutConstraint()
    private var passwordTopConstraint = NSLayoutConstraint()
    private var confirmPasswordTopConstraint = NSLayoutConstraint()
    
    private let termsRadioButton = RadioButton(frame: CGRect())
    private let termsLabel = UILabel()
    private let submitButton = UIButton()
    private let modeChangeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "WELCOME"
        view.backgroundColor = UIColor(red: 200.0/255.0, green: 125.0/255.0, blue: 237.0/255.0, alpha: 1)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        
        emailErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        emailErrorLabel.numberOfLines = 0
        emailErrorLabel.font = UIFont.body()
        emailErrorLabel.textColor = .red
        //view.addSubview(emailErrorLabel)
        
        emailInputField.translatesAutoresizingMaskIntoConstraints = false
        emailInputField.title = "EMAIL ADDRESS"
        emailInputField.textField.autocapitalizationType = .none
        emailInputField.textField.addTarget(self, action: #selector(updateSubmitButton), for: .editingChanged)
        emailInputField.selectedColor = .white
        emailInputField.deSelectedColor = .white
        emailInputField.textField.textColor = .white
        emailInputField.textField.tintColor = .white
        view.addSubview(emailInputField)
        
        usernameInputField.translatesAutoresizingMaskIntoConstraints = false
        usernameInputField.title = "USERNAME"
        usernameInputField.textField.autocapitalizationType = .words
        usernameInputField.textField.addTarget(self, action: #selector(updateSubmitButton), for: .editingChanged)
        usernameInputField.selectedColor = .white
        usernameInputField.deSelectedColor = .white
        usernameInputField.textField.textColor = .white
        usernameInputField.textField.textColor = .white
        view.insertSubview(usernameInputField, belowSubview: emailInputField)
        
        usernameErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameErrorLabel.numberOfLines = 0
        usernameErrorLabel.font = UIFont.body()
        usernameErrorLabel.textColor = .red
        //view.addSubview(usernameErrorLabel)
        
        passwordInputField.translatesAutoresizingMaskIntoConstraints = false
        passwordInputField.title = "PASSWORD"
        passwordInputField.textField.isSecureTextEntry = true
        passwordInputField.textField.autocapitalizationType = .none
        passwordInputField.textField.delegate = self
        passwordInputField.textField.addTarget(self, action: #selector(updateSubmitButton), for: .editingChanged)
        passwordInputField.selectedColor = .white
        passwordInputField.deSelectedColor = .white
        passwordInputField.textField.textColor = .white
        passwordInputField.textField.textColor = .white
        view.addSubview(passwordInputField)
        
        confirmPasswordInputField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordInputField.title = "CONFIRM PASSWORD"
        confirmPasswordInputField.textField.autocapitalizationType = .none
        confirmPasswordInputField.textField.isSecureTextEntry = true
        confirmPasswordInputField.textField.addTarget(self, action: #selector(updateSubmitButton), for: .editingChanged)
        confirmPasswordInputField.selectedColor = .white
        confirmPasswordInputField.deSelectedColor = .white
        confirmPasswordInputField.textField.textColor = .white
        confirmPasswordInputField.textField.textColor = .white
        view.insertSubview(confirmPasswordInputField, belowSubview: passwordInputField)
        
        passwordErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordErrorLabel.numberOfLines = 0
        passwordErrorLabel.font = UIFont.body()
        passwordErrorLabel.textColor = .red
        //view.addSubview(passwordErrorLabel)
        
        termsRadioButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(termsRadioButton)
        
        termsLabel.translatesAutoresizingMaskIntoConstraints = false
        termsLabel.text = "I agree with terms & conditions"
        termsLabel.textColor = .white
        termsLabel.font = UIFont.listSubTitle()
        view.addSubview(termsLabel)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
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
        
//        emailErrorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
//        emailErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//        emailErrorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        let yOffset = -1 * (26.0 + 4 * textFieldHeight + 24 * 3)
        emailInputField.topAnchor.constraint(equalTo: termsRadioButton.topAnchor, constant: yOffset).isActive = true
        emailInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        emailInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        emailInputField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        usernameTopConstraint = usernameInputField.topAnchor.constraint(equalTo: emailInputField.bottomAnchor, constant: 24)
        usernameTopConstraint.isActive = true
        usernameInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        usernameInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        usernameInputField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
//        usernameErrorLabel.topAnchor.constraint(equalTo: usernameInputField.bottomAnchor, constant: 10).isActive = true
//        usernameErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//        usernameErrorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        passwordTopConstraint = passwordInputField.topAnchor.constraint(equalTo: usernameInputField.bottomAnchor, constant: 24)
        passwordTopConstraint.isActive = true
        passwordInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        passwordInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        passwordInputField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        confirmPasswordTopConstraint = confirmPasswordInputField.topAnchor.constraint(equalTo: passwordInputField.bottomAnchor, constant: 24)
        confirmPasswordTopConstraint.isActive = true
        confirmPasswordInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        confirmPasswordInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        confirmPasswordInputField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        //passwordErrorLabel.topAnchor.constraint(equalTo: confirmPasswordInputField.bottomAnchor, constant: 10).isActive = true
        //passwordErrorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        //passwordErrorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        
        
        activityIndicator.centerXAnchor.constraint(equalTo: submitButton.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor).isActive = true
        
        termsRadioButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        termsRadioButton.heightAnchor.constraint(equalToConstant: RadioButton.preferedSize).isActive = true
        termsRadioButton.widthAnchor.constraint(equalToConstant: RadioButton.preferedSize).isActive = true
        termsRadioButton.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -32).isActive = true
        
        termsLabel.centerYAnchor.constraint(equalTo: termsRadioButton.centerYAnchor).isActive = true
        termsLabel.leadingAnchor.constraint(equalTo: termsRadioButton.trailingAnchor, constant: 8).isActive = true
        
        submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
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
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        //SETUP
        
        //updateEmailError(text: "", animated: false)
        //updateUsernameError(text: "", animated: false)
        //updatePasswordError(text: "", animated: false)
        updateSubmitButton()
        updateLoader(visible: false, animated: false)
        modeChanged(animated: false)
    }
    
    //MARK: Actions
    
    @objc func modeChangeButtonTouched() {
        guard let previousType = selectedType else {
            selectedType = .signIn
            modeChanged(animated: true)
            return
        }
        
        selectedType = previousType == .signIn ? .register : .signIn
        modeChanged(animated: true)
    }
    
    @objc func modeChanged(animated: Bool) {
        updateEmailError(text: "", animated: true)
        updateUsernameError(text: "", animated: true)
        updatePasswordError(text: "", animated: true)
        if selectedType == .register {
            submitButton.setTitle("SIGN UP", for: .normal)
            modeChangeButton.setTitle("Already have an account? Log In", for: .normal)
            view.layoutIfNeeded()
            
            confirmPasswordTopConstraint.constant = 24
            confirmPasswordInputField.alpha = 1
            
            usernameTopConstraint.constant = 24
            usernameInputField.alpha = 1
            
            UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
                self.termsLabel.alpha = 1
                self.termsRadioButton.alpha = 1
                self.view.layoutIfNeeded()
            })
        } else {
            submitButton.setTitle("LOG IN", for: .normal)
            modeChangeButton.setTitle("Dont have an account? Sign Up", for: .normal)
            view.layoutIfNeeded()
            
            confirmPasswordTopConstraint.constant = -1 * textFieldHeight
            usernameTopConstraint.constant = -1 * textFieldHeight
            
            UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
                self.confirmPasswordInputField.alpha = 0
                self.usernameInputField.alpha = 0
                self.view.layoutIfNeeded()
                self.termsLabel.alpha = 0
                self.termsRadioButton.alpha = 0
            }) { (complete: Bool) in
                
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
        
        //updateEmailError(text: emailError, animated: true)
        //updateUsernameError(text: usernameError, animated: true)
        //updatePasswordError(text: passwordError, animated: true)
        
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
            passwordTopConstraint.constant =  24
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
}
