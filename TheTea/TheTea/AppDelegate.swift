//
//  AppDelegate.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/11/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit
import CoreData
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        StyleManager.updateNavBarStyling()
        
        let eventListVC = EventListViewController()
        let eventsFRC = EventManager.allFutureEvents()
        eventListVC.eventsFRC = eventsFRC
        let rootNav = UINavigationController(rootViewController: eventListVC)
        rootNav.navigationBar.prefersLargeTitles = true
        
        let myAccountVC = UIViewController()
        myAccountVC.title = "MY ACCOUNT"
        let myAccountNav = UINavigationController(rootViewController: myAccountVC)
        myAccountVC.view.backgroundColor = .white
        myAccountNav.navigationBar.isTranslucent = false
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.isTranslucent = false
        tabBarController.viewControllers = [rootNav, myAccountNav]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = tabBarController
        window!.makeKeyAndVisible()
        
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        
        EventManager.updateUpcomingEvents()
        EventCollectionManager.updateFeaturedEventCollections()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.sharedInstance.saveContext()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
}
