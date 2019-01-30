//
//  LoginViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/16/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

enum AuthType: Int {
    case register
    case signIn
}

protocol LoginViewDelegate {
    func loginSucceeded()
}

class LoginViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    var delegate: LoginViewDelegate?
    
    private var selectedType:AuthType? = .register
    
    private let scrollView = UIScrollView()
    
    private let logoTopSpacer = UIView()
    private let logoIconImageView = UIImageView(image: UIImage(named: "logoIcon"))
    private let logoImageView = UIImageView(image: UIImage(named: "logoWhite"))
    private let logoBottomSpacer = UIView()
    
    private let emailInputField = InputField(frame: CGRect(x: 0, y: 0, width: 0, height: 500))
    private let usernameInputField = InputField(frame: CGRect())
    private let passwordInputField = InputField(frame: CGRect(x: 0, y: 0, width: 300, height: 56))
    private let confirmPasswordInputField = InputField(frame: CGRect())
    
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    private let textFieldHeight: CGFloat = 56.0
    private var emailTopConstraint = NSLayoutConstraint()
    private var usernameTopConstraint = NSLayoutConstraint()
    private var passwordTopConstraint = NSLayoutConstraint()
    private var confirmPasswordTopConstraint = NSLayoutConstraint()
    
    private let termsRadioButton = RadioButton(frame: CGRect())
    private let termsTextView = UITextView()
    private let submitButton = UIButton()
    private let modeChangeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Welcome"
        view.backgroundColor = .clear
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTouched))
        navigationItem.leftBarButtonItem = cancelButton
        
        if let nav = navigationController as? ClearNavigationController {
            nav.backgroundImageView.image = UIImage(named: "placeholderBackground2")
        }
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        //scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        
        logoTopSpacer.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(logoTopSpacer)
        
        logoIconImageView.translatesAutoresizingMaskIntoConstraints = false
        logoIconImageView.contentMode = .scaleAspectFill
        scrollView.addSubview(logoIconImageView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFill
        scrollView.addSubview(logoImageView)
        
        logoBottomSpacer.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(logoBottomSpacer)
        
        emailInputField.translatesAutoresizingMaskIntoConstraints = false
        emailInputField.title = "EMAIL ADDRESS"
        emailInputField.textField.autocapitalizationType = .none
        emailInputField.textField.keyboardType = .emailAddress
        emailInputField.textField.returnKeyType = .done
        emailInputField.textField.addTarget(self, action: #selector(updateSubmitButton), for: .editingChanged)
        emailInputField.selectedColor = .white
        emailInputField.deSelectedColor = .white
        emailInputField.textField.textColor = .white
        emailInputField.textField.tintColor = .white
        scrollView.addSubview(emailInputField)
        
        usernameInputField.translatesAutoresizingMaskIntoConstraints = false
        usernameInputField.title = "USERNAME"
        usernameInputField.textField.autocapitalizationType = .words
        usernameInputField.textField.returnKeyType = .done
        usernameInputField.textField.addTarget(self, action: #selector(updateSubmitButton), for: .editingChanged)
        usernameInputField.selectedColor = .white
        usernameInputField.deSelectedColor = .white
        usernameInputField.textField.textColor = .white
        usernameInputField.textField.textColor = .white
        usernameInputField.textField.tintColor = .white
        scrollView.insertSubview(usernameInputField, belowSubview: emailInputField)
        
        passwordInputField.translatesAutoresizingMaskIntoConstraints = false
        passwordInputField.title = "PASSWORD"
        passwordInputField.ctaButton.addTarget(self, action: #selector(forgotPasswordTouched), for: .touchUpInside)
        passwordInputField.textField.isSecureTextEntry = true
        passwordInputField.textField.autocapitalizationType = .none
        passwordInputField.textField.returnKeyType = .done
        passwordInputField.textField.addTarget(self, action: #selector(updateSubmitButton), for: .editingChanged)
        passwordInputField.selectedColor = .white
        passwordInputField.deSelectedColor = .white
        passwordInputField.textField.textColor = .white
        passwordInputField.textField.tintColor = .white
        scrollView.addSubview(passwordInputField)
        
        confirmPasswordInputField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordInputField.title = "CONFIRM PASSWORD"
        confirmPasswordInputField.textField.autocapitalizationType = .none
        confirmPasswordInputField.textField.isSecureTextEntry = true
        confirmPasswordInputField.textField.returnKeyType = .done
        confirmPasswordInputField.textField.addTarget(self, action: #selector(updateSubmitButton), for: .editingChanged)
        confirmPasswordInputField.selectedColor = .white
        confirmPasswordInputField.deSelectedColor = .white
        confirmPasswordInputField.textField.textColor = .white
        confirmPasswordInputField.textField.tintColor = .white
        scrollView.insertSubview(confirmPasswordInputField, belowSubview: passwordInputField)
        
        termsRadioButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(termsRadioButton)
        
        termsTextView.translatesAutoresizingMaskIntoConstraints = false
        termsTextView.isEditable = false
        termsTextView.isScrollEnabled = false
        termsTextView.backgroundColor = .clear
        let termsString = "I agree with terms & conditions"
        guard let termsFont = UIFont.listSubTitle() else { return }
        let termsAttrString = NSMutableAttributedString(string: termsString, attributes: [
            NSAttributedString.Key.font: termsFont, NSAttributedString.Key.foregroundColor: UIColor.white
            ])
        let textRange = NSMakeRange(13, 18)
        termsAttrString.addAttribute(.link, value: "", range: textRange)
        termsTextView.attributedText = termsAttrString
        termsTextView.linkTextAttributes = [NSAttributedString.Key.font: termsFont, NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
        termsTextView.font = UIFont.listSubTitle()
        termsTextView.delegate = self
        scrollView.addSubview(termsTextView)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        scrollView.addSubview(activityIndicator)
        
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.backgroundColor = .white
        submitButton.setTitleColor(UIColor.primaryCTA(), for: .normal)
        submitButton.titleLabel?.font = UIFont.cta()
        submitButton.layer.cornerRadius = 5
        submitButton.addTarget(self, action: #selector(submitButtonTouched), for: .touchUpInside)
        scrollView.addSubview(submitButton)
        
        modeChangeButton.translatesAutoresizingMaskIntoConstraints = false
        modeChangeButton.setTitleColor(.white, for: .normal)
        modeChangeButton.titleLabel?.font = UIFont.cta()
        modeChangeButton.addTarget(self, action: #selector(modeChangeButtonTouched), for: .touchUpInside)
        scrollView.addSubview(modeChangeButton)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 88).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        logoTopSpacer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        logoTopSpacer.heightAnchor.constraint(greaterThanOrEqualToConstant: 64).isActive = true
        logoTopSpacer.bottomAnchor.constraint(equalTo: logoIconImageView.topAnchor).isActive = true
        
        logoIconImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        logoImageView.topAnchor.constraint(equalTo: logoIconImageView.bottomAnchor, constant: 24).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        logoBottomSpacer.topAnchor.constraint(equalTo: logoImageView.bottomAnchor).isActive = true
        logoBottomSpacer.heightAnchor.constraint(equalTo: logoTopSpacer.heightAnchor).isActive = true
        logoBottomSpacer.bottomAnchor.constraint(equalTo: emailInputField.topAnchor).isActive = true
        
        let yOffset = -1 * (26.0 + 4 * textFieldHeight + 24 * 3)
        emailInputField.topAnchor.constraint(equalTo: termsRadioButton.topAnchor, constant: yOffset).isActive = true
        emailInputField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40).isActive = true
        emailInputField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40).isActive = true
        emailInputField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        usernameTopConstraint = usernameInputField.topAnchor.constraint(equalTo: emailInputField.bottomAnchor, constant: 24)
        usernameTopConstraint.isActive = true
        usernameInputField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40).isActive = true
        usernameInputField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40).isActive = true
        usernameInputField.widthAnchor.constraint(equalTo:view.widthAnchor, constant: -80).isActive = true
        usernameInputField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        passwordTopConstraint = passwordInputField.topAnchor.constraint(equalTo: usernameInputField.bottomAnchor, constant: 24)
        passwordTopConstraint.isActive = true
        passwordInputField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40).isActive = true
        passwordInputField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40).isActive = true
        passwordInputField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        confirmPasswordTopConstraint = confirmPasswordInputField.topAnchor.constraint(equalTo: passwordInputField.bottomAnchor, constant: 24)
        confirmPasswordTopConstraint.isActive = true
        confirmPasswordInputField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40).isActive = true
        confirmPasswordInputField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40).isActive = true
        confirmPasswordInputField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: submitButton.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor).isActive = true
        
        termsRadioButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40).isActive = true
        termsRadioButton.heightAnchor.constraint(equalToConstant: RadioButton.preferedSize).isActive = true
        termsRadioButton.widthAnchor.constraint(equalToConstant: RadioButton.preferedSize).isActive = true
        termsRadioButton.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -32).isActive = true
        
        termsTextView.centerYAnchor.constraint(equalTo: termsRadioButton.centerYAnchor).isActive = true
        termsTextView.leadingAnchor.constraint(equalTo: termsRadioButton.trailingAnchor, constant: 8).isActive = true
        
        submitButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: modeChangeButton.topAnchor, constant: -20).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        modeChangeButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        modeChangeButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        if UIScreen.main.bounds.height < 800 {
            modeChangeButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = true
        } else {
            modeChangeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        }
        modeChangeButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        //SETUP
        updateSubmitButton()
        updateLoader(visible: false, animated: false)
        modeChanged(animated: false)
    }
    
    //MARK: Actions
    
    @objc func cancelButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
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
        if selectedType == .register {
            submitButton.setTitle("SIGN UP", for: .normal)
            modeChangeButton.setTitle("Already have an account? Log In", for: .normal)
            passwordInputField.cta = ""
            view.layoutIfNeeded()
            
            confirmPasswordTopConstraint.constant = 24
            confirmPasswordInputField.alpha = 1
            
            usernameTopConstraint.constant = 24
            usernameInputField.alpha = 1
            
            UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
                self.termsTextView.alpha = 1
                self.termsRadioButton.alpha = 1
                self.view.layoutIfNeeded()
            })
        } else {
            submitButton.setTitle("LOG IN", for: .normal)
            modeChangeButton.setTitle("Dont have an account? Sign Up", for: .normal)
            passwordInputField.cta = "Forgot?"
            view.layoutIfNeeded()
            
            confirmPasswordTopConstraint.constant = -1 * textFieldHeight
            usernameTopConstraint.constant = -1 * textFieldHeight
            
            UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
                self.confirmPasswordInputField.alpha = 0
                self.usernameInputField.alpha = 0
                self.view.layoutIfNeeded()
                self.termsTextView.alpha = 0
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
        let termsAccepted = termsRadioButton.isSelected || selectedType == .signIn
        
        var emailError = ""
        var usernameError = ""
        var passwordError = ""
        
        if !emailValid {
            emailError = "Please enter a valid e-mail address"
        }
        if !usernameValid {
            usernameError = "Must be at least \(MemberDataManager.minUsernameLength) characters"
        }
        if !passwordsMatch {
            passwordError = "Your passwords do not match"
        }
        if !passwordValid {
            passwordError = "Must be at least \(MemberDataManager.minPasswordLength) characters"
        }
        
        updateEmailError(text: emailError, animated: true)
        updateUsernameError(text: usernameError, animated: true)
        updatePasswordError(text: passwordError, animated: true)
        
        if emailValid && usernameValid && passwordsMatch && passwordValid && termsAccepted {
            updateLoader(visible: true, animated: true)
            if selectedType == .signIn {
                MemberDataManager.loginMember(email: email, password: password, onSuccess: {
                    self.delegate?.loginSucceeded()
                    self.updateLoader(visible: false, animated: true)
                    self.dismiss(animated: true, completion: nil)
                }) { (error) in
                    self.updateLoader(visible: false, animated: true)
                    let alert = UIAlertController(title: "Error", message: "\(error?.localizedDescription ?? "We were unable to log you in. Please try again.")", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                MemberDataManager.createMember(email: email, username: username, password: password, onSuccess: {
                    self.delegate?.loginSucceeded()
                    self.updateLoader(visible: false, animated: true)
                    self.dismiss(animated: true, completion: nil)
                }) { (error) in
                    self.updateLoader(visible: false, animated: true)
                }
            }
        }
    }
    
    @objc func forgotPasswordTouched() {
        //TODO: Connect Functionality
        print("FORGOT PASSWORD")
    }
    
    func updateLoader(visible: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            self.submitButton.alpha = visible ? 0 : 1
            self.activityIndicator.alpha = visible ? 1 : 0
        }
    }
    
    //MARK: Helpers
    
    func updateEmailError(text: String, animated: Bool) {
        emailInputField.showError(text: text)
    }
    
    func updateUsernameError(text: String, animated: Bool) {
        usernameInputField.showError(text: text)
    }
    
    func updatePasswordError(text: String, animated: Bool) {
        passwordInputField.showError(text: text)
    }
    
    func reset() {
        selectedType = .signIn
        emailInputField.textField.text = ""
        usernameInputField.textField.text = ""
        passwordInputField.textField.text = ""
        confirmPasswordInputField.textField.text = ""
    }
    //MARK: Textview Delegate
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let termsVC = TermsViewController()
        let termsNav = ClearNavigationController(rootViewController: termsVC)
        present(termsNav, animated: true, completion: nil)
        return false
    }
}
