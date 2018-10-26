//
//  EventRepeatRules.swift
//  TheTea
//
//  Created by Stephen Thomas on 10/26/18.
//  Copyright © 2018 The Tea LLC. All rights reserved.
//

import UIKit

enum DaysOfTheWeek: String {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
    
    func plural() -> String {
        return rawValue + "s"
    }
    
    func abreviation() -> String {
        var abreviation = ""
        
        if self == .monday {
            abreviation = "Mon"
        }
        if self == .tuesday {
            abreviation = "Tue"
        }
        if self == .wednesday {
            abreviation = "Wed"
        }
        if self == .thursday {
            abreviation = "Thurs"
        }
        if self == .friday {
            abreviation = "Fri"
        }
        if self == .saturday {
            abreviation = "Sat"
        }
        if self == .sunday {
            abreviation = "Sun"
        }
        
        return abreviation
    }
}

class EventRepeatRules {
    var repeatsMondays = false
    var repeatsTuesdays = false
    var repeatsWednesdays = false
    var repeatsThursdays = false
    var repeatsFridays = false
    var repeatsSaturdays = false
    var repeatsSundays = false
    private init() {}
    
    convenience init(repeatsMondays: Bool, repeatsTuesdays: Bool, repeatsWednesdays: Bool, repeatsThursdays: Bool, repeatsFridays: Bool, repeatsSaturdays: Bool, repeatsSundays: Bool) {
        self.init()
        
        self.repeatsMondays = repeatsMondays
        self.repeatsTuesdays = repeatsTuesdays
        self.repeatsWednesdays = repeatsWednesdays
        self.repeatsThursdays = repeatsThursdays
        self.repeatsFridays = repeatsFridays
        self.repeatsSaturdays = repeatsSaturdays
        self.repeatsSundays = repeatsSundays
    }
    
    func repeatingDays() -> [DaysOfTheWeek] {
        var days = [DaysOfTheWeek]()
        if repeatsMondays {
            days.append(.monday)
        }
        if repeatsTuesdays {
            days.append(.tuesday)
        }
        if repeatsWednesdays {
            days.append(.wednesday)
        }
        if repeatsThursdays {
            days.append(.thursday)
        }
        if repeatsFridays {
            days.append(.friday)
        }
        if repeatsSaturdays {
            days.append(.saturday)
        }
        if repeatsSundays {
            days.append(.sunday)
        }
        
        return days
    }
    
    func rules() -> String {
        var rules = ""
        let repeatingDays = self.repeatingDays()
        
        if repeatingDays.count == 0 {
            rules = "NEVER"
        } else if repeatingDays.count == 1 {
            rules = repeatingDays[0].plural().uppercased()
        } else if repeatingDays.count == 2 {
            rules = repeatingDays[0].plural().uppercased() + " and " + repeatingDays[1].plural().uppercased()
        } else {
            for index in 0 ..< repeatingDays.count {
                let weekday = repeatingDays[index]
                if index > 0 {
                    rules += ", "
                }
                rules += weekday.abreviation().uppercased()
            }
        }
        
        if Set(repeatingDays) == Set([.monday, .tuesday, .wednesday, .thursday, .friday]) {
            rules = "WEEKDAYS"
        }
        
        if repeatingDays.count == 7 {
            rules = "EVERYDAY"
        }
        
        return rules
    }
}
