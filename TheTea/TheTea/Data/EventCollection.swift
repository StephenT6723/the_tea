//
//  EventList.swift
//  TheTea
//
//  Created by Stephen Thomas on 10/4/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit
import CoreData

enum EventCollectionStatus {
    case updating
    case ready
}

protocol EventCollectionDelegate {
    func eventListStatusChanged(sender: EventCollection)
}

class EventCollection {
    var title = ""
    var subtitle = ""
    var predicate: NSPredicate?
    var sortDescriptors = [NSSortDescriptor]()
    var delegate: EventCollectionDelegate?
    var status = EventCollectionStatus.ready
    var events = [Event]()
    
    convenience init (title: String, subtitle: String, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, delegate: EventCollectionDelegate?) {
        self.init()
        self.title = title
        self.subtitle = subtitle
        self.predicate = predicate
        self.delegate = delegate
        if let sortDescriptors = sortDescriptors {
            self.sortDescriptors = sortDescriptors
        }
    }
    
    func update() {
        if status == .updating {
            return
        }
        
        //update status
        status = .updating
        if let delegate = self.delegate {
            delegate.eventListStatusChanged(sender: self)
        }
        
        //get data
        let request = NSFetchRequest<Event>(entityName:"Event")
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        do {
            //update data
            let events = try context.fetch(request)
            self.events = events
            
            //update status
            self.status = .ready
            if let delegate = self.delegate {
                delegate.eventListStatusChanged(sender: self)
            }
        } catch {
            print("Error fetching events for list: \(self.title): \(self)")
        }
    }
}
