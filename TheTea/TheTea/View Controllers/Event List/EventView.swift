//
//  EventListCell.swift
//  TheTea
//
//  Created by Stephen Thomas on 1/5/19.
//  Copyright © 2019 The Tea LLC. All rights reserved.
//

import UIKit

class EventView: UIView {
    var image: UIImage? {
        didSet {
            imageView.image = image
            setNeedsLayout()
        }
    }
    private var imageView = UIImageView()
    private let overlay = UIView()
    let subtitleLabel = UILabel()
    let titleLabel = UILabel()
    
    let timeImageView = UIImageView()
    let timeLabel = UILabel()
    
    let placeImageView = UIImageView()
    let placeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor(white: 0, alpha: 0.15).cgColor
        
        clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = UIColor(white: 1, alpha: 0.9)
        addSubview(overlay)
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.sectionTitle()
        subtitleLabel.textColor = UIColor.lightCopy()
        overlay.addSubview(subtitleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.listTitle()
        titleLabel.textColor = UIColor.primaryCopy()
        overlay.addSubview(titleLabel)
        
        timeImageView.translatesAutoresizingMaskIntoConstraints = false
        timeImageView.image = UIImage(named: "priceIcon")
        timeImageView.contentMode = .scaleAspectFit
        overlay.addSubview(timeImageView)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont.sectionTitle()
        timeLabel.textColor = UIColor.secondaryCopy()
        overlay.addSubview(timeLabel)
        
        placeImageView.translatesAutoresizingMaskIntoConstraints = false
        placeImageView.image = UIImage(named: "priceIcon")
        placeImageView.contentMode = .scaleAspectFit
        overlay.addSubview(placeImageView)
        
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        placeLabel.font = UIFont.sectionTitle()
        placeLabel.textColor = UIColor.secondaryCopy()
        overlay.addSubview(placeLabel)
        
        overlay.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        overlay.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        overlay.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        overlay.heightAnchor.constraint(equalToConstant: 110.0).isActive = true
        
        subtitleLabel.leadingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: 20).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: overlay.topAnchor, constant: 16).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: overlay.trailingAnchor, constant: -20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 6).isActive = true
        
        timeImageView.leadingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: 20).isActive = true
        timeImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        timeImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        timeImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        timeLabel.centerYAnchor.constraint(equalTo: timeImageView.centerYAnchor).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: timeImageView.trailingAnchor, constant: 6).isActive = true
        
        placeImageView.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 20).isActive = true
        placeImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        placeImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        placeImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        placeLabel.centerYAnchor.constraint(equalTo: placeImageView.centerYAnchor).isActive = true
        placeLabel.leadingAnchor.constraint(equalTo: placeImageView.trailingAnchor, constant: 6).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateImageView()
    }
    
    private func updateImageView() {
        guard let image = self.image else {
            return
        }
        
        let imageSize = image.size
        let ratio = imageSize.height / imageSize.width
        
        let width = self.bounds.width
        let imageHeight = width * ratio
        let height = imageHeight > self.bounds.height ? imageHeight : self.bounds.height
        
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
}
