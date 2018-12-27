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
    
    func update(name: String, hosts: [Member], hotness: Int32?, startTime: Date, endTime: Date?, about: String?, location: EventLocation?, price: Double?, ticketURL: String?, canceled: Bool, published: Bool) {
        if hosts.count == 0 {
            print("UNABLE TO UPDATE EVENT WITH NO HOSTS")
            return
        }        
        self.name = name
        self.removeFromHosts(self.hosts ?? NSSet())
        self.addToHosts(NSSet(array: hosts))
        self.hotness = hotness ?? 0
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
}
