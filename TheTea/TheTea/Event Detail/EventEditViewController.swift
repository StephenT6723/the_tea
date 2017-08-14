//
//  EventEditViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/11/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

class EventEditViewController: UIViewController, UITextFieldDelegate {
    var event: Event?
    private let nameTextField = UITextField()
    private let createButton = UIButton()
    private let backgroundView = UIView()
    private let dateBackground = UIView()
    private let startTimeTextField = UITextField()
    private let startTimePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = UIRectEdge()
        view.backgroundColor = .white
        updateTitle()
        updateNavButtons()
        
        let margins = view.layoutMarginsGuide
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.placeholder = "Event Name"
        nameTextField.backgroundColor = .white
        nameTextField.autocapitalizationType = .words
        view.addSubview(nameTextField)
        
        nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        nameTextField.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor(white: 0.85, alpha: 1)
        view.addSubview(backgroundView)
        
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        dateBackground.translatesAutoresizingMaskIntoConstraints = false
        dateBackground.backgroundColor = .white
        view.addSubview(dateBackground)
        
        dateBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        dateBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        dateBackground.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
        dateBackground.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        startTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        startTimeTextField.text = DateStringHelper.fullDescription(of: Date())
        startTimeTextField.backgroundColor = .white
        startTimeTextField.tintColor = UIColor.white
        startTimePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        startTimeTextField.inputView = startTimePicker
        view.addSubview(startTimeTextField)
        
        startTimeTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
        startTimeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        startTimeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        startTimeTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        if isCreatingNew() {
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
        } else {
            if let event = self.event {
                nameTextField.text = event.name
                if let startTime = event.startTime {
                    startTimePicker.date = startTime as Date
                    startTimeTextField.text = DateStringHelper.fullDescription(of: startTime as Date)
                }
            }
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
            navigationItem.rightBarButtonItem = doneButton
        }
    }
    
    //MARK: Helpers
    
    func isCreatingNew() -> Bool {
        return event == nil
    }
    
    func saveEvent() {
        if isCreatingNew() {
            if let name = nameTextField.text {
                if name.characters.count > 0 {
                    EventManager.createEvent(name: name, startTime: startTimePicker.date, endTime: nil)
                }
            }
        } else {
            if let event = self.event {
                if let name = nameTextField.text {
                    if name.characters.count > 0 {
                        EventManager.updateEvent(event: event, name: name, startTime: startTimePicker.date, endTime: nil)
                    }
                }
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
    
    func datePickerChanged(picker: UIDatePicker) {
        if startTimeTextField.isFirstResponder {
            startTimeTextField.text = DateStringHelper.fullDescription(of: picker.date)
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let screenHeight = UIScreen.main.bounds.height
            view.frame = CGRect(x: 0, y: view.frame.origin.y, width: view.frame.width, height: screenHeight - (keyboardSize.height + view.frame.origin.y))
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let screenHeight = UIScreen.main.bounds.height
        view.frame = CGRect(x: 0, y: view.frame.origin.y, width: view.frame.width, height: screenHeight - view.frame.origin.y)
    }
}
