//
//  MyAccountViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/16/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "My Account"
        view.backgroundColor = .white
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTouched))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    func cancelButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
}
