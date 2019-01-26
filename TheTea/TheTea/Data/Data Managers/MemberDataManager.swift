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
    static let minPasswordLength = 7
    static let minUsernameLength = 7
    
    //MARK: Actions
    
    class func createMember(email: String, username: String, password: String,
                            onSuccess success:@escaping () -> Void,
                            onFailure failure: @escaping (_ error: Error?) -> Void) {
        TGAServer.createMember(email: email, username: username, password: password, onSuccess: { (data) in
            guard let id = data[Member.tgaIDKey] as? String else {
                failure(nil)
                return
            }
            //find or create member object
            let member = self.member(tgaID: id) ?? createLocalMember(tgaID: id)
            
            member.updateWithData(data: data)
            member.authToken = Member.createToken(email: email, password: password)
            CoreDataManager.sharedInstance.saveContext()
            success()
        }) { (error) in
            failure(error)
        }
    }
    
    class func loginMember(email: String, password: String,
                            onSuccess success:@escaping () -> Void,
                            onFailure failure: @escaping (_ error: Error?) -> Void) {
        TGAServer.loginMember(email: email, password: password, onSuccess: { (data) in
            guard let id = data[Member.tgaIDKey] as? String else {
                failure(nil)
                return
            }
            //find or create member object
            let member = self.member(tgaID: id) ?? createLocalMember(tgaID: id)
            
            member.updateWithData(data: data)
            member.authToken = Member.createToken(email: email, password: password)
            CoreDataManager.sharedInstance.saveContext()
            success()
        }) { (error) in
            failure(error)
        }
    }
    
    class func updateMember(name: String, email: String?, facebookID: String?, instagram: String?, twitter: String?, about: String?,
                           onSuccess success:@escaping () -> Void,
                           onFailure failure: @escaping (_ error: Error?) -> Void) {
        //TODO: Validate Email Correctly.
        TGAServer.updateMember(name: name, email: email ?? "", facebookID: facebookID ?? "", instagram: instagram ?? "", twitter: twitter ?? "", about: about ?? "", onSuccess: { (data) in
            let member = self.loggedInMember()
            member?.updateWithData(data: data)
            CoreDataManager.sharedInstance.saveContext()
            success()
        }) { (error) in
            failure(error)
        }
    }
    
    class func fetchLoggedInMember(onSuccess success:@escaping () -> Void,
                                   onFailure failure: @escaping (_ error: Error?) -> Void) {
        if !MemberDataManager.isLoggedIn() {
            failure(nil)
            return
        }
        self.fetchMember(id: loggedInMember()?.tgaID ?? "", onSuccess: {
            success()
        }) { (error) in
            failure(error)
        }
    }
    
    class func fetchMember(id: String,
                           onSuccess success:@escaping () -> Void,
                           onFailure failure: @escaping (_ error: Error?) -> Void) {
        TGAServer.fetchMember(id: id, onSuccess: { (data) in
            let member = self.member(tgaID: id) ?? createLocalMember(tgaID: id)
            member.updateWithData(data: data)
            CoreDataManager.sharedInstance.saveContext()
            success()
        }) { (error) in
            failure(error)
        }
    }
    
    class func logoutMember() {
        if let currentMember = self.loggedInMember() {
            currentMember.authToken = nil
            CoreDataManager.sharedInstance.saveContext()
        }
    }
    
    class func member(tgaID: String) -> Member? {
        let request = NSFetchRequest<Member>(entityName:"Member")
        request.predicate = NSPredicate(format: "tgaID like %@", tgaID)
        
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
    
    //MARK: DB Updates
    
    class func updateLocalMember(tgaID: String, name: String) -> Member {
        let member = self.member(tgaID: tgaID) ?? createLocalMember(tgaID: tgaID)
        member.name = name
        return member
    }
    
    private class func createLocalMember(tgaID: String) -> Member {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let member = Member(context: context)
        member.tgaID = tgaID
        
        return member
    }
    
    //MARK: Helpers
    
    class func isLoggedIn() -> Bool {
        return loggedInMember() != nil
    }
    
    class func loggedInMember() -> Member? {
        let request = NSFetchRequest<Member>(entityName:"Member")
        request.predicate = NSPredicate(format: "authToken != nil")
        
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
    
    class func canEditEvent(event: Event) -> Bool {
        return loggedInMember()?.canEditEvent(event:event) ?? false
    }
    
    //MARK: Data Validation
    
    static func isValidPassword(password: String) -> Bool {
        return password.count >= minPasswordLength
    }
    
    static func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    static func isValidUsername(username: String) -> Bool {
        //TODO: Update validation rules
        if username.count < minUsernameLength {
            return false
        }
        return true
    }
}
