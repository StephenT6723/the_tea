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
        
        let todayData = dataString(from: Date())
        guard let todaysDate = self.date(from: todayData) else {
            return ""
        }
        
        let diff = Calendar.current.dateComponents([Calendar.Component.day], from: todaysDate, to: date)
        if diff.day == 0 {
            return "Today"
        } else if diff.day == -1 {
            return "Yesterday"
        }  else if diff.day == 1 {
            return "Tomorrow"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        return dateFormatter.string(from:date)
    }
    
    class func fullDescription(of date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        let timeString = dateFormatter.string(from: date)
        
        return "\(dayDescription(of:date)) - \(timeString == "11:59 PM" ? "Midnight" : timeString)"
    }
    
    class func dataString(from date:Date) -> String {
        let currentCalendar = Calendar.current
        
        let day = currentCalendar.component(.day, from: date)
        let month = currentCalendar.component(.month, from: date)
        let year = currentCalendar.component(.year, from: date)
        
        return "\(year * 10000 + month * 100 + day)"
    }
    
    class func date(from dataString: String) -> Date? {
        if let numericSection = Int(dataString) {
            // Parse the numericSection into its year/month/day components.
            let year = numericSection / 10000
            let month = (numericSection / 100) % 100
            let day = numericSection % 100
            
            // Reconstruct the date from these components.
            var components = DateComponents()
            components.calendar = Calendar.current
            components.day = day
            components.month = month
            components.year = year
            
            return components.date
        }
        return nil
    }
}
