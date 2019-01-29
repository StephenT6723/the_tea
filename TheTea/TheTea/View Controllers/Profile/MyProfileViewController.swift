//
//  MyProfileViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 1/25/19.
//  Copyright © 2019 The Tea LLC. All rights reserved.
//

import UIKit
import CoreData

class MyProfileViewController: UIViewController, LoginViewDelegate {

    private let createEventButton = PrimaryCTA(frame: CGRect())
    private let favoritesButton = MyProfileEventButton(frame: CGRect())
    private let hostingButton = MyProfileEventButton(frame: CGRect())
    private let usernameInputField = InputField(frame: CGRect())
    private let emailInputField = InputField(frame: CGRect())
    
    private let saveButton = PrimaryCTA(frame: CGRect())
    private let cancelButton = UIButton()
    
    private let buttonWidth: CGFloat = 178.0
    private let textFieldHeight: CGFloat = 56.0
    
    private let loginVC = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTouched))
        
        title = "My Profile"
        view.backgroundColor = .white
        
        createEventButton.translatesAutoresizingMaskIntoConstraints = false
        createEventButton.setTitle("Add an Event  ", for: .normal)
        createEventButton.setImage(UIImage(named:"plannerIcon"), for: .normal)
        createEventButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        createEventButton.addTarget(self, action: #selector(addEventButtonTouched), for: .touchUpInside)
        view.addSubview(createEventButton)
        
        favoritesButton.translatesAutoresizingMaskIntoConstraints = false
        favoritesButton.titleLabel.text = "My Favorites".uppercased()
        favoritesButton.button.addTarget(self, action: #selector(favoritesButtonTouched), for: .touchUpInside)
        view.addSubview(favoritesButton)
        
        hostingButton.translatesAutoresizingMaskIntoConstraints = false
        hostingButton.titleLabel.text = "My Hosted Events".uppercased()
        hostingButton.button.addTarget(self, action: #selector(hostingButtonTouched), for: .touchUpInside)
        view.addSubview(hostingButton)
        
        usernameInputField.translatesAutoresizingMaskIntoConstraints = false
        usernameInputField.title = "USERNAME"
        usernameInputField.textField.autocapitalizationType = .words
        usernameInputField.textField.autocorrectionType = .no
        usernameInputField.textField.returnKeyType = .done
        usernameInputField.textField.addTarget(self, action: #selector(updateSaveButtons), for: .editingChanged)
        view.addSubview(usernameInputField)
        
        emailInputField.translatesAutoresizingMaskIntoConstraints = false
        emailInputField.title = "EMAIL ADDRESS"
        emailInputField.textField.autocapitalizationType = .none
        emailInputField.textField.keyboardType = .emailAddress
        emailInputField.textField.returnKeyType = .done
        emailInputField.textField.addTarget(self, action: #selector(updateSaveButtons), for: .editingChanged)
        view.addSubview(emailInputField)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Save Changes", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTouched), for: .touchUpInside)
        saveButton.alpha = 0
        view.addSubview(saveButton)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.lightCopy(), for: .normal)
        cancelButton.titleLabel?.font = UIFont.cta()
        cancelButton.addTarget(self, action: #selector(cancelButtonTouched), for: .touchUpInside)
        cancelButton.alpha = 0
        view.addSubview(cancelButton)
        
        createEventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createEventButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        createEventButton.heightAnchor.constraint(equalToConstant: PrimaryCTA.preferedHeight).isActive = true
        createEventButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        favoritesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        favoritesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        favoritesButton.topAnchor.constraint(equalTo: createEventButton.bottomAnchor, constant: 30).isActive = true
        favoritesButton.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        hostingButton.topAnchor.constraint(equalTo: favoritesButton.bottomAnchor, constant: 24).isActive = true
        hostingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        hostingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        hostingButton.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        usernameInputField.topAnchor.constraint(equalTo: hostingButton.bottomAnchor, constant: 24).isActive = true
        usernameInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        usernameInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        usernameInputField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        emailInputField.topAnchor.constraint(equalTo: usernameInputField.bottomAnchor, constant: 24).isActive = true
        emailInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emailInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emailInputField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: PrimaryCTA.preferedHeight).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        
        loginVC.delegate = self
        loginVC.view.alpha = 0
        self.addChild(loginVC)
        
        view.addSubview(loginVC.view)
        loginVC.view.translatesAutoresizingMaskIntoConstraints = false
        loginVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loginVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loginVC.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loginVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        loginVC.didMove(toParent: self)
        
        if !MemberDataManager.isLoggedIn() {
            presentLoginView()
        } else {
            setLoaderVisible(true, animated: false)
            
            MemberDataManager.fetchLoggedInMember(onSuccess: {
                self.updateContent()
                self.setLoaderVisible(false, animated: true)
            }) { (error) in
                self.setLoaderVisible(false, animated: true)
                print("ERROR UPDATING LOGGED IN MEMBER: \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateNavButtons()
        updateContent()
    }

    //MARK: Actions
    
    @objc func doneButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func logoutButtonTouched() {
        let alert = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Log out", style: .default, handler: { action in
            MemberDataManager.logoutMember()
            self.presentLoginView()
            self.updateNavButtons()
            self.updateContent()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    @objc func addEventButtonTouched() {
        let addEventVC = EventEditViewController()
        let addNav = ClearNavigationController(rootViewController: addEventVC)
        present(addNav, animated: true, completion: nil)
    }
    
    @objc func updateSaveButtons() {
        UIView.animate(withDuration: 0.3) {
            self.saveButton.alpha = self.contentUpdated() ? 1 : 0
            self.cancelButton.alpha = self.contentUpdated() ? 1 : 0
        }
    }
    
    @objc func favoritesButtonTouched() {
        guard let eventsFRC = EventManager.favoritedEvents() else {
            return
        }
        
        let eventCollectionVC = EventCollectionViewController()
        eventCollectionVC.eventsFRC = eventsFRC
        eventCollectionVC.title = "My Favorites"
        navigationController?.pushViewController(eventCollectionVC, animated: true)
    }
    
    @objc func hostingButtonTouched() {
        guard let eventsFRC = EventManager.hostedEvents() else {
            return
        }
        
        let eventCollectionVC = EventCollectionViewController()
        eventCollectionVC.eventsFRC = eventsFRC
        eventCollectionVC.title = "My Hosted Events"
        navigationController?.pushViewController(eventCollectionVC, animated: true)
    }
    
    @objc func saveButtonTouched() {
        guard let name = usernameInputField.textField.text, let email = emailInputField.textField.text else {
            return
        }
        
        if name.count < MemberDataManager.minUsernameLength {
            let alert = UIAlertController(title: "Error", message: "Please enter a username with more than \(MemberDataManager.minUsernameLength) letters.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        if !MemberDataManager.isValidEmail(email: email) {
            let alert = UIAlertController(title: "Error", message: "Please enter a valid email address.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        setLoaderVisible(true, animated: true)
        MemberDataManager.updateMember(name: name, email: email, facebookID: "", instagram: "", twitter: "", about: "", onSuccess: {
            self.setLoaderVisible(false, animated: true)
        }) { (error) in
            let alert = UIAlertController(title: "Error", message: "\(error?.localizedDescription ?? "We were unable to update your profile. Please try again.")", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
            self.setLoaderVisible(false, animated: true)
            print(error?.localizedDescription ?? "Unable to save member")
        }
    }
    
    @objc func cancelButtonTouched() {
        updateContent()
    }
    
    @objc func presentLoginView() {
        self.loginVC.view.alpha = 1
    }
    
    //MARK: Login View Delegate
    
    func loginSucceeded() {
        updateContent()
        UIView.animate(withDuration: 0.3, animations: {
            self.loginVC.view.alpha = 0
        }) { (_) in
            self.loginVC.reset()
        }
        updateNavButtons()
    }
    
    //MARK: Helpers
    
    func updateNavButtons() {
        navigationItem.rightBarButtonItem = MemberDataManager.isLoggedIn() ? UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logoutButtonTouched)) : nil
    }
    
    func updateContent() {
        favoritesButton.label.text = "\(MemberDataManager.loggedInMember()?.chronologicalFavorites().count ?? 0) Events"
        hostingButton.label.text = "\(MemberDataManager.loggedInMember()?.hotHosting().count ?? 0) Events"
        usernameInputField.textField.text = MemberDataManager.loggedInMember()?.name
        emailInputField.textField.text = MemberDataManager.loggedInMember()?.email
    }
    
    func contentUpdated() -> Bool {
        guard let member = MemberDataManager.loggedInMember() else {
            return false
        }
        
        return member.name != usernameInputField.textField.text ?? "" || member.email != emailInputField.textField.text ?? ""
    }
}

class MyProfileEventButton: UIControl {
    let button = UIButton()
    let titleLabel = UILabel()
    let label = UILabel()
    private let arrowImageView = UIImageView(image:UIImage(named: "arrow"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.inputFieldTitle()
        titleLabel.textColor = UIColor.lightCopy()
        addSubview(titleLabel)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.inputField()
        label.textColor = UIColor.primaryCopy()
        addSubview(label)
        
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.contentMode = .scaleAspectFill
        addSubview(arrowImageView)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        arrowImageView.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
