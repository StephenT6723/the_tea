//
//  EventManager.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/11/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit
import CoreData

class EventManager: NSObject {
    class func allFutureEvents() -> NSFetchedResultsController<Event> {
        let request = NSFetchRequest<Event>(entityName:"Event")
        let todayString = DateStringHelper.dataString(from: Date())
        let predicate = NSPredicate(format: "daySectionIdentifier >= %@", todayString)
        request.predicate = predicate
        let startTimeSort = NSSortDescriptor(key: "startTime", ascending: true)
        request.sortDescriptors = [startTimeSort]
        
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let eventsFRC = NSFetchedResultsController<Event>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "daySectionIdentifier", cacheName: nil)
        
        do {
            try eventsFRC.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        return eventsFRC
    }
    
    class func createEvent(name: String, startTime: Date, endTime: Date?, about: String?, location: EventLocation?) {
        if self.event(name: name) != nil {
            return
        }
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let event = Event(context: context)
        event.update(name: name, startTime: startTime, endTime: endTime, about: about, location: location)
        CoreDataManager.sharedInstance.saveContext()
    }
    
    class func updateEvent(event: Event, name: String, startTime: Date, endTime: Date?, about: String?, location: EventLocation?) {
        event.update(name: name, startTime: startTime, endTime: endTime, about: about, location: location)
        CoreDataManager.sharedInstance.saveContext()
    }
    
    class func delete(event:Event) {
        CoreDataManager.sharedInstance.persistentContainer.viewContext.delete(event)
        CoreDataManager.sharedInstance.saveContext()
    }
    
    class func event(name: String) -> Event? {
        let request = NSFetchRequest<Event>(entityName:"Event")
        request.predicate = NSPredicate(format: "name like %@", name)
        
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        do {
            let events = try context.fetch(request)
            if events.count > 0 {
                return events[0]
            }
        } catch {
            return nil
        }
        
        return nil
    }
}
