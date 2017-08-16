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
    func updateWithData(data: [String: AnyObject]) {
        if let newName = data["name"] as? String {
            name = newName
        }
        
        if let newStartTime = data["startTime"] as? Date {
            startTime = newStartTime as NSDate
        }
        
        if let newEndTime = data["endTime"] as? Date {
            endTime = newEndTime as NSDate
        }
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
