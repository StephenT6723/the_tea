//
//  RootViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 12/19/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "TGA 0.2"
        view.backgroundColor = .purple
        
        if !MemberDataManager.isLoggedIn() {
            let authVC = LoginViewController()
            self.addChild(authVC)
            view.addSubview(authVC.view)
            authVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            authVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            authVC.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            authVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            authVC.didMove(toParent: self)
        } else {
            let listVC = EventListViewController()
            let eventsFRC = EventManager.allFutureEvents()
            listVC.eventsFRC = eventsFRC
            let listNav = UINavigationController(rootViewController: listVC)
            listNav.isNavigationBarHidden = true
            self.addChild(listNav)
            view.addSubview(listNav.view)
            listNav.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            listNav.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            listNav.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            listNav.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            listNav.didMove(toParent: self)
        }
    }
}
