//
//  ActivityIndicator.swift
//  TGA Loader Demo
//
//  Created by Stephen Thomas on 1/26/19.
//  Copyright © 2019 Stephen Thomas. All rights reserved.
//

import UIKit

class ActivityIndicator: UIControl {
    let minWidth: CGFloat = 40
    var isAnimating = false {
        didSet {
            if isAnimating {
                grow()
            }
        }
    }
    
    static let preferedWidth: CGFloat = 100
    static let preferedHeight: CGFloat = 4
    private let bouncingView = UIView()
    private var widthConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bouncingView.translatesAutoresizingMaskIntoConstraints = false
        bouncingView.backgroundColor = UIColor(red:0.59, green:0.71, blue:1, alpha:1)
        bouncingView.layer.cornerRadius = 2
        addSubview(bouncingView)
        
        bouncingView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        widthConstraint = bouncingView.widthAnchor.constraint(equalToConstant: 0)
        widthConstraint.isActive = true
        bouncingView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        bouncingView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func grow() {
        widthConstraint.constant = ActivityIndicator.preferedWidth
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: .overrideInheritedCurve, animations: {
            self.layoutIfNeeded()
        }) { (bool) in
            self.shrink()
        }
    }
    
    func shrink() {
        widthConstraint.constant = isAnimating ? minWidth : 0
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
        }) { (bool) in
            if self.isAnimating {
                self.grow()
            }
        }
    }
}
