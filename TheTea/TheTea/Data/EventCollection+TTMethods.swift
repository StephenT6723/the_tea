//
//  EventCollection+TTMethods.swift
//  TheTea
//
//  Created by Stephen Thomas on 4/3/18.
//  Copyright © 2018 The Tea LLC. All rights reserved.
//

import UIKit
import CoreData

extension EventCollection {
    static let titleKey = "title"
    static let subtitleKey = "subtitle"
    static let gayIDKey = "gayID"
    static let sortIndexKey = "sortIndex"
    static let imageURLKey = "imageURL"
    static let eventKey = "events"
    static let aboutKey = "about"
    static let featuredKey = "featured"
    
    func update(title: String, subtitle: String?, sortIndex: Int16?, imageURL: String?, about: String?, featured: Bool) {
        self.title = title
        self.subtitle = subtitle
        if let sortIndex = sortIndex {
            self.sortIndex = sortIndex
        }
        self.imageURL = imageURL
        self.about = about
        self.featured = featured
    }
    
    func update(events: [[String: String]]) {
        if let allEvents = self.events {
            removeFromEvents(allEvents)
        }
        
        for eventData in events {
            if let event = EventManager.updateLocalEvent(from: eventData) {
                addToEvents(event)
            }
        }
    }
    
    class func placeholderImage(for index: Int) -> UIImage? {
        return UIImage(named: "collectionPlaceholder\(index)")
    }
}
