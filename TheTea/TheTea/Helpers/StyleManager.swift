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
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.font:UIFont.navTitle() as Any,
                                                      NSAttributedString.Key.foregroundColor:UIColor.primaryCopy()]
        
        let barButtonAppearace = UIBarButtonItem.appearance()
        barButtonAppearace.tintColor = UIColor.primaryCTA()
        barButtonAppearace.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.barButtonTitle() as Any,
                                                   NSAttributedString.Key.foregroundColor:UIColor.primaryCTA()], for: .normal)
    }
}
