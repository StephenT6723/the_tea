//
//  EventListHeaderView.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/24/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

class EventListHeaderView: UITableViewHeaderFooterView {
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let seeAllButton = UIButton()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.headerOne()
        titleLabel.textColor = UIColor.primaryCopy()
        contentView.addSubview(titleLabel)
        
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.font = UIFont.listSubTitle()
        subTitleLabel.textColor = UIColor.primaryCopy()
        contentView.addSubview(subTitleLabel)
        
        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        seeAllButton.setTitle("See All", for: .normal)
        seeAllButton.setTitleColor(UIColor.primaryCTA(), for: .normal)
        seeAllButton.titleLabel?.font = UIFont.cta()
        contentView.addSubview(seeAllButton)
        
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
        
        subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10.0).isActive = true
        subTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7).isActive = true
        
        seeAllButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17.0).isActive = true
        seeAllButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        seeAllButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
