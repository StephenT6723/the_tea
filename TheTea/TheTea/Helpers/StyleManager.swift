//
//  StyleManager.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/24/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

class StyleManager {
    class func updateNavBarStyling() {
        UIApplication.shared.statusBarStyle = .lightContent
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor.primaryBrand()
        navigationBarAppearace.titleTextAttributes = [NSAttributedStringKey.font:UIFont.headerTwo() as Any,
                                                      NSAttributedStringKey.foregroundColor:UIColor.white]
        
        let barButtonAppearace = UIBarButtonItem.appearance()
        barButtonAppearace.tintColor = UIColor.white
        barButtonAppearace.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.barButtonTitle() as Any,
                                                   NSAttributedStringKey.foregroundColor:UIColor.white], for: .normal)
    }
}
