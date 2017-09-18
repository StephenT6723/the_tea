//
//  Member+TTMethods.swift
//  TheTea
//
//  Created by Stephen Thomas on 9/18/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import Foundation
import CoreData


extension Member {
    func updateWithData(data: [String: AnyObject]) {
        
    }
    
    func canEditEvent(event: Event) -> Bool {
        return true
    }
}
