//
//  EventCollectionManager.swift
//  TheTea
//
//  Created by Stephen Thomas on 4/3/18.
//  Copyright © 2018 The Tea LLC. All rights reserved.
//

import UIKit
import CoreData

extension Notification.Name {
    static let featuredUpdatedNotificationName = Notification.Name("featuredUpdatedNotificationName")
}

class EventCollectionManager {
    class func featuredEventCollections() -> [EventCollection] {
        let request = NSFetchRequest<EventCollection>(entityName:"EventCollection")
        let predicate = NSPredicate(format: "featured == 1")
        request.predicate = predicate
        let sort = NSSortDescriptor(key: "sortIndex", ascending: true)
        request.sortDescriptors = [sort]
        
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        do {
            let collections = try context.fetch(request)
            return collections
        } catch {
            return []
        }
    }
    
    class func userUpdatedEventCollections() -> [EventCollection] {
        let request = NSFetchRequest<EventCollection>(entityName:"EventCollection")
        let predicate = NSPredicate(format: "userUpdated == 1")
        request.predicate = predicate
        let sort = NSSortDescriptor(key: "sortIndex", ascending: true)
        request.sortDescriptors = [sort]
        
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        do {
            let collections = try context.fetch(request)
            return collections
        } catch {
            return []
        }
    }
    
    class func eventCollection(gayID: String) -> EventCollection? {
        let request = NSFetchRequest<EventCollection>(entityName:"EventCollection")
        request.predicate = NSPredicate(format: "gayID like %@", gayID)
        
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        do {
            let eventCollections = try context.fetch(request)
            if eventCollections.count > 0 {
                return eventCollections[0]
            }
        } catch {
            return nil
        }
        
        return nil
    }
    
    //MARK: Fetches
    
    class func updateFeaturedEventCollections() {
        let collectionData = TGAServer.fetchEventCollections()
        updateLocalEventCollections(from: collectionData)
        
        NotificationCenter.default.post(name: .featuredUpdatedNotificationName, object: nil)
    }
    
    class func updateLocalEventCollections(from data: [[String: Any]]) {
        for collectionDict in data {
            updateLocalEventCollection(from: collectionDict)
        }
    }
    
    class func updateLocalEventCollection(from data: [String: Any]) {
        guard let gayID = data[EventCollection.gayIDKey] as? String  else {
            print("TRIED TO UPDATE COLLECTION WITHOUT GAYID")
            return
        }
        
        //TODO: Check last updated to prevent rapidly updating over and over?
        
        //find or create event object
        let collection = eventCollection(gayID: gayID) ?? createLocalEventCollection(gayID: gayID)
        
        guard let title = data[EventCollection.titleKey] as? String else {
            print("TRIED TO CREATE EVENT COLLECTION WITHOUT REQUIRED DATA")
            return
        }
        
        var sortIndex: Int16?
        if let sortIndexString = data[EventCollection.sortIndexKey] as? String {
            sortIndex = Int16(sortIndexString)
        }
        
        var userUpdated: Bool = false
        if let updated = data[EventCollection.userUpdatedKey] as? Bool {
            userUpdated = updated
        }
        
        collection.update(title: title, subtitle: data[EventCollection.subtitleKey] as? String, sortIndex: sortIndex, imageURL: data[EventCollection.imageURLKey] as? String, about: data[EventCollection.aboutKey] as? String, featured: true, userUpdated: userUpdated)
        
        if let events = data[EventCollection.eventKey] as? [[String: String]] {
            collection.update(events: events)
        }
        
        CoreDataManager.sharedInstance.saveContext()
    }
    
    class func createLocalEventCollection(gayID: String) -> EventCollection {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let eventCollection = EventCollection(context: context)
        eventCollection.gayID = gayID
        CoreDataManager.sharedInstance.saveContext()
        
        return eventCollection
    }
}
