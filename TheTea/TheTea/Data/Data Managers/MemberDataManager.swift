//
//  MemberDataManager.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/13/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit

class MemberDataManager {
    static let sharedInstance = MemberDataManager()
    private init() {}
    
    func isLoggedIn() -> Bool {
        return false
    }
    
    func canEditEvent(event: Event) -> Bool {
        return true
    }
}
