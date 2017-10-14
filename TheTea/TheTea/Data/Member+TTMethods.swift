//
//  Member+TTMethods.swift
//  TheTea
//
//  Created by Stephen Thomas on 9/18/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import Foundation
import CoreData


extension Member {
    static let nameKey = "name"
    static let tgaIDKey = "tgaID"
    static let likeToFBKey = "linkToFacebook"
    static let facebookIDKey = "facebookID"
    static let instagramKey = "instagram"
    static let twitterKey = "twitter"
    static let aboutKey = "about"
    
    func updateWithData(data: [String: AnyObject]) {
        var name = ""
        if let dataName = data[Member.nameKey] as? String {
            name = dataName
        }
        self.name = name
        
        if let linkToFB = data[Member.likeToFBKey] as? Bool {
            self.linkToFacebook = linkToFB
        } else {
            self.linkToFacebook = false
        }
        
        if let fbID = data[Member.facebookIDKey] as? String {
            self.facebookID = fbID
        }
        
        self.instagram = data[Member.instagramKey] as? String
        self.twitter = data[Member.twitterKey] as? String
        self.about = data[Member.aboutKey] as? String
    }
    
    func canEditEvent(event: Event) -> Bool {
        return true
    }
    
    func hostedEvents() -> EventList {
        let startTimeSort = NSSortDescriptor(key: "startTime", ascending: true)
        
        let eventList = EventList(title: "\(String(describing: self.name)) Hosted Events", subtitle: "", predicate: nil, sortDescriptors: [startTimeSort], delegate: nil)
        return eventList
    }
    
    func upcomingHostedEvents() -> EventList {
        let todayString = DateStringHelper.dataString(from: Date())
        let predicate = NSPredicate(format: "daySectionIdentifier >= %@", todayString)
        let startTimeSort = NSSortDescriptor(key: "startTime", ascending: true)
        
        let eventList = EventList(title: "\(String(describing: self.name)) Upcoming Hosted Events", subtitle: "", predicate: predicate, sortDescriptors: [startTimeSort], delegate: nil)
        return eventList
    }
    
    func pastHostedEvents() -> EventList {
        let todayString = DateStringHelper.dataString(from: Date())
        let predicate = NSPredicate(format: "daySectionIdentifier < %@", todayString)
        let startTimeSort = NSSortDescriptor(key: "startTime", ascending: true)
        
        let eventList = EventList(title: "\(String(describing: self.name)) Past Hosted Events", subtitle: "", predicate: predicate, sortDescriptors: [startTimeSort], delegate: nil)
        return eventList
    }
}
