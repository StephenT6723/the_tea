//
//  City+TTMethods.swift
//  TheTea
//
//  Created by Stephen Thomas on 1/26/19.
//  Copyright © 2019 The Tea LLC. All rights reserved.
//

import Foundation
import CoreData

extension City {
    static let nameKey = "name"
    static let gayIDKey = "gayID"
    static let quoteKey = "quote"
    static let stateKey = "state"
    
    func update(name: String, quote: String, state: String?) {
        self.name = name
        self.quote = quote
        self.state = state
    }
    
    func fullImageURL() -> String? {
        if imageURL?.count ?? 0 <= 0 {
            return nil
        }
        return TGAServer.domain + "/\(imageURL ?? "")"
    }
}
