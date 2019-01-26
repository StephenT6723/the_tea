//
//  File.swift
//  TGA Loader Demo
//
//  Created by Stephen Thomas on 1/26/19.
//  Copyright © 2019 Stephen Thomas. All rights reserved.
//

import UIKit

extension UIViewController {
    func setLoaderVisible(_ visible: Bool, animated: Bool) {
        if visible {
            let loadingView = LoadingView.sharedInstance
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(loadingView)
            
            loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            loadingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            loadingView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            
            loadingView.alpha = 0
            view.isUserInteractionEnabled = false
            UIView.animate(withDuration: animated ? 0.3 : 0) {
                loadingView.alpha = 1
            }
        } else {
            view.isUserInteractionEnabled = true
            let loadingView = LoadingView.sharedInstance
            UIView.animate(withDuration: animated ? 0.3 : 0, animations: {
                loadingView.alpha = 0
            }) { (complete) in
                loadingView.removeFromSuperview()
            }
        }
    }
    
    func loaderVisible() -> Bool {
        return LoadingView.sharedInstance.superview != nil
    }
}

class LoadingView: UIView {
    static let sharedInstance = LoadingView(frame: CGRect())
    var activityIndicator = ActivityIndicator(frame: CGRect())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: ActivityIndicator.preferedHeight).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: ActivityIndicator.preferedWidth).isActive = true
        
        activityIndicator.isAnimating = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
