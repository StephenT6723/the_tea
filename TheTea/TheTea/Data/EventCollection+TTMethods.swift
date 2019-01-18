//
//  EventCollection+TTMethods.swift
//  TheTea
//
//  Created by Stephen Thomas on 4/3/18.
//  Copyright © 2018 The Tea LLC. All rights reserved.
//

import UIKit
import CoreData

extension EventCollection {
    static let titleKey = "title"
    static let subtitleKey = "subtitle"
    static let gayIDKey = "gayID"
    static let sortIndexKey = "sortIndex"
    static let imageURLKey = "imageURL"
    static let eventKey = "events"
    static let aboutKey = "about"
    static let featuredKey = "featured"
    static let userUpdatedKey = "userUpdated"
    
    func update(title: String, subtitle: String?, sortIndex: Int16?, imageURL: String?, about: String?, featured: Bool, userUpdated: Bool) {
        self.title = title
        self.subtitle = subtitle
        if let sortIndex = sortIndex {
            self.sortIndex = sortIndex
        }
        self.imageURL = imageURL
        self.about = about
        self.featured = featured
        self.userUpdated = userUpdated
    }
    
    func update(events: [[String: String]]) {
        if let allEvents = self.events {
            removeFromEvents(allEvents)
        }
        
        for eventData in events {
            //TODO: Update the event properly. We can't do that with placeholder data that has no real dates.
            guard let gayID = eventData[Event.gayIDKey]  else {
                print("TRIED TO UPDATE EVENT WITHOUT GAYID")
                return
            }
            if let event = EventManager.event(gayID: gayID) {
                addToEvents(event)
            }
        }
    }
    
    class func placeholderImage(for index: Int) -> UIImage? {
        return UIImage(named: "collectionPlaceholder\(index)")
    }
    
    func eventsFRC(sortDescriptors: [NSSortDescriptor]?) -> NSFetchedResultsController<Event> {
        let request = NSFetchRequest<Event>(entityName:"Event")
        let predicate = NSPredicate(format: "ANY collections == %@", self)
        request.predicate = predicate
        let sort = sortDescriptors ?? [NSSortDescriptor(key: "hotness", ascending: false)]
        request.sortDescriptors = sort
        
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let eventsFRC = NSFetchedResultsController<Event>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try eventsFRC.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        return eventsFRC
    }
}
