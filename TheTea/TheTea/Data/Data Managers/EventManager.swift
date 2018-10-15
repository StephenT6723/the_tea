//
//  EventManager.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/11/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit
import CoreData

class EventManager {
    static let daysPerFetch = 7
    
    //MARK: Fetches
    
    class func allFutureEvents() -> NSFetchedResultsController<Event> {
        let request = NSFetchRequest<Event>(entityName:"Event")
        let todayString = DateStringHelper.dataString(from: Date())
        let predicate = NSPredicate(format: "daySectionIdentifier >= %@", todayString)
        request.predicate = predicate
        let startTimeSort = NSSortDescriptor(key: "startTime", ascending: true)
        request.sortDescriptors = [startTimeSort]
        
        let context = CoreDataManager.sharedInstance.viewContext()
        let eventsFRC = NSFetchedResultsController<Event>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "daySectionIdentifier", cacheName: nil)
        
        do {
            try eventsFRC.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        return eventsFRC
    }
    
    class func events(with sectionIdentifier: String) -> NSFetchedResultsController<Event> {
        let request = NSFetchRequest<Event>(entityName:"Event")
        let predicate = NSPredicate(format: "daySectionIdentifier == %@", sectionIdentifier)
        request.predicate = predicate
        let startTimeSort = NSSortDescriptor(key: "startTime", ascending: true)
        request.sortDescriptors = [startTimeSort]
        
        let context = CoreDataManager.sharedInstance.viewContext()
        let eventsFRC = NSFetchedResultsController<Event>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "daySectionIdentifier", cacheName: nil)
        
        do {
            try eventsFRC.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        return eventsFRC
    }
    
    class func event(gayID: String) -> Event? {
        let request = NSFetchRequest<Event>(entityName:"Event")
        request.predicate = NSPredicate(format: "gayID like %@", gayID)
        
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
    
    //MARK: Fetch
    
    class func updateUpcomingEvents() {
        TGAServer.fetchEvents(onSuccess: { (data) in
            self.updateLocalEvents(from: data)
        }) { (error) in
            if let error = error {
                print("EVENT FETCH FAILED: \(error.localizedDescription)")
            }
            //TODO: Post notification
        }
    }
    
    //MARK: Local Data Updates
    
    private class func updateLocalEvents(from data: [[String: String]]) {
        for eventDict in data {
            let _ = updateLocalEvent(from: eventDict)
        }
        CoreDataManager.sharedInstance.saveContext()
    }
    
    private class func updateLocalEvent(from data: [String: String]) -> Event? {
        guard let gayID = data[Event.gayIDKey]  else {
            print("TRIED TO UPDATE EVENT WITHOUT GAYID")
            return nil
        }
        
        //TODO: Check last updated to prevent rapidly updating over and over?
        
        //find or create event object
        let event = self.event(gayID: gayID) ?? createLocalEvent(gayID: gayID)
        
        //parse data
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        
        guard let name = data[Event.nameKey], let startTimeString = data[Event.startTimeKey] else {
            print("TRIED TO CREATE EVENT WITHOUT REQUIRED DATA")
            return nil
        }
        
        guard let startTime = dateFormatter.date(from: startTimeString) else {
            print("UNABLE TO PARSE START TIME: \(startTimeString)")
            return nil
        }
        
        var location: EventLocation?
        
        if let locationName = data[Event.locationNameKey], let address = data[Event.addressKey], let latitudeString = data[Event.latitudeKey], let longitudeString = data[Event.longitudeKey] {
            if let latitude = Double(latitudeString), let longitude = Double(longitudeString) {
                if latitude != 0 && longitude != 0 {
                    location = EventLocation(locationName: locationName, address: address, latitude: latitude, longitude: longitude)
                }
            }
        }
        
        let endTimeString = data[Event.endTimeKey] ?? ""
        let hotness = Int32(data[Event.hotnessKey] ?? "")
        
        let price = Double(data[Event.priceKey] ?? "")
        let ticketURL = data[Event.ticketURLKey]
        
        //update event object
        event.update(name: name, hotness: hotness, startTime: startTime, endTime: dateFormatter.date(from:endTimeString), about: data[Event.aboutKey], location: location, price: price, ticketURL:ticketURL)
        
        return event
    }
    
    private class func createLocalEvent(gayID: String) -> Event {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let event = Event(context: context)
        event.gayID = gayID
        
        return event
    }
    
    //MARK: Remote Data Updates
    
    class func createEvent(name: String, startTime: Date, endTime: Date?, about: String?, location: EventLocation?,
                           onSuccess success:@escaping (_ data: [[String: String]]) -> Void,
                           onFailure failure: @escaping (_ error: Error?) -> Void) {
        TGAServer.createEvent(name: name, startTime: startTime, endTime: endTime, about: about, location: location, onSuccess: { (data) in
            self.updateLocalEvents(from: data)
        }) { (error) in
            if let error = error {
                print("EVENT FETCH FAILED: \(error.localizedDescription)")
            }
            //TODO: Post notification
        }
    }
    
    class func updateEvent(event: Event, name: String, startTime: Date, endTime: Date?, about: String?, location: EventLocation?) -> Bool {
        return TGAServer.updateEvent(event: event, name: name, startTime: startTime, endTime: endTime, about: about, location: location)
    }
    
    class func delete(event:Event) -> Bool {
        return TGAServer.delete(event: event)
    }
}
