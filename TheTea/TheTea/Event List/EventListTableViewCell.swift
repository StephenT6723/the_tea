//
//  EventListTableViewCell.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/11/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

class EventListTableViewCell: UITableViewCell {
    let customContentView = UIView()
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.backgroundColor = UIColor.primaryBrand()
        
        customContentView.translatesAutoresizingMaskIntoConstraints = false
        customContentView.backgroundColor = .white
        customContentView.layer.cornerRadius = 6
        contentView.addSubview(customContentView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.headerOne()
        titleLabel.textColor = UIColor.primaryCopy()
        titleLabel.numberOfLines = 0
        customContentView.addSubview(titleLabel)
        
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.font = UIFont.body()
        subTitleLabel.textColor = UIColor.lightCopy()
        subTitleLabel.numberOfLines = 0
        customContentView.addSubview(subTitleLabel)
        
        customContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        customContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        customContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        customContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: customContentView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: -20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: customContentView.topAnchor, constant: 14).isActive = true
        
        subTitleLabel.leadingAnchor.constraint(equalTo: customContentView.leadingAnchor, constant: 20).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: customContentView.trailingAnchor, constant: -20).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
        subTitleLabel.bottomAnchor.constraint(equalTo: customContentView.bottomAnchor, constant: -14).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func subTitle(for event: Event, timeFormatter: DateFormatter) -> String {
        if let startTime = event.startTime {
            var subtitle = timeFormatter.string(from: startTime as Date)
            if let locationName = event.locationName {
                subtitle += " | "
                subtitle += locationName
            }
            return subtitle
        }
        return ""
    }
}
