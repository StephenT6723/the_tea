//
//  SingleSelectList.swift
//  TheTea
//
//  Created by Stephen Thomas on 1/26/19.
//  Copyright © 2019 The Tea LLC. All rights reserved.
//

import UIKit

protocol SingleSelectListDelegate {
    func numberOfItemsIn(list: SingleSelectList) -> Int
    func rowHeightIn(list: SingleSelectList) -> CGFloat
    func view(for list: SingleSelectList, at index: Int) -> UIView
}

class SingleSelectList: UIControl {
    private let scrollView = UIScrollView()
    private var buttons = [UIButton]()
    private let selectionView = UIView()
    private var selectionViewContraint = NSLayoutConstraint()
    private static var topPadding: CGFloat = 10
    var delegate: SingleSelectListDelegate? {
        didSet {
            updateContent()
        }
    }
    var selectedIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        addSubview(scrollView)
        
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        selectionView.backgroundColor = UIColor(red:0.19, green:0.21, blue:0.27, alpha:0.3)
        selectionView.layer.cornerRadius = 5
        selectionView.clipsToBounds = true
        scrollView.addSubview(selectionView)
        
        selectionView.frame = CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width - 40, height: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateContent() {
        guard let delegate = self.delegate else {
            return
        }
        
        for button in buttons {
            button.removeFromSuperview()
        }
        
        buttons = [UIButton]()

        var previousContentView: UIView?
        for i in 0..<delegate.numberOfItemsIn(list: self) {
            let contentView = delegate.view(for: self, at: i)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            //contentView.button.tag = i
            //contentView.button.addTarget(self, action: #selector(hostButtonTouched), for: .touchUpInside)
            scrollView.addSubview(contentView)
            
            if previousContentView != nil {
                contentView.topAnchor.constraint(equalTo: previousContentView!.bottomAnchor).isActive = true
            } else {
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: SingleSelectList.topPadding).isActive = true
                contentView.widthAnchor.constraint(equalTo: widthAnchor, constant: -40).isActive = true
            }
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
            
            if i == delegate.numberOfItemsIn(list: self) - 1 {
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
            }
            
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = i
            button.addTarget(self, action: #selector(buttonSelected(sender:)), for: .touchUpInside)
            scrollView.addSubview(button)
            
            buttons.append(button)
            
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            button.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            
            previousContentView = contentView
        }
    }
    
    @objc func buttonSelected(sender: UIButton) {
        updateSelectedIndex(animated: true, index: sender.tag)
    }
    
    func updateSelectedIndex(animated: Bool, index: Int) {
        let selectedButton = buttons[index]
        guard let rowHeight = delegate?.rowHeightIn(list: self) else {
            return
        }
        
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            self.selectionView.frame = CGRect(x: 20, y: selectedButton.frame.minY + 10, width: selectedButton.frame.width, height: rowHeight - 20)
        }
        selectedIndex = index
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let rowHeight = delegate?.rowHeightIn(list: self) else {
            return
        }
        self.selectionView.frame = CGRect(x: 20, y: SingleSelectList.topPadding + rowHeight * CGFloat(selectedIndex) + 10, width: UIScreen.main.bounds.width - 40, height: rowHeight - 20)
    }
}
