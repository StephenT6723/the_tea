//
//  EventListTableViewCell.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/11/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

class EventCarouselTableViewCell: UITableViewCell {
    static let preferedHeight: CGFloat = 412.0
    let carousel = Carousel(frame: CGRect(x:0, y:0, width:300, height: EventCarouselTableViewCell.preferedHeight))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.backgroundColor = .white
        
        carousel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(carousel)
        
        carousel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        carousel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        carousel.heightAnchor.constraint(equalToConstant: EventCarouselTableViewCell.preferedHeight).isActive = true
        carousel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        carousel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
