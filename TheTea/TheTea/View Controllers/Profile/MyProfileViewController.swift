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

    private let tableView = UITableView(frame: CGRect(), style: UITableView.Style.grouped)
    var eventsFRC = EventManager.favoritedEvents() ?? NSFetchedResultsController<Event>()
    
    private let timeFormatter = DateFormatter()
    
    private let editView = EditProfileView(frame: CGRect())
    
    private let loginVC = LoginViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTouched))
        
        title = "My Profile"
        view.backgroundColor = .white
        
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
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
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 50
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tableView.backgroundColor = .white
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: String(describing: EventTableViewCell.self))
        tableView.register(MyProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: MyProfileHeaderView.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.clipsToBounds = false
        view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateNavButtons()
    }

    //MARK: Actions
    
    @objc func doneButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func logoutButtonTouched() {
        let alert = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Log out", style: .default, handler: { action in
            MemberDataManager.logoutMember()
            self.dismiss(animated: true, completion: nil)
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
        guard let name = editView.nameTextField.text, let email = editView.emailTextField.text else {
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
        editView.nameTextField.resignFirstResponder()
        editView.emailTextField.resignFirstResponder()
        setLoaderVisible(true, animated: true)
        MemberDataManager.updateMember(name: name, email: email, facebookID: "", instagram: "", twitter: "", about: "", onSuccess: {
            self.dismissAlertView()
            self.setLoaderVisible(false, animated: true)
            self.tableView.reloadData()
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
    
    @objc func editProfileButtonTouched() {
        editView.nameTextField.text = MemberDataManager.loggedInMember()?.name
        editView.emailTextField.text = MemberDataManager.loggedInMember()?.email
        editView.cancelButton.addTarget(self, action: #selector(editProfileCancelButtonTouched), for: .touchUpInside)
        editView.saveButton.addTarget(self, action: #selector(saveButtonTouched), for: .touchUpInside)
        presentAlertView(view: editView)
    }
    
    @objc func editProfileCancelButtonTouched() {
        dismissAlertView()
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
        tableView.reloadData()
    }
}

extension MyProfileViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = eventsFRC.sections else {
            return 0
        }
        
        guard section < sections.count else {
            return 0
        }
        
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: MyProfileHeaderView.self)) as? MyProfileHeaderView,
            let member = MemberDataManager.loggedInMember(),
            let city = CityManager.selectedCity() else {
            return MyProfileHeaderView(reuseIdentifier: String(describing: MyProfileHeaderView.self))
        }
        
        header.customContentView.nameLabel.text = member.name
        header.customContentView.locationLabel.text = "\(city.name ?? ""), \(city.state ?? "")"
        header.customContentView.emailLabel.text = member.email
        header.customContentView.addEventButton.addTarget(self, action: #selector(addEventButtonTouched), for: .touchUpInside)
        header.customContentView.editProfileButton.addTarget(self, action: #selector(editProfileButtonTouched), for: .touchUpInside)
        
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventTableViewCell.self), for: indexPath) as? EventTableViewCell else {
            return EventTableViewCell()
        }
        
        let event = eventsFRC.object(at: indexPath)
        if let url = event.fullImageURL() {
            cell.eventView.imageURL = url
        } else {
            cell.eventView.image = event.backupImage()
        }
        let subtitleColor = event.canceled ? UIColor(red:0.92, green:0.4, blue:0.4, alpha:1) : UIColor.lightCopy()
        cell.eventView.update(title: event.name, subtitle: event.subtitle(), subtitleColor: subtitleColor)
        cell.eventView.timeLabel.text = timeFormatter.string(from: event.startTime ?? Date())
        cell.eventView.placeLabel.text = event.locationName
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        let priceString = event.price == 0 ? "Free" : numberFormatter.string(from: NSNumber(value: event.price))
        cell.eventView.priceLabel.text = priceString
        
        return cell
    }
}

extension MyProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = eventsFRC.object(at: indexPath)
        let detailVC = EventDetailViewController(event:event)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

class MyProfileHeaderView: UITableViewHeaderFooterView {
    let imageView = UIImageView(image: UIImage(named: "LosAngelesBackup4"))
    let customContentView = MyProfileContentView(frame: CGRect())
    private let segmentedControl = SegmentedControl()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 252)
        gradient.colors = [
            UIColor(red:0.94, green:0.53, blue:1, alpha:0.6).cgColor,
            UIColor(red:0.47, green:0.77, blue:1, alpha:0.6).cgColor
        ]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 1, y: 1)
        imageView.layer.addSublayer(gradient)
        
        customContentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(customContentView)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.items = ["Favorites", "Hosting"]
        segmentedControl.backgroundColor = UIColor(white: 1, alpha: 0.9)
        addSubview(segmentedControl)
        
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 170).isActive = true
        
        customContentView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -50).isActive = true
        customContentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        customContentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        customContentView.heightAnchor.constraint(equalToConstant: 340).isActive = true
        
        segmentedControl.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 310).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 46).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class MyProfileContentView: UIView {
    let addProfilePictureButton = AddProfilePictureButton(frame: CGRect())
    let nameLabel = UILabel()
    let locationLabel = UILabel()
    let addEventButton = PrimaryCTA(frame: CGRect())
    let emailTitleLabel = UILabel()
    let emailLabel = UILabel()
    let editProfileButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 12.0
        backgroundColor = .white
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.08).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 10
        
        addProfilePictureButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(addProfilePictureButton)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        nameLabel.textColor = UIColor(red:0.19, green:0.21, blue:0.27, alpha:1)
        addSubview(nameLabel)
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.font = UIFont(name: "Montserrat-Regular", size: 14)
        locationLabel.textColor = UIColor(red:0.19, green:0.21, blue:0.27, alpha:0.48)
        addSubview(locationLabel)
        
        addEventButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(addEventButton)
        
        addEventButton.translatesAutoresizingMaskIntoConstraints = false
        addEventButton.setTitle("Add an Event  ", for: .normal)
        addEventButton.setImage(UIImage(named:"plannerIcon"), for: .normal)
        addEventButton.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        addSubview(addEventButton)
        
        emailTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTitleLabel.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        emailTitleLabel.textColor = UIColor(red:0.19, green:0.21, blue:0.27, alpha:0.48)
        emailTitleLabel.text = "EMAIL ADDRESS"
        addSubview(emailTitleLabel)
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        emailLabel.textColor = UIColor(red:0.19, green:0.21, blue:0.27, alpha:1)
        addSubview(emailLabel)
        
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false
        editProfileButton.setTitle("Edit Profile", for: .normal)
        editProfileButton.setTitleColor(UIColor.primaryCTA(), for: .normal)
        editProfileButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 12)
        addSubview(editProfileButton)
        
        addProfilePictureButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addProfilePictureButton.centerYAnchor.constraint(equalTo: topAnchor).isActive = true
        addProfilePictureButton.widthAnchor.constraint(equalToConstant: AddProfilePictureButton.preferedSize).isActive = true
        addProfilePictureButton.heightAnchor.constraint(equalToConstant: AddProfilePictureButton.preferedSize).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: addProfilePictureButton.bottomAnchor, constant: 12).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addEventButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 24).isActive = true
        addEventButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addEventButton.heightAnchor.constraint(equalToConstant: PrimaryCTA.preferedHeight).isActive = true
        addEventButton.widthAnchor.constraint(equalToConstant: 178).isActive = true
        
        emailTitleLabel.topAnchor.constraint(equalTo: addEventButton.bottomAnchor, constant: 46).isActive = true
        emailTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        emailLabel.topAnchor.constraint(equalTo: emailTitleLabel.bottomAnchor, constant: 6).isActive = true
        emailLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        editProfileButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        editProfileButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class AddProfilePictureButton: UIButton {
    static let preferedSize: CGFloat = 112
    private let backgroundView = UIView()
    private let cameraImageView = UIImageView(image: UIImage(named: "cameraIcon"))
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = AddProfilePictureButton.preferedSize / 2
        backgroundColor = UIColor(red:1, green:1, blue:1, alpha:0.4)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor(red:0.9, green:0.92, blue:0.92, alpha:1)
        backgroundView.layer.cornerRadius = (AddProfilePictureButton.preferedSize - 8) / 2
        addSubview(backgroundView)
        
        cameraImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cameraImageView)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add Profile\nPicture"
        label.font = UIFont(name: "Montserrat-SemiBold", size: 10)
        label.textAlignment = .center
        label.textColor = UIColor(red:0.19, green:0.21, blue:0.27, alpha:0.58)
        label.numberOfLines = 0
        addSubview(label)
        
        backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
        
        cameraImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cameraImageView.topAnchor.constraint(equalTo: topAnchor, constant: 28).isActive = true
        
        label.topAnchor.constraint(equalTo: cameraImageView.bottomAnchor, constant: 8).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
