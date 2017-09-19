//
//  EventEditViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/11/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit
import MapKit

class EventEditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, LocationPickerViewControllerDelegate {
    var event: Event?
    private let scrollView = UIScrollView()
    private let nameTextField = EventEditField()
    private let hostTextField = EventEditField()
    private let loginView = EventEditLoginView(frame: CGRect())
    private let startTimeTextField = EventEditField()
    private let startTimePicker = UIDatePicker()
    private let addEndTimeButton = UIButton()
    private var endTimeTopConstraint = NSLayoutConstraint()
    private let endTimeTextField = EventEditField()
    private let endTimePicker = UIDatePicker()
    private let hideEndTimeButton = UIButton()
    private let locationLabel = EventEditField()
    private let aboutTextView = EventEditField()
    private let deleteButton = UIButton()
    
    private let createContainer = UIView()
    private let createButton = PrimaryCTA(frame: CGRect())
    
    private let aboutTextViewPlaceholder = "MORE INFO"
    private let textFieldHeight: CGFloat = 48.0
    private var selectedLocation: EventLocation?

    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = UIRectEdge()
        view.backgroundColor = UIColor.primaryBrand()
        updateTitle()
        updateNavButtons()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.textField.placeholder = "EVENT NAME"
        nameTextField.textField.autocapitalizationType = .words
        nameTextField.textField.addTarget(self, action: #selector(updateSaveButtons), for: .editingChanged)
        scrollView.addSubview(nameTextField)
        
        if let member = MemberDataManager.sharedInstance.currentMember() {
            guard let name = member.name else {
                return
            }
            
            hostTextField.translatesAutoresizingMaskIntoConstraints = false
            hostTextField.textField.text = "HOSTED BY: \(name)"
            hostTextField.textField.autocapitalizationType = .words
            hostTextField.showDivider = false
            scrollView.addSubview(hostTextField)
            
            hostTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            hostTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
            hostTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
            hostTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        } else {
            loginView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(loginView)
            
            loginView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            loginView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
            loginView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
            loginView.heightAnchor.constraint(equalToConstant: 74).isActive = true
        }
        
        startTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        startTimeTextField.textField.tintColor = UIColor.white
        startTimePicker.minimumDate = Date()
        startTimePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        startTimeTextField.textField.inputView = startTimePicker
        scrollView.addSubview(startTimeTextField)
        
        addEndTimeButton.translatesAutoresizingMaskIntoConstraints = false
        addEndTimeButton.setTitle("+ END TIME", for: .normal)
        addEndTimeButton.titleLabel?.font = UIFont.cta()
        addEndTimeButton.contentHorizontalAlignment = .right
        addEndTimeButton.setTitleColor(UIColor.primaryCTA(), for: .normal)
        addEndTimeButton.addTarget(self, action: #selector(addEndTimeTouched), for: .touchUpInside)
        startTimeTextField.accessoryView = addEndTimeButton
        
        endTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        endTimeTextField.textField.tintColor = UIColor.white
        endTimeTextField.alpha = 0
        endTimePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        endTimePicker.minimumDate = Date()
        endTimeTextField.textField.inputView = endTimePicker
        scrollView.insertSubview(endTimeTextField, belowSubview: startTimeTextField)
        
        hideEndTimeButton.translatesAutoresizingMaskIntoConstraints = false
        hideEndTimeButton.setTitle("X", for: .normal)
        hideEndTimeButton.titleLabel?.font = UIFont.cta()
        hideEndTimeButton.setTitleColor(UIColor.primaryCTA(), for: .normal)
        hideEndTimeButton.addTarget(self, action: #selector(hideEndTimeTouched), for: .touchUpInside)
        hideEndTimeButton.contentHorizontalAlignment = .right
        endTimeTextField.accessoryView = hideEndTimeButton
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.type = .button
        locationLabel.button.addTarget(self, action: #selector(locationButtonTouched), for: .touchUpInside)
        scrollView.addSubview(locationLabel)
        
        aboutTextView.translatesAutoresizingMaskIntoConstraints = false
        aboutTextView.textView.text = aboutTextViewPlaceholder
        aboutTextView.textView.delegate = self
        aboutTextView.type = .textView
        scrollView.addSubview(aboutTextView)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        nameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        if MemberDataManager.sharedInstance.isLoggedIn() {
            startTimeTextField.topAnchor.constraint(equalTo: hostTextField.bottomAnchor, constant: 20).isActive = true
        } else {
            startTimeTextField.topAnchor.constraint(equalTo: loginView.bottomAnchor, constant: 20).isActive = true
        }
        startTimeTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        startTimeTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        startTimeTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        addEndTimeButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        endTimeTopConstraint = endTimeTextField.topAnchor.constraint(equalTo: startTimeTextField.topAnchor)
        endTimeTopConstraint.isActive = true
        endTimeTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        endTimeTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        endTimeTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        hideEndTimeButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        locationLabel.topAnchor.constraint(equalTo: endTimeTextField.bottomAnchor).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        aboutTextView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor).isActive = true
        aboutTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        aboutTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        aboutTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: textFieldHeight).isActive = true
        
        if isCreatingNew() {
            createContainer.translatesAutoresizingMaskIntoConstraints = false
            createContainer.backgroundColor = .white
            createContainer.layer.masksToBounds = false
            createContainer.layer.shadowColor = UIColor.black.cgColor
            createContainer.layer.shadowOpacity = 0.1
            createContainer.layer.shadowRadius = 5
            createContainer.layer.shouldRasterize = true
            createContainer.layer.rasterizationScale = UIScreen.main.scale
            view.addSubview(createContainer)
            
            createButton.translatesAutoresizingMaskIntoConstraints = false
            createButton.setTitle("CREATE", for: .normal)
            createButton.addTarget(self, action: #selector(createButtonTouched), for: .touchUpInside)
            createContainer.addSubview(createButton)
            
            createContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            createContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            createContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            createContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            createButton.leadingAnchor.constraint(equalTo: createContainer.leadingAnchor, constant: 20).isActive = true
            createButton.trailingAnchor.constraint(equalTo: createContainer.trailingAnchor, constant: -20).isActive = true
            createButton.bottomAnchor.constraint(equalTo: createContainer.bottomAnchor, constant: -20).isActive = true
            createButton.heightAnchor.constraint(equalToConstant: CGFloat(PrimaryCTA.preferedHeight())).isActive = true
            
            aboutTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: createContainer.topAnchor).isActive = true
            
            updateEndTime()
        } else {
            if let event = self.event {
                nameTextField.textField.text = event.name
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
                        aboutTextView.textView.text = about
                        aboutTextView.textView.textColor = .black
                    }
                }
                if let eventLocation = event.eventLocation() {
                    selectedLocation = eventLocation
                }
                
                if MemberDataManager.sharedInstance.canEditEvent(event: event) {
                    deleteButton.translatesAutoresizingMaskIntoConstraints = false
                    deleteButton.setTitleColor(.red, for: .normal)
                    deleteButton.titleLabel?.font = UIFont.cta()
                    deleteButton.setTitle("DELETE EVENT", for: .normal)
                    deleteButton.layer.cornerRadius = 8
                    deleteButton.backgroundColor = .white
                    deleteButton.addTarget(self, action: #selector(deleteButtonTouched), for: .touchUpInside)
                    scrollView.addSubview(deleteButton)
                    
                    deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
                    deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
                    deleteButton.topAnchor.constraint(equalTo: aboutTextView.bottomAnchor, constant: 20).isActive = true
                    deleteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
                    deleteButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
                } else {
                    aboutTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
                }
            }
            
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        
        updateLocationLabel()
        updateTimeTextFields()
        updateSaveButtons()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK: Display Update
    
    func updateTitle() {
        if isCreatingNew() {
            title = "ADD EVENT"
        } else {
            title = "EDIT EVENT"
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
        startTimeTextField.textField.text = DateStringHelper.fullDescription(of: startTimePicker.date)
        if endTimePicker.date < startTimePicker.date {
            updateEndTime()
        }
        endTimeTextField.textField.text = "Ends \(DateStringHelper.fullDescription(of: endTimePicker.date))"
        endTimePicker.minimumDate = startTimePicker.date
    }
    
    func updateEndTime() {
        let calendar = NSCalendar.current
        if let newEndTime = calendar.date(byAdding: .hour, value: 1, to: startTimePicker.date) {
            endTimePicker.date = newEndTime
        }
    }
    
    func updateLocationLabel() {
        if let selectedLocation = self.selectedLocation {
            if selectedLocation.locationName.characters.count > 0 {
                locationLabel.label.text = selectedLocation.locationName
                locationLabel.label.textColor = .black
                return
            }
        }
        
        locationLabel.label.text = "LOCATION"
        locationLabel.label.textColor = UIColor.lightCopy()
    }
    
    func updateSaveButtons() {
        let enabled = dataUpdated()
        
        createButton.isEnabled = enabled
        navigationItem.rightBarButtonItem?.isEnabled = enabled
    }
    
    //MARK: Helpers
    
    func isCreatingNew() -> Bool {
        return event == nil
    }
    
    func isEndTimeVisible() -> Bool {
        return endTimeTextField.alpha > 0
    }
    
    func dataUpdated() -> Bool {
        if !MemberDataManager.sharedInstance.isLoggedIn() {
            return false
        }
        
        if let event = self.event {
            if let name = nameTextField.textField.text {
                if name.characters.count > 0 && name != event.name {
                    return true
                }
            }
            if let startTime = event.startTime as Date? {
                if startTimePicker.date != startTime {
                    return true
                }
            }
            if let endTime = event.endTime as Date? {
                if endTimePicker.date != endTime {
                    return true
                }
            }
            var aboutText = ""
            if aboutTextView.textView.text != aboutTextViewPlaceholder && aboutTextView.textView.text.characters.count > 0 {
                aboutText = aboutTextView.textView.text
                if aboutText != event.about {
                    return true
                }
            }
            
            if let selectedLocation = self.selectedLocation {
                if let location = event.eventLocation() {
                    if selectedLocation != location {
                        return true
                    }
                } else {
                    return true
                }
            } else if event.eventLocation() != nil {
                return true
            }
        } else  {
            if let name = nameTextField.textField.text {
                if name.characters.count > 0 {
                    return true
                }
            }
        }
        
        return false
    }
    
    func saveEvent() {
        var aboutText = ""
        if aboutTextView.textView.text != aboutTextViewPlaceholder && aboutTextView.textView.text.characters.count > 0 {
            aboutText = aboutTextView.textView.text
        }
        if isCreatingNew() {
            if let name = nameTextField.textField.text {
                if name.characters.count > 0 {
                    EventManager.createEvent(name: name,
                                             startTime: startTimePicker.date,
                                             endTime: isEndTimeVisible() ? endTimePicker.date : nil,
                                             about: aboutText,
                                             location: selectedLocation)
                }
            }
        } else {
            if let event = self.event {
                if let name = nameTextField.textField.text {
                    if name.characters.count > 0 {
                        EventManager.updateEvent(event: event,
                                                 name: name,
                                                 startTime: startTimePicker.date,
                                                 endTime: isEndTimeVisible() ? endTimePicker.date : nil,
                                                 about: aboutText,
                                                 location: selectedLocation)
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
        updateSaveButtons()
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
    
    func locationButtonTouched() {
        let locationVC = LocationPickerViewController()
        locationVC.delegate = self
        let locationNav = UINavigationController(rootViewController: locationVC)
        locationNav.navigationBar.isTranslucent = false
        present(locationNav, animated: true, completion: nil)
    }
    
    func deleteButtonTouched() {
        guard let eventName = self.event?.name else {
            return
        }
        
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete \(eventName)", preferredStyle: UIAlertControllerStyle.alert)
        let deleteAction = UIAlertAction(title: "DELETE", style: UIAlertActionStyle.destructive)  { (action: UIAlertAction) in
            if let event = self.event {
                EventManager.delete(event: event)
                self.dismiss(animated: true, completion: nil)
            }
        }
        alert.addAction(deleteAction)
        let cancelAction = UIAlertAction.init(title: "CANCEL", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Location selection
    
    func locationPicker(sender: LocationPickerViewController, selected location:EventLocation) {
        selectedLocation = location
        updateLocationLabel()
        updateSaveButtons()
    }
    
    //MARK: Keyboard updates
    
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

//MARK: Login View

class EventEditLoginView : UIView {
    let titleLabel = UILabel()
    let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.body()
        titleLabel.text = "Log in to Create Events"
        titleLabel.textColor = UIColor.primaryCopy()
        addSubview(titleLabel)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("GET STARTED", for: .normal)
        button.setTitleColor(UIColor.primaryCTA(), for: .normal)
        button.titleLabel?.font = UIFont.cta()
        addSubview(button)
        
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        
        button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//MARK: Event Edit Fields

enum EventEditFieldType {
    case textField
    case textView
    case button
}

class EventEditField: UIView {
    var type = EventEditFieldType.textField {
        didSet {
            switch type {
            case .textField:
                textField.alpha = 1
                label.alpha = 0
                button.alpha = 0
                textView.alpha = 0
            case .textView:
                textField.alpha = 0
                label.alpha = 0
                button.alpha = 0
                textView.alpha = 1
            case .button:
                textField.alpha = 0
                label.alpha = 1
                button.alpha = 1
                textView.alpha = 0
            }
        }
    }
    let label = UILabel()
    let button = UIButton()
    let textField = UITextField()
    let textView = UITextView()
    private let divider = UIView()
    var showDivider = true {
        didSet {
            divider.isHidden = !showDivider
        }
    }
    private let accessoryContainer = UIView()
    var accessoryView = UIView() {
        didSet {
            updateAccessoryView(newView: accessoryView)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.body()
        textField.textColor = UIColor.primaryCopy()
        addSubview(textField)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.body()
        label.textColor = UIColor.primaryCopy()
        label.alpha = 0
        addSubview(label)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        addSubview(button)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = UIColor.lightCopy()
        textView.isScrollEnabled = false
        textView.alpha = 0
        textView.font = .body()
        addSubview(textView)
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = UIColor.dividers()
        addSubview(divider)
        
        accessoryContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(accessoryContainer)
        
        accessoryView = UIView()
        accessoryView.widthAnchor.constraint(equalToConstant: 0).isActive = true
        updateAccessoryView(newView: accessoryView)
        
        textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: accessoryContainer.leadingAnchor, constant: -10).isActive = true
        textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: accessoryContainer.leadingAnchor, constant: -10).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        textView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        divider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        divider.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        accessoryContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        accessoryContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        accessoryContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateAccessoryView(newView: UIView) {
        for view in accessoryContainer.subviews {
            view.removeFromSuperview()
        }
        
        newView.translatesAutoresizingMaskIntoConstraints = false
        accessoryContainer.addSubview(newView)
        
        newView.leadingAnchor.constraint(equalTo: accessoryContainer.leadingAnchor, constant: 0).isActive = true
        newView.trailingAnchor.constraint(equalTo: accessoryContainer.trailingAnchor, constant: 0).isActive = true
        newView.centerYAnchor.constraint(equalTo: accessoryContainer.centerYAnchor).isActive = true
    }
}
