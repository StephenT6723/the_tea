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
    func collection(for carousel: EventCollectionCarousel, at index: Int) -> EventCollection?
    func carousel(_ carousel: EventCollectionCarousel, didSelect index: Int)
}

class EventCollectionCarousel: UIView {
    var delegate: EventCollectionCarouselDelegate? {
        didSet {
            updateContent()
        }
    }
    private let scrollView = EventCollectionCarouselScrollView()
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
            let collection = delegate.collection(for: self, at: index)
            let image = EventCollection.placeholderImage(for: index)
            cell.imageView.image = image
            cell.button.tag = index
            cell.button.addTarget(self, action: #selector(cellSelected(sender:)), for: .touchUpInside)
            cell.titleLabel.text = collection?.title
            cell.subTitleLabel.text = collection?.subtitle
            scrollView.addSubview(cell)
            
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
    
    @objc func cellSelected(sender: UIButton) {
        if let delegate = self.delegate {
            delegate.carousel(self, didSelect: sender.tag)
        }
    }
}

class EventCollectionCarouselScrollView: UIScrollView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if let superview = self.superview {
            let superPoint = convert(point, to: superview)
            return superview.point(inside:superPoint, with: event)
        }
        return false
    }
}
