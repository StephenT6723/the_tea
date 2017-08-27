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
        navigationBarAppearace.titleTextAttributes = [NSFontAttributeName:UIFont.headerTwo() as Any,
                                                      NSForegroundColorAttributeName:UIColor.white]
        
        let barButtonAppearace = UIBarButtonItem.appearance()
        barButtonAppearace.tintColor = UIColor.white
        barButtonAppearace.setTitleTextAttributes([NSFontAttributeName:UIFont.barButtonTitle() as Any,
                                                   NSForegroundColorAttributeName:UIColor.white], for: .normal)
    }
}
