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
    
    func currentMember() -> Member? {
        let request = NSFetchRequest<Member>(entityName:"Member")
        
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        var results = [Member]()
        
        do {
            try results = context.fetch(request)
            if results.count > 0 {
                return results[0]
            } else {
                return self.createPlaceholderMember()
            }
        } catch {
            fatalError("Failed to fetch Member Object: \(error)")
        }
        
        return nil
    }
    
    func canEditEvent(event: Event) -> Bool {
        if let member = self.currentMember() {
            return member.canEditEvent(event: event)
        }
        
        return false
    }
    
    func createPlaceholderMember() -> Member {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let member = Member(context: context)
        member.name = "Alexander Unick"
        member.about = "Under the call sign 'Pharah,' she works to safeguard the AI installation. Though she mourns Overwatch's passing, she still dreams of fighting the good fight and making a difference on a global scale."
        member.facebookID = "placeholder"
        member.tgaID = "placeholder"
        member.linkToFacebook = false
        member.twitter = ""
        member.instagram = ""
        CoreDataManager.sharedInstance.saveContext()
        return member
    }
}
