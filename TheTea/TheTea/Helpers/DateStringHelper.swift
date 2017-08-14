//
//  DateStringHelper.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/13/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

class DateStringHelper {
    class func dayDescription(of date:Date) -> String {
        let weekDayFormatter = DateFormatter()
        weekDayFormatter.dateFormat = "EEEE"
        
        let diff = Calendar.current.dateComponents([Calendar.Component.day], from: Date(), to: date)
        if diff.day == 0 {
            return "Today"
        } else if diff.day == -1 {
            return "Yesterday"
        }  else if diff.day == 1 {
            return "Tomorrow"
        } /*else if diff.day! > -7 && diff.day! < 0 {
            return "Last \(weekDayFormatter.string(from: date))"
        } else if diff.day! < 7 && diff.day! > 0 {
            return "Next \(weekDayFormatter.string(from: date))"
        } */
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        return dateFormatter.string(from:date)
    }
    
    class func fullDescription(of date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        return "\(dayDescription(of:date)) at \(dateFormatter.string(from:date))"
    }
}
