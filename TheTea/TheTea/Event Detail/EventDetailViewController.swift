//
//  EventDetailViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/13/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    var event : Event?
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    let aboutLabel = UILabel()
    let locationLabel = UILabel()
    
    convenience init(event: Event) {
        self.init()
        self.event = event
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Event Detail"
        view.backgroundColor = .white
        
        guard let event = self.event else {
            return
        }
        
        if MemberDataManager.sharedInstance.canEditEvent(event:event) {
            let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTouched))
            navigationItem.rightBarButtonItem = editButton
        }
        
        let margins = view.layoutMarginsGuide
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(titleLabel)
        
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20).isActive = true
        
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(detailLabel)
        
        detailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        detailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.numberOfLines = 0
        aboutLabel.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(aboutLabel)
        
        aboutLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        aboutLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        aboutLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 10).isActive = true
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.numberOfLines = 0
        locationLabel.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(locationLabel)
        
        locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        locationLabel.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 10).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateContent()
    }
    
    func updateContent() {
        guard let event = self.event else {
            return
        }
        
        titleLabel.text = event.name?.capitalized
        if let date = event.startTime {
            detailLabel.text = DateStringHelper.fullDescription(of: date as Date)
        }
        aboutLabel.text = "Pharah is a versatile and mobile Offense hero, capable of limited-duration flight. This gives her good escape capabilities, excellent vantage in open-air situations, and enables her to reach enemy snipers with ease. Her Ultimate ability Barrage allows her to rain heavy damage down on her enemies."
        locationLabel.text = "20 Henry Street Apt. 2DN\nBrooklyn, NY 11201"
    }
    
    func editButtonTouched() {
        let editVC = EventEditViewController()
        editVC.event = event
        let editNav = UINavigationController(rootViewController: editVC)
        editNav.navigationBar.isTranslucent = false
        present(editNav, animated: true, completion: nil)
    }
}
