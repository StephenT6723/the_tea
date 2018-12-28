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
    
    func updateWithData(data: [String: String]) {
        self.email = data[Member.emailKey]
        self.name = data[Member.nameKey]
        self.facebookID = data[Member.facebookIDKey]
        self.instagram = data[Member.instagramKey]
        self.twitter = data[Member.twitterKey]
        self.about = data[Member.aboutKey]
    }
    
    func canEditEvent(event: Event) -> Bool {
        return event.creatorTGAID == tgaID
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
}
