//
//  LoginViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/16/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    let facebookButton = FBSDKLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "LOG IN"
        view.backgroundColor = .white
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTouched))
        navigationItem.leftBarButtonItem = cancelButton
        
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        facebookButton.readPermissions = ["public_profile", "email", "user_friends"]
        view.addSubview( facebookButton)
        
        facebookButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facebookButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
    }
    
    func cancelButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
}
