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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "My Profile"
        view.backgroundColor = .white
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTouched))
        navigationItem.leftBarButtonItem = cancelButton
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProfileUserInfoCell.self, forCellReuseIdentifier: String(describing: ProfileUserInfoCell.self))
        tableView.register(EventListTableViewCell.self, forCellReuseIdentifier: String(describing: EventListTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 80 : 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "My Events"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileUserInfoCell.self), for: indexPath) as? ProfileUserInfoCell else {
                return ProfileUserInfoCell()
            }
            
            cell.nameLabel.text = "Pharah"
            cell.emailLabel.text = "justicerainsfromabove@overwatch.com"
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
    let customImageView = UIImageView(image: UIImage(named: "placeholder_profile_image"))
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        customImageView.contentMode = .scaleAspectFill
        customImageView.clipsToBounds = true
        contentView.addSubview(customImageView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        contentView.addSubview(nameLabel)
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(emailLabel)
        
        customImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14).isActive = true
        customImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        customImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        customImageView.widthAnchor.constraint(equalTo: customImageView.heightAnchor).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: 10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: customImageView.topAnchor, constant: 10).isActive = true
        
        emailLabel.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: 10).isActive = true
        emailLabel.bottomAnchor.constraint(equalTo: customImageView.bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
