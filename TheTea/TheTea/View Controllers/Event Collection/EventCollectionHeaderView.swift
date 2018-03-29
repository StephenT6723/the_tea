//
//  EventCollectionHeaderView.swift
//  TheTea
//
//  Created by Stephen Thomas on 3/29/18.
//  Copyright © 2018 The Tea LLC. All rights reserved.
//

import UIKit

enum CollectionSortType: String {
    case hot = "HOT"
    case new = "NEW"
    case upcoming = "UPCOMING"
}

class EventCollectionHeaderView: UITableViewHeaderFooterView {
    let sortLabel = UILabel()
    let sortButton = UIButton()
    var selectedSort = CollectionSortType.hot {
        didSet {
            updateSortString()
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.lightBackground()
        
        sortLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sortLabel)
        
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sortButton)
        
        sortLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17.0).isActive = true
        sortLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        sortLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        sortButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        sortButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        sortButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        sortButton.widthAnchor.constraint(equalToConstant: 117).isActive = true
        
        updateSortString()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateSortString() {
        let sortString = "SORT BY: \(selectedSort.rawValue)"
        guard let font = UIFont.cta() else {
            sortLabel.text = ""
            return
        }
        let attributes = [ NSAttributedStringKey.foregroundColor: UIColor.primaryCTA(), NSAttributedStringKey.font: font ] as [NSAttributedStringKey : Any]
        let attrString = NSMutableAttributedString(string: sortString, attributes: attributes)
        attrString.setAttributes([ NSAttributedStringKey.foregroundColor: UIColor.lightCopy(), NSAttributedStringKey.font: font ] as [NSAttributedStringKey : Any], range: NSMakeRange(0, 8))
        
        sortLabel.attributedText = attrString
    }
}
