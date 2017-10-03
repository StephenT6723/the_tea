//
//  MyAccountViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/16/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView()
    var aboutText = "Soaring through the air in her combat armor, and armed with a launcher that lays down high-explosive rockets, Pharah is a force to be reckoned with."
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "My Profile"
        view.backgroundColor = .white
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTouched))
        navigationItem.leftBarButtonItem = cancelButton
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProfileUserInfoCell.self, forCellReuseIdentifier: String(describing: ProfileUserInfoCell.self))
        tableView.register(EventListTableViewCell.self, forCellReuseIdentifier: String(describing: EventListTableViewCell.self))
        tableView.register(ProfileHeader.self, forHeaderFooterViewReuseIdentifier: String(describing: ProfileHeader.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func cancelButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && aboutText.characters.count > 0 {
            return 1
        }
        return events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? UITableViewAutomaticDimension : 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: ProfileHeader.self)) as? ProfileHeader else {
            return ProfileHeader()
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileUserInfoCell.self), for: indexPath) as? ProfileUserInfoCell else {
                return ProfileUserInfoCell()
            }
            
            cell.aboutLabel.text = aboutText
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventListTableViewCell.self), for: indexPath) as? EventListTableViewCell else {
            return EventListTableViewCell()
        }
        
        cell.textLabel?.text = "Drag Show"
        cell.detailTextLabel?.text = "Pieces Bar"
        return cell
    }
}

class ProfileUserInfoCell: UITableViewCell {
    let aboutLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.primaryBrand()
        clipsToBounds = false
        
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.font = UIFont.body()
        aboutLabel.textColor = .white
        aboutLabel.numberOfLines = 0
        addSubview(aboutLabel)
        
        aboutLabel.topAnchor.constraint(equalTo: topAnchor, constant: -4).isActive = true
        aboutLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        aboutLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        aboutLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ProfileHeader: UITableViewHeaderFooterView {
    let nameLabel = UILabel()
    let profileImageView = UIImageView(image: UIImage(named: "placeholder_profile_image"))
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
        nameLabel.text = "ALEXANDER UNICK"
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
        
        profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        
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
