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
        navigationBarAppearace.titleTextAttributes = [NSAttributedStringKey.font:UIFont.headerTwo() as Any,
                                                      NSAttributedStringKey.foregroundColor:UIColor.primaryCopy()]
        navigationBarAppearace.largeTitleTextAttributes = [NSAttributedStringKey.font:UIFont(name: "SourceSansPro-Bold", size: 30) as Any,
                                                           NSAttributedStringKey.foregroundColor:UIColor.primaryCopy()]
        
        let barButtonAppearace = UIBarButtonItem.appearance()
        barButtonAppearace.tintColor = UIColor.primaryCTA()
        barButtonAppearace.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.barButtonTitle() as Any,
                                                   NSAttributedStringKey.foregroundColor:UIColor.primaryCTA()], for: .normal)
    }
}
