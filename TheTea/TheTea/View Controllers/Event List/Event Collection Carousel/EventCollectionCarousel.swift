//
//  EventCollectionCarousel.swift
//  TheTea
//
//  Created by Stephen Thomas on 3/28/18.
//  Copyright © 2018 The Tea LLC. All rights reserved.
//

import UIKit

protocol EventCollectionCarouselDelegate {
    func numberOfCollectionsIn(carousel: EventCollectionCarousel) -> Int
    func image(for carousel: EventCollectionCarousel, at index: Int) -> UIImage?
    func carousel(_ carousel: EventCollectionCarousel, didSelectIndex: Int)
}

class EventCollectionCarousel: UIView {
    var delegate: EventCollectionCarouselDelegate? {
        didSet {
            updateContent()
        }
    }
    private let scrollView = UIScrollView()
    private let gapSize = 16
    private let previewAmount = 12
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.clipsToBounds = false
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(gapSize) / 2).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1 * (CGFloat(gapSize) / 2 + CGFloat(previewAmount))).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateContent() {
        for view in scrollView.subviews {
            view.removeFromSuperview()
        }
        
        guard let delegate = self.delegate else {
            return
        }
        
        var previousCell: EventCollectionCarouselCell?
        
        for index in 0 ..< delegate.numberOfCollectionsIn(carousel: self) {
            let cell = EventCollectionCarouselCell(frame: CGRect())
            cell.translatesAutoresizingMaskIntoConstraints = false
            let image = delegate.image(for: self, at: index)
            cell.imageView.image = image
            scrollView.addSubview(cell)
            
            if index == 0 {
                cell.titleLabel.text = "NIGHT LIFE"
                cell.subTitleLabel.text = "Time to party, honey"
            } else if index == 1 {
                cell.titleLabel.text = "HAPPY HOUR"
                cell.subTitleLabel.text = "May it last all night"
            } else if index == 2 {
                cell.titleLabel.text = "DRAG SHOWS"
                cell.subTitleLabel.text = "Category is..."
            } else {
                cell.titleLabel.text = "ST.PATTY'S"
                cell.subTitleLabel.text = "Lucky you"
            }
            
            cell.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            cell.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            cell.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
            
            if let previousCell = previousCell {
                cell.widthAnchor.constraint(equalTo: previousCell.widthAnchor).isActive = true
                cell.leadingAnchor.constraint(equalTo: previousCell.trailingAnchor, constant: CGFloat(gapSize)).isActive = true
            } else {
                cell.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -1 * CGFloat(gapSize)).isActive = true
                cell.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(gapSize) / 2).isActive = true
            }
            
            if index == delegate.numberOfCollectionsIn(carousel: self) - 1 {
                cell.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: CGFloat(gapSize) / 2).isActive = true
            }
            
            previousCell = cell
        }
    }
}
