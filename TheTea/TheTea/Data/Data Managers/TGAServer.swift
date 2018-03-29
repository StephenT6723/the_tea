//
//  TGAServer.swift
//  TheTea
//
//  Created by Stephen Thomas on 10/9/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

class TGAServer {
    class func authenticateMember(facebookUserID: String, name: String) -> [String: AnyObject] {
        var memberData = [String: AnyObject]()
        memberData[Member.nameKey] = name as AnyObject
        memberData[Member.tgaIDKey] = "12345" as AnyObject
        memberData[Member.facebookIDKey] = facebookUserID as AnyObject
        memberData[Member.likeToFBKey] = false as AnyObject
        memberData[Member.instagramKey] = "" as AnyObject
        memberData[Member.twitterKey] = "" as AnyObject
        memberData[Member.aboutKey] = "" as AnyObject
        return memberData
    }
    
    class func fetchEvents() -> [[String: String]] {
        var allEvents = [[String: String]]()
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "test_events", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        if let dict = myDict {
            if let eventsData = dict as? [String:[[String:String]]] {
                var currentWeekday = ""
                var currentDay = Date()
                let weekdayFormatter = DateFormatter()
                weekdayFormatter.dateFormat = "EEEE"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy h:mm a"
                
                for _ in 1...7 {
                    currentWeekday = weekdayFormatter.string(from: currentDay)
                    
                    if let todaysData = eventsData[currentWeekday] {
                        for eventData in todaysData {
                            var updatedEventData = [String: String]()
                            updatedEventData[Event.nameKey] = eventData[Event.nameKey]
                            updatedEventData[Event.gayIDKey] = eventData[Event.gayIDKey]
                            updatedEventData[Event.hotnessKey] = "\(Int32(arc4random_uniform(1000)))"
                            if let startTimeString = eventData[Event.startTimeKey] {
                                let updatedStartTime = date(from: startTimeString, date: currentDay)
                                let updatedStartTimeString = dateFormatter.string(from: updatedStartTime!)
                                updatedEventData[Event.startTimeKey] = updatedStartTimeString
                            }
                            if let endTimeString = eventData[Event.endTimeKey] {
                                let updatedEndTime = date(from: endTimeString, date: currentDay)
                                let updatedEndTimeString = dateFormatter.string(from: updatedEndTime!)
                                updatedEventData[Event.endTimeKey] = updatedEndTimeString
                            }
                            updatedEventData[Event.aboutKey] = eventData[Event.aboutKey]
                            updatedEventData[Event.locationNameKey] = eventData[Event.locationNameKey]
                            updatedEventData[Event.addressKey] = eventData[Event.addressKey]
                            updatedEventData[Event.latitudeKey] = eventData[Event.latitudeKey]
                            updatedEventData[Event.longitudeKey] = eventData[Event.longitudeKey]
                            allEvents.append(updatedEventData)
                        }
                    }
                    
                    if let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: currentDay) {
                        currentDay = nextDay
                    } else {
                        break
                    }
                }
            }
        }
        return allEvents
    }
    
    class func date(from time: String, date: Date) -> Date? {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let calendar = Calendar.current
        
        if let timeDate = timeFormatter.date(from: time) {
            var timeComponents = calendar.dateComponents([.hour, .minute], from: timeDate)
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
            timeComponents.year = dateComponents.year
            timeComponents.month = dateComponents.month
            timeComponents.day = dateComponents.day
            
            return calendar.date(from: timeComponents)
        }
        
        return nil
    }
}
