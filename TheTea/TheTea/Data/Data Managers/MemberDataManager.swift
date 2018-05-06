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
        guard let tgaID = TGAServer.authenticateMember(facebookUserID: profile.userID, name: profile.name) else {
            print("TGA Authentication Failed")
            return false
        }
        let memberData = TGAServer.fetchMember(tgaID: tgaID)
        
        if let member = addNewMember(tgaID: tgaID) {
            member.updateWithData(data: memberData)
            //DEBUG HACK TO USE REAL NAME AND ID
            member.name = profile.name
            member.facebookID = profile.userID
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
        let success = TGAServer.updateMember(name: name, linkToFacebook: linkToFacebook, instagram: instagram, twitter: twitter)
        if success {
            let member = currentMember()
            var memberData = [String: AnyObject]()
            memberData[Member.nameKey] = name as AnyObject
            memberData[Member.linkToFBKey] = linkToFacebook as AnyObject
            memberData[Member.instagramKey] = instagram as AnyObject
            memberData[Member.twitterKey] = twitter as AnyObject
            member?.updateWithData(data: memberData)
            CoreDataManager.sharedInstance.saveContext()
        } else {
            //Handle Error
        }
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
