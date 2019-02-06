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
    
    func presentAlertView(view: UIView) {
        let alertContainer = AlertContainer.sharedInstance
        alertContainer.alertView = view
        alertContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(alertContainer)
        
        alertContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        alertContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        alertContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        alertContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        alertContainer.updatePresented(true) {}
    }
    
    func dismissAlertView() {
        let alertContainer = AlertContainer.sharedInstance
        alertContainer.updatePresented(false) {
            alertContainer.removeFromSuperview()
        }
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

class AlertContainer: UIView {
    static let sharedInstance = AlertContainer(frame: CGRect())
    let backgroundView = UIView()
    var alertView: UIView? {
        willSet {
            alertView?.removeFromSuperview()
        }
    }
    var alertCenterConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor(red:0.19, green:0.21, blue:0.27, alpha:0.7)
        backgroundView.alpha = 0
        addSubview(backgroundView)
        
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updatePresented(_ presented: Bool, complete:@escaping () -> Void) {
        guard let alertView = self.alertView else {
            return
        }
        
        if presented {
            alertView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(alertView)
            
            alertView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
            alertView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
            alertCenterConstraint = alertView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 20)
            alertCenterConstraint.isActive = true
            
            layoutIfNeeded()
            alertView.alpha = 0
        }
        
        alertCenterConstraint.constant = presented ? 0 : 20
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = presented ? 1 : 0
            alertView.alpha = presented ? 1 : 0
            self.layoutIfNeeded()
        }) { (finished) in
            complete()
        }
    }
    
    //MARK: Keyboard updates
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.alertCenterConstraint.constant = ((keyboardSize.height / 2) - 30) * -1
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.alertCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}
