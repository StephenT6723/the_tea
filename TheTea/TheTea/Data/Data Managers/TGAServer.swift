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
    static let apiEventNameKey = "name"
    static let apiAboutKey = "about"
    static let apiStartTimeKey = "start_time"
    static let apiEndTimeKey = "end_time"
    static let apiLocationNameKey = "location_name"
    static let apiAddressKey = "address"
    static let apiLatitudeKey = "latitude"
    static let apiLongitudeKey = "longitude"
    
    static let apiMemberNameKey = "name"
    static let apiMemberAboutKey = "about"
    static let apiMemberEmailKey = "email"
    static let apiMemberFacebookIDKey = "facebookID"
    static let apiMemberInstagramKey = "instagram"
    static let apiMemberTwitterKey = "twitter"
    
    static let domain = "https://www.thegayagenda.com"
    
    //MARK: Users
    
    class func createMember(email: String, password: String,
                            onSuccess success:@escaping (_ data: [String: String]) -> Void,
                            onFailure failure: @escaping (_ error: Error?) -> Void) {
        var memberDict = [String:String]()
        memberDict[Member.tgaIDKey] = "1"
        memberDict[Member.emailKey] = email
        let deadlineTime = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            success(memberDict)
        }
    }
    
    class func loginMember(email: String, password: String,
                            onSuccess success:@escaping (_ data: [String: String]) -> Void,
                            onFailure failure: @escaping (_ error: Error?) -> Void) {
        var memberDict = [String:String]()
        memberDict[Member.tgaIDKey] = "1"
        memberDict[Member.emailKey] = email
        let deadlineTime = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            success(memberDict)
        }
    }
    
    class func updateMember(name: String, email: String, facebookID: String, instagram: String, twitter: String, about: String,
                           onSuccess success:@escaping (_ data: [String: String]) -> Void,
                           onFailure failure: @escaping (_ error: Error?) -> Void) {
        var memberDict = [String:String]()
        memberDict[Member.tgaIDKey] = "1"
        memberDict[Member.nameKey] = name
        memberDict[Member.emailKey] = email
        memberDict[Member.facebookIDKey] = facebookID
        memberDict[Member.instagramKey] = instagram
        memberDict[Member.twitterKey] = twitter
        memberDict[Member.aboutKey] = about
        let deadlineTime = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            success(memberDict)
        }
    }
    
    class func fetchMember(id: String,
                           onSuccess success:@escaping (_ data: [String: String]) -> Void,
                           onFailure failure: @escaping (_ error: Error?) -> Void){
        failure(NSError(domain: "", code: 404, userInfo: nil))
    }
    
    private class func memberDictFrom(json: JSON) -> [String: String] {
        var memberDict = [String:String]()
        let jsonData = json["data"]
        if let gayID = jsonData["id"].string {
            memberDict[Member.tgaIDKey] = gayID
        }
        if let name = jsonData["attributes"][apiMemberNameKey].string {
            memberDict[Member.nameKey] = name
        }
        if let email = jsonData["attributes"][apiMemberEmailKey].string {
            memberDict[Member.emailKey] = email
        }
        if let facebookID = jsonData["attributes"][apiMemberFacebookIDKey].string {
            memberDict[Member.facebookIDKey] = facebookID
        }
        if let instagram = jsonData["attributes"][apiMemberInstagramKey].string {
            memberDict[Member.instagramKey] = instagram
        }
        if let twitter = jsonData["attributes"][apiMemberTwitterKey].string {
            memberDict[Member.twitterKey] = twitter
        }
        if let about = jsonData["attributes"][apiMemberAboutKey].string {
            memberDict[Member.aboutKey] = about
        }
        return memberDict
    }
    
    //MARK: Event Fetches
    
    class func fetchEvents(onSuccess success:@escaping (_ data: [[String: String]]) -> Void,
                           onFailure failure: @escaping (_ error: Error?) -> Void) {
        Alamofire.request("\(domain)/events/",
                            method: .get,
                            parameters: ["format": "json"],
                            encoding: URLEncoding(destination: .queryString),
                            headers: nil).responseJSON { response in
            guard let data = response.data else {
                failure(response.error)
                return
            }
            do {
                let json = try JSON(data: data)
                let data = eventDictFrom(json: json)
                success(data)
            } catch {
                failure(error)
            }
        }
    }
    
    private class func eventDictFrom(json: JSON) -> [[String: String]] {
        var cleanedData = [[String:String]]()
        for eventData in json["data"] {
            var eventDict = [String:String]()
            let jsonData = eventData.1
            if let name = jsonData["attributes"][apiEventNameKey].string {
                eventDict[Event.nameKey] = name
            }
            if let gayID = jsonData["id"].string {
                eventDict[Event.gayIDKey] = gayID
            }
            if let startTime = jsonData["attributes"][apiStartTimeKey].string {
                eventDict[Event.startTimeKey] = startTime
            }
            if let endTime = jsonData["attributes"][apiEndTimeKey].string {
                eventDict[Event.endTimeKey] = endTime
            }
            if let about = jsonData["attributes"][apiAboutKey].string {
                eventDict[Event.aboutKey] = about
            }
            if let locationName = jsonData["attributes"][apiLocationNameKey].string {
                eventDict[Event.locationNameKey] = locationName
            }
            if let address = jsonData["attributes"][apiAddressKey].string {
                eventDict[Event.addressKey] = address
            }
            if let latitude = jsonData["attributes"][apiLatitudeKey].number {
                eventDict[Event.latitudeKey] = "\(latitude)"
            }
            if let longitude = jsonData["attributes"][apiLongitudeKey].number {
                eventDict[Event.longitudeKey] = "\(longitude)"
            }
            cleanedData.append(eventDict)
        }
        return cleanedData
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
    
    class func createEvent(name: String, startTime: Date, endTime: Date?, about: String?, location: EventLocation?,
                           onSuccess success:@escaping (_ data: [[String: String]]) -> Void,
                           onFailure failure: @escaping (_ error: Error?) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        
        var params = [String: String]()
        params["format"] = "json"
        params[apiEventNameKey] = name
        params[apiStartTimeKey] = dateFormatter.string(from: startTime)
        if let endTime = endTime {
            params[apiEndTimeKey] = dateFormatter.string(from: endTime)
        }
        if let about = about {
            params[apiAboutKey] = about
        }
        if let address = location?.address {
            params[apiAddressKey] = address
        }
        if let locationName = location?.locationName {
            params[apiLocationNameKey] = locationName
        }
        if let latitude = location?.latitude {
            params[apiLatitudeKey] = "\(latitude)"
        }
        if let longitude = location?.longitude {
            params[apiLongitudeKey] = "\(longitude)"
        }
        
        Alamofire.request("\(domain)/events/",
            method: .post,
            parameters: params,
            encoding: URLEncoding(destination: .queryString),
            headers: nil).responseJSON { response in
                guard let data = response.data else {
                    failure(response.error)
                    return
                }
                do {
                    let json = try JSON(data: data)
                    let dict = eventDictFrom(json: json)
                    success(dict)
                } catch {
                    failure(error)
                }
        }
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
