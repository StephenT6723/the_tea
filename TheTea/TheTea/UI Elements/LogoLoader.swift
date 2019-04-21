//
//  LogoLoader.swift
//  TGALogoLoader
//
//  Created by Stephen Thomas on 2/8/19.
//  Copyright © 2019 Stephen Thomas. All rights reserved.
//

import UIKit

class LogoLoader: UIView {
    static let preferedSize: CGFloat = 72
    private let imageView = UIImageView(image: UIImage(named: "transLogo"))
    private let gradientView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 20
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.layer.cornerRadius = 35
        gradientView.clipsToBounds = true
        addSubview(gradientView)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 72, height: 72)
        gradientLayer.colors = [
            UIColor(red:0.94, green:0.53, blue:1, alpha:0.9).cgColor,
            UIColor(red:0.47, green:0.77, blue:1, alpha:0.9).cgColor
        ]
        gradientLayer.locations = [0.3, 0.70]
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientView.layer.addSublayer(gradientLayer)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        gradientView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        gradientView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        gradientView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        gradientView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func animate() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = ((360*Double.pi)/180)
        rotationAnimation.duration = 2.0
        rotationAnimation.repeatCount = 1e100
        
        gradientView.layer.add(rotationAnimation, forKey: nil)
    }
}
