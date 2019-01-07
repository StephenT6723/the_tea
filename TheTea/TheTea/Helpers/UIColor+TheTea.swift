//
//  UIColor+TheTea.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/24/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

extension UIColor {
    class func primaryBrand() -> UIColor {
        return UIColor(hexString:"#907EE9")
    }
    
    class func lightBrandCopy() -> UIColor {
        return UIColor(hexString:"#B0A4EF")
    }
    
    class func primaryCopy() -> UIColor {
        return UIColor(red:0.09, green:0.08, blue:0.14, alpha:1)
    }
    
    class func secondaryCopy() -> UIColor {
        return UIColor(red:0.19, green:0.21, blue:0.27, alpha:1)
    }
    
    class func primaryCTA() -> UIColor {
        return UIColor(red:0.59, green:0.71, blue:1, alpha:1)
    }
    
    class func lightCopy() -> UIColor {
        return UIColor(red:0.19, green:0.21, blue:0.27, alpha:0.48)
    }
    class func lightBackground() -> UIColor {
        return UIColor(hexString:"EFEFF4")
    }
    
    class func dividers() -> UIColor {
        return UIColor(hexString:"#E2E2E2")
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
