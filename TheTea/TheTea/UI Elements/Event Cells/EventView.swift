//
//  EventListCell.swift
//  TheTea
//
//  Created by Stephen Thomas on 1/5/19.
//  Copyright © 2019 The Tea LLC. All rights reserved.
//

import UIKit
import Kingfisher

class EventView: UIView {
    var imageURL: String? {
        didSet {
            guard let imageURL = self.imageURL else {
                imageView.image = nil
                return
            }
            let url = URL(string: imageURL)
            imageView.kf.setImage(with: url) { result in
                switch result {
                case .success(_):
                    self.updateImageView()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    private var imageViewContainer = UIView()
    private var activityIndicator = ActivityIndicator(frame: CGRect())
    private var imageView = UIImageView()
    private let overlay = UIView()
    private let subtitleLabel = UILabel()
    private let titleLabel = UILabel()
    private var titleTopConstraint = NSLayoutConstraint()
    
    let timeImageView = UIImageView(image: UIImage(named: "timeIcon"))
    let timeLabel = UILabel()
    
    let placeImageView = UIImageView(image: UIImage(named: "placeIcon"))
    let placeLabel = UILabel()
    
    let priceImageView = UIImageView(image: UIImage(named: "priceIcon"))
    let priceLabel = UILabel()
    
    let leftSpacer = UIView()
    let rightSpacer = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        layer.cornerRadius = 16
        layer.shadowOffset = CGSize(width: 1, height: 2)
        layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.16).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.masksToBounds = false
        layer.borderWidth = 1
        layer.borderColor = UIColor(white: 0, alpha: 0.15).cgColor
        
        imageViewContainer.translatesAutoresizingMaskIntoConstraints = false
        imageViewContainer.layer.cornerRadius = 16
        imageViewContainer.clipsToBounds = true
        addSubview(imageViewContainer)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        imageViewContainer.addSubview(activityIndicator)
        
        imageView.contentMode = .scaleAspectFill
        imageViewContainer.addSubview(imageView)
        
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = UIColor(white: 1, alpha: 0.9)
        imageViewContainer.addSubview(overlay)
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.sectionTitle()
        subtitleLabel.textColor = UIColor.lightCopy()
        overlay.addSubview(subtitleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.listTitle()
        titleLabel.textColor = UIColor.primaryCopy()
        titleLabel.numberOfLines = 0
        overlay.addSubview(titleLabel)
        
        timeImageView.translatesAutoresizingMaskIntoConstraints = false
        timeImageView.contentMode = .scaleAspectFit
        overlay.addSubview(timeImageView)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont.sectionTitle()
        timeLabel.textColor = UIColor.secondaryCopy()
        timeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        overlay.addSubview(timeLabel)
        
        placeImageView.translatesAutoresizingMaskIntoConstraints = false
        placeImageView.contentMode = .scaleAspectFit
        overlay.addSubview(placeImageView)
        
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        placeLabel.font = UIFont.sectionTitle()
        placeLabel.textColor = UIColor.secondaryCopy()
        overlay.addSubview(placeLabel)
        
        priceImageView.translatesAutoresizingMaskIntoConstraints = false
        priceImageView.contentMode = .scaleAspectFit
        overlay.addSubview(priceImageView)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = UIFont.sectionTitle()
        priceLabel.textColor = UIColor.secondaryCopy()
        priceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        overlay.addSubview(priceLabel)
        
        imageViewContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageViewContainer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageViewContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageViewContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: ActivityIndicator.preferedHeight).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: ActivityIndicator.preferedWidth).isActive = true
        
        activityIndicator.isAnimating = true
        
        overlay.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        overlay.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        overlay.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        overlay.heightAnchor.constraint(greaterThanOrEqualToConstant: 90).isActive = true
        
        subtitleLabel.leadingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: 20).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: overlay.topAnchor, constant: 16).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: overlay.trailingAnchor, constant: -20).isActive = true
        titleTopConstraint = titleLabel.topAnchor.constraint(equalTo: overlay.topAnchor, constant: 12)
        titleTopConstraint.isActive = true
        
        timeImageView.leadingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: 20).isActive = true
        timeImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        timeImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        timeImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        timeImageView.bottomAnchor.constraint(equalTo: overlay.bottomAnchor, constant: -16).isActive = true
        
        timeLabel.centerYAnchor.constraint(equalTo: timeImageView.centerYAnchor).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: timeImageView.trailingAnchor, constant: 6).isActive = true
        
        leftSpacer.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(leftSpacer)
        
        leftSpacer.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor).isActive = true
        leftSpacer.widthAnchor.constraint(greaterThanOrEqualToConstant: 6).isActive = true
        leftSpacer.trailingAnchor.constraint(equalTo: placeImageView.leadingAnchor).isActive = true
        
        placeImageView.centerYAnchor.constraint(equalTo: timeImageView.centerYAnchor).isActive = true
        placeImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        placeImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        placeLabel.centerYAnchor.constraint(equalTo: placeImageView.centerYAnchor).isActive = true
        placeLabel.leadingAnchor.constraint(equalTo: placeImageView.trailingAnchor, constant: 6).isActive = true
        
        rightSpacer.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(rightSpacer)
        
        rightSpacer.leadingAnchor.constraint(equalTo: placeLabel.trailingAnchor).isActive = true
        rightSpacer.widthAnchor.constraint(greaterThanOrEqualToConstant: 6).isActive = true
        rightSpacer.widthAnchor.constraint(equalTo: leftSpacer.widthAnchor).isActive = true
        rightSpacer.trailingAnchor.constraint(equalTo: priceImageView.leadingAnchor).isActive = true
        
        priceImageView.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -6).isActive = true
        priceImageView.centerYAnchor.constraint(equalTo: placeImageView.centerYAnchor).isActive = true
        priceImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        priceImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        priceLabel.centerYAnchor.constraint(equalTo: priceImageView.centerYAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: overlay.trailingAnchor, constant: -20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateImageView()
    }
    
    private func updateImageView() {
        guard let image = imageView.image else {
            return
        }
        
        let imageSize = image.size
        let ratio = imageSize.height / imageSize.width
        
        let width = self.bounds.width
        let imageHeight = width * ratio
        let height = imageHeight > self.bounds.height ? imageHeight : self.bounds.height
        
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    func update(title: String?, subtitle: String?, subtitleColor: UIColor?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        subtitleLabel.textColor = subtitleColor
        
        titleTopConstraint.constant = subtitle == nil ? 12: 40
    }
}
