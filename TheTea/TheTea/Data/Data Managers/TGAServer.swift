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
    static let apiStartTimeKey = "startTime"
    static let apiEndTimeKey = "endTime"
    static let apiLocationNameKey = "locationName"
    static let apiAddressKey = "address"
    static let apiLatitudeKey = "latitude"
    static let apiLongitudeKey = "longitude"
    static let apiCanceledKey = "canceled"
    static let apiPublishedKey = "published"
    static let apiPriceKey = "ticketPrice"
    static let apiTicketURLKey = "ticketURL"
    static let apiHotnessKey = "hotness"
    static let apiHostsKey = "hosts"
    static let apiRepeatsKey = "repeats"
    
    static let apiMemberNameKey = "name"
    static let apiMemberAboutKey = "about"
    static let apiMemberEmailKey = "email"
    static let apiMemberPasswordKey = "password"
    static let apiMemberFacebookIDKey = "facebookID"
    static let apiMemberInstagramKey = "instagram"
    static let apiMemberTwitterKey = "twitter"
    
    static let domain = "https://www.thegayagenda.com"
    
    //MARK: Headers
    
    class func headers(email: String, password: String) -> HTTPHeaders {
        return [
            "Authorization": "Basic \(Member.createToken(email: email, password: password))",
            "Accept": "application/json"
        ]
    }
    
    class func headersForCurrentMember() -> HTTPHeaders? {
        guard let currentToken = MemberDataManager.loggedInMember()?.authToken else {
            return nil
        }
        return [
            "Authorization": "Basic \(currentToken)",
            "Accept": "application/json"
        ]
    }
    
    //MARK: Users
    
    class func createMember(email: String, username: String, password: String,
                            onSuccess success:@escaping (_ data: [String: String]) -> Void,
                            onFailure failure: @escaping (_ error: Error?) -> Void) {
        var params = [String: String]()
        params["format"] = "json"
        params[apiMemberEmailKey] = email
        params[apiMemberNameKey] = username
        params[apiMemberPasswordKey] = password
        
        Alamofire.request("\(domain)/user/",
            method: .post,
            parameters: params,
            encoding: URLEncoding(destination: .queryString),
            headers: nil).responseJSON { response in
                guard let data = response.data else {
                    failure(response.error)
                    return
                }
                do {
                    //TODO: Handle errors when name missing or email taken.
                    let json = try JSON(data: data)
                    let dict = memberDictFrom(json: json)
                    success(dict)
                } catch {
                    failure(error)
                }
        }
    }
    
    class func loginMember(email: String, password: String,
                            onSuccess success:@escaping (_ data: [String: String]) -> Void,
                            onFailure failure: @escaping (_ error: Error?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(Member.createToken(email: email, password: password))",
            "Accept": "application/json"
        ]
        
        var params = [String: String]()
        params["format"] = "json"
        
        Alamofire.request("\(domain)/user/login",
            method: .post,
            parameters: params,
            encoding: URLEncoding(destination: .queryString),
            headers: headers).responseJSON { response in
                guard let data = response.data else {
                    failure(response.error)
                    return
                }
                do {
                    let json = try JSON(data: data)
                    let dict = memberDictFrom(json: json)
                    success(dict)
                } catch {
                    failure(error)
                }
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
        let jsonData = json["user"]
        if let gayID = jsonData["id"].number {
            memberDict[Member.tgaIDKey] = "\(gayID)"
        }
        if let name = jsonData[apiMemberNameKey].string {
            memberDict[Member.nameKey] = name
        }
        if let email = jsonData[apiMemberEmailKey].string {
            memberDict[Member.emailKey] = email
        }
        if let facebookID = jsonData[apiMemberFacebookIDKey].string {
            memberDict[Member.facebookIDKey] = facebookID
        }
        if let instagram = jsonData[apiMemberInstagramKey].string {
            memberDict[Member.instagramKey] = instagram
        }
        if let twitter = jsonData[apiMemberTwitterKey].string {
            memberDict[Member.twitterKey] = twitter
        }
        if let about = jsonData[apiMemberAboutKey].string {
            memberDict[Member.aboutKey] = about
        }
        return memberDict
    }
    
    //MARK: Event Fetches
    
    class func fetchEvents(onSuccess success:@escaping (_ data: [[String: Any]]) -> Void,
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
    
    private class func eventDictFrom(json: JSON) -> [[String: Any]] {
        var cleanedData = [[String:Any]]()
        for eventData in json["events"] {
            var eventDict = [String:Any]()
            let jsonData = eventData.1
            if let name = jsonData[apiEventNameKey].string {
                eventDict[Event.nameKey] = name
            }
            if let gayID = jsonData["id"].number {
                eventDict[Event.gayIDKey] = "\(gayID)"
            }
            if let startTime = jsonData[apiStartTimeKey].string {
                eventDict[Event.startTimeKey] = startTime
            }
            if let endTime = jsonData[apiEndTimeKey].string {
                eventDict[Event.endTimeKey] = endTime
            }
            if let about = jsonData[apiAboutKey].string {
                eventDict[Event.aboutKey] = about
            }
            if let locationName = jsonData[apiLocationNameKey].string {
                eventDict[Event.locationNameKey] = locationName
            }
            if let address = jsonData[apiAddressKey].string {
                eventDict[Event.addressKey] = address
            }
            if let latitude = jsonData[apiLatitudeKey].string {
                eventDict[Event.latitudeKey] = latitude
            }
            if let longitude = jsonData[apiLongitudeKey].string {
                eventDict[Event.longitudeKey] = longitude
            }
            if let canceled = jsonData[apiCanceledKey].bool {
                eventDict[Event.canceledKey] = "\(canceled)"
            }
            if let published = jsonData[apiPublishedKey].bool {
                eventDict[Event.publishedKey] = "\(published)"
            }
            if let price = jsonData[apiPriceKey].string {
                eventDict[Event.priceKey] = price
            }
            if let ticketURL = jsonData[apiTicketURLKey].string {
                eventDict[Event.ticketURLKey] = ticketURL
            }
            if let hotness = jsonData[apiHotnessKey].number {
                eventDict[Event.hotnessKey] = "\(hotness)"
            }
            if let hosts = jsonData[apiHostsKey].array {
                if hosts.count > 0 {
                    var hostsArray = [[String: String]]()
                    for host in hosts {
                        guard let id = host["id"].number, let name = host["name"].string else {
                            continue
                        }
                        hostsArray.append([Member.tgaIDKey : "\(id)", Member.nameKey : name])
                    }
                    eventDict[Event.hostsKey] = hostsArray
                }
            }
            if let repeats = jsonData[apiRepeatsKey].string {
                eventDict[Event.repeatsKey] = repeats
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
    
    class func createEvent(name: String, startTime: Date, endTime: Date?, about: String?, location: EventLocation?, price: Double, ticketURL: String?, repeats: String,
                           onSuccess success:@escaping () -> Void,
                           onFailure failure: @escaping (_ error: Error?) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        var params = [String: String]()
        params["format"] = "json"
        params[apiEventNameKey] = name
        params[apiStartTimeKey] = dateFormatter.string(from: startTime)
        if let endTime = endTime {
            params[apiEndTimeKey] = dateFormatter.string(from: endTime)
        }
        params[apiAboutKey] = about ?? ""
        params[apiAddressKey] = location?.address ?? ""
        params[apiLocationNameKey] = location?.locationName ?? ""
        params[apiLatitudeKey] = "\(location?.latitude ?? 0)"
        params[apiLongitudeKey] = "\(location?.longitude ?? 0)"
        params[apiPriceKey] = "\(price)"
        params[apiTicketURLKey] = ticketURL ?? ""
        params[apiRepeatsKey] = repeats

        let headers = self.headersForCurrentMember()
        
        Alamofire.request("\(domain)/events/",
            method: .post,
            parameters: params,
            encoding: URLEncoding(destination: .queryString),
            headers: headers).responseJSON { response in
                response.response?.statusCode == 200 ? success() : failure(response.error)
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
    
    //MARK: Favorites
    
    class func addFavorite(event: Event,
                           onSuccess success:@escaping () -> Void,
                           onFailure failure: @escaping (_ error: Error?) -> Void) {
        guard let headers = headersForCurrentMember(), let currentMember = MemberDataManager.loggedInMember() else {
            failure(nil)
            return
        }
        
        var params = [String: String]()
        params["format"] = "json"
        
        Alamofire.request("\(domain)/user/\(currentMember.tgaID!)/favorite/\(event.gayID!)",
            method: .post,
            parameters: params,
            encoding: URLEncoding(destination: .queryString),
            headers: headers).responseJSON { response in
                if response.error != nil {
                    failure(response.error)
                    return
                }
                
                success()
        }
    }
    
    class func removeFavorite(event: Event,
                           onSuccess success:@escaping () -> Void,
                           onFailure failure: @escaping (_ error: Error?) -> Void) {
        guard let headers = headersForCurrentMember(), let currentMember = MemberDataManager.loggedInMember() else {
            failure(nil)
            return
        }
        
        var params = [String: String]()
        params["format"] = "json"
        
        Alamofire.request("\(domain)/user/\(currentMember.tgaID!)/favorite/\(event.gayID!)",
            method: .delete,
            parameters: params,
            encoding: URLEncoding(destination: .queryString),
            headers: headers).responseJSON { response in
                if response.error != nil {
                    failure(response.error)
                    return
                }
                
                success()
        }
    }
}
