//
//  EventEditViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/11/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

class EventEditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    var event: Event?
    private let nameTextField = UITextField()
    private let createButton = UIButton()
    private let backgroundView = UIView()
    private let dateBackground = UIView()
    private let startTimeTextField = UITextField()
    private let startTimePicker = UIDatePicker()
    private let addEndTimeButton = UIButton()
    private var endTimeTopConstraint = NSLayoutConstraint()
    private let endTimeTextField = UITextField()
    private let endTimePicker = UIDatePicker()
    private let hideEndTimeButton = UIButton()
    private let aboutTextView = UITextView()
    
    private let aboutTextViewPlaceholder = "More info"
    private let textFieldHeight: CGFloat = 40.0

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
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor(white: 0.85, alpha: 1)
        view.addSubview(backgroundView)
        
        dateBackground.translatesAutoresizingMaskIntoConstraints = false
        dateBackground.backgroundColor = .white
        view.addSubview(dateBackground)
        
        startTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        startTimeTextField.backgroundColor = .white
        startTimeTextField.tintColor = UIColor.white
        startTimePicker.minimumDate = Date()
        startTimePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        startTimeTextField.inputView = startTimePicker
        view.addSubview(startTimeTextField)
        
        addEndTimeButton.translatesAutoresizingMaskIntoConstraints = false
        addEndTimeButton.setTitle("+ End Time", for: .normal)
        addEndTimeButton.setTitleColor(UIColor(red: 0, green: 0.5, blue: 1, alpha: 1), for: .normal)
        addEndTimeButton.addTarget(self, action: #selector(addEndTimeTouched), for: .touchUpInside)
        view.addSubview(addEndTimeButton)
        
        endTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        endTimeTextField.backgroundColor = .white
        endTimeTextField.tintColor = UIColor.white
        endTimeTextField.alpha = 0
        endTimePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        endTimePicker.minimumDate = Date()
        endTimeTextField.inputView = endTimePicker
        view.insertSubview(endTimeTextField, belowSubview: startTimeTextField)
        
        hideEndTimeButton.translatesAutoresizingMaskIntoConstraints = false
        hideEndTimeButton.setTitle("X", for: .normal)
        hideEndTimeButton.setTitleColor(UIColor(red: 0, green: 0.5, blue: 1, alpha: 1), for: .normal)
        hideEndTimeButton.addTarget(self, action: #selector(hideEndTimeTouched), for: .touchUpInside)
        view.insertSubview(hideEndTimeButton, belowSubview: startTimeTextField)
        
        aboutTextView.translatesAutoresizingMaskIntoConstraints = false
        aboutTextView.text = aboutTextViewPlaceholder
        aboutTextView.textColor = .lightGray
        aboutTextView.backgroundColor = .white
        aboutTextView.isScrollEnabled = false
        aboutTextView.delegate = self
        aboutTextView.font = UIFont.systemFont(ofSize: 17)
        view.addSubview(aboutTextView)
        
        nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        nameTextField.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        dateBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        dateBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        dateBackground.topAnchor.constraint(equalTo: startTimeTextField.topAnchor).isActive = true
        dateBackground.bottomAnchor.constraint(equalTo: aboutTextView.bottomAnchor).isActive = true
        
        startTimeTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
        startTimeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        startTimeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        startTimeTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        addEndTimeButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
        addEndTimeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        addEndTimeButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        addEndTimeButton.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        endTimeTopConstraint = endTimeTextField.topAnchor.constraint(equalTo: startTimeTextField.topAnchor)
        endTimeTopConstraint.isActive = true
        endTimeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        endTimeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        endTimeTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        hideEndTimeButton.topAnchor.constraint(equalTo: endTimeTextField.topAnchor).isActive = true
        hideEndTimeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        hideEndTimeButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        hideEndTimeButton.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        aboutTextView.topAnchor.constraint(equalTo: endTimeTextField.bottomAnchor).isActive = true
        aboutTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        aboutTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        aboutTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: textFieldHeight).isActive = true
        
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
            
            updateEndTime()
        } else {
            if let event = self.event {
                nameTextField.text = event.name
                if let startTime = event.startTime {
                    startTimePicker.date = startTime as Date
                    if let endTime = event.endTime {
                        endTimePicker.date = endTime as Date
                        updateEndTime(visible: true, animated: false)
                    } else {
                        updateEndTime()
                    }
                }
                if let about = event.about {
                    if about.characters.count > 0 {
                        aboutTextView.text = about
                        aboutTextView.textColor = .black
                    }
                }
            }
        }
        
        updateTimeTextFields()
        
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
    
    func updateTimeTextFields() {
        startTimeTextField.text = DateStringHelper.fullDescription(of: startTimePicker.date)
        if endTimePicker.date < startTimePicker.date {
            updateEndTime()
        }
        endTimeTextField.text = "Ends \(DateStringHelper.fullDescription(of: endTimePicker.date))"
        endTimePicker.minimumDate = startTimePicker.date
    }
    
    func updateEndTime() {
        let calendar = NSCalendar.current
        if let newEndTime = calendar.date(byAdding: .hour, value: 1, to: startTimePicker.date) {
            endTimePicker.date = newEndTime
        }
    }
    
    //MARK: Helpers
    
    func isCreatingNew() -> Bool {
        return event == nil
    }
    
    func isEndTimeVisible() -> Bool {
        return endTimeTextField.alpha > 0
    }
    
    func saveEvent() {
        var aboutText = ""
        if aboutTextView.text != aboutTextViewPlaceholder && aboutTextView.text.characters.count > 0 {
            aboutText = aboutTextView.text
        }
        if isCreatingNew() {
            if let name = nameTextField.text {
                if name.characters.count > 0 {
                    EventManager.createEvent(name: name, startTime: startTimePicker.date, endTime: isEndTimeVisible() ? endTimePicker.date : nil, about: aboutText)
                }
            }
        } else {
            if let event = self.event {
                if let name = nameTextField.text {
                    if name.characters.count > 0 {
                        EventManager.updateEvent(event: event, name: name, startTime: startTimePicker.date, endTime: isEndTimeVisible() ? endTimePicker.date : nil, about: aboutText)
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
        updateTimeTextFields()
    }
    
    func addEndTimeTouched() {
        updateEndTime(visible: true, animated: true)
    }
    
    func hideEndTimeTouched() {
        updateEndTime(visible: false, animated: true)
    }
    
    func updateEndTime(visible: Bool, animated: Bool) {
        if visible {
            endTimeTopConstraint.constant = textFieldHeight
            endTimeTextField.alpha = 1
            UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
                self.addEndTimeButton.alpha = 0
                self.view.layoutIfNeeded()
            })
        } else {
            endTimeTopConstraint.constant = 0
            UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
                self.addEndTimeButton.alpha = 1
                self.view.layoutIfNeeded()
            }) { (complete: Bool) in
                self.endTimeTextField.alpha = 0
            }
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
    
    //MARK Text View Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "More info"
            textView.textColor = .lightGray
        }
    }
}
