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
    static let apiRepeatingIDKey = "repeatingEventId"
    static let apiAboutKey = "about"
    static let apiStartTimeKey = "startTime"
    static let apiEndTimeKey = "endTime"
    static let apiLocationNameKey = "locationName"
    static let apiAddressKey = "address"
    static let apiLatitudeKey = "latitude"
    static let apiLongitudeKey = "longitude"
    static let apiCanceledKey = "canceled"
    static let apiPublishedKey = "published"
    static let apiPriceKey = "price"
    static let apiTicketURLKey = "ticketURL"
    static let apiHotnessKey = "hotness"
    static let apiHostsKey = "hosts"
    static let apiRepeatsKey = "repeats"
    static let apiImagesKey = "images"
    static let apiURLKey = "url"
    static let apiTimeZoneKey = "timeZone"
    
    static let apiMemberNameKey = "name"
    static let apiMemberAboutKey = "about"
    static let apiMemberEmailKey = "email"
    static let apiMemberPasswordKey = "password"
    static let apiMemberFacebookIDKey = "facebookID"
    static let apiMemberInstagramKey = "instagram"
    static let apiMemberTwitterKey = "twitter"
    static let apiMemberFavoritesKey = "favoriteEvents"
    
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
                            onSuccess success:@escaping (_ data: [String: Any]) -> Void,
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
                    if response.response?.statusCode != 200 {
                        failure(NSError(domain:"", code:response.response!.statusCode, userInfo:nil))
                        return
                    }
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
                            onSuccess success:@escaping (_ data: [String: Any]) -> Void,
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
                    if response.response?.statusCode != 200 {
                        failure(NSError(domain:"", code:response.response!.statusCode, userInfo:nil))
                        return
                    }
                    let json = try JSON(data: data)
                    let dict = memberDictFrom(json: json)
                    success(dict)
                } catch {
                    failure(error)
                }
        }
    }
    
    class func updateMember(name: String, email: String, facebookID: String, instagram: String, twitter: String, about: String,
                           onSuccess success:@escaping (_ data: [String: Any]) -> Void,
                           onFailure failure: @escaping (_ error: Error?) -> Void) {
        var memberDict = [String:String]()
        memberDict[Member.nameKey] = name
        memberDict[Member.emailKey] = email
        memberDict[Member.facebookIDKey] = facebookID
        memberDict[Member.instagramKey] = instagram
        memberDict[Member.twitterKey] = twitter
        memberDict[Member.aboutKey] = about
        
        let id = MemberDataManager.loggedInMember()?.tgaID ?? ""
        let headers = self.headersForCurrentMember()
        
        Alamofire.request("\(domain)/user/\(id)",
            method: .put,
            parameters: nil,
            encoding: URLEncoding(destination: .queryString),
            headers: headers).responseJSON { response in
                guard let data = response.data else {
                    failure(response.error)
                    return
                }
                do {
                    if response.response?.statusCode != 200 {
                        failure(NSError(domain:"", code:response.response!.statusCode, userInfo:nil))
                        return
                    }
                    //TODO: Handle errors when name missing or email taken.
                    let json = try JSON(data: data)
                    let dict = memberDictFrom(json: json)
                    success(dict)
                } catch {
                    failure(error)
                }
        }
    }
    
    class func fetchMember(id: String,
                           onSuccess success:@escaping (_ data: [String: Any]) -> Void,
                           onFailure failure: @escaping (_ error: Error?) -> Void) {
        Alamofire.request("\(domain)/user/\(id)",
            method: .get,
            parameters: nil,
            encoding: URLEncoding(destination: .queryString),
            headers: nil).responseJSON { response in
                guard let data = response.data else {
                    failure(response.error)
                    return
                }
                do {
                    if response.response?.statusCode != 200 {
                        failure(NSError(domain:"", code:response.response!.statusCode, userInfo:nil))
                        return
                    }
                    //TODO: Handle errors when name missing or email taken.
                    let json = try JSON(data: data)
                    let dict = memberDictFrom(json: json)
                    success(dict)
                } catch {
                    failure(error)
                }
        }
    }
    
    private class func memberDictFrom(json: JSON) -> [String: Any] {
        var memberDict = [String:Any]()
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
        if let favorites = jsonData[apiMemberFavoritesKey].array {
            if favorites.count > 0 {
                var favoritesData = [[String: Any]]()
                for eventData in favorites {
                    favoritesData.append(eventDictFrom(json: eventData))
                }
                memberDict[Member.favoritesKey] = favoritesData
            }
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
                if response.response?.statusCode != 200 {
                    failure(NSError(domain:"", code:response.response?.statusCode ?? 500, userInfo:nil))
                    return
                }
                let json = try JSON(data: data)
                let data = eventsDictFrom(json: json)
                success(data)
            } catch {
                failure(error)
            }
        }
    }
    
    private class func eventDictFrom(json: JSON) -> [String: Any] {
        var eventDict = [String:Any]()
        if let name = json[apiEventNameKey].string {
            eventDict[Event.nameKey] = name
        }
        if let gayID = json["id"].number {
            eventDict[Event.gayIDKey] = "\(gayID)"
        }
        if let repeatingID = json[apiRepeatingIDKey].number {
            eventDict[Event.repeatingEventIdKey] = "\(repeatingID)"
        }
        if let startTime = json[apiStartTimeKey].string {
            eventDict[Event.startTimeKey] = startTime
        }
        if let endTime = json[apiEndTimeKey].string {
            eventDict[Event.endTimeKey] = endTime
        }
        if let about = json[apiAboutKey].string {
            eventDict[Event.aboutKey] = about
        }
        if let locationName = json[apiLocationNameKey].string {
            eventDict[Event.locationNameKey] = locationName
        }
        if let address = json[apiAddressKey].string {
            eventDict[Event.addressKey] = address
        }
        if let latitude = json[apiLatitudeKey].string {
            eventDict[Event.latitudeKey] = latitude
        }
        if let longitude = json[apiLongitudeKey].string {
            eventDict[Event.longitudeKey] = longitude
        }
        if let canceled = json[apiCanceledKey].bool {
            eventDict[Event.canceledKey] = "\(canceled)"
        }
        if let published = json[apiPublishedKey].bool {
            eventDict[Event.publishedKey] = "\(published)"
        }
        if let price = json["ticketPrice"].string { //TODO: Fix this on the API side
            eventDict[Event.priceKey] = price
        }
        if let ticketURL = json[apiTicketURLKey].string {
            eventDict[Event.ticketURLKey] = ticketURL
        }
        if let hotness = json[apiHotnessKey].number {
            eventDict[Event.hotnessKey] = "\(hotness)"
        }
        if let hosts = json[apiHostsKey].array {
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
        if let repeats = json[apiRepeatsKey].string {
            eventDict[Event.repeatsKey] = repeats
        }
        if let imageData = json[apiImagesKey].array {
            if imageData.count > 0 {
                if let firstImageURL = imageData[0][apiURLKey].string {
                    eventDict[Event.imageURLKey] = firstImageURL
                }
            }
        }
        return eventDict
    }
    
    private class func eventsDictFrom(json: JSON) -> [[String: Any]] {
        var cleanedData = [[String:Any]]()
        for eventData in json["events"] {
            let jsonData = eventData.1
            cleanedData.append(eventDictFrom(json: jsonData))
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
    
    class func createEvent(name: String, startTime: Date, endTime: Date?, about: String?, location: EventLocation?, price: Double, ticketURL: String?, repeats: String, image: UIImage?,
                           onSuccess success:@escaping () -> Void,
                           onFailure failure: @escaping (_ error: Error?) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        var params = [String: Any]()
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
        params[apiTimeZoneKey] = "\(TimeZone.current.secondsFromGMT())"
        if let imageData = image?.pngData() {
            let dataString = imageData.base64EncodedString()
            var dataDict = [String:String]()
            dataDict["extension"] = "png"
            dataDict["base64"] = dataString
            params["images"] = [dataDict]
        }
        
        let headers = self.headersForCurrentMember()
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: params,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii) ?? ""
            Alamofire.request("\(domain)/events/",
                method: .post,
                parameters: [:],
                encoding: JSONStringArrayEncoding.init(string: theJSONText),
                headers: headers).responseJSON { response in
                    if response.response?.statusCode != 200 {
                        failure(NSError(domain:"", code:response.response!.statusCode, userInfo:nil))
                        return
                    }
                    success()
            }
        }
        failure(nil)
    }
    
    class func fetchEvent(eventID: String,
                          onSuccess success:@escaping (_ data: [[String: Any]]) -> Void,
                           onFailure failure: @escaping (_ error: Error?) -> Void) {
        Alamofire.request("\(domain)/events/\(eventID)",
            method: .get,
            parameters: ["format": "json"],
            encoding: URLEncoding(destination: .queryString),
            headers: nil).responseJSON { response in
                guard let data = response.data else {
                    failure(response.error)
                    return
                }
                do {
                    if response.response?.statusCode != 200 {
                        failure(NSError(domain:"", code:response.response?.statusCode ?? 500, userInfo:nil))
                        return
                    }
                    let json = try JSON(data: data)
                    let data = eventsDictFrom(json: json)
                    success(data)
                } catch {
                    failure(error)
                }
        }
    }
    
    class func updateEvent(event: Event, name: String, startTime: Date, endTime: Date?, about: String?, location: EventLocation?, price: Double, ticketURL: String?, repeats: String, image: UIImage?,
                           onSuccess success:@escaping () -> Void,
                           onFailure failure: @escaping (_ error: Error?) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        var params = [String: Any]()
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
        params[apiTimeZoneKey] = "\(TimeZone.current.secondsFromGMT())"
        if let imageData = image?.pngData() {
            let dataString = imageData.base64EncodedString()
            var dataDict = [String:String]()
            dataDict["extension"] = "png"
            dataDict["base64"] = dataString
            params["images"] = [dataDict]
        }
        
        let headers = self.headersForCurrentMember()
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: params,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii) ?? ""
            Alamofire.request("\(domain)/events/\(event.repeatingEventId ?? "")",
                method: .put,
                parameters: [:],
                encoding: JSONStringArrayEncoding.init(string: theJSONText),
                headers: headers).responseJSON { response in
                    if response.response?.statusCode != 200 {
                        failure(NSError(domain:"", code:response.response!.statusCode, userInfo:nil))
                        return
                    }
                    success()
            }
        }
        failure(nil)
    }
    
    class func cancel(event: Event,
                      onSuccess success:@escaping () -> Void,
                      onFailure failure: @escaping (_ error: Error?) -> Void) {
        var params = [String: Any]()
        params["format"] = "json"
        params[apiCanceledKey] = true
        
        let headers = self.headersForCurrentMember()
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: params,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii) ?? ""
            Alamofire.request("\(domain)/events/\(event.repeatingEventId ?? "")",
                method: .put,
                parameters: [:],
                encoding: JSONStringArrayEncoding.init(string: theJSONText),
                headers: headers).responseJSON { response in
                    if response.response?.statusCode != 200 {
                        failure(NSError(domain:"", code:response.response!.statusCode, userInfo:nil))
                        return
                    }
                    success()
            }
        }
        failure(nil)
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

struct JSONStringArrayEncoding: ParameterEncoding {
    private let myString: String
    
    init(string: String) {
        self.myString = string
    }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = urlRequest.urlRequest
        
        let data = myString.data(using: .utf8)!
        
        if urlRequest?.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        urlRequest?.httpBody = data
        
        return urlRequest!
    }
}
