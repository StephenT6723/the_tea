//
//  EventLocation.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/16/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

class EventLocation {
    var locationName = ""
    var address = ""
    var latitude = 0.0
    var longitude = 0.0
    private init() {}
    
    convenience init(locationName: String, address: String, latitude: Double, longitude: Double) {
        self.init()
        self.locationName = locationName
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
}

func == (firstEvent: EventLocation, secondEvent: EventLocation) -> Bool {
    return firstEvent.locationName == secondEvent.locationName && firstEvent.address == secondEvent.address && firstEvent.latitude == secondEvent.latitude && firstEvent.longitude == secondEvent.longitude
}

func != (firstEvent: EventLocation, secondEvent: EventLocation) -> Bool {
    return !(firstEvent == secondEvent)
}
