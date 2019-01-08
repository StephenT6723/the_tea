//
//  EventCollectionHeaderView.swift
//  TheTea
//
//  Created by Stephen Thomas on 3/29/18.
//  Copyright © 2018 The Tea LLC. All rights reserved.
//

import UIKit

enum CollectionSortType: String, CaseIterable {
    case hot = "HOT"
    case name = "NAME"
    case time = "TIME"
    case place = "PLACE"
    
    func sortDecriptors() -> [NSSortDescriptor] {
        var descriptors = [NSSortDescriptor]()
        
        switch self {
        case .hot:
            let hotnessSort = NSSortDescriptor(key: "hotness", ascending: true)
            descriptors.append(hotnessSort)
        case .name:
            let nameSort = NSSortDescriptor(key: "name", ascending: true)
            descriptors.append(nameSort)
        case .time:
            let startTimeSort = NSSortDescriptor(key: "startTime", ascending: true)
            descriptors.append(startTimeSort)
        default:
            let locationSort = NSSortDescriptor(key: "locationName", ascending: true)
            descriptors.append(locationSort)
        }
        
        return descriptors
    }
}

class EventCollectionHeaderView: UITableViewHeaderFooterView {
    let sortLabel = UILabel()
    let sortButton = UIButton()
    var selectedSort = CollectionSortType.hot {
        didSet {
            updateSortString()
        }
    }
    let segmentedControl = SegmentedControl()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.items = ["Hot", "Newest", "Closest"]
        contentView.addSubview(segmentedControl)
        
        segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
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
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.primaryCTA(), NSAttributedString.Key.font: font ] as [NSAttributedString.Key : Any]
        let attrString = NSMutableAttributedString(string: sortString, attributes: attributes)
        attrString.setAttributes([ NSAttributedString.Key.foregroundColor: UIColor.lightCopy(), NSAttributedString.Key.font: font ] as [NSAttributedString.Key : Any], range: NSMakeRange(0, 8))
        
        sortLabel.attributedText = attrString
    }
}
