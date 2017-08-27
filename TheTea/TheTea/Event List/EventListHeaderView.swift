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
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.primaryBrand()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "TODAY"
        titleLabel.font = UIFont.headerOne()
        titleLabel.textColor = .white
        contentView.addSubview(titleLabel)
        
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.text = "Thursday Aug, 24th"
        subTitleLabel.font = UIFont.listSubTitle()
        subTitleLabel.textColor = UIColor.lightBrandCopy()
        contentView.addSubview(subTitleLabel)
        
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10.0).isActive = true
        subTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
