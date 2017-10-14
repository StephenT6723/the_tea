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
    let topPanel = LoginTopPanelView(frame: CGRect())
    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "LOG IN"
        view.backgroundColor = .white
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTouched))
        navigationItem.leftBarButtonItem = cancelButton
        
        topPanel.translatesAutoresizingMaskIntoConstraints = false
        topPanel.backgroundColor = UIColor.primaryBrand()
        topPanel.layer.masksToBounds = false
        topPanel.layer.shadowColor = UIColor.black.cgColor
        topPanel.layer.shadowOpacity = 0.5
        topPanel.layer.shadowOffset = CGSize(width: 0, height: 0)
        topPanel.layer.shadowRadius = 6
        topPanel.layer.shouldRasterize = true
        topPanel.layer.rasterizationScale = UIScreen.main.scale
        view.addSubview(topPanel)
        
        topPanel.pushView(view: recruitView())
        
        topPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topPanel.heightAnchor.constraint(equalToConstant: 184).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "WHY FACEBOOK?"
        titleLabel.font = UIFont.headerThree()
        titleLabel.textColor = UIColor.lightCopy()
        view.addSubview(titleLabel)
        
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topPanel.bottomAnchor, constant: 20).isActive = true
        
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.text = "First of all, we will NEVER post anything on your wall! We use Facebook to make the login process as seamless as possible for our Family. Not to invade your privacy or spam your friends.\n\nWe don’t ask for any crazy permissions. Just what we need to improve your experience here at The Gay Agenda.\n\nIf you don’t feel comfortable connecting with Facebook, that’s fine! You only need to connect if you would like to create your own events here in the app."
        bodyLabel.font = UIFont.body()
        bodyLabel.textColor = UIColor.lightCopy()
        bodyLabel.numberOfLines = 0
        view.addSubview(bodyLabel)
        
        bodyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
    }
    
    @objc func cancelButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Top Panel Content Views
    
    func recruitView() -> UIView {
        let recruitView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.headerOne()
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "WE ARE HERE TO RECRUIT YOU"
        recruitView.addSubview(titleLabel)
        
        let subTitleLabel = UILabel()
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.font = UIFont.body()
        subTitleLabel.textColor = .white
        subTitleLabel.textAlignment = .center
        subTitleLabel.text = "Enlist and you’ll be able add your own events to\nThe Gay Agenda"
        subTitleLabel.numberOfLines = 0
        recruitView.addSubview(subTitleLabel)
        
        let facebookButton = PrimaryCTA()
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        facebookButton.setTitle("CONNECT TO FACEBOOK", for: .normal)
        facebookButton.addTarget(self, action: #selector(connectWithFacebookTouched), for: .touchUpInside)
        recruitView.addSubview(facebookButton)
        
        titleLabel.leadingAnchor.constraint(equalTo: recruitView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: recruitView.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: recruitView.topAnchor, constant: 22).isActive = true
        
        subTitleLabel.leadingAnchor.constraint(equalTo: recruitView.leadingAnchor).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: recruitView.trailingAnchor).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        
        facebookButton.leadingAnchor.constraint(equalTo: recruitView.leadingAnchor, constant: 20).isActive = true
        facebookButton.trailingAnchor.constraint(equalTo: recruitView.trailingAnchor, constant: -20).isActive = true
        facebookButton.bottomAnchor.constraint(equalTo: recruitView.bottomAnchor, constant: -20).isActive = true
        facebookButton.heightAnchor.constraint(equalToConstant: CGFloat(PrimaryCTA.preferedHeight())).isActive = true
        
        return recruitView
    }
    
    func errorView(errorText: String) -> UIView {
        let errorView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.headerOne()
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "OOPSE"
        errorView.addSubview(titleLabel)
        
        let subTitleLabel = UILabel()
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.font = UIFont.body()
        subTitleLabel.textColor = .white
        subTitleLabel.textAlignment = .center
        subTitleLabel.text = errorText
        subTitleLabel.numberOfLines = 0
        errorView.addSubview(subTitleLabel)
        
        let tryAgainButton = PrimaryCTA()
        tryAgainButton.translatesAutoresizingMaskIntoConstraints = false
        tryAgainButton.setTitle("TRY AGAIN", for: .normal)
        tryAgainButton.addTarget(self, action: #selector(connectWithFacebookTouched), for: .touchUpInside)
        errorView.addSubview(tryAgainButton)
        
        titleLabel.leadingAnchor.constraint(equalTo: errorView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: errorView.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: errorView.topAnchor, constant: 22).isActive = true
        
        subTitleLabel.leadingAnchor.constraint(equalTo: errorView.leadingAnchor).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: errorView.trailingAnchor).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        
        tryAgainButton.leadingAnchor.constraint(equalTo: errorView.leadingAnchor, constant: 20).isActive = true
        tryAgainButton.trailingAnchor.constraint(equalTo: errorView.trailingAnchor, constant: -20).isActive = true
        tryAgainButton.bottomAnchor.constraint(equalTo: errorView.bottomAnchor, constant: -20).isActive = true
        tryAgainButton.heightAnchor.constraint(equalToConstant: CGFloat(PrimaryCTA.preferedHeight())).isActive = true
        
        return errorView
    }
    
    func creatingAccountView() -> UIView {
        let creatingView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.headerOne()
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "CREATING YOUR ACCOUNT"
        creatingView.addSubview(titleLabel)
        
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        creatingView.addSubview(loadingView)
        
        titleLabel.leadingAnchor.constraint(equalTo: creatingView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: creatingView.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: creatingView.topAnchor, constant: 22).isActive = true
        
        loadingView.leadingAnchor.constraint(equalTo: creatingView.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: creatingView.trailingAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: creatingView.bottomAnchor).isActive = true
        
        return creatingView
    }
    
    //MARK: Actions
    
    @objc func connectWithFacebookTouched() {
        if FBSDKProfile.current() == nil {
            connectWithFacebook()
        } else if !MemberDataManager.sharedInstance.isLoggedIn(){
            connectWithTGA()
        } else {
            print("Login tapped for already logged in member.")
        }
    }
    
    func connectWithFacebook() {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile"], from: self) { (result: FBSDKLoginManagerLoginResult?, error: Error?) in
            if let error = error {
                print("ERROR LOGGING IN TO FACEBOOK: \(String(describing: error.localizedDescription))")
                self.topPanel.pushView(view: self.errorView(errorText: "There was a problem logging in to Facebook"))
                return
            }
            
            guard let result = result else {
                return
            }
            
            if result.isCancelled {
                return
            }
            
            UIView.animate(withDuration: 0.1, animations: {
                self.titleLabel.alpha = 0
                self.bodyLabel.alpha = 0
            })
            self.topPanel.pushView(view: self.creatingAccountView())
            
            self.connectWithTGA()
        }
    }
    
    func connectWithTGA() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let success = MemberDataManager.sharedInstance.loginMemberWithFacebook()
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.topPanel.pushView(view: self.errorView(errorText: "There was a problem creating your The Gay Agenda account"))
            }
        }
    }
}

class LoginTopPanelView: UIView {
    var view: UIView?
    var viewXConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func pushView(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        view.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        let newXConstraint = view.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: self.bounds.width)
        newXConstraint.isActive = true
        layoutIfNeeded()
        
        viewXConstraint.constant = -1 * self.bounds.width
        viewXConstraint = newXConstraint
        viewXConstraint.constant = 0
        
        UIView.animate(withDuration: self.view == nil ? 0 : 0.1, animations: {
            self.layoutIfNeeded()
        }, completion: { (complete: Bool) in
            self.view?.removeFromSuperview()
            self.view = view
        })
    }
}
