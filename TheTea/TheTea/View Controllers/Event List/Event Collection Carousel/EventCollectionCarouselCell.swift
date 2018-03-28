//
//  EventCollectionCarouselCell.swift
//  TheTea
//
//  Created by Stephen Thomas on 3/28/18.
//  Copyright © 2018 The Tea LLC. All rights reserved.
//

import UIKit

class EventCollectionCarouselCell: UIView {
    let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 4
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
