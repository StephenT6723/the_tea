//
//  EditMyAccountViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 10/4/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

//TODO: Add @'s to twitter and insta when needed

class EditMyAccountViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let nameTextField = InputField()
    private let facebookTextField = InputField()
    private let facebookSwitch = UISwitch()
    private let instagramTextField = InputField()
    private let twitterTextField = InputField()
    private let logoutButton = AlertCTA()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "EDIT PROFILE"
        view.backgroundColor = UIColor.primaryBrand()
        edgesForExtendedLayout = UIRectEdge()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTouched))
        navigationItem.leftBarButtonItem = cancelButton
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTouched))
        navigationItem.rightBarButtonItem = saveButton
        
        guard let member = MemberDataManager.sharedInstance.currentMember() else {
            return
        }
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.textField.placeholder = "NAME"
        nameTextField.textField.autocapitalizationType = .words
        nameTextField.textField.addTarget(self, action: #selector(updateSaveButtons), for: .editingChanged)
        nameTextField.textField.text = member.name
        scrollView.addSubview(nameTextField)
        
        facebookSwitch.tintColor = UIColor.primaryCTA()
        facebookSwitch.onTintColor = UIColor.primaryCTA()
        facebookSwitch.isOn = member.linkToFacebook
        facebookSwitch.addTarget(self, action: #selector(updateSaveButtons), for: .valueChanged)
        
        facebookTextField.translatesAutoresizingMaskIntoConstraints = false
        facebookTextField.textField.text = "LINK TO FACEBOOK IN MY PROFILE"
        facebookTextField.textField.isUserInteractionEnabled = false
        facebookTextField.accessoryView = facebookSwitch
        scrollView.addSubview(facebookTextField)
        
        instagramTextField.translatesAutoresizingMaskIntoConstraints = false
        instagramTextField.textField.placeholder = "INSTAGRAM"
        instagramTextField.textField.autocapitalizationType = .none
        instagramTextField.textField.addTarget(self, action: #selector(updateSaveButtons), for: .editingChanged)
        instagramTextField.textField.text = member.instagram
        scrollView.addSubview(instagramTextField)
        
        twitterTextField.translatesAutoresizingMaskIntoConstraints = false
        twitterTextField.textField.placeholder = "TWITTER"
        twitterTextField.textField.autocapitalizationType = .none
        twitterTextField.textField.addTarget(self, action: #selector(updateSaveButtons), for: .editingChanged)
        twitterTextField.textField.text = member.twitter
        scrollView.addSubview(twitterTextField)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setTitle("LOG OUT", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTouched), for: .touchUpInside)
        scrollView.addSubview(logoutButton)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        nameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: InputField.textFieldHeight).isActive = true
        
        facebookTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        facebookTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        facebookTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
        facebookTextField.heightAnchor.constraint(equalToConstant: InputField.textFieldHeight).isActive = true
        
        instagramTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        instagramTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        instagramTextField.topAnchor.constraint(equalTo: facebookTextField.bottomAnchor).isActive = true
        instagramTextField.heightAnchor.constraint(equalToConstant: InputField.textFieldHeight).isActive = true
        
        twitterTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        twitterTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        twitterTextField.topAnchor.constraint(equalTo: instagramTextField.bottomAnchor).isActive = true
        twitterTextField.heightAnchor.constraint(equalToConstant: InputField.textFieldHeight).isActive = true
        
        logoutButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        logoutButton.topAnchor.constraint(equalTo: twitterTextField.bottomAnchor, constant: 20).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: AlertCTA.preferedHeight).isActive = true
        
        updateSaveButtons()
    }
    
    func updateSaveButtons() {
        let enabled = dataUpdated()
        
        navigationItem.rightBarButtonItem?.isEnabled = enabled
    }
    
    func dataUpdated() -> Bool {
        if !MemberDataManager.sharedInstance.isLoggedIn() {
            return false
        }
        
        guard let member = MemberDataManager.sharedInstance.currentMember() else {
            return false
        }
        
        if let name = nameTextField.textField.text {
            if name.characters.count > 0 && name != member.name {
                return true
            }
        }
        if facebookSwitch.isOn != member.linkToFacebook {
            return true
        }
        
        if instagramTextField.textField.text != member.instagram {
            return true
        }
        
        if twitterTextField.textField.text != member.twitter {
            return true
        }
        
        return false
    }
    
    //MARK: ACTIONS
    
    func cancelButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    func saveButtonTouched() {
        guard let name = nameTextField.textField.text else {
            return
        }
        MemberDataManager.sharedInstance.updateCurrentMember(name: name, linkToFacebook: facebookSwitch.isOn, instagram: instagramTextField.textField.text, twitter: twitterTextField.textField.text)
        dismiss(animated: true, completion: nil)
    }
    
    func logoutButtonTouched() {
        MemberDataManager.sharedInstance.logoutCurrentMember()
        dismiss(animated: true, completion: nil)
    }
}
