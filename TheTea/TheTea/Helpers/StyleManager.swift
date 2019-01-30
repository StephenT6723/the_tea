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
        barButtonAppearace.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.cta() as Any,
                                                   NSAttributedString.Key.foregroundColor:UIColor.primaryCTA()], for: .normal)
        barButtonAppearace.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.cta() as Any,
                                                   NSAttributedString.Key.foregroundColor:UIColor.primaryCTA()], for: .selected)
        barButtonAppearace.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.cta() as Any,
                                                   NSAttributedString.Key.foregroundColor:UIColor.primaryCTA()], for: .focused)
        barButtonAppearace.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.cta() as Any,
                                                   NSAttributedString.Key.foregroundColor:UIColor.primaryCTA()], for: .highlighted)
        barButtonAppearace.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.cta() as Any,
                                                   NSAttributedString.Key.foregroundColor:UIColor.lightCopy()], for: .disabled)
    }
    
    class func setWhiteNavBarStyling() {
        let barButtonAppearace = UIBarButtonItem.appearance()
        barButtonAppearace.tintColor = .white
        barButtonAppearace.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.cta() as Any,
                                                   NSAttributedString.Key.foregroundColor:UIColor.white], for: .normal)
        barButtonAppearace.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.cta() as Any,
                                                   NSAttributedString.Key.foregroundColor:UIColor.white], for: .selected)
        barButtonAppearace.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.cta() as Any,
                                                   NSAttributedString.Key.foregroundColor:UIColor.white], for: .focused)
        barButtonAppearace.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.cta() as Any,
                                                   NSAttributedString.Key.foregroundColor:UIColor.white], for: .highlighted)
    }
}
