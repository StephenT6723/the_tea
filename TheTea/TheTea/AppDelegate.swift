//
//  AppDelegate.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/11/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        StyleManager.updateNavBarStyling()
 
        let eventListVC = EventListViewController()
        let eventsFRC = EventManager.allFutureEvents()
        eventListVC.eventsFRC = eventsFRC
        let rootNav = UINavigationController(rootViewController: eventListVC)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = rootNav
        window!.makeKeyAndVisible()
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.sharedInstance.saveContext()
    }
}
