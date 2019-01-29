//
//  ClearNavigationController.swift
//  TheTea
//
//  Created by Stephen Thomas on 1/28/19.
//  Copyright © 2019 The Tea LLC. All rights reserved.
//

import UIKit

class ClearNavigationController: UINavigationController {
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        effectView.frame =  (self.navigationBar.bounds.insetBy(dx: 0, dy: -24).offsetBy(dx: 0, dy: -24))
        self.navigationBar.isTranslucent = true
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //self.navigationBar.tintColor = .clear
        //self.navigationBar.barTintColor = .clear
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.addSubview(effectView)
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.navTitle() as Any,
                                                 NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationBar.sendSubviewToBack(effectView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationBar.sendSubviewToBack(effectView)
    }
}
