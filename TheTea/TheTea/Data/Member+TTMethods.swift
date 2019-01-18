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
                if let event = EventManager.updateLocalEvent(from: eventData) {
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
    
    func hotFavorites() -> [Event] {
        guard let favorites = self.favorites else {
            return [Event]()
        }
        guard let favoritesArray = Array(favorites) as? [Event] else {
            return [Event]()
        }
        
        return favoritesArray.sorted(by: { $0.hotness > $1.hotness })
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
