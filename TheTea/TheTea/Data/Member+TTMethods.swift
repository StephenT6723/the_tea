//
//  Member+TTMethods.swift
//  TheTea
//
//  Created by Stephen Thomas on 9/18/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import Foundation
import CoreData


extension Member {
    func updateWithData(data: [String: AnyObject]) {
        
    }
    
    func canEditEvent(event: Event) -> Bool {
        return true
    }
    
    func hostedEvents() -> [Event] {
        return [Event]()
    }
    
    func upcomingHostedEvents() -> EventList {
        let todayString = DateStringHelper.dataString(from: Date())
        let predicate = NSPredicate(format: "daySectionIdentifier >= %@", todayString)
        let startTimeSort = NSSortDescriptor(key: "startTime", ascending: true)
        
        let eventList = EventList(title: "\(String(describing: self.name)) Upcoming Hosted Events", subtitle: "", predicate: predicate, sortDescriptors: [startTimeSort], delegate: nil)
        return eventList
    }
    
    func pastHostedEvents() -> [Event] {
        let request = NSFetchRequest<Event>(entityName:"Event")
        let todayString = DateStringHelper.dataString(from: Date())
        let predicate = NSPredicate(format: "daySectionIdentifier < %@", todayString)
        request.predicate = predicate
        let startTimeSort = NSSortDescriptor(key: "startTime", ascending: true)
        request.sortDescriptors = [startTimeSort]
        
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        do {
            let events = try context.fetch(request)
            return events
        } catch {
            return [Event]()
        }
    }
}
