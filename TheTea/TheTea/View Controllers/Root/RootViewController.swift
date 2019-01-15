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
        
        let authView = LoginViewController()
        self.addChild(authView)
        view.addSubview(authView.view)
        authView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        authView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        authView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        authView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        authView.didMove(toParent: self)
    }
}
