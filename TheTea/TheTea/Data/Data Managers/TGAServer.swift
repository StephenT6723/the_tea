//
//  TGAServer.swift
//  TheTea
//
//  Created by Stephen Thomas on 10/9/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

class TGAServer {
    class func authenticateMember(facebookUserID: String, name: String) -> [String: AnyObject] {
        var memberData = [String: AnyObject]()
        memberData[Member.nameKey] = name as AnyObject
        memberData[Member.tgaIDKey] = "12345" as AnyObject
        memberData[Member.facebookIDKey] = facebookUserID as AnyObject
        memberData[Member.likeToFBKey] = false as AnyObject
        memberData[Member.instagramKey] = "" as AnyObject
        memberData[Member.twitterKey] = "" as AnyObject
        memberData[Member.aboutKey] = "" as AnyObject
        return memberData
    }
}
