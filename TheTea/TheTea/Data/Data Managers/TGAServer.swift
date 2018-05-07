//
//  TGAServer.swift
//  TheTea
//
//  Created by Stephen Thomas on 10/9/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TGAServer {
    static let domain = "https://the-gay-agenda.herokuapp.com"
    
    //MARK: Users
    
    class func authenticateMember(facebookUserID: String, name: String) -> String? {
        /*
        var memberData = [String: AnyObject]()
        memberData[Member.nameKey] = name as AnyObject
        memberData[Member.tgaIDKey] = "12345" as AnyObject
        memberData[Member.facebookIDKey] = facebookUserID as AnyObject
        memberData[Member.linkToFBKey] = false as AnyObject
        memberData[Member.instagramKey] = "" as AnyObject
        memberData[Member.twitterKey] = "" as AnyObject
        memberData[Member.aboutKey] = "" as AnyObject
        return memberData */
        return "12345"
    }
    
    class func fetchMember(tgaID: String) -> [String: AnyObject] {
        var memberData = [String: AnyObject]()
        memberData[Member.nameKey] = "Peter Parker" as AnyObject
        memberData[Member.tgaIDKey] = tgaID as AnyObject
        memberData[Member.facebookIDKey] = "abcdefg" as AnyObject
        memberData[Member.linkToFBKey] = false as AnyObject
        memberData[Member.instagramKey] = "" as AnyObject
        memberData[Member.twitterKey] = "" as AnyObject
        memberData[Member.aboutKey] = "" as AnyObject
        return memberData
    }
    
    class func updateMember(name: String, linkToFacebook: Bool, instagram: String?, twitter: String?) -> Bool {
        return true
    }
    
    //MARK: Event Fetches
    
    class func fetchEvents(onSuccess success:@escaping (_ data: [[String: String]]) -> Void,
                           onFailure failure: @escaping (_ error: Error?) -> Void) {
        Alamofire.request("\(domain)/events/").responseJSON { response in
            guard let data = response.data else {
                failure(response.error)
                return
            }
            do {
                let json = try JSON(data: data)
                var cleanedData = [[String:String]]()
                for eventData in json["data"] {
                    var eventDict = [String:String]()
                    let jsonData = eventData.1
                    if let name = jsonData["attributes"]["name"].string {
                        eventDict[Event.nameKey] = name
                    }
                    if let gayID = jsonData["id"].string {
                        eventDict[Event.gayIDKey] = gayID
                    }
                    if let startTime = jsonData["attributes"]["start_time"].string {
                        eventDict[Event.startTimeKey] = startTime
                    }
                    if let endTime = jsonData["attributes"]["end_time"].string {
                        eventDict[Event.endTimeKey] = endTime
                    }
                    if let about = jsonData["attributes"]["about"].string {
                        eventDict[Event.aboutKey] = about
                    }
                    if let locationName = jsonData["attributes"]["location_name"].string {
                        eventDict[Event.locationNameKey] = locationName
                    }
                    if let address = jsonData["attributes"]["address"].string {
                        eventDict[Event.addressKey] = address
                    }
                    if let latitude = jsonData["attributes"]["latitude"].number {
                        eventDict[Event.latitudeKey] = "\(latitude)"
                    }
                    if let longitude = jsonData["attributes"]["longitude"].number {
                        eventDict[Event.longitudeKey] = "\(longitude)"
                    }
                    cleanedData.append(eventDict)
                }
                success(cleanedData)
            } catch {
                failure(error)
            }
        }
    }
    
    //MARK: Event Collection Fetches
    
    class func fetchEventCollections() -> [[String: Any]] {
        let allCollections = [[String: String]]()
        var myArray: NSArray?
        if let path = Bundle.main.path(forResource: "test_event_collections", ofType: "plist") {
            myArray = NSArray(contentsOfFile: path)
            if let data = myArray as? [[String: Any]] {
                return data
            }
        }
        return allCollections
    }
    
    //MARK: Event CRUD
    
    class func createEvent(name: String, startTime: Date, endTime: Date?, about: String?, location: EventLocation?) -> Bool {
        /*
         let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
         let event = Event(context: context)
         let hotness = Int32(arc4random_uniform(1000))
         event.update(name: name, hotness: hotness, startTime: startTime, endTime: endTime, about: about, location: location, price: 0, ticketURL:"")
         CoreDataManager.sharedInstance.saveContext() */
        
        //PUSH TO SERVER AND WAIT FOR RESPONSE
        
        return true
    }
    
    class func fetchEvent(tgaID: String) -> [String: String] {
        return [String: String]()
    }
    
    class func updateEvent(event: Event, name: String, startTime: Date, endTime: Date?, about: String?, location: EventLocation?) -> Bool {
        /*
         event.update(name: name, hotness: nil, startTime: startTime, endTime: endTime, about: about, location: location, price: 0, ticketURL:"")
         CoreDataManager.sharedInstance.saveContext() */
        
        //PUSH TO SERVER AND WAIT FOR RESPONSE
        return true
    }
    
    class func delete(event:Event) -> Bool {
        /*
         CoreDataManager.sharedInstance.persistentContainer.viewContext.delete(event)
         CoreDataManager.sharedInstance.saveContext() */
        
        //PUSH TO SERVER AND WAIT FOR RESPONSE
        return true
    }
}
