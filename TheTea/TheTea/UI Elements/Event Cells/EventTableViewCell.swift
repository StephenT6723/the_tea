//
//  EventTableViewCell.swift
//  TheTea
//
//  Created by Stephen Thomas on 1/8/19.
//  Copyright © 2019 The Tea LLC. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    static let preferedHeight: CGFloat = 412.0
    let eventView = EventView(frame: CGRect())

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.backgroundColor = .white
        
        eventView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(eventView)
        
        eventView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        eventView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        eventView.heightAnchor.constraint(equalToConstant: EventTableViewCell.preferedHeight).isActive = true
        eventView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14).isActive = true
        eventView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
