//
//  MyProfileRootViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 1/17/19.
//  Copyright © 2019 The Tea LLC. All rights reserved.
//

import UIKit

class MyProfileRootViewController: UIViewController, LoginViewDelegate {
    let loginViewController = LoginViewController()
    let profileViewController = MyAccountViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        
        
    }

    func loginSucceeded() {
        
    }
}
