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
    static let startTimeKey = "startTime"
    static let endTimeKey = "endTime"
    static let aboutKey = "about"
    static let locationNameKey = "locationName"
    static let addressKey = "address"
    static let latitudeKey = "latitude"
    static let longitudeKey = "longitude"
    
    func update(name: String, startTime: Date, endTime: Date?, about: String?, location: EventLocation?) {
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.about = about
        self.locationName = location?.locationName
        self.address = location?.address
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
}
