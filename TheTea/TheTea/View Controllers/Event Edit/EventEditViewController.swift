//
//  EventEditViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/11/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit
import MapKit

class EventEditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, LocationPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var event: Event?
    private let scrollView = UIScrollView()
    
    private let imageSelectButton = EventEditImageSelectButton(frame: CGRect())
    
    private let nameTextField = InputField()
    private let hostTextField = InputField()
    private var hostHeightConstraint = NSLayoutConstraint()
    private let loginView = EventEditLoginView(frame: CGRect())
    
    private let dateTextField = InputField()
    private let datePicker = UIDatePicker()
    
    private let startTimeTextField = InputField()
    private let startTimePicker = UIDatePicker()
    private let addEndTimeButton = UIButton()
    private var endTimeTopConstraint = NSLayoutConstraint()
    private let endTimeTextField = InputField()
    private let endTimePicker = UIDatePicker()
    private let hideEndTimeButton = UIButton()
    private let repeatsInputView = InputField()
    private let repeatsLabel = UILabel()
    
    private let locationLabel = InputField()
    private let aboutTextView = InputField()
    private let deleteButton = AlertCTA()
    
    private let collectionsLabel = UILabel()
    private var collectionInputFields = [InputField]()
    private var selectedCollections = [EventCollection]()
    
    private let priceInputField = InputField()
    private let priceStepper = UIStepper()
    private var ticketURLTopConstraint = NSLayoutConstraint()
    private let ticketURLTextField = InputField()
    
    private let createContainer = UIView()
    private let createButton = PrimaryCTA(frame: CGRect())
    
    private let aboutTextViewPlaceholder = "MORE INFO"
    private let textFieldHeight: CGFloat = 56.0
    private var selectedLocation: EventLocation?
    private var selectedRepeats = EventRepeatRules()
    private var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = UIRectEdge()
        view.backgroundColor = .white
        updateTitle()
        updateNavButtons()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        
        imageSelectButton.translatesAutoresizingMaskIntoConstraints = false
        imageSelectButton.button.addTarget(self, action: #selector(addImageButtonTouched), for: .touchUpInside)
        imageSelectButton.removeButton.addTarget(self, action: #selector(removeImageButtonTouched), for: .touchUpInside)
        scrollView.addSubview(imageSelectButton)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.title = "EVENT NAME"
        nameTextField.textField.autocapitalizationType = .words
        nameTextField.textField.addTarget(self, action: #selector(updateSaveButtons), for: .editingChanged)
        scrollView.addSubview(nameTextField)
        
        hostTextField.translatesAutoresizingMaskIntoConstraints = false
        hostTextField.title = "HOSTED BY"
        hostTextField.type = .button
        hostTextField.alpha = 0
        scrollView.addSubview(hostTextField)
        
        hostTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        hostTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        hostTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24).isActive = true
        hostHeightConstraint = hostTextField.heightAnchor.constraint(equalToConstant: textFieldHeight)
        hostHeightConstraint.isActive = true
        
        loginView.translatesAutoresizingMaskIntoConstraints = false
        loginView.button.addTarget(self, action: #selector(loginButtonTouched), for: .touchUpInside)
        scrollView.addSubview(loginView)
        
        loginView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        loginView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        loginView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        loginView.bottomAnchor.constraint(equalTo: hostTextField.bottomAnchor).isActive = true
        
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        dateTextField.title = "DATE"
        dateTextField.textField.tintColor = UIColor.white
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        dateTextField.textField.inputView = datePicker
        scrollView.addSubview(dateTextField)
        
        startTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        startTimeTextField.title = "START TIME"
        startTimeTextField.textField.tintColor = UIColor.white
        startTimePicker.datePickerMode = .time
        startTimePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        startTimePicker.minuteInterval = 15
        startTimePicker.date = Calendar.current.date(bySettingHour: 20, minute: 00, second: 0, of: Date()) ?? Date()
        startTimeTextField.textField.inputView = startTimePicker
        scrollView.addSubview(startTimeTextField)
        
        endTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        endTimeTextField.title = "END TIME"
        endTimeTextField.textField.tintColor = UIColor.white
        endTimePicker.datePickerMode = .time
        endTimePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        endTimePicker.minuteInterval = 15
        endTimePicker.date = Calendar.current.date(bySettingHour: 22, minute: 00, second: 0, of: Date()) ?? Date()
        endTimeTextField.textField.inputView = endTimePicker
        scrollView.addSubview(endTimeTextField)
        
        hideEndTimeButton.translatesAutoresizingMaskIntoConstraints = false
        hideEndTimeButton.setTitle("X", for: .normal)
        hideEndTimeButton.titleLabel?.font = UIFont.cta()
        hideEndTimeButton.setTitleColor(UIColor.primaryCTA(), for: .normal)
        hideEndTimeButton.addTarget(self, action: #selector(hideEndTimeTouched), for: .touchUpInside)
        hideEndTimeButton.contentHorizontalAlignment = .right
        
        repeatsInputView.translatesAutoresizingMaskIntoConstraints = false
        repeatsInputView.title = "REPEATS"
        repeatsInputView.type = .button
        repeatsInputView.button.addTarget(self, action: #selector(repeatsButtonTouched), for: .touchUpInside)
        scrollView.addSubview(repeatsInputView)
        
        repeatsLabel.translatesAutoresizingMaskIntoConstraints = false
        repeatsLabel.font = UIFont.cta()
        repeatsLabel.textColor = UIColor.primaryCTA()
        repeatsLabel.text = "NEVER"
        repeatsLabel.textAlignment = .right
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.title = "LOCATION"
        locationLabel.type = .button
        locationLabel.button.addTarget(self, action: #selector(locationButtonTouched), for: .touchUpInside)
        scrollView.addSubview(locationLabel)
        
        aboutTextView.translatesAutoresizingMaskIntoConstraints = false
        aboutTextView.title = "MORE INFO"
        //aboutTextView.textView.delegate = self
        aboutTextView.type = .textView
        aboutTextView.addTarget(self, action: #selector(updateSaveButtons), for: .editingChanged)
        //aboutTextView.textView.addTarget(self, action: #selector(updateSaveButtons), for: .editingChanged)
        scrollView.addSubview(aboutTextView)
        
        priceInputField.translatesAutoresizingMaskIntoConstraints = false
        priceInputField.title = "PRICE"
        priceInputField.textField.keyboardType = .decimalPad
        priceInputField.type = .price
        priceInputField.textField.text = "0"
        priceInputField.textField.addTarget(self, action: #selector(updateSaveButtons), for: .editingChanged)
        scrollView.addSubview(priceInputField)
        
        ticketURLTextField.translatesAutoresizingMaskIntoConstraints = false
        ticketURLTextField.title = "TICKET LINK"
        ticketURLTextField.textField.keyboardType = .URL
        ticketURLTextField.textField.autocapitalizationType = .none
        ticketURLTextField.textField.autocorrectionType = .no
        ticketURLTextField.textField.addTarget(self, action: #selector(updateSaveButtons), for: .editingChanged)
        scrollView.addSubview(ticketURLTextField)
        /*
        collectionsLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionsLabel.text = "COLLECTIONS"
        collectionsLabel.font = UIFont.headerOne()
        collectionsLabel.textColor = UIColor.lightCopy()
        scrollView.addSubview(collectionsLabel)
        
        let collections = EventCollectionManager.userUpdatedEventCollections()
        var previousCollectionInputField: LegacyInputField? = nil
        for collection in collections {
            let currentIndex = collections.index(of: collection) ?? 0
            
            let inputField = LegacyInputField()
            inputField.translatesAutoresizingMaskIntoConstraints = false
            inputField.type = .button
            inputField.label.text = collection.title?.uppercased()
            inputField.button.tag = currentIndex
            inputField.button.addTarget(self, action: #selector(collectionButtonTouched), for: .touchUpInside)
            if currentIndex == collections.count - 1 {
                inputField.showDivider = false
            }
            scrollView.addSubview(inputField)
            
            if let previousInputField = previousCollectionInputField {
                inputField.topAnchor.constraint(equalTo: previousInputField.bottomAnchor).isActive = true
            } else {
                inputField.topAnchor.constraint(equalTo: collectionsLabel.bottomAnchor, constant: 20).isActive = true
            }
            
            inputField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            inputField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
            inputField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
            
            previousCollectionInputField = inputField
            collectionInputFields.append(inputField)
        } */
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        imageSelectButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        imageSelectButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        imageSelectButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        
        nameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        nameTextField.topAnchor.constraint(equalTo: imageSelectButton.bottomAnchor, constant: 32).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        dateTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24).isActive = true
        dateTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        dateTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        dateTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        startTimeTextField.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 24).isActive = true
        startTimeTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        startTimeTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        startTimeTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        //addEndTimeButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        endTimeTopConstraint = endTimeTextField.topAnchor.constraint(equalTo: startTimeTextField.bottomAnchor, constant: 24)
        endTimeTopConstraint.isActive = true
        endTimeTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        endTimeTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        endTimeTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        //hideEndTimeButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        repeatsInputView.topAnchor.constraint(equalTo: endTimeTextField.bottomAnchor, constant: 24).isActive = true
        repeatsInputView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        repeatsInputView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        repeatsInputView.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        locationLabel.topAnchor.constraint(equalTo: repeatsInputView.bottomAnchor, constant: 24).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        aboutTextView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 24).isActive = true
        aboutTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        aboutTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        aboutTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: textFieldHeight).isActive = true
        
        priceInputField.topAnchor.constraint(equalTo: aboutTextView.bottomAnchor, constant: 24).isActive = true
        priceInputField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        priceInputField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        priceInputField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        ticketURLTopConstraint = ticketURLTextField.topAnchor.constraint(equalTo: priceInputField.bottomAnchor, constant: 24)
        ticketURLTopConstraint.isActive = true
        ticketURLTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        ticketURLTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        ticketURLTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        /*
        collectionsLabel.topAnchor.constraint(equalTo: ticketURLTextField.bottomAnchor, constant: 20).isActive = true
        collectionsLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        collectionsLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true */
        
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
            createButton.setTitle("Create Event", for: .normal)
            createButton.addTarget(self, action: #selector(createButtonTouched), for: .touchUpInside)
            createContainer.addSubview(createButton)
            
            createContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            createContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            createContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            createContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            createButton.leadingAnchor.constraint(equalTo: createContainer.leadingAnchor, constant: 20).isActive = true
            createButton.trailingAnchor.constraint(equalTo: createContainer.trailingAnchor, constant: -20).isActive = true
            createButton.topAnchor.constraint(equalTo: createContainer.topAnchor, constant: 14).isActive = true
            createButton.heightAnchor.constraint(equalToConstant: CGFloat(PrimaryCTA.preferedHeight)).isActive = true
            
            ticketURLTextField.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
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
                    if about.count > 0 {
                        aboutTextView.textView.text = about
                        aboutTextView.textView.textColor = .black
                    }
                }
                if let eventLocation = event.eventLocation() {
                    selectedLocation = eventLocation
                }
                
                selectedRepeats = event.repeatRules()
                
                if MemberDataManager.canEditEvent(event: event) {
                    deleteButton.translatesAutoresizingMaskIntoConstraints = false
                    deleteButton.setTitle("DELETE EVENT", for: .normal)
                    deleteButton.addTarget(self, action: #selector(deleteButtonTouched), for: .touchUpInside)
                    scrollView.addSubview(deleteButton)
                    
                    deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
                    deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
                    deleteButton.topAnchor.constraint(equalTo: aboutTextView.bottomAnchor, constant: 20).isActive = true
                    deleteButton.heightAnchor.constraint(equalToConstant: AlertCTA.preferedHeight).isActive = true
                    deleteButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
                } else {
                    ticketURLTextField.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
                }
            }
        }
        
        updateLocationLabel()
        updateTimeTextFields()
        updateCollections()
        updateSaveButtons()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !MemberDataManager.isLoggedIn() {
            loginView.alpha = 1
            hostHeightConstraint.constant = 74
        } else {
            loginView.alpha = 0
            hostHeightConstraint.constant = textFieldHeight
            hostTextField.textField.text = MemberDataManager.loggedInMember()?.name
        }
        
        repeatsInputView.textField.text = selectedRepeats.rules(abreviated: true)
    }
    
    //MARK: Display Update
    
    func updateTitle() {
        if isCreatingNew() {
            title = "Add an Event"
        } else {
            title = "Update Event"
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
        dateTextField.textField.text = DateStringHelper.dayDescription(of: datePicker.date)
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
        startTimeTextField.textField.text = timeFormatter.string(from: startTimePicker.date)
        endTimeTextField.textField.text = timeFormatter.string(from: endTimePicker.date)
    }
    
    func updateEndTime() {
        let calendar = NSCalendar.current
        if let newEndTime = calendar.date(byAdding: .hour, value: 1, to: startTimePicker.date) {
            endTimePicker.date = newEndTime
        }
    }
    
    func updateLocationLabel() {
        if let selectedLocation = self.selectedLocation {
            if selectedLocation.locationName.count > 0 {
                locationLabel.textField.text = selectedLocation.locationName
                return
            }
        }
        
        locationLabel.textField.text = ""
    }
    
    func updateCollections() {
        /*
        let collections = EventCollectionManager.userUpdatedEventCollections()
        for collection in collections {
            guard let index = collections.index(of: collection) else {
                return
            }
            let inputField = collectionInputFields[index]
            if selectedCollections.contains(collection) {
                inputField.label.textColor = UIColor.primaryCopy()
            } else {
                inputField.label.textColor = UIColor.lightCopy()
            }
        } */
    }
    
    @objc func updatePrice() {
        /*
        let price = priceStepper.value
        if price == 0 {
            priceInputField.label.text = "FREE"
        } else {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            
            priceInputField.label.text = numberFormatter.string(from: NSNumber(value: priceStepper.value))
        }
        
        updateTicketURL(visible: price != 0, animated: true) */
    }
    
    @objc func updateSaveButtons() {
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
        if !MemberDataManager.isLoggedIn() {
            return false
        }
        
        if let event = self.event {
            if let name = nameTextField.textField.text {
                if name.count > 0 && name != event.name {
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
            if aboutTextView.textView.text != aboutTextViewPlaceholder && aboutTextView.textView.text.count > 0 {
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
                if name.count > 0 {
                    return true
                }
            }
        }
        
        return false
    }
    
    func saveEvent() -> Bool {
        if isCreatingNew() {
            if let name = nameTextField.textField.text {
                if name.count > 0 {
                    EventManager.createEvent(name: name,
                                                    startTime: selectedStartTime(),
                                                    endTime: selectedEndTime(),
                                                    about: aboutTextView.textView.text,
                                                    location: selectedLocation,
                                                    price: Double(priceInputField.textField.text ?? "0") ?? 0,
                                                    ticketURL: ticketURLTextField.textField.text,
                                                    repeats: selectedRepeats.dataString(),
                                                    image: selectedImage,
                                                    onSuccess: { (data) in
                                                        self.dismiss(animated: true, completion: nil)
                                                    }) { (error) in
                                                        if let error = error {
                                                            print("EVENT FETCH FAILED: \(error.localizedDescription)")
                                                        }
                                                        //TODO: Post notification
                                                    }
                    return true
                }
            }
        } else {
            if let event = self.event {
                if let name = nameTextField.textField.text {
                    if name.count > 0 {
                        return EventManager.updateEvent(event: event,
                                                        name: name,
                                                        startTime: selectedStartTime(),
                                                        endTime: isEndTimeVisible() ? endTimePicker.date : nil,
                                                        about: aboutTextView.textView.text,
                                                        location: selectedLocation)
                    }
                }
            }
        }
        return false
    }
    
    func selectedStartTime() -> Date {
        let hours = Calendar.current.component(.hour, from: startTimePicker.date)
        let minutes = Calendar.current.component(.minute, from: startTimePicker.date)
        return Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: datePicker.date) ?? Date()
    }
    
    func selectedEndTime() -> Date {
        let hours = Calendar.current.component(.hour, from: endTimePicker.date)
        let minutes = Calendar.current.component(.minute, from: endTimePicker.date)
        var endTime = Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: datePicker.date) ?? Date()
        let startTime = selectedStartTime()
        if endTime < startTime {
            print("WRONG END TIME: \(endTime)")
            let newEndTime = Calendar.current.date(byAdding: .day, value: 1, to: startTime)
            endTime = Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: newEndTime ?? Date()) ?? Date()
            print("Fixed: \(startTime) |TO| \(endTime)")
        }
        return endTime
    }
    
    //MARK: Actions
    
    @objc func addImageButtonTouched() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){

            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func removeImageButtonTouched() {
        imageSelectButton.image = nil
        selectedImage = nil
    }
    
    @objc func cancelButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonTouched() {
        if saveEvent() {
            dismiss(animated: true, completion: nil)
        } else {
            print("SAVE FAILED")
        }
    }
    
    @objc func createButtonTouched() {
        if saveEvent() {
            dismiss(animated: true, completion: nil)
        } else {
            print("SAVE FAILED")
        }
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        updateTimeTextFields()
        updateSaveButtons()
    }
    
    @objc func addEndTimeTouched() {
        updateEndTime(visible: true, animated: true)
    }
    
    @objc func hideEndTimeTouched() {
        updateEndTime(visible: false, animated: true)
    }
    
    @objc func loginButtonTouched() {
        let loginVC = LoginViewController()
        let loginNav = UINavigationController(rootViewController: loginVC)
        loginNav.navigationBar.isTranslucent = false
        present(loginNav, animated: true, completion: nil)
    }
    
    @objc func collectionButtonTouched(sender: UIButton) {
        let index = sender.tag
        
        let collections = EventCollectionManager.userUpdatedEventCollections()
        let tappedCollection = collections[index]
        if selectedCollections.contains(tappedCollection) {
            if let selectedIndex = selectedCollections.index(of: tappedCollection) {
                selectedCollections.remove(at: selectedIndex)
            }
        } else {
            selectedCollections.append(tappedCollection)
        }
        
        updateCollections()
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
    
    func updateTicketURL(visible: Bool, animated: Bool) {
        /*
        if visible {
            ticketURLTopConstraint.constant = textFieldHeight
            self.priceInputField.showDivider = true
            UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            ticketURLTopConstraint.constant = 0
            UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
                self.view.layoutIfNeeded()
            })  { (complete: Bool) in
                self.priceInputField.showDivider = false
            }
        } */
    }
    
    @objc func locationButtonTouched() {
        let locationVC = LocationPickerViewController()
        locationVC.delegate = self
        let locationNav = UINavigationController(rootViewController: locationVC)
        locationNav.navigationBar.isTranslucent = false
        present(locationNav, animated: true, completion: nil)
    }
    
    @objc func repeatsButtonTouched() {
        let repeatVC = RepeatEditViewController()
        repeatVC.rules = selectedRepeats
        if let nav = self.navigationController {
            nav.pushViewController(repeatVC, animated: true)
        }
    }
    
    @objc func deleteButtonTouched() {
        guard let eventName = self.event?.name else {
            return
        }
        
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete \(eventName)", preferredStyle: UIAlertController.Style.alert)
        let deleteAction = UIAlertAction(title: "DELETE", style: UIAlertAction.Style.destructive)  { (action: UIAlertAction) in
            if let event = self.event {
                if EventManager.delete(event: event) {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("DELETE FAILED")
                }
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let screenHeight = UIScreen.main.bounds.height
            view.frame = CGRect(x: 0, y: view.frame.origin.y, width: view.frame.width, height: screenHeight - (keyboardSize.height + view.frame.origin.y))
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let screenHeight = UIScreen.main.bounds.height
        view.frame = CGRect(x: 0, y: view.frame.origin.y, width: view.frame.width, height: screenHeight - view.frame.origin.y)
    }
    
    //MARK: Image Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        picker.dismiss(animated: true, completion: nil)
        selectedImage = image
        imageSelectButton.image = image
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

class EventEditImageSelectButton : UIView {
    var image: UIImage? = UIImage() {
        didSet {
            guard let image = image else {
                heightConstraint.constant = minHeight
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.removeButton.alpha = 0
                    if let superview = self.superview {
                        superview.layoutIfNeeded()
                    }
                    self.imageView.alpha = 0
                }) { (_) in
                    self.imageView.image = nil
                    self.imageView.alpha = 1
                }
                
                return
            }
            
            imageView.image = image
            removeButton.alpha = 1
            
            let imageSize = image.size
            let ratio = imageSize.height / imageSize.width
            
            let width = self.bounds.width
            let imageHeight = width * ratio
            let height = imageHeight > minHeight ? imageHeight : minHeight
            heightConstraint.constant = height
        }
    }
    let button = UIButton()
    let removeButton = UIButton()
    
    private let topSpacer = UIView()
    private let bottomSpacer = UIView()
    private let iconImageView = UIImageView(image: UIImage(named: "addEventImage"))
    private let label = UILabel()
    private let imageView = UIImageView()
    private var heightConstraint = NSLayoutConstraint()
    private let minHeight: CGFloat = 170
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.16).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 6
        
        backgroundColor = .white
        
        translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = heightAnchor.constraint(equalToConstant: minHeight)
        heightConstraint.isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .center
        addSubview(iconImageView)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add an event picture"
        label.textColor = UIColor.primaryCTA()
        label.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        addSubview(label)
        
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.setTitle("Remove", for: .normal)
        removeButton.setTitleColor(UIColor.primaryCTA(), for: .normal)
        removeButton.titleLabel?.font = UIFont.cta()
        removeButton.backgroundColor = .white
        removeButton.layer.cornerRadius = 5
        removeButton.alpha = 0
        addSubview(removeButton)
        
        topSpacer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topSpacer)
        
        topSpacer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iconImageView.topAnchor.constraint(equalTo: topSpacer.bottomAnchor).isActive = true
        
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 16).isActive = true
        
        bottomSpacer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomSpacer)
        
        bottomSpacer.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        bottomSpacer.heightAnchor.constraint(equalTo: topSpacer.heightAnchor).isActive = true
        bottomSpacer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        removeButton.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        removeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        removeButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        removeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
