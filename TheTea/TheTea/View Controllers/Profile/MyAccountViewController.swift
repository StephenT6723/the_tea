//
//  MyAccountViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/16/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class MyAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView(frame: CGRect(), style: .grouped)
    var upcomingEvents = EventCollection()
    var currentMember = MemberDataManager.sharedInstance.currentMember()
    var hasShownLogin = false
    let signUpPrompt = UIView()
    let signUpLabel = UILabel()
    let signUpCTA = PrimaryCTA(frame: CGRect())
    private let timeFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "MY PROFILE"
        
        view.backgroundColor = .white
        
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 0.01))
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.primaryBrand()
        tableView.register(ProfileAboutCell.self, forCellReuseIdentifier: String(describing: ProfileAboutCell.self))
        tableView.register(EventListTableViewCell.self, forCellReuseIdentifier: String(describing: EventListTableViewCell.self))
        tableView.register(ProfileHeader.self, forHeaderFooterViewReuseIdentifier: String(describing: ProfileHeader.self))
        tableView.register(ProfileMyEventsHeader.self, forHeaderFooterViewReuseIdentifier: String(describing: ProfileMyEventsHeader.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.estimatedSectionHeaderHeight = 130
        view.addSubview(tableView)
        
        signUpPrompt.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signUpPrompt)
        
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.text = "Sign up to access your profile"
        signUpLabel.textColor = UIColor.primaryCopy()
        signUpLabel.font = UIFont.headerTwo()
        signUpLabel.textAlignment = .center
        signUpPrompt.addSubview(signUpLabel)
        
        signUpCTA.translatesAutoresizingMaskIntoConstraints = false
        signUpCTA.setTitle("SIGN UP", for: .normal)
        signUpCTA.addTarget(self, action: #selector(presentLoginView), for: .touchUpInside)
        signUpPrompt.addSubview(signUpCTA)
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        signUpPrompt.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        signUpPrompt.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        signUpPrompt.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        signUpPrompt.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        signUpLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        signUpLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        signUpLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -90).isActive = true
        
        signUpCTA.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        signUpCTA.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        signUpCTA.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: 40).isActive = true
        signUpCTA.heightAnchor.constraint(equalToConstant: PrimaryCTA.preferedHeight).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !MemberDataManager.sharedInstance.isLoggedIn() {
            if !hasShownLogin {
                presentLoginView()
                hasShownLogin = true
            }
            tableView.alpha = 0
            signUpPrompt.alpha = 1
            navigationItem.rightBarButtonItem = nil
        } else {
            hasShownLogin = false
            tableView.alpha = 1
            signUpPrompt.alpha = 0
            tableView.reloadData()
            let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTouched))
            navigationItem.rightBarButtonItem = editButton
        }
    }
    
    //MARK: Actions
    
    @objc func editButtonTouched() {
        let editVC = EditMyAccountViewController()
        let editNav = UINavigationController(rootViewController: editVC)
        editNav.navigationBar.isTranslucent = false
        present(editNav, animated: true, completion: nil)
    }
    
    @objc func myEventsOptionChanged(sender: SegmentedControl) {
        //let isUpcoming = sender.selectedIndex == 0
        
    }
    
    @objc func presentLoginView() {
        let loginVC = LoginViewController()
        let loginNav = UINavigationController(rootViewController: loginVC)
        loginNav.navigationBar.prefersLargeTitles = true
        loginNav.navigationBar.isTranslucent = false
        present(loginNav, animated: true, completion: nil)
    }
    
    //MARK: Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let aboutText = currentMember?.about {
            if section == 0 && aboutText.count > 0 {
                return 1
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: ProfileHeader.self)) as? ProfileHeader else {
                return ProfileHeader()
            }
            
            guard let currentMember = self.currentMember else {
                return header
            }
            
            header.nameLabel.text = currentMember.name?.capitalized
            header.facebookButton.alpha = 1
            header.facebookButton.isEnabled = true
            
            if !currentMember.linkToFacebook {
                header.facebookButton.alpha = 0.3
                header.facebookButton.isEnabled = false
            }
            
            header.instagramButton.alpha = 1
            header.instagramButton.isEnabled = true
            
            if currentMember.instagram?.count == 0 {
                header.instagramButton.alpha = 0.3
                header.instagramButton.isEnabled = false
            }
            
            header.twitterButton.alpha = 1
            header.twitterButton.isEnabled = true
            
            if currentMember.twitter?.count == 0 {
                header.twitterButton.alpha = 0.3
                header.twitterButton.isEnabled = false
            }
            
            header.profileImageView.profileID = currentMember.facebookID
            
            return header
        } else {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: ProfileMyEventsHeader.self)) as? ProfileMyEventsHeader else {
                return ProfileMyEventsHeader()
            }
            
            header.titleLabel.text = "MY EVENTS"
            header.segmentedControl.addTarget(self, action: #selector(myEventsOptionChanged(sender:)), for: .valueChanged)
            
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileAboutCell.self), for: indexPath) as? ProfileAboutCell else {
                return ProfileAboutCell()
            }
            
            cell.aboutLabel.text = currentMember?.about
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventListTableViewCell.self), for: indexPath) as? EventListTableViewCell else {
            return EventListTableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            
        }
    }
}

class ProfileHeader: UITableViewHeaderFooterView {
    let nameLabel = UILabel()
    let profileImageView = FBSDKProfilePictureView()
    let backgroundStripe = UIView()
    let facebookButton = UIButton()
    let instagramButton = UIButton()
    let twitterButton = UIButton()
    
    let socialButtonSize: CGFloat = 20
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.primaryBrand()
        
        backgroundStripe.translatesAutoresizingMaskIntoConstraints = false
        backgroundStripe.backgroundColor = .white
        contentView.addSubview(backgroundStripe)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 3
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 8
        contentView.addSubview(profileImageView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.headerOne()
        nameLabel.textColor = UIColor.primaryCopy()
        contentView.addSubview(nameLabel)
        
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        facebookButton.layer.cornerRadius = 2
        facebookButton.clipsToBounds = true
        facebookButton.setImage(UIImage(named:"facebook"), for: .normal)
        contentView.addSubview(facebookButton)
        
        instagramButton.translatesAutoresizingMaskIntoConstraints = false
        instagramButton.layer.cornerRadius = 2
        instagramButton.clipsToBounds = true
        instagramButton.setImage(UIImage(named:"insta"), for: .normal)
        contentView.addSubview(instagramButton)
        
        twitterButton.translatesAutoresizingMaskIntoConstraints = false
        twitterButton.layer.cornerRadius = 2
        twitterButton.clipsToBounds = true
        twitterButton.setImage(UIImage(named:"twitter"), for: .normal)
        contentView.addSubview(twitterButton)
        
        backgroundStripe.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        backgroundStripe.heightAnchor.constraint(equalToConstant: 70).isActive = true
        backgroundStripe.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        backgroundStripe.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: backgroundStripe.topAnchor, constant: 7).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        facebookButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6).isActive = true
        facebookButton.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20).isActive = true
        facebookButton.heightAnchor.constraint(equalToConstant: socialButtonSize).isActive = true
        facebookButton.widthAnchor.constraint(equalToConstant: socialButtonSize).isActive = true
        
        instagramButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6).isActive = true
        instagramButton.leadingAnchor.constraint(equalTo: facebookButton.trailingAnchor, constant: 20).isActive = true
        instagramButton.heightAnchor.constraint(equalToConstant: socialButtonSize).isActive = true
        instagramButton.widthAnchor.constraint(equalToConstant: socialButtonSize).isActive = true
        
        twitterButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6).isActive = true
        twitterButton.leadingAnchor.constraint(equalTo: instagramButton.trailingAnchor, constant: 20).isActive = true
        twitterButton.heightAnchor.constraint(equalToConstant: socialButtonSize).isActive = true
        twitterButton.widthAnchor.constraint(equalToConstant: socialButtonSize).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ProfileAboutCell: UITableViewCell {
    let aboutLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.primaryBrand()
        selectionStyle = .none
        clipsToBounds = false
        
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.font = UIFont.body()
        aboutLabel.textColor = .white
        aboutLabel.numberOfLines = 0
        addSubview(aboutLabel)
        
        aboutLabel.topAnchor.constraint(equalTo: topAnchor, constant: -4).isActive = true
        aboutLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14).isActive = true
        aboutLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        aboutLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ProfileMyEventsHeader: UITableViewHeaderFooterView {
    let titleLabel = UILabel()
    let segmentedControl = SegmentedControl()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.primaryBrand()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.headerOne()
        titleLabel.textColor = .white
        contentView.addSubview(titleLabel)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.items = ["UPCOMING", "PAST"]
        contentView.addSubview(segmentedControl)
        
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        
        segmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
