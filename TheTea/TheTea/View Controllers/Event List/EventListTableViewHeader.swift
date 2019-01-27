//
//  EventListTableViewHeader.swift
//  TheTea
//
//  Created by Stephen Thomas on 1/14/19.
//  Copyright © 2019 The Tea LLC. All rights reserved.
//

import UIKit

class EventListTableViewHeader: UIView {
    let backgroundImageView = UIImageView(image: UIImage(named: "listHeaderPlaceholder"))
    let locationButton = LocationButton()
    let label = UILabel()
    let tgaLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.alpha = 0
        addSubview(backgroundImageView)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome to the beta! Enjoy yourself but try not to break anything expensive."
        label.font = UIFont(name: "Montserrat-Medium", size: 18)
        label.textColor = .white
        label.numberOfLines = 0
        label.alpha = 0
        addSubview(label)
        
        tgaLabel.translatesAutoresizingMaskIntoConstraints = false
        tgaLabel.text = "- The Gay Agenda"
        tgaLabel.font = UIFont(name: "Montserrat-Medium", size: 14)
        tgaLabel.textColor = .white
        tgaLabel.textAlignment = .right
        tgaLabel.alpha = 0
        addSubview(tgaLabel)
        
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(locationButton)
        
        backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: 188).isActive = true
        
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40).isActive = true
        label.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor, constant: -10).isActive = true
        
        tgaLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
        tgaLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40).isActive = true
        tgaLabel.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        
        locationButton.centerYAnchor.constraint(equalTo: backgroundImageView.bottomAnchor).isActive = true
        locationButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        locationButton.heightAnchor.constraint(equalToConstant: LocationButton.preferedHeight).isActive = true
        locationButton.widthAnchor.constraint(equalToConstant: LocationButton.preferedWidth).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateContent(city: City) {
        label.text = city.quote
        locationButton.title = "\(city.name ?? ""), \(city.state ?? "")"
        UIView.animate(withDuration: 0.3) {
            self.label.alpha = 1
            self.tgaLabel.alpha = 1
            self.backgroundImageView.alpha = 1
        }
    }
}

class LocationButton: UIButton {
    static let preferedHeight: CGFloat = 35.0
    static let preferedWidth: CGFloat = 190.0
    var title: String? {
        didSet {
            locationLabel.text = title?.uppercased()
            UIView.animate(withDuration: 0.3) {
                self.locationLabel.alpha = 1
                self.locationIcon.alpha = 1
            }
        }
    }
    let locationLabel = UILabel()
    private let locationIcon = UIImageView(image: UIImage(named: "locationIcon"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.16).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 6
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.font = UIFont.inputFieldTitle()
        locationLabel.textColor = UIColor.primaryCTA()
        locationLabel.alpha = 0
        addSubview(locationLabel)
        
        locationIcon.translatesAutoresizingMaskIntoConstraints = false
        locationIcon.contentMode = .center
        locationIcon.alpha = 0
        addSubview(locationIcon)
        
        locationLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -6).isActive = true
        
        locationIcon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        locationIcon.leadingAnchor.constraint(equalTo: locationLabel.trailingAnchor, constant: 7).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
