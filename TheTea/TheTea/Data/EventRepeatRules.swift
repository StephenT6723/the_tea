//
//  EventRepeatRules.swift
//  TheTea
//
//  Created by Stephen Thomas on 10/26/18.
//  Copyright © 2018 The Tea LLC. All rights reserved.
//

import UIKit

enum DaysOfTheWeek: String, CaseIterable {
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
    
    convenience init(dataString: String) {
        self.init()
        if dataString.count != 7 {
            return
        }
        let charArray = Array(dataString)
        for i in 0..<charArray.count {
            if i == 0 {
                self.repeatsMondays = charArray[i] == "1"
            }
            if i == 1 {
                self.repeatsTuesdays = charArray[i] == "1"
            }
            if i == 2 {
                self.repeatsWednesdays = charArray[i] == "1"
            }
            if i == 3 {
                self.repeatsThursdays = charArray[i] == "1"
            }
            if i == 4 {
                self.repeatsFridays = charArray[i] == "1"
            }
            if i == 5 {
                self.repeatsSaturdays = charArray[i] == "1"
            }
            if i == 6 {
                self.repeatsSundays = charArray[i] == "1"
            }
        }
    }
    
    func toggleDay(day:DaysOfTheWeek) {
        switch day {
        case .monday:
            repeatsMondays = !repeatsMondays
        case .tuesday:
            repeatsTuesdays = !repeatsTuesdays
        case .wednesday:
            repeatsWednesdays = !repeatsWednesdays
        case .thursday:
            repeatsThursdays = !repeatsThursdays
        case .friday:
            repeatsFridays = !repeatsFridays
        case .saturday:
            repeatsSaturdays = !repeatsSaturdays
        default:
            repeatsSundays = !repeatsSundays
        }
    }
    
    func neverRepeat() {
        repeatsMondays = false
        repeatsTuesdays = false
        repeatsWednesdays = false
        repeatsThursdays = false
        repeatsFridays = false
        repeatsSaturdays = false
        repeatsSundays = false
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
    
    func rules(abreviated: Bool) -> String {
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
                rules += abreviated ? weekday.abreviation().uppercased() : weekday.plural().uppercased()
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
    
    func dataString() -> String {
        return (repeatsMondays ? "1" : "0") + (repeatsTuesdays ? "1" : "0") + (repeatsWednesdays ? "1" : "0") + (repeatsThursdays ? "1" : "0") + (repeatsFridays ? "1" : "0") + (repeatsSaturdays ? "1" : "0") + (repeatsSundays ? "1" : "0")
    }
}
