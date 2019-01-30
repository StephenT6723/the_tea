//
//  EventEditViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/11/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher

class EventEditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, LocationPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var event: Event?
    
    private let scrollView = UIScrollView()
    private var scrollViewBottomConstraint = NSLayoutConstraint()
    
    private let imageSelectButton = EventEditImageSelectButton(frame: CGRect())
    
    private let nameTextField = InputField()
    private let hostTextField = InputField()
    private var hostHeightConstraint = NSLayoutConstraint()
    
    private let dateTextField = InputField()
    private let datePicker = UIDatePicker()
    
    private let startTimeTextField = InputField()
    private let startTimePicker = UIDatePicker()
    
    private var endTimeTopConstraint = NSLayoutConstraint()
    private let endTimeTextField = InputField()
    private let endTimePicker = UIDatePicker()
    
    private let repeatsInputView = InputField()
    private let repeatsLabel = UILabel()
    
    private let locationLabel = InputField()
    private let locationBottomBar = UIView()
    private let aboutTextView = InputField()
    private let deleteButton = UIButton()
    
    private let collectionsLabel = UILabel()
    private var collectionInputFields = [InputField]()
    private var selectedCollections = [EventCollection]()
    
    private let priceInputField = InputField()
    private let priceStepper = UIStepper()
    private var ticketURLTopConstraint = NSLayoutConstraint()
    private let ticketURLTextField = InputField()
    
    private let requiredFieldLabel = UILabel()
    
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    private let createButton = UIButton()
    
    private let aboutTextViewPlaceholder = "MORE INFO"
    private let textFieldHeight: CGFloat = 56.0
    private let sidePadding: CGFloat = 40.0
    private var selectedLocation: EventLocation?
    private var selectedRepeats = EventRepeatRules()
    private var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        view.backgroundColor = .clear
        updateTitle()
        updateNavButtons()
        
        if let nav = navigationController as? ClearNavigationController {
            nav.backgroundImageView.image = UIImage(named: "placeholderBackground3")
        }
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        
        imageSelectButton.translatesAutoresizingMaskIntoConstraints = false
        imageSelectButton.button.addTarget(self, action: #selector(addImageButtonTouched), for: .touchUpInside)
        imageSelectButton.removeButton.addTarget(self, action: #selector(removeImageButtonTouched), for: .touchUpInside)
        scrollView.addSubview(imageSelectButton)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.title = "EVENT NAME *"
        nameTextField.selectedColor = .white
        nameTextField.deSelectedColor = .white
        nameTextField.textField.textColor = .white
        nameTextField.textField.returnKeyType = .done
        nameTextField.textField.autocapitalizationType = .words
        nameTextField.textField.addTarget(self, action: #selector(updateSaveButtons), for: .editingChanged)
        scrollView.addSubview(nameTextField)
        
        hostTextField.translatesAutoresizingMaskIntoConstraints = false
        hostTextField.title = "HOSTED BY"
        hostTextField.type = .button
        hostTextField.alpha = 0
        scrollView.addSubview(hostTextField)
        
        hostTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: sidePadding).isActive = true
        hostTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -1 * sidePadding).isActive = true
        hostTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24).isActive = true
        hostHeightConstraint = hostTextField.heightAnchor.constraint(equalToConstant: textFieldHeight)
        hostHeightConstraint.isActive = true
        
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        dateTextField.title = "DATE"
        dateTextField.selectedColor = .white
        dateTextField.deSelectedColor = .white
        dateTextField.textField.textColor = .white
        dateTextField.textField.tintColor = .clear
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .date
        let dateDoneBar = UIToolbar()
        dateDoneBar.frame = CGRect(x: 0, y: 0, width: 400, height: 44)
        dateDoneBar.backgroundColor = .white
        let dateDoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(keyboardDoneButtonTouched))
        dateDoneBar.setItems([dateDoneButton], animated: false)
        dateTextField.textField.inputAccessoryView = dateDoneBar
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        dateTextField.textField.inputView = datePicker
        scrollView.addSubview(dateTextField)
        
        startTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        startTimeTextField.title = "START TIME *"
        startTimeTextField.cta = "Add end time"
        startTimeTextField.textField.textColor = .white
        startTimeTextField.selectedColor = .white
        startTimeTextField.deSelectedColor = .white
        startTimeTextField.ctaButton.addTarget(self, action: #selector(addEndTimeTouched), for: .touchUpInside)
        startTimeTextField.textField.tintColor = .clear
        let startTimeDoneBar = UIToolbar()
        startTimeDoneBar.frame = CGRect(x: 0, y: 0, width: 400, height: 44)
        startTimeDoneBar.backgroundColor = .white
        let startTimeDoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(keyboardDoneButtonTouched))
        startTimeDoneBar.setItems([startTimeDoneButton], animated: false)
        startTimeTextField.textField.inputAccessoryView = startTimeDoneBar
        startTimePicker.datePickerMode = .time
        startTimePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        startTimePicker.minuteInterval = 15
        startTimePicker.date = Calendar.current.date(bySettingHour: 20, minute: 00, second: 0, of: Date()) ?? Date()
        startTimeTextField.textField.inputView = startTimePicker
        scrollView.addSubview(startTimeTextField)
        
        endTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        endTimeTextField.title = "END TIME"
        endTimeTextField.textField.textColor = .white
        endTimeTextField.selectedColor = .white
        endTimeTextField.deSelectedColor = .white
        endTimeTextField.alpha = 0
        endTimeTextField.xIcon.alpha = 1
        endTimeTextField.xIcon.addTarget(self, action: #selector(hideEndTimeTouched), for: .touchUpInside)
        let endTimeDoneBar = UIToolbar()
        endTimeDoneBar.frame = CGRect(x: 0, y: 0, width: 400, height: 44)
        endTimeDoneBar.backgroundColor = .white
        let endTimeDoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(keyboardDoneButtonTouched))
        endTimeDoneBar.setItems([endTimeDoneButton], animated: false)
        endTimeTextField.textField.inputAccessoryView = endTimeDoneBar
        endTimePicker.datePickerMode = .time
        endTimePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        endTimePicker.minuteInterval = 15
        endTimePicker.date = Calendar.current.date(bySettingHour: 22, minute: 00, second: 0, of: Date()) ?? Date()
        endTimeTextField.textField.inputView = endTimePicker
        endTimeTextField.textField.tintColor = .clear
        scrollView.addSubview(endTimeTextField)
        
        repeatsInputView.translatesAutoresizingMaskIntoConstraints = false
        repeatsInputView.title = "REPEATS"
        repeatsInputView.selectedColor = .white
        repeatsInputView.deSelectedColor = .white
        repeatsInputView.textField.textColor = .white
        repeatsInputView.type = .button
        repeatsInputView.button.addTarget(self, action: #selector(repeatsButtonTouched), for: .touchUpInside)
        scrollView.addSubview(repeatsInputView)
        
        repeatsLabel.translatesAutoresizingMaskIntoConstraints = false
        repeatsLabel.font = UIFont.cta()
        repeatsLabel.textColor = UIColor.primaryCTA()
        repeatsLabel.text = "NEVER"
        repeatsLabel.textAlignment = .right
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.title = "LOCATION *"
        locationLabel.type = .button
        locationLabel.selectedColor = .white
        locationLabel.deSelectedColor = .white
        locationLabel.textField.textColor = .white
        locationLabel.button.addTarget(self, action: #selector(locationButtonTouched), for: .touchUpInside)
        scrollView.addSubview(locationLabel)
        
        aboutTextView.translatesAutoresizingMaskIntoConstraints = false
        aboutTextView.title = "MORE INFO"
        aboutTextView.selectedColor = .white
        aboutTextView.deSelectedColor = .white
        aboutTextView.textView.tintColor = .white
        aboutTextView.type = .textView
        aboutTextView.textView.textColor = .white
        aboutTextView.addTarget(self, action: #selector(updateSaveButtons), for: .editingChanged)
        let moreInfoDoneBar = UIToolbar()
        moreInfoDoneBar.frame = CGRect(x: 0, y: 0, width: 400, height: 44)
        moreInfoDoneBar.backgroundColor = .white
        let moreInfoDoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(keyboardDoneButtonTouched))
        moreInfoDoneBar.setItems([moreInfoDoneButton], animated: false)
        aboutTextView.textView.inputAccessoryView = moreInfoDoneBar
        scrollView.addSubview(aboutTextView)
        
        priceInputField.translatesAutoresizingMaskIntoConstraints = false
        priceInputField.title = "PRICE"
        priceInputField.textField.keyboardType = .decimalPad
        priceInputField.selectedColor = .white
        priceInputField.deSelectedColor = .white
        priceInputField.type = .price
        priceInputField.textField.text = "0"
        priceInputField.textField.textColor = .white
        priceInputField.priceLabel.textColor = .white
        priceInputField.textField.addTarget(self, action: #selector(updateSaveButtons), for: .editingChanged)
        let priceDoneBar = UIToolbar()
        priceDoneBar.frame = CGRect(x: 0, y: 0, width: 400, height: 44)
        priceDoneBar.backgroundColor = .white
        let priceDoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(keyboardDoneButtonTouched))
        priceDoneBar.setItems([priceDoneButton], animated: false)
        priceInputField.textField.inputAccessoryView = priceDoneBar
        scrollView.addSubview(priceInputField)
        
        ticketURLTextField.translatesAutoresizingMaskIntoConstraints = false
        ticketURLTextField.title = "TICKET LINK"
        ticketURLTextField.textField.keyboardType = .URL
        ticketURLTextField.textField.autocapitalizationType = .none
        ticketURLTextField.textField.autocorrectionType = .no
        ticketURLTextField.textField.textColor = .white
        ticketURLTextField.selectedColor = .white
        ticketURLTextField.deSelectedColor = .white
        ticketURLTextField.textField.returnKeyType = .done
        ticketURLTextField.textField.addTarget(self, action: #selector(updateSaveButtons), for: .editingChanged)
        scrollView.addSubview(ticketURLTextField)
        
        requiredFieldLabel.translatesAutoresizingMaskIntoConstraints = false
        requiredFieldLabel.textColor = .white
        requiredFieldLabel.font = UIFont(name: "Montserrat-Bold", size: 12)
        requiredFieldLabel.text = "* Required Field"
        scrollView.addSubview(requiredFieldLabel)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        scrollViewBottomConstraint.isActive = true
        
        imageSelectButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: sidePadding).isActive = true
        imageSelectButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -1 * sidePadding).isActive = true
        imageSelectButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        
        nameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: sidePadding).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -1 * sidePadding).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -2 * sidePadding).isActive = true
        nameTextField.topAnchor.constraint(equalTo: imageSelectButton.bottomAnchor, constant: 32).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        dateTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24).isActive = true
        dateTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: sidePadding).isActive = true
        dateTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -1 * sidePadding).isActive = true
        dateTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        startTimeTextField.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 24).isActive = true
        startTimeTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: sidePadding).isActive = true
        startTimeTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -1 * sidePadding).isActive = true
        startTimeTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        endTimeTopConstraint = endTimeTextField.topAnchor.constraint(equalTo: startTimeTextField.topAnchor, constant: 0)
        endTimeTopConstraint.isActive = true
        endTimeTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: sidePadding).isActive = true
        endTimeTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -1 * sidePadding).isActive = true
        endTimeTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        repeatsInputView.topAnchor.constraint(equalTo: endTimeTextField.bottomAnchor, constant: 24).isActive = true
        repeatsInputView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: sidePadding).isActive = true
        repeatsInputView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -1 * sidePadding).isActive = true
        repeatsInputView.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        locationLabel.topAnchor.constraint(equalTo: repeatsInputView.bottomAnchor, constant: 24).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -1 * sidePadding).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: sidePadding).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        aboutTextView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 24).isActive = true
        aboutTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -1 * sidePadding).isActive = true
        aboutTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: sidePadding).isActive = true
        aboutTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: textFieldHeight).isActive = true
        
        priceInputField.topAnchor.constraint(equalTo: aboutTextView.bottomAnchor, constant: 24).isActive = true
        priceInputField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: sidePadding).isActive = true
        priceInputField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -1 * sidePadding).isActive = true
        priceInputField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        ticketURLTopConstraint = ticketURLTextField.topAnchor.constraint(equalTo: priceInputField.bottomAnchor, constant: 24)
        ticketURLTopConstraint.isActive = true
        ticketURLTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: sidePadding).isActive = true
        ticketURLTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -1 * sidePadding).isActive = true
        ticketURLTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        
        requiredFieldLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: sidePadding).isActive = true
        requiredFieldLabel.topAnchor.constraint(equalTo: ticketURLTextField.bottomAnchor, constant: 30).isActive = true
        
        if isCreatingNew() {
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(activityIndicator)
            
            createButton.translatesAutoresizingMaskIntoConstraints = false
            createButton.setTitle("ADD EVENT", for: .normal)
            createButton.addTarget(self, action: #selector(createButtonTouched), for: .touchUpInside)
            createButton.backgroundColor = .white
            createButton.setTitleColor(UIColor.primaryCTA(), for: .normal)
            createButton.layer.cornerRadius = 5
            createButton.titleLabel?.font = UIFont.cta()
            scrollView.addSubview(createButton)
            
            activityIndicator.centerXAnchor.constraint(equalTo: createButton.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: createButton.centerYAnchor).isActive = true
            
            createButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: sidePadding).isActive = true
            createButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -1 * sidePadding).isActive = true
            createButton.topAnchor.constraint(equalTo: requiredFieldLabel.bottomAnchor, constant: 30).isActive = true
            createButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            createButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = true
            
            updateEndTime()
        } else {
            if let event = self.event {
                if let url = URL(string: event.fullImageURL() ?? "") {
                    KingfisherManager.shared.retrieveImage(with: url) { result in
                        if let image = result.value?.image {
                            self.imageSelectButton.image = image
                            self.selectedImage = image
                        }
                    }
                }
                
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
                    }
                }
                if let eventLocation = event.eventLocation() {
                    selectedLocation = eventLocation
                }
                
                selectedRepeats = EventRepeatRules(dataString: event.repeatRules().dataString())
                
                if event.price > 0 {
                    priceInputField.textField.text = "\(event.price)"
                }
                
                ticketURLTextField.textField.text = event.ticketURL
                
                if MemberDataManager.canEditEvent(event: event) {
                    deleteButton.translatesAutoresizingMaskIntoConstraints = false
                    deleteButton.setTitle("CANCEL EVENT", for: .normal)
                    deleteButton.setTitleColor(.white, for: .normal)
                    deleteButton.titleLabel?.font = UIFont.cta()
                    deleteButton.addTarget(self, action: #selector(deleteButtonTouched), for: .touchUpInside)
                    scrollView.addSubview(deleteButton)
                    
                    deleteButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
                    deleteButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
                    deleteButton.topAnchor.constraint(equalTo: requiredFieldLabel.bottomAnchor, constant: 30).isActive = true
                    deleteButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
                    deleteButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
                } else {
                    requiredFieldLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
                }
            }
        }
        
        updateLocationLabel()
        updateTimeTextFields()
        updateSaveButtons()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        repeatsInputView.textField.text = selectedRepeats.rules(abreviated: true)
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if toVC is LocationPickerViewController || fromVC is LocationPickerViewController {
            let animator = LocationAnimator()
            animator.presenting = fromVC == self
            return animator
        }
        let animator = CustomAnimator()
        animator.presenting = fromVC == self
        return animator
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
        cancelButton.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.cta() as Any,
                                             NSAttributedString.Key.foregroundColor:UIColor.white], for: .normal)
        cancelButton.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.cta() as Any,
                                             NSAttributedString.Key.foregroundColor:UIColor.white], for: .highlighted)
        navigationItem.leftBarButtonItem = cancelButton
        
        if !isCreatingNew() {
            let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(doneButtonTouched))
            saveButton.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.cta() as Any,
                                                 NSAttributedString.Key.foregroundColor:UIColor.white], for: .normal)
            saveButton.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.cta() as Any,
                                                 NSAttributedString.Key.foregroundColor:UIColor.white], for: .highlighted)
            navigationItem.rightBarButtonItem = saveButton
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
        if let newEndTime = calendar.date(byAdding: .hour, value: 3, to: startTimePicker.date) {
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
    
    @objc func updateSaveButtons() {
        let enabled = dataUpdated()
        
        createButton.isEnabled = enabled
        navigationItem.rightBarButtonItem?.isEnabled = enabled
    }
    
    func prepareToDisplayLocationView(completion:@escaping () -> Void) {
        let locationLabelFrame = scrollView.convert(locationLabel.frame, to: view)
        
        locationBottomBar.frame = CGRect(x: locationLabelFrame.minX, y: locationLabelFrame.maxY - 2, width: locationLabelFrame.width, height: 2)
        locationBottomBar.backgroundColor = .white
        view.addSubview(locationBottomBar)
        
        locationLabel.divider.alpha = 0
        
        UIView.animate(withDuration: 0.35, animations: {
            self.scrollView.alpha = 0
            self.locationBottomBar.frame = CGRect(x: self.locationBottomBar.frame.origin.x, y: 157, width: self.locationBottomBar.frame.width, height: 2)
            self.view.layoutIfNeeded()
        }) { (complete) in
            completion()
        }
    }
    
    func returnFromLocationView(completion:@escaping () -> Void) {
        let locationLabelFrame = scrollView.convert(locationLabel.frame, to: view)
        
        UIView.animate(withDuration: 0.35, animations: {
            self.scrollView.alpha = 1
            self.view.layoutIfNeeded()
            self.locationBottomBar.frame = CGRect(x: locationLabelFrame.minX, y: locationLabelFrame.maxY - 1, width: locationLabelFrame.width, height: 1)
        }) { (complete) in
            self.locationBottomBar.removeFromSuperview()
            self.locationLabel.divider.alpha = 1
            completion()
        }
    }
    
    //MARK: Helpers
    
    func isCreatingNew() -> Bool {
        return event == nil
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
            if selectedStartTime() != event.startTime ?? Date() {
                return true
            }
            if selectedEndTime() != event.endTime ?? Date() {
                return true
            }
            if aboutTextView.textView.text != event.about {
                return true
            }
            if event.repeatRules().dataString() != selectedRepeats.dataString() {
                return true
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
            if event.price != Double(priceInputField.textField.text ?? "0") ?? 0 {
                return true
            }
            if event.ticketURL != ticketURLTextField.textField.text {
                return true
            }
        } else  {
            if let name = nameTextField.textField.text, let _ = selectedLocation {
                if name.count > 0 {
                    return true
                }
            }
        }
        
        return false
    }
    
    func saveEvent() {
        if isCreatingNew() {
            if let name = nameTextField.textField.text {
                if name.count > 0 {
                    activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.3) {
                        self.createButton.alpha = 0
                    }
                    EventManager.createEvent(name: name,
                                                    startTime: selectedStartTime(),
                                                    endTime: selectedEndTime(),
                                                    about: aboutTextView.textView.text,
                                                    location: selectedLocation,
                                                    price: Double(priceInputField.textField.text ?? "0") ?? 0,
                                                    ticketURL: ticketURLTextField.textField.text,
                                                    repeats: selectedRepeats.dataString(),
                                                    image: selectedImage,
                                                    onSuccess: { () in
                                                        let alert = UIAlertController(title: "Success!", message: "Your event as been added. It will appear in The Gay Agenda once approved.", preferredStyle: .alert)
                                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                                            self.dismiss(animated: true, completion: nil)
                                                        }))
                                                        self.present(alert, animated: true, completion: nil)
                                                        self.activityIndicator.stopAnimating()
                                                        UIView.animate(withDuration: 0.3) {
                                                            self.createButton.alpha = 1
                                                        }
                                                    }) { (error) in
                                                        guard let error = error else {
                                                            return
                                                        }
                                                        print("EVENT CREATION FAILED: \(error.localizedDescription)")
                                                        let alert = UIAlertController(title: "Error", message: "We were unable to create your event. Please try again.", preferredStyle: .alert)
                                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                                            
                                                        }))
                                                        self.present(alert, animated: true, completion: nil)
                                                        self.activityIndicator.stopAnimating()
                                                        UIView.animate(withDuration: 0.3) {
                                                            self.createButton.alpha = 1
                                                        }
                                                    }
                }
            }
        } else {
            if let event = self.event {
                if let name = nameTextField.textField.text {
                    if name.count > 0 {
                        EventManager.updateEvent(event: event,
                                                 name: name,
                                                 startTime: selectedStartTime(),
                                                 endTime: selectedEndTime(),
                                                 about: aboutTextView.textView.text,
                                                 location: selectedLocation,
                                                 price: Double(priceInputField.textField.text ?? "0") ?? 0,
                                                 ticketURL: ticketURLTextField.textField.text,
                                                 repeats: selectedRepeats.dataString(),
                                                 image: selectedImage,
                                                 onSuccess: { () in
                                                    self.dismiss(animated: true, completion: nil)
                        }) { (error) in
                            guard let error = error else {
                                return
                            }
                            print("EVENT UUPDATE FAILED: \(error.localizedDescription)")
                            let alert = UIAlertController(title: "Error", message: "We were unable to update your event. Please try again.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                            //update loader
                        }
                    }
                }
            }
        }
    }
    
    func selectedStartTime() -> Date {
        let hours = Calendar.current.component(.hour, from: startTimePicker.date)
        let minutes = Calendar.current.component(.minute, from: startTimePicker.date)
        return Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: datePicker.date) ?? Date()
    }
    
    func selectedEndTime() -> Date? {
        if endTimeTextField.alpha == 0 {
            return nil
        }
        let hours = Calendar.current.component(.hour, from: endTimePicker.date)
        let minutes = Calendar.current.component(.minute, from: endTimePicker.date)
        var endTime = Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: datePicker.date) ?? Date()
        let startTime = selectedStartTime()
        if endTime < startTime {
            let newEndTime = Calendar.current.date(byAdding: .day, value: 1, to: startTime)
            endTime = Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: newEndTime ?? Date()) ?? Date()
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
        saveEvent()
    }
    
    @objc func createButtonTouched() {
        saveEvent()
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
    }
    
    func updateEndTime(visible: Bool, animated: Bool) {
        if visible {
            endTimeTopConstraint.constant = textFieldHeight + 24
            UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
                self.endTimeTextField.alpha = 1
                self.view.layoutIfNeeded()
            })
        } else {
            endTimeTopConstraint.constant = 0
            UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
                self.endTimeTextField.alpha = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func locationButtonTouched() {
        let locationVC = LocationPickerViewController()
        locationVC.delegate = self
        navigationController?.pushViewController(locationVC, animated: true)
    }
    
    @objc func repeatsButtonTouched() {
        let repeatVC = RepeatEditViewController()
        repeatVC.rules = selectedRepeats
        navigationController?.pushViewController(repeatVC, animated: true)
    }
    
    @objc func deleteButtonTouched() {
        guard let eventName = self.event?.name else {
            return
        }
        
        let alert = UIAlertController(title: nil, message: "Are you sure you want to cancel \(eventName)", preferredStyle: UIAlertController.Style.alert)
        let deleteAction = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.destructive)  { (action: UIAlertAction) in
            if let event = self.event {
                EventManager.cancelEvent(event: event, onSuccess: {
                    self.dismiss(animated: true, completion: nil)
                }, onFailure: { (error) in
                    guard let error = error else {
                        return
                    }
                    print("EVENT CANCELATION FAILED: \(error.localizedDescription)")
                    let alert = UIAlertController(title: "Error", message: "We were unable to cancel your event. Please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }
        alert.addAction(deleteAction)
        let cancelAction = UIAlertAction.init(title: "KEEP", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func keyboardDoneButtonTouched() {
        dateTextField.textField.resignFirstResponder()
        startTimeTextField.textField.resignFirstResponder()
        endTimeTextField.textField.resignFirstResponder()
        aboutTextView.textView.resignFirstResponder()
        priceInputField.textField.resignFirstResponder()
    }
    
    //MARK: Location selection
    
    func locationPicker(sender: LocationPickerViewController, selected location:EventLocation) {
        selectedLocation = location
        updateLocationLabel()
        updateSaveButtons()
    }
    
    //MARK: Keyboard updates
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollViewBottomConstraint.constant = keyboardSize.height * -1
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollViewBottomConstraint.constant = 0
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
            
            setNeedsLayout()
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
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        
        backgroundColor = UIColor(red:1, green:1, blue:1, alpha:0.2)
        
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
        label.textColor = .white
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let image = self.image else {
            heightConstraint.constant = minHeight
            return
        }
        let imageSize = image.size
        let ratio = imageSize.height / imageSize.width
        
        let width = self.bounds.width
        let imageHeight = width * ratio
        let height = imageHeight > minHeight ? imageHeight : minHeight
        heightConstraint.constant = height
    }
}

class LocationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var presenting = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        let container = transitionContext.containerView
        if presenting {
            container.addSubview(toView)
        } else {
            container.insertSubview(toView, belowSubview: fromView)
        }
        
        toView.frame = container.frame
        toView.layoutIfNeeded()
        
        if let fromVC = transitionContext.viewController(forKey: .from) as? EventEditViewController {
            toView.alpha = 0
            fromVC.prepareToDisplayLocationView {
                toView.alpha = 1
                fromView.alpha = 0
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        } else {
            guard let toVC = transitionContext.viewController(forKey: .to) as? EventEditViewController else {
                return
            }
            toView.alpha = 1
            fromView.alpha = 0
            toVC.returnFromLocationView {
                
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
