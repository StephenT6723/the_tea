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
        return UIFont(name: "Montserrat-Bold", size: 24)
    }
    
    class func headerTwo() -> UIFont? {
        return UIFont(name: "Montserrat-SemiBold", size: 16)
    }
    
    class func headerThree() -> UIFont? {
        return UIFont(name: "SourceSansPro-Bold", size: 16)
    }
    
    class func barButtonTitle() -> UIFont? {
        return UIFont(name: "SourceSansPro-Regular", size: 17)
    }
    
    class func listTitle() -> UIFont? {
        return UIFont(name: "Montserrat-Bold", size: 20)
    }
    
    class func listSubTitle() -> UIFont? {
        return UIFont(name: "Montserrat-Medium", size: 12)
    }
    
    class func body() -> UIFont? {
        return UIFont(name: "Montserrat-Regular", size: 14)
    }
    
    class func sectionTitle() -> UIFont? {
        return UIFont(name: "Montserrat-SemiBold", size: 14)
    }
    
    class func cta() -> UIFont? {
        return UIFont(name: "Montserrat-Bold", size: 12)
    }
}
