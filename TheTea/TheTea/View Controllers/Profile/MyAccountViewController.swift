//
//  MyAccountViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/16/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class MyAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CarouselDelegate {
    let tableView = UITableView(frame: CGRect(), style: .grouped)
    var upcomingEvents = EventCollection()
    var currentMember = MemberDataManager.loggedInMember()
    var hasShownLogin = false
    let signUpPrompt = UIView()
    let signUpLabel = UILabel()
    let signUpCTA = PrimaryCTA(frame: CGRect())
    private let timeFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 0.01))
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.lightBackground()
        tableView.register(ProfileAboutCell.self, forCellReuseIdentifier: String(describing: ProfileAboutCell.self))
        tableView.register(ProfileNoEventsCell.self, forCellReuseIdentifier: String(describing: ProfileNoEventsCell.self))
        tableView.register(EventCarouselTableViewCell.self, forCellReuseIdentifier: String(describing: EventCarouselTableViewCell.self))
        tableView.register(ProfileHeader.self, forHeaderFooterViewReuseIdentifier: String(describing: ProfileHeader.self))
        tableView.register(EventListHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: EventListHeaderView.self))
        tableView.register(ProfileAddEventFooter.self, forHeaderFooterViewReuseIdentifier: String(describing: ProfileAddEventFooter.self))
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

        if !MemberDataManager.isLoggedIn() {
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
    
    @objc func presentLoginView() {
        let loginVC = LoginViewController()
        let loginNav = UINavigationController(rootViewController: loginVC)
        loginNav.navigationBar.prefersLargeTitles = true
        loginNav.navigationBar.isTranslucent = false
        present(loginNav, animated: true, completion: nil)
    }
    
    @objc func addEventTapped() {
        let addEventVC = EventEditViewController()
        let addNav = UINavigationController(rootViewController: addEventVC)
        addNav.navigationBar.isTranslucent = false
        present(addNav, animated: true, completion: nil)
    }
    
    @objc func seeAllTapped(sender: UIButton) {
        let section = sender.tag
        
        //guard let sectionInfo = eventsFRC.sections?[section] else { return }
        
        //let sectionName = sectionInfo.name
        if section == 1 {
            let eventCollectionVC = EventCollectionViewController()
            let selectedEventsFRC = EventManager.favoritedEvents()
            eventCollectionVC.eventsFRC = selectedEventsFRC
            eventCollectionVC.title = "FAVORITES"
            navigationController?.pushViewController(eventCollectionVC, animated: true)
        }
    }
    
    //MARK: Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if MemberDataManager.loggedInMember() == nil {
            return 0
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let aboutText = currentMember?.about {
            if section == 0 && aboutText.count > 0 {
                return 1
            }
        }
        
        if section == 1 {
            let favoriteCount = MemberDataManager.loggedInMember()?.favorites?.count
            if favoriteCount ?? 0 > 0 {
                return 1
            }
            return 1
        }
        
        if section == 2 {
            return 1
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
        if section == 2 {
           return UITableView.automaticDimension
        }
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
            
            header.nameLabel.text = currentMember.name?.capitalized ?? "My Profile"
            
            header.facebookButton.isEnabled = true
            header.instagramButton.isEnabled = true//currentMember.instagram?.count ?? 0 > 0
            header.twitterButton.isEnabled = currentMember.twitter?.count ?? 0 > 0
            
            header.addEventButton.addTarget(self, action: #selector(addEventTapped), for: .touchUpInside)
            
            return header
        } else {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: EventListHeaderView.self)) as? EventListHeaderView else {
                return EventListHeaderView()
            }
            
            if section == 1 {
                header.titleLabel.text = "Favorites"
                let favoriteCount = MemberDataManager.loggedInMember()?.favorites?.count
                header.seeAllButton.alpha = 0
                if favoriteCount ?? 0 > 3 {
                    header.seeAllButton.addTarget(self, action: #selector(seeAllTapped(sender:)), for: .touchUpInside)
                    header.seeAllButton.alpha = 1
                    header.seeAllButton.tag = 1
                }
            } else if section == 2 {
                header.titleLabel.text = "Hosted Events"
                header.seeAllButton.alpha = 0
            } else if section == 3 {
                header.titleLabel.text = "Past Events"
                header.seeAllButton.alpha = 0
            }
            
            
            
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: ProfileAddEventFooter.self)) as? ProfileAddEventFooter else {
                return ProfileAddEventFooter()
            }
            footer.addEventButton.addTarget(self, action: #selector(addEventTapped), for: .touchUpInside) //self, action: #selector(addEventTapped))
            return footer
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileAboutCell.self), for: indexPath) as? ProfileAboutCell else {
                return ProfileAboutCell()
            }
            
            cell.aboutLabel.text = currentMember?.about
            
            return cell
        }
        
        if indexPath.section == 1 {
            if MemberDataManager.loggedInMember()?.favorites?.count ?? 0 > 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventCarouselTableViewCell.self), for: indexPath) as? EventCarouselTableViewCell else {
                    return EventCarouselTableViewCell()
                }
                
                cell.carousel.tag = indexPath.section
                cell.carousel.delegate = self
                cell.carousel.updateContent()
                
                return cell
            }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileNoEventsCell.self), for: indexPath) as? ProfileNoEventsCell else {
                return ProfileNoEventsCell()
            }
            
            cell.label.text = "You don't have any favorite events yet"
            cell.label.textAlignment = .center
            
            return cell
        }
        
        if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileNoEventsCell.self), for: indexPath) as? ProfileNoEventsCell else {
                return ProfileNoEventsCell()
            }
            
            cell.label.text = "You aren't hosting any events yet"
            cell.label.textAlignment = .center
            
            return cell
        }
        
        if indexPath.section == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileNoEventsCell.self), for: indexPath) as? ProfileNoEventsCell else {
                return ProfileNoEventsCell()
            }
            
            cell.label.text = "You don't have any past events"
            cell.label.textAlignment = .center
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventCarouselTableViewCell.self), for: indexPath) as? EventCarouselTableViewCell else {
            return EventCarouselTableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            guard let member = MemberDataManager.loggedInMember() else {
                return
            }
            
            if member.favorites?.count ?? 0 > 0 {
                let favorites = member.hotFavorites()
                let favorite = favorites[indexPath.row]
                
                let detailVC = EventDetailViewController(event:favorite)
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
    //MARK: Carousel Delegate
    
    func numberOfItemsIn(carousel: Carousel) -> Int {
        guard let member = MemberDataManager.loggedInMember() else {
            return 0
        }
        
        let favorites = member.hotFavorites()
        
        return favorites.count > 3 ? 3 : favorites.count
    }
    
    func view(for carousel: Carousel, at index: Int) -> UIView? {
        let index = carousel.tag
        
        guard let member = MemberDataManager.loggedInMember() else {
            return nil
        }
        
        let favorites = member.hotFavorites()
        let event = favorites[index]
        
        let cellView = EventView(frame: CGRect())
        cellView.imageURL = event.fullImageURL()
        cellView.titleLabel.text = event.name
        cellView.timeLabel.text = timeFormatter.string(from: event.startTime ?? Date())
        cellView.placeLabel.text = event.locationName
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        let priceString = event.price == 0 ? "Free" : numberFormatter.string(from: NSNumber(value: event.price))
        cellView.priceLabel.text = priceString
        
        return cellView
    }
    
    func carousel(_ carousel: Carousel, didSelect index: Int) {
        let index = carousel.tag
        
        guard let member = MemberDataManager.loggedInMember() else {
            return
        }
        
        let favorites = member.hotFavorites()
        let event = favorites[index]
        let detailVC = EventDetailViewController(event:event)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

class ProfileHeader: UITableViewHeaderFooterView {
    let nameLabel = UILabel()
    let profileImageView = UIImageView()
    let imageViewContainer = UIView()
    let backgroundStripe = UIView()
    let facebookButton = ProfileSocialButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    let instagramButton = ProfileSocialButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    let twitterButton = ProfileSocialButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    let addEventButton = PrimaryCTA()
    
    let socialButtonSize: CGFloat = 30
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        backgroundStripe.translatesAutoresizingMaskIntoConstraints = false
        backgroundStripe.backgroundColor = .clear
        contentView.addSubview(backgroundStripe)
        
        imageViewContainer.translatesAutoresizingMaskIntoConstraints = false
        imageViewContainer.layer.cornerRadius = 35
        imageViewContainer.layer.borderWidth = 1
        imageViewContainer.layer.borderColor = UIColor.white.cgColor
        imageViewContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageViewContainer.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.16).cgColor
        imageViewContainer.layer.shadowOpacity = 1
        imageViewContainer.layer.shadowRadius = 5
        contentView.addSubview(imageViewContainer)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 35
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.image = UIImage(named: "placeholder_profile_image")
        imageViewContainer.addSubview(profileImageView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.profileTitle()
        nameLabel.textColor = UIColor.primaryCopy()
        contentView.addSubview(nameLabel)
        
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        facebookButton.setImage(UIImage(named:"facebook"), for: .normal)
        contentView.addSubview(facebookButton)
        
        instagramButton.translatesAutoresizingMaskIntoConstraints = false
        instagramButton.setImage(UIImage(named:"insta"), for: .normal)
        contentView.addSubview(instagramButton)
        
        twitterButton.translatesAutoresizingMaskIntoConstraints = false
        twitterButton.setImage(UIImage(named:"twitter"), for: .normal)
        contentView.addSubview(twitterButton)
        
        addEventButton.translatesAutoresizingMaskIntoConstraints = false
        addEventButton.setTitle("Post an Event", for: .normal)
        contentView.addSubview(addEventButton)
        
        backgroundStripe.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        backgroundStripe.heightAnchor.constraint(equalToConstant: 70).isActive = true
        backgroundStripe.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        backgroundStripe.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        imageViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        imageViewContainer.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageViewContainer.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        
        profileImageView.topAnchor.constraint(equalTo: imageViewContainer.topAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: imageViewContainer.leadingAnchor).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 2).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        facebookButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -6).isActive = true
        facebookButton.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16).isActive = true
        facebookButton.heightAnchor.constraint(equalToConstant: socialButtonSize).isActive = true
        facebookButton.widthAnchor.constraint(equalToConstant: socialButtonSize).isActive = true
        
        instagramButton.bottomAnchor.constraint(equalTo: facebookButton.bottomAnchor).isActive = true
        instagramButton.leadingAnchor.constraint(equalTo: facebookButton.trailingAnchor, constant: 10).isActive = true
        instagramButton.heightAnchor.constraint(equalToConstant: socialButtonSize).isActive = true
        instagramButton.widthAnchor.constraint(equalToConstant: socialButtonSize).isActive = true
        
        twitterButton.bottomAnchor.constraint(equalTo: facebookButton.bottomAnchor).isActive = true
        twitterButton.leadingAnchor.constraint(equalTo: instagramButton.trailingAnchor, constant: 10).isActive = true
        twitterButton.heightAnchor.constraint(equalToConstant: socialButtonSize).isActive = true
        twitterButton.widthAnchor.constraint(equalToConstant: socialButtonSize).isActive = true
        
        addEventButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        addEventButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        addEventButton.heightAnchor.constraint(equalToConstant: PrimaryCTA.preferedHeight).isActive = true
        addEventButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        addEventButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ProfileSocialButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                clipsToBounds = false
            } else {
                clipsToBounds = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 5
        backgroundColor = UIColor.white
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.16).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 6
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(rect: frame).cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ProfileAboutCell: UITableViewCell {
    let aboutLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.lightBackground()
        selectionStyle = .none
        clipsToBounds = false
        
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.font = UIFont.body()
        aboutLabel.textColor = UIColor.primaryCopy()
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

class ProfileNoEventsCell: UITableViewCell {
    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.lightBackground()
        selectionStyle = .none
        clipsToBounds = false
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.body()
        label.textColor = UIColor.primaryCopy()
        label.numberOfLines = 0
        addSubview(label)
        
        label.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ProfileAddEventFooter: UITableViewHeaderFooterView {
    let addEventButton = PrimaryCTA()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.lightBackground()
        
        addEventButton.translatesAutoresizingMaskIntoConstraints = false
        addEventButton.setTitle("POST AN EVENT", for: .normal)
        contentView.addSubview(addEventButton)
        
        addEventButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        addEventButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        addEventButton.heightAnchor.constraint(equalToConstant: PrimaryCTA.preferedHeight).isActive = true
        addEventButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        addEventButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
