//
//  EventCollectionHeaderView.swift
//  TheTea
//
//  Created by Stephen Thomas on 3/29/18.
//  Copyright © 2018 The Tea LLC. All rights reserved.
//

import UIKit

enum CollectionSortType: String, CaseIterable {
    case hot = "Hot"
    case time = "Now"
    case new = "New"
    
    func sortDecriptors() -> [NSSortDescriptor] {
        var descriptors = [NSSortDescriptor]()
        
        switch self {
        case .hot:
            let hotnessSort = NSSortDescriptor(key: "hotness", ascending: false)
            descriptors.append(hotnessSort)
        case .time:
            let startTimeSort = NSSortDescriptor(key: "startTime", ascending: true)
            descriptors.append(startTimeSort)
        default:
            let locationSort = NSSortDescriptor(key: "dateCreated", ascending: true)
            descriptors.append(locationSort)
        }
        
        return descriptors
    }
}

class EventCollectionHeaderView: UITableViewHeaderFooterView {
    var selectedSort: CollectionSortType {
        get {
            let cases = CollectionSortType.allCases
            return cases[segmentedControl.selectedIndex]
        } set {
            let cases = CollectionSortType.allCases
            segmentedControl.selectedIndex = cases.firstIndex(of: newValue) ?? 0
        }
    }
    let segmentedControl = SegmentedControl()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        var items = [String]()
        for sortType in CollectionSortType.allCases {
            items.append(sortType.rawValue)
        }
        segmentedControl.items = items
        contentView.addSubview(segmentedControl)
        
        segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
