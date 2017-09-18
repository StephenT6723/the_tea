//
//  MemberDataManager.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/13/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit
import CoreData

class MemberDataManager {
    static let sharedInstance = MemberDataManager()
    private init() {}
    
    func isLoggedIn() -> Bool {
        let member = currentMember()
        return member != nil
    }
    
    func canEditEvent(event: Event) -> Bool {
        return true
    }
    
    func currentMember() -> Member? {
        let request = NSFetchRequest<Member>(entityName:"Member")
        
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        var results = [Member]()
        
        do {
            try results = context.fetch(request)
            if results.count > 0 {
                return results[0]
            }
        } catch {
            fatalError("Failed to fetch Member Object: \(error)")
        }
        
        return nil
    }
}
