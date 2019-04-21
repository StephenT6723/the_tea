//
//  CityManager.swift
//  TheTea
//
//  Created by Stephen Thomas on 1/26/19.
//  Copyright © 2019 The Tea LLC. All rights reserved.
//

import UIKit
import CoreData

class CityManager {
    //MARK: Fetches
    
    class func allCities() -> [City] {
        let request = NSFetchRequest<City>(entityName:"City")
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: true)]
        let context = CoreDataManager.sharedInstance.viewContext()
        var results = [City]()
        
        do {
            try results = context.fetch(request)
            return results
        } catch {
            fatalError("Failed to fetch City Object: \(error)")
        }
    }
    
    class func updateAllCities(onSuccess success:@escaping () -> Void,
                               onFailure failure: @escaping (_ error: Error?) -> Void)  {
        TGAServer.fetchCities(onSuccess: { (data) in
            self.updateLocalCities(from: data)
            success()
        }) { (error) in
            print("EVENT FETCH FAILED: \(error?.localizedDescription ?? "")")
            failure(error)
        }
    }
    
    private class func updateLocalCities(from data: [[String: Any]]) {
        for cityDict in data {
            let _ = updateLocalCity(from: cityDict)
        }
        CoreDataManager.sharedInstance.saveContext()
    }
    
    class func updateLocalCity(from data: [String: Any]) -> City? {
        guard let gayID = data[City.gayIDKey] as? String  else {
            print("TRIED TO UPDATE CITY WITHOUT GAYID")
            return nil
        }
        
        //find or create event object
        let city = self.city(gayID: gayID) ?? createLocalCity(gayID: gayID)
        
        //parse data
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let name = data[City.nameKey] as? String, let quote = data[City.quoteKey] as? String, let state = data[City.stateKey] as? String else {
            print("TRIED TO CREATE CITY WITHOUT REQUIRED DATA")
            return nil
        }
        
        //update city object
        city.update(name: name, quote: quote, state: state)
        return city
    }
    
    private class func createLocalCity(gayID: String) -> City {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let city = City(context: context)
        city.gayID = gayID
        city.dateCreated = Date() //TODO: Get this from the server
        
        return city
    }
    
    class func city(gayID: String) -> City? {
        let request = NSFetchRequest<City>(entityName:"City")
        request.predicate = NSPredicate(format: "gayID like %@", gayID)
        
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        do {
            let cities = try context.fetch(request)
            if cities.count > 0 {
                return cities[0]
            }
        } catch {
            return nil
        }
        
        return nil
    }
    
    class func selectedCity() -> City? {
        let request = NSFetchRequest<City>(entityName:"City")
        request.predicate = NSPredicate(format: "selected == YES")
        
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        var results = [City]()
        
        do {
            try results = context.fetch(request)
            if results.count > 0 {
                return results[0]
            }
        } catch {
            fatalError("Failed to fetch City Object: \(error)")
        }
        
        return nil
    }
    
    class func selectCity(city: City) {
        guard let previousCity = selectedCity() else {
            city.selected = true
            CoreDataManager.sharedInstance.saveContext()
            return
        }
        if previousCity == city {
            return
        }
        previousCity.selected = false
        
        city.selected = true
        
        CoreDataManager.sharedInstance.saveContext()
    }
}
