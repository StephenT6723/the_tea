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
        let predicate = NSPredicate(format: "daySectionIdentifier >= %@ AND canceled == false", todayString)
        request.predicate = predicate
        let startTimeSort = NSSortDescriptor(key: "daySectionIdentifier", ascending: true)
        let hotnessSort = NSSortDescriptor(key: "hotness", ascending: false)
        request.sortDescriptors = [startTimeSort, hotnessSort]
        
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
        let predicate = NSPredicate(format: "daySectionIdentifier == %@ AND canceled == false", sectionIdentifier)
        request.predicate = predicate
        let startTimeSort = NSSortDescriptor(key: "hotness", ascending: false)
        request.sortDescriptors = [startTimeSort]
        
        let context = CoreDataManager.sharedInstance.viewContext()
        let eventsFRC = NSFetchedResultsController<Event>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try eventsFRC.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        return eventsFRC
    }
    
    class func favoritedEvents() -> NSFetchedResultsController<Event>? {
        guard let ids = MemberDataManager.loggedInMember()?.chronologicalFavoritIDs() else {
            return nil
        }
        
        let request = NSFetchRequest<Event>(entityName:"Event")
        let predicate = NSPredicate(format: "gayID IN %@", ids)
        request.predicate = predicate
        let startTimeSort = NSSortDescriptor(key: "hotness", ascending: false)
        request.sortDescriptors = [startTimeSort]
        
        let context = CoreDataManager.sharedInstance.viewContext()
        let eventsFRC = NSFetchedResultsController<Event>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try eventsFRC.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        return eventsFRC
    }
    
    class func hostedEvents() -> NSFetchedResultsController<Event>? {
        guard let ids = MemberDataManager.loggedInMember()?.hotHostingIDs() else {
            return nil
        }
        
        let request = NSFetchRequest<Event>(entityName:"Event")
        let predicate = NSPredicate(format: "gayID IN %@", ids)
        request.predicate = predicate
        let startTimeSort = NSSortDescriptor(key: "hotness", ascending: false)
        request.sortDescriptors = [startTimeSort]
        
        let context = CoreDataManager.sharedInstance.viewContext()
        let eventsFRC = NSFetchedResultsController<Event>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
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
    
    //MARK: Updates
    
    class func updateUpcomingEvents(onSuccess success:@escaping () -> Void,
                                    onFailure failure: @escaping (_ error: Error?) -> Void)  {
        TGAServer.fetchEvents(onSuccess: { (data) in()
            self.updateLocalEvents(from: data)
            self.updateStaleTime()
            success()
        }) { (error) in
            if let error = error {
                print("EVENT FETCH FAILED: \(error.localizedDescription)")
            }
            failure(error)
        }
    }
    
    class func updateEvent(event: Event,
                           onSuccess success:@escaping () -> Void,
                           onFailure failure: @escaping (_ error: Error?) -> Void)  {
    }
    
    //MARK: Local Data Updates
    
    private class func updateLocalEvents(from data: [[String: Any]]) {
        for eventDict in data {
            let _ = updateLocalEvent(from: eventDict, overrideImages: true, overrideHosts: true, overrideHotness: true)
        }
        CoreDataManager.sharedInstance.saveContext()
    }
    
    class func updateLocalEvent(from data: [String: Any], overrideImages: Bool, overrideHosts: Bool, overrideHotness: Bool) -> Event? {
        guard let gayID = data[Event.gayIDKey] as? String  else {
            print("TRIED TO UPDATE EVENT WITHOUT GAYID")
            return nil
        }
        
        //TODO: Check last updated to prevent rapidly updating over and over?
        
        //find or create event object
        let event = self.event(gayID: gayID) ?? createLocalEvent(gayID: gayID)
        
        updateLocalEvent(event: event, with: data, overrideImages: overrideImages, overrideHosts: overrideHosts, overrideHotness: overrideHotness)
        
        return event
    }
    
    class func updateLocalEvent(event: Event, with data: [String: Any], overrideImages: Bool, overrideHosts: Bool, overrideHotness: Bool) {
        //parse data
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let name = data[Event.nameKey] as? String, let startTimeString = data[Event.startTimeKey] as? String else {
            print("TRIED TO CREATE EVENT WITHOUT REQUIRED DATA")
            return
        }
        
        guard let startTime = dateFormatter.date(from: startTimeString) else {
            print("UNABLE TO PARSE START TIME: \(startTimeString)")
            return
        }
        
        if name == "One Woman Show" {
            print("Start Time: \(startTime)")
        }
        
        var location: EventLocation?
        
        if let locationName = data[Event.locationNameKey] as? String, let address = data[Event.addressKey] as? String, let latitudeString = data[Event.latitudeKey] as? String, let longitudeString = data[Event.longitudeKey] as? String {
            if let latitude = Double(latitudeString), let longitude = Double(longitudeString) {
                if latitude != 0 && longitude != 0 {
                    location = EventLocation(locationName: locationName, address: address, latitude: latitude, longitude: longitude)
                }
            }
        }
        
        let dateCreatedString = data[Event.dateCreatedKey] as? String ?? ""
        let endTimeString = data[Event.endTimeKey] as? String ?? ""
        var hotness: Int32 = event.hotness
        if overrideHotness{
            hotness = Int32(data[Event.hotnessKey] as? String ?? "") ?? 0
        }
        
        let price = Double(data[Event.priceKey] as? String ?? "")
        let ticketURL = data[Event.ticketURLKey] as? String
        
        let canceled = Bool(data[Event.canceledKey] as? String ?? "") ?? false
        let published = Bool(data[Event.publishedKey] as? String ?? "") ?? false
        
        let repeatRules = data[Event.repeatsKey] as? String ?? "0000000"
        let repeatingEventId = data[Event.repeatingEventIdKey] as? String ?? ""
        
        
        var imageURL = event.imageURL
        if overrideImages {
            imageURL = data[Event.imageURLKey] as? String ?? ""
        }
        
        var hostObjects = [Member]()
        if overrideHosts {
            let hosts = data[Event.hostsKey] as? [[String :String]] ?? []
            for hostData in hosts {
                guard let id = hostData[Member.tgaIDKey], let name = hostData[Member.nameKey] else {
                    print("MEMBER FOUND WITH NO ID/NAME")
                    return
                }
                let member = MemberDataManager.updateLocalMember(tgaID: id, name: name)
                hostObjects.append(member)
            }
        } else {
            hostObjects = event.hosts?.allObjects as? [Member] ?? [Member]()
        }
        
        //update event object
        event.update(name: name, hosts: hostObjects, hotness: hotness, dateCreated: dateFormatter.date(from:dateCreatedString) ?? Date(), startTime: startTime, endTime: dateFormatter.date(from:endTimeString), about: data[Event.aboutKey] as? String, location: location, price: price, ticketURL:ticketURL, canceled: canceled, published: published, repeats: repeatRules, repeatingEventId: repeatingEventId, imageURL: imageURL)
    }
    
    private class func createLocalEvent(gayID: String) -> Event {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let event = Event(context: context)
        event.gayID = gayID
        
        return event
    }
    
    class func resetAllEvents() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        do {
            let results = try CoreDataManager.sharedInstance.viewContext().fetch(fetchRequest)
            for event in results {
                guard let eventData = event as? Event else {continue}
                CoreDataManager.sharedInstance.viewContext().delete(eventData)
            }
        } catch let error {
            print("Resetting events failed :", error)
        }
    }
    
    //MARK: Remote Data Updates
    
    class func createEvent(name: String, startTime: Date, endTime: Date?, about: String?, location: EventLocation?, price: Double, ticketURL: String?, repeats: String, image: UIImage?,
                           onSuccess success:@escaping () -> Void,
                           onFailure failure: @escaping (_ error: Error?) -> Void) {
        TGAServer.createEvent(name: name, startTime: startTime, endTime: endTime, about: about, location: location, price: price, ticketURL: ticketURL, repeats: repeats, image: image, onSuccess: { () in
            success()
        }) { (error) in
            failure(error)
        }
    }
    
    class func updateEvent(event: Event, name: String, startTime: Date, endTime: Date?, about: String?, location: EventLocation?, price: Double, ticketURL: String?, repeats: String, image: UIImage?,
                           onSuccess success:@escaping () -> Void,
                           onFailure failure: @escaping (_ error: Error?) -> Void) {
        TGAServer.updateEvent(event: event, name: name, startTime: startTime, endTime: endTime, about: about, location: location, price: price, ticketURL: ticketURL, repeats: repeats, image: image, onSuccess: { () in
            success()
        }) { (error) in
            failure(error)
        }
    }
    
    class func cancelEvent(event:Event,
                           onSuccess success:@escaping () -> Void,
                           onFailure failure: @escaping (_ error: Error?) -> Void) {
        TGAServer.cancel(event: event, onSuccess: {
            success()
        }) { (error) in
            failure(error)
        }
    }
    
    class func toggleFavorite(event:Event,
                              onSuccess success:@escaping () -> Void,
                              onFailure failure: @escaping (_ error: Error?) -> Void) {
        guard let currentMember = MemberDataManager.loggedInMember() else {
            failure(nil)
            return
        }
        
        if !event.favorited() {
            TGAServer.addFavorite(event: event, onSuccess: { () in
                currentMember.addToFavorites(event)
                CoreDataManager.sharedInstance.saveContext()
                success()
            }) { (error) in
                failure(error)
            }
        } else {
            TGAServer.removeFavorite(event: event, onSuccess: { () in
                currentMember.removeFromFavorites(event)
                CoreDataManager.sharedInstance.saveContext()
                success()
            }) { (error) in
                failure(error)
            }
        }
    }
    
    //MARK: Stale
    
    class func eventsStale() -> Bool {
        guard let lastFetchTime = UserDefaults.standard.object(forKey: "LastEventFetchTime") as? Date else {
            //first fetch
            return true
        }
        
        let hoursSinceFetch = Calendar.current.dateComponents([.hour], from: lastFetchTime, to: Date()).hour ?? 0
        return hoursSinceFetch > staleTime()
    }
    
    class func staleTime() -> Int {
        //in hours
        return 6
    }
    
    class func updateStaleTime() {
        UserDefaults.standard.set(Date(), forKey: "LastEventFetchTime")
        UserDefaults.standard.synchronize()
    }
}
