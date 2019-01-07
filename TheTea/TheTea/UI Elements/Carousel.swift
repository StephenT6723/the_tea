//
//  Carousel.swift
//  TheTea
//
//  Created by Stephen Thomas on 1/7/19.
//  Copyright © 2019 The Tea LLC. All rights reserved.
//

import UIKit

protocol CarouselDelegate {
    func numberOfItemsIn(carousel: Carousel) -> Int
    func view(for carousel: Carousel, at index: Int) -> UIView?
    func carousel(_ carousel: Carousel, didSelect index: Int)
}

class Carousel: UIView {
    var delegate: CarouselDelegate? {
        didSet {
            updateContent()
        }
    }
    private let scrollView = CarouselScrollView()
    var gapSize = 16
    var previewAmount = 12
    
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
        
        var previousView: UIView?
        
        for index in 0 ..< delegate.numberOfItemsIn(carousel: self) {
            guard let view = delegate.view(for: self, at: index) else {
                continue
            }
            view.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(view)
            
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = index
            button.addTarget(self, action: #selector(cellSelected(sender:)), for: .touchUpInside)
            view.addSubview(button)
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            button.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
            
            if let previousView = previousView {
                view.widthAnchor.constraint(equalTo: previousView.widthAnchor).isActive = true
                view.leadingAnchor.constraint(equalTo: previousView.trailingAnchor, constant: CGFloat(gapSize)).isActive = true
            } else {
                view.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -1 * CGFloat(gapSize)).isActive = true
                view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(gapSize) / 2).isActive = true
            }
            
            if index == delegate.numberOfItemsIn(carousel: self) - 1 {
                view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: CGFloat(gapSize) / 2).isActive = true
            }
            
            previousView = view
        }
    }
    
    @objc func cellSelected(sender: UIButton) {
        if let delegate = self.delegate {
            delegate.carousel(self, didSelect: sender.tag)
        }
    }
}

class CarouselScrollView: UIScrollView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if let superview = self.superview {
            let superPoint = convert(point, to: superview)
            return superview.point(inside:superPoint, with: event)
        }
        return false
    }
}
