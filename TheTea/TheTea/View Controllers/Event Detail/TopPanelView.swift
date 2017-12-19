//
//  TopPanelViewController.swift
//  TopPanelViewControllerDemo
//
//  Created by Stephen Thomas on 8/28/17.
//  Copyright © 2017 Stephen Thomas. All rights reserved.
//

import UIKit

class TopPanelView: UIView, UIScrollViewDelegate {
    private var topPanel = UIView()
    private var topPanelMask = UIView()
    private var scrollableView = UIView()
    private let scrollView = TopPanelScrollView()
    private var topPanelheightConstraint = NSLayoutConstraint()
    private var shadowView = UIView()
    var topPanelHeight: CGFloat = 200.0 {
        didSet {
            scrollView.topPanelHeight = topPanelHeight
        }
    }
    
    func updateContent(topPanel: UIView, scrollableView: UIView) {
        self.topPanel.removeFromSuperview()
        self.scrollableView.removeFromSuperview()
        self.shadowView.removeFromSuperview()
        
        if topPanelMask.superview == nil {
            topPanelMask.translatesAutoresizingMaskIntoConstraints = false
            topPanelMask.backgroundColor = .black
            topPanelMask.alpha = 0
            topPanelMask.isUserInteractionEnabled = false
            addSubview(topPanelMask)
            
            topPanelMask.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            topPanelMask.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            topPanelMask.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            topPanelMask.heightAnchor.constraint(equalToConstant: topPanelHeight).isActive = true
        }
        
        if scrollView.superview == nil {
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.delegate = self
            scrollView.alwaysBounceVertical = true
            addSubview(scrollView)
            
            scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
        
        self.topPanel = topPanel
        self.scrollableView = scrollableView
        
        topPanel.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(topPanel, at:0)
        
        shadowView = UIView()
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.4
        shadowView.layer.shadowOffset = CGSize(width: 1, height: -4)
        shadowView.layer.shadowRadius = 4
        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = UIScreen.main.scale
        shadowView.backgroundColor = .white
        scrollView.addSubview(shadowView)
        
        scrollableView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(scrollableView)
        
        topPanel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topPanel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        topPanel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        topPanelheightConstraint = NSLayoutConstraint(item: topPanel,
                                                      attribute: .height,
                                                      relatedBy: .equal,
                                                      toItem: nil,
                                                      attribute: .notAnAttribute,
                                                      multiplier: 1,
                                                      constant: topPanelHeight)
        addConstraint(topPanelheightConstraint)
        
        scrollableView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: topPanelHeight).isActive = true
        scrollableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        scrollableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        shadowView.topAnchor.constraint(equalTo: scrollableView.topAnchor).isActive = true
        shadowView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        shadowView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        shadowView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxAlpha: CGFloat = 0.2
        
        var delta = scrollView.contentOffset.y / topPanelHeight
        if delta > 1 {
            delta = 1
        }
        topPanelMask.alpha = delta * maxAlpha
        
        let minHeight: CGFloat = 0.9
        var height = topPanelHeight - scrollView.contentOffset.y
        if height < topPanelHeight {
            height = topPanelHeight * minHeight + ((1 - minHeight) * topPanelHeight) * (1 - delta)
        }
        topPanelheightConstraint.constant = height
    }
}

class TopPanelScrollView: UIScrollView {
    var topPanelHeight: CGFloat = 200
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let frame = CGRect(x: 0, y: topPanelHeight, width: self.bounds.width, height: self.bounds.height - topPanelHeight)
        return frame.contains(point)
    }
}
