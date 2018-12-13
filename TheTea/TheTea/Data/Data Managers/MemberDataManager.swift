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
    static let authEnabled = true
    static let minPasswordLength = 7
    private init() {}
    
    //MARK: Actions
    
    class func createMember(email: String, password: String,
                            onSuccess success:@escaping () -> Void,
                            onFailure failure: @escaping (_ error: Error?) -> Void) {
        //TODO: Validate email
        TGAServer.createMember(email: email, password: password, onSuccess: { (data) in
            guard let id = data[Member.tgaIDKey] else {
                //TODO: Fail
                return
            }
            let newMember = self.addNewMember(tgaID: id)
            newMember?.updateWithData(data: data)
            CoreDataManager.sharedInstance.saveContext()
            success()
        }) { (error) in
            failure(error)
        }
    }
    
    class func loginMember(email: String, password: String,
                            onSuccess success:@escaping () -> Void,
                            onFailure failure: @escaping (_ error: Error?) -> Void) {
        //TODO: Validate email
        TGAServer.loginMember(email: email, password: password, onSuccess: { (data) in
            guard let id = data[Member.tgaIDKey] else {
                //TODO: Fail
                return
            }
            let newMember = self.addNewMember(tgaID: id)
            newMember?.updateWithData(data: data)
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
            let member = self.currentMember()
            member?.updateWithData(data: data)
            CoreDataManager.sharedInstance.saveContext()
            success()
        }) { (error) in
            failure(error)
        }
    }
    
    class func logoutMember(onSuccess success:@escaping () -> Void,
                      onFailure failure: @escaping (_ error: Error?) -> Void) {
        if let currentMember = self.currentMember() {
            let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
            context.delete(currentMember)
            CoreDataManager.sharedInstance.saveContext()
        }
    }
    
    //MARK: DB Updates
    
    class func addNewMember(tgaID: String) -> Member? {
        if isLoggedIn() {
            return nil
        }
        
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let member = Member(context: context)
        member.tgaID = tgaID
        CoreDataManager.sharedInstance.saveContext()
        return member
    }
    
    //MARK: Helpers
    
    class func isLoggedIn() -> Bool {
        let member = currentMember()
        return member != nil
    }
    
    class func currentMember() -> Member? {
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
    
    class func canEditEvent(event: Event) -> Bool {
        if let member = self.currentMember() {
            return member.canEditEvent(event: event)
        }
        
        return false
    }
    
    //MARK: Data Validation
    
    static func isValidPassword(password: String) -> Bool {
        if password.count < minPasswordLength {
            return false
        }
        return true
    }
    
    static func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
