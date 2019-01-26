//
//  Event+CoreDataProperties.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/11/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import Foundation
import CoreData

extension Event {
    static let nameKey = "name"
    static let hotnessKey = "hotness"
    static let gayIDKey = "gayID"
    static let dateCreatedKey = "dateCreated"
    static let startTimeKey = "startTime"
    static let endTimeKey = "endTime"
    static let aboutKey = "about"
    static let locationNameKey = "locationName"
    static let addressKey = "address"
    static let latitudeKey = "latitude"
    static let longitudeKey = "longitude"
    static let priceKey = "price"
    static let ticketURLKey = "ticketURL"
    static let canceledKey = "canceled"
    static let publishedKey = "published"
    static let hostsKey = "hosts"
    static let repeatsKey = "repeats"
    static let repeatingEventIdKey = "repeatingEventId"
    static let imageURLKey = "imageURL"
    
    func update(name: String, hosts: [Member], hotness: Int32?, dateCreated: Date, startTime: Date, endTime: Date?, about: String?, location: EventLocation?, price: Double?, ticketURL: String?, canceled: Bool, published: Bool, repeats: String, repeatingEventId: String, imageURL: String?) {
        self.name = name
        self.removeFromHosts(self.hosts ?? NSSet())
        self.addToHosts(NSSet(array: hosts))
        self.hotness = hotness ?? 0
        self.dateCreated = dateCreated
        self.startTime = startTime
        self.endTime = endTime
        self.about = about
        self.locationName = location?.locationName
        self.address = location?.address
        self.price = price ?? 0
        self.ticketURL = ticketURL ?? ""
        if let latitude = location?.latitude, let longitude = location?.longitude {
            self.latitude = latitude
            self.longitude = longitude
        } else {
            self.latitude = 0
            self.longitude = 0
        }
        self.daySectionIdentifier = DateStringHelper.dataString(from: startTime)
        self.canceled = canceled
        self.published = published
        self.imageURL = imageURL
        let repeatRules = EventRepeatRules(dataString: repeats)
        self.repeatingEventId = repeatingEventId
        self.updateWithRules(rules: repeatRules)
    }
    
    func updateWithRules(rules: EventRepeatRules) {
        self.repeatsMondays = rules.repeatsMondays
        self.repeatsTuesdays = rules.repeatsTuesdays
        self.repeatsWednesdays = rules.repeatsWednesdays
        self.repeatsThursdays = rules.repeatsThursdays
        self.repeatsFridays = rules.repeatsFridays
        self.repeatsSaturdays = rules.repeatsSaturdays
        self.repeatsSundays = rules.repeatsSundays
    }
    
    func eventLocation() -> EventLocation? {
        if let locationName = self.locationName, let address = self.address {
            if self.latitude != 0 && self.longitude != 0 {
                return EventLocation(locationName: locationName, address: address, latitude: latitude, longitude: longitude)
            }
        }
        return nil
    }
    
    func repeatRules() -> EventRepeatRules {
        let rules = EventRepeatRules(repeatsMondays: repeatsMondays, repeatsTuesdays: repeatsTuesdays, repeatsWednesdays: repeatsWednesdays, repeatsThursdays: repeatsThursdays, repeatsFridays: repeatsFridays, repeatsSaturdays: repeatsSaturdays, repeatsSundays: repeatsSundays)
        return rules
    }
    
    func favorited() -> Bool {
        guard let currentMember = MemberDataManager.loggedInMember() else {
            return false
        }
        return currentMember.favorites?.contains(self) ?? false
    }
    
    func fullImageURL() -> String? {
        if imageURL?.count ?? 0 <= 0 {
            return nil
        }
        return TGAServer.domain + "/\(imageURL ?? "")"
    }
    
    func sortedHosts() -> [Member] {
        guard let hosts = self.hosts else {
            return [Member]()
        }
        
        guard let hostsArray = Array(hosts) as? [Member] else {
            return [Member]()
        }
        
        return hostsArray.sorted(by: { (first, second) -> Bool in
            guard let firstName = first.name, let secondName = second.name else {
                return false
            }
            return firstName > secondName
        })
    }
    
    func subtitle() -> String? {
        if canceled {
            return "CANCELED"
        }
        
        if !published {
            return "PENDING"
        }
        return nil
    }
}
