//
//  MemberDataManager.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/13/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit
import CoreData
import FBSDKLoginKit

class MemberDataManager {
    static let sharedInstance = MemberDataManager()
    private init() {}
    
    func isLoggedIn() -> Bool {
        let member = currentMember()
        return member != nil
    }
    
    func loginMemberWithFacebook() -> Bool {
        guard let profile = FBSDKProfile.current(), !isLoggedIn() else {
            print("Tried to create TGA Account but facebook is not logged in")
            return false
        }
        
        //make server call to auth with FB data
        let memberData = TGAServer.authenticateMember(facebookUserID: profile.userID, name: profile.name)
        
        //auth successfull: got a bunch of data from the server with a tb member
        guard let tgaID = memberData[Member.tgaIDKey] as? String else {
            return false
        }
        
        if let member = addNewMember(tgaID: tgaID) {
            member.updateWithData(data: memberData)
            CoreDataManager.sharedInstance.saveContext()
            
            return true
        }
        
        return false
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
    
    func updateCurrentMember(name: String, linkToFacebook: Bool, instagram: String?, twitter: String?) {
        let member = currentMember()
        var memberData = [String: AnyObject]()
        memberData[Member.nameKey] = name as AnyObject
        memberData[Member.likeToFBKey] = linkToFacebook as AnyObject
        memberData[Member.instagramKey] = instagram as AnyObject
        memberData[Member.twitterKey] = twitter as AnyObject
        member?.updateWithData(data: memberData)
        CoreDataManager.sharedInstance.saveContext()
    }
    
    func canEditEvent(event: Event) -> Bool {
        if let member = self.currentMember() {
            return member.canEditEvent(event: event)
        }
        
        return false
    }
    
    func addNewMember(tgaID: String) -> Member? {
        if isLoggedIn() {
            return nil
        }
        
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let member = Member(context: context)
        member.tgaID = tgaID
        CoreDataManager.sharedInstance.saveContext()
        return member
    }
    
    func logoutCurrentMember() {
        if let currentMember = self.currentMember() {
            let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
            context.delete(currentMember)
            CoreDataManager.sharedInstance.saveContext()
        }
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
}
