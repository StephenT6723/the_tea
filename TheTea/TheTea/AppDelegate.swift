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
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let authEnabled = MemberDataManager.authEnabled
        
        StyleManager.updateNavBarStyling()
        /*
        let root = RootViewController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = root
        window!.makeKeyAndVisible()
        
        EventCollectionManager.updateFeaturedEventCollections()
        return true
        */
        let eventListVC = EventListViewController()
        let eventsFRC = EventManager.allFutureEvents()
        eventListVC.eventsFRC = eventsFRC
        let rootNav = UINavigationController(rootViewController: eventListVC)
        rootNav.tabBarItem.image = UIImage(named: "rootViewIcon")
        
        if authEnabled {
            let myAccountVC = MyAccountViewController()
            let myAccountNav = UINavigationController(rootViewController: myAccountVC)
            myAccountNav.navigationBar.isTranslucent = false
            myAccountVC.title = "MY PROFILE"
            myAccountNav.tabBarItem.image = UIImage(named: "myProfileIcon")
            
            let tabBarController = UITabBarController()
            tabBarController.tabBar.tintColor = UIColor.primaryCTA()
            tabBarController.tabBar.isTranslucent = false
            tabBarController.viewControllers = [rootNav, myAccountNav]
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window!.rootViewController = tabBarController
            window!.makeKeyAndVisible()
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
            window!.rootViewController = rootNav
            window!.makeKeyAndVisible()
        }
        
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        
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
