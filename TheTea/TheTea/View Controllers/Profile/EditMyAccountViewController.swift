//
//  EditMyAccountViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 10/4/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

//TODO: Add @'s to twitter and insta when needed

class EditMyAccountViewController: UIViewController, UITextViewDelegate {
    private let scrollView = UIScrollView()
    private let nameTextField = InputField()
    private let facebookTextField = InputField()
    private let instagramTextField = InputField()
    private let twitterTextField = InputField()
    private let aboutTextView = InputField()
    private let logoutButton = UIButton()
    
    private let submitContainer = UIView()
    private let submitButton = PrimaryCTA(frame: CGRect())
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    private let textFieldHeight: CGFloat = 56.0
    
    private let aboutTextViewPlaceholder = "ABOUT ME"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "EDIT PROFILE"
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = UIRectEdge()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTouched))
        navigationItem.leftBarButtonItem = cancelButton
        
        guard let member = MemberDataManager.loggedInMember() else {
            return
        }
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        //TODO: Update placeholder colors
        nameTextField.title = "NAME"
        nameTextField.textField.autocapitalizationType = .words
        nameTextField.textField.addTarget(self, action: #selector(updateSaveButtons), for: .editingChanged)
        nameTextField.textField.text = member.name
        scrollView.addSubview(nameTextField)
        
        facebookTextField.translatesAutoresizingMaskIntoConstraints = false
        facebookTextField.title = "FACEBOOK"
        facebookTextField.textField.autocapitalizationType = .none
        facebookTextField.textField.addTarget(self, action: #selector(updateSaveButtons), for: .editingChanged)
        facebookTextField.textField.text = member.facebookID
        scrollView.addSubview(facebookTextField)
        
        instagramTextField.translatesAutoresizingMaskIntoConstraints = false
        instagramTextField.title = "INSTAGRAM"
        instagramTextField.textField.autocapitalizationType = .none
        instagramTextField.textField.addTarget(self, action: #selector(updateSaveButtons), for: .editingChanged)
        instagramTextField.textField.text = member.instagram
        scrollView.addSubview(instagramTextField)
        
        twitterTextField.translatesAutoresizingMaskIntoConstraints = false
        twitterTextField.title = "TWITTER"
        twitterTextField.textField.autocapitalizationType = .none
        twitterTextField.textField.addTarget(self, action: #selector(updateSaveButtons), for: .editingChanged)
        twitterTextField.textField.text = member.twitter
        scrollView.addSubview(twitterTextField)
        
        aboutTextView.translatesAutoresizingMaskIntoConstraints = false
        aboutTextView.title = "ABOUT ME"
        aboutTextView.type = .textView
        aboutTextView.textView.text = member.about
        scrollView.addSubview(aboutTextView)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setTitle("LOG OUT", for: .normal)
        logoutButton.setTitleColor(UIColor.primaryCTA(), for: .normal)
        logoutButton.titleLabel?.font = UIFont.cta()
        logoutButton.addTarget(self, action: #selector(logoutButtonTouched), for: .touchUpInside)
        scrollView.addSubview(logoutButton)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        nameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        nameTextField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        facebookTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        facebookTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        facebookTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24).isActive = true
        facebookTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        instagramTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        instagramTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        instagramTextField.topAnchor.constraint(equalTo: facebookTextField.bottomAnchor, constant: 24).isActive = true
        instagramTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        twitterTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        twitterTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        twitterTextField.topAnchor.constraint(equalTo: instagramTextField.bottomAnchor, constant: 24).isActive = true
        twitterTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        aboutTextView.topAnchor.constraint(equalTo: twitterTextField.bottomAnchor, constant: 24).isActive = true
        aboutTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        aboutTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        aboutTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: textFieldHeight).isActive = true
        
        logoutButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        logoutButton.topAnchor.constraint(equalTo: aboutTextView.bottomAnchor, constant: 20).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
        
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
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        submitContainer.addSubview(activityIndicator)
        
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.addTarget(self, action: #selector(saveButtonTouched), for: .touchUpInside)
        submitContainer.addSubview(submitButton)
        
        submitContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        submitContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        submitContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        submitContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        submitButton.leadingAnchor.constraint(equalTo: submitContainer.leadingAnchor, constant: 20).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: submitContainer.trailingAnchor, constant: -20).isActive = true
        submitButton.topAnchor.constraint(equalTo: submitContainer.topAnchor, constant: 14).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: CGFloat(PrimaryCTA.preferedHeight)).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: submitButton.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor).isActive = true
        
        updateSaveButtons()
    }
    
    @objc func updateSaveButtons() {
        let enabled = dataUpdated()
        
        submitButton.isEnabled = enabled
    }
    
    func dataUpdated() -> Bool {
        if !MemberDataManager.isLoggedIn() {
            return false
        }
        
        guard let member = MemberDataManager.loggedInMember() else {
            return false
        }
        
        if let name = nameTextField.textField.text {
            if name.count > 0 && name != member.name {
                return true
            }
        }
        
        if facebookTextField.textField.text != member.facebookID {
            return true
        }
        
        if instagramTextField.textField.text != member.instagram {
            return true
        }
        
        if twitterTextField.textField.text != member.twitter {
            return true
        }
        
        if aboutTextView.textView.text != member.about && aboutTextView.textView.text != aboutTextViewPlaceholder {
            return true
        }
        
        return false
    }
    
    //MARK: ACTIONS
    
    @objc func cancelButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTouched() {
        guard let name = nameTextField.textField.text else {
            return
        }
        let about = aboutTextView.textView.text == aboutTextViewPlaceholder ? nil : aboutTextView.textView.text
        self.updateLoader(visible: true, animated: true)
        MemberDataManager.updateMember(name: name, email: MemberDataManager.loggedInMember()?.email, facebookID: facebookTextField.textField.text, instagram: instagramTextField.textField.text, twitter: twitterTextField.textField.text, about: about, onSuccess: {
            self.dismiss(animated: true, completion: nil)
        }) { (error) in
            //TODO: Display Error somewhere
            self.updateLoader(visible: false, animated: true)
            print(error?.localizedDescription ?? "Unable to save member")
        }
    }
    
    func updateLoader(visible: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            self.submitButton.alpha = visible ? 0 : 1
            if visible {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @objc func logoutButtonTouched() {
        //TODO: Show loader somewhere
        MemberDataManager.logoutMember()
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK Text View Delegate
    
    func textViewDidChange(_ textView: UITextView) {
        updateSaveButtons()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightCopy() {
            textView.text = nil
            textView.textColor = UIColor.primaryCopy()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = aboutTextViewPlaceholder
            textView.textColor = UIColor.lightCopy()
        }
    }
}
