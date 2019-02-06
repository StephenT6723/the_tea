//
//  RootViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 1/30/19.
//  Copyright © 2019 The Tea LLC. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    private let gradientLayer = CAGradientLayer()
    let backgroundImageView = UIImageView(image: UIImage(named: "placeholderBackground2"))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 375, height: 812)
        gradientLayer.colors = [
            UIColor(red:0.94, green:0.53, blue:1, alpha:0.9).cgColor,
            UIColor(red:0.47, green:0.77, blue:1, alpha:0.9).cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        backgroundImageView.layer.addSublayer(gradientLayer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

}
