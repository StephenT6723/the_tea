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
    static let tgaIDKey = "tgaID"
    static let nameKey = "name"
    static let emailKey = "email"
    static let facebookIDKey = "facebookID"
    static let instagramKey = "instagram"
    static let twitterKey = "twitter"
    static let aboutKey = "about"
    static let favoritesKey = "favoriteEvents"
    
    func updateWithData(data: [String: Any]) {
        self.email = data[Member.emailKey] as? String ?? nil
        self.name = data[Member.nameKey] as? String ?? nil
        self.facebookID = data[Member.facebookIDKey] as? String ?? nil
        self.instagram = data[Member.instagramKey] as? String ?? nil
        self.twitter = data[Member.twitterKey] as? String ?? nil
        self.about = data[Member.aboutKey] as? String ?? nil
        
        self.removeFromFavorites(self.favorites ?? NSSet())
        if let favoritesData = data[Member.favoritesKey] as? [[String: Any]] {
            for eventData in favoritesData {
                if let event = EventManager.updateLocalEvent(from: eventData, overrideImages: false, overrideHosts: false, overrideHotness: false) {
                    addToFavorites(event)
                }
            }
        }
    }
    
    func canEditEvent(event: Event) -> Bool {
        return hosting?.contains(event) ?? false
    }
    
    class func createToken(email: String, password: String) -> String {
        let tokenString = "\(email):\(password)"
        return Data(tokenString.utf8).base64EncodedString()
    }
    
    func chronologicalFavorites() -> [Event] {
        guard let favorites = self.favorites else {
            return [Event]()
        }
        guard let favoritesArray = Array(favorites) as? [Event] else {
            return [Event]()
        }
        
        let timeSortedFavorites = favoritesArray.sorted(by: { $0.startTime ?? Date() < $1.startTime ?? Date() }) //Sorting by time so that the instance of each event we get is the closest one to now. The ones way in the future will not have images.
        
        var repeatIDs = [String]()
        var uniqueEvents = [Event]()
        for event in timeSortedFavorites {
            if !repeatIDs.contains(event.repeatingEventId ?? "") {
                repeatIDs.append(event.repeatingEventId ?? "")
                uniqueEvents.append(event)
            }
        }
        
        return uniqueEvents
    }
    
    func hotHosting() -> [Event] {
        guard let hosting = self.hosting else {
            return [Event]()
        }
        guard let hostingArray = Array(hosting) as? [Event] else {
            return [Event]()
        }
        
        return hostingArray.sorted(by: { $0.hotness > $1.hotness })
    }
}
