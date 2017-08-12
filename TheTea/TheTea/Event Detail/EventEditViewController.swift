//
//  EventEditViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/11/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

class EventEditViewController: UIViewController {
    var event: Event?
    private let nameTextField = UITextField()
    private let createButton = UIButton()
    private let backgroundView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = UIRectEdge()
        view.backgroundColor = .white
        updateTitle()
        updateNavButtons()
        
        let margins = view.layoutMarginsGuide
        
        if isCreatingNew() {
            nameTextField.translatesAutoresizingMaskIntoConstraints = false
            nameTextField.placeholder = "Event Name"
            nameTextField.backgroundColor = .white
            nameTextField.autocapitalizationType = .words
            view.addSubview(nameTextField)
            
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
            nameTextField.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
            nameTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            createButton.translatesAutoresizingMaskIntoConstraints = false
            createButton.setTitle("Create", for: .normal)
            createButton.setTitleColor(UIColor(red: 0, green: 0.5, blue: 1, alpha: 1), for: .normal)
            createButton.addTarget(self, action: #selector(createButtonTouched), for: .touchUpInside)
            createButton.backgroundColor = .white
            view.addSubview(createButton)
            
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            createButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            backgroundView.backgroundColor = UIColor(white: 0.8, alpha: 1)
            view.addSubview(backgroundView)
            
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            backgroundView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
            backgroundView.bottomAnchor.constraint(equalTo: createButton.topAnchor).isActive = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK: Display Update
    
    func updateTitle() {
        if isCreatingNew() {
            title = "Add Event"
        } else {
            title = "Edit Event"
        }
    }
    
    func updateNavButtons() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTouched))
        navigationItem.leftBarButtonItem = cancelButton
        
        if !isCreatingNew() {
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTouched))
            navigationItem.leftBarButtonItem = doneButton
        }
    }
    
    //MARK: Helpers
    
    func isCreatingNew() -> Bool {
        return event == nil
    }
    
    func saveEvent() {
        if let name = nameTextField.text {
            if name.characters.count > 0 {
                EventManager.createEvent(name: name, startTime: Date(), endTime: nil)
            }
        }
    }
    
    //MARK: Actions
    
    func cancelButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    func doneButtonTouched() {
        saveEvent()
        dismiss(animated: true, completion: nil)
    }
    
    func createButtonTouched() {
        saveEvent()
        dismiss(animated: true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame = CGRect(x: 0, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height - keyboardSize.height)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame = CGRect(x: 0, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height + keyboardSize.height)
        }
    }
}
