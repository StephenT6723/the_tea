//
//  EventDetailViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/13/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit
import MapKit

class EventDetailViewController: UIViewController {
    var event : Event?
    
    let topCarousel = EventDetailCarousel(frame: CGRect())
    let contentView = UIView()
    let topPanelView = TopPanelView()
    
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    let aboutLabel = UILabel()
    let locationLabel = UILabel()
    
    convenience init(event: Event) {
        self.init()
        self.event = event
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "EVENT DETAIL"
        view.backgroundColor = .white
        
        guard let event = self.event else {
            return
        }
        
        if MemberDataManager.sharedInstance.canEditEvent(event:event) {
            let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTouched))
            navigationItem.rightBarButtonItem = editButton
        } else {
            let reportButton = UIBarButtonItem(title: "REPORT", style: .plain, target: self, action: #selector(reportButtonTouched))
            navigationItem.rightBarButtonItem = reportButton
        }
        
        topCarousel.translatesAutoresizingMaskIntoConstraints = false
        topCarousel.event = event
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.headerOne()
        titleLabel.textColor = UIColor.primaryCopy()
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.font = UIFont.body()
        detailLabel.textColor = UIColor.lightCopy()
        contentView.addSubview(detailLabel)
        
        detailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.numberOfLines = 0
        locationLabel.font = UIFont.body()
        locationLabel.textColor = UIColor.lightCopy()
        contentView.addSubview(locationLabel)
        
        locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        locationLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor).isActive = true
        
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.numberOfLines = 0
        aboutLabel.font = UIFont.body()
        aboutLabel.textColor = UIColor.primaryCopy()
        contentView.addSubview(aboutLabel)
        
        aboutLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        aboutLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        aboutLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10).isActive = true
        aboutLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        topPanelView.translatesAutoresizingMaskIntoConstraints = false
        topPanelView.updateContent(topPanel: topCarousel, scrollableView: contentView)
        view.addSubview(topPanelView)
        
        topPanelView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topPanelView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        topPanelView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topPanelView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.event?.managedObjectContext == nil {
            self.navigationController?.popViewController(animated: false)
        }
        updateContent()
    }
    
    func updateContent() {
        guard let event = self.event else {
            return
        }
        
        titleLabel.text = event.name?.uppercased()
        if let date = event.startTime {
            detailLabel.text = "\(DateStringHelper.fullDescription(of: date as Date))"
        }
        aboutLabel.text = event.about
        if let locationName = event.locationName {
            var locationString = locationName
            if let address = event.address {
                //TODO: Find a way to do this that is smarter.
                locationString += " - \(address.replacingOccurrences(of: ", United States", with: ""))"
            }
            locationLabel.text = locationString
        }
        topCarousel.updateContent()
    }
    
    @objc func editButtonTouched() {
        let editVC = EventEditViewController()
        editVC.event = event
        let editNav = UINavigationController(rootViewController: editVC)
        editNav.navigationBar.isTranslucent = false
        present(editNav, animated: true, completion: nil)
    }
    
    @objc func reportButtonTouched() {
        print("REPORT")
    }
}

class EventDetailCarousel : UIView {
    let mapView = MKMapView()
    let noLocationView = UIView()
    var event: Event? = nil {
        didSet {
            updateContent()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isUserInteractionEnabled = false
        addSubview(mapView)
        
        mapView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        noLocationView.translatesAutoresizingMaskIntoConstraints = false
        noLocationView.isUserInteractionEnabled = false
        noLocationView.backgroundColor = UIColor.primaryBrand()
        addSubview(noLocationView)
        
        noLocationView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        noLocationView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        noLocationView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        noLocationView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        let logoImageView = UIImageView(image: UIImage(named: "logo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.isUserInteractionEnabled = false
        noLocationView.addSubview(logoImageView)
        
        logoImageView.topAnchor.constraint(equalTo: noLocationView.topAnchor).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: noLocationView.bottomAnchor).isActive = true
        logoImageView.leadingAnchor.constraint(equalTo: noLocationView.leadingAnchor).isActive = true
        logoImageView.trailingAnchor.constraint(equalTo: noLocationView.trailingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateContent() {
        if let event = self.event {
            if event.latitude == 0 && event.longitude == 0 {
                noLocationView.alpha = 1
            } else {
                noLocationView.alpha = 0
                
                let coordinate = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = event.locationName
                mapView.addAnnotation(annotation)
                
                let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
                mapView.region = region
            }
        }
    }
}
