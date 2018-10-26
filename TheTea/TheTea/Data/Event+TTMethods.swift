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
    
    func update(name: String, hotness: Int32?, startTime: Date, endTime: Date?, about: String?, location: EventLocation?, price: Double?, ticketURL: String?) {
        self.name = name
        if let hotness = hotness {
            self.hotness = hotness
        }
        self.startTime = startTime
        self.endTime = endTime
        self.about = about
        self.locationName = location?.locationName
        self.address = location?.address
        if let price = price {
            self.price = price
        }
        if let ticketURL = ticketURL {
            self.ticketURL = ticketURL
        }
        if let latitude = location?.latitude, let longitude = location?.longitude {
            self.latitude = latitude
            self.longitude = longitude
        } else {
            self.latitude = 0
            self.longitude = 0
        }
        self.daySectionIdentifier = DateStringHelper.dataString(from: startTime)
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
