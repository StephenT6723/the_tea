//
//  UIFont+TheTea.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/24/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

extension UIFont {
    class func headerOne() -> UIFont? {
        return UIFont(name: "SourceSansPro-Bold", size: 18)
    }
    
    class func headerTwo() -> UIFont? {
        return UIFont(name: "SourceSansPro-Semibold", size: 17)
    }
    
    class func barButtonTitle() -> UIFont? {
        return UIFont(name: "SourceSansPro-Regular", size: 17)
    }
    
    class func listSubTitle() -> UIFont? {
        return UIFont(name: "SourceSansPro-Regular", size: 18)
    }
    
    class func body() -> UIFont? {
        return UIFont(name: "SourceSansPro-Regular", size: 15)
    }
}
