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
    
    private let topCarousel = EventDetailCarousel(frame: CGRect())
    private let contentView = UIView()
    private let topPanelView = TopPanelView()
    
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let aboutLabel = UILabel()
    
    private let timeTitleLabel = UILabel()
    private let timeLabel = UILabel()
    
    private let ticketTitleLabel = UILabel()
    private let ticketLabel = UILabel()
    
    private let locationTitleLabel = UILabel()
    private let locationLabel = UILabel()
    
    private let reportButton = UIButton()
    
    let mapView = MKMapView()
    
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
        
        if MemberDataManager.canEditEvent(event:event) {
            let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTouched))
            navigationItem.rightBarButtonItem = editButton
        } else {
            let reportButton = UIBarButtonItem(title: "SHARE", style: .plain, target: self, action: #selector(shareButtonTouched))
            navigationItem.rightBarButtonItem = reportButton
        }
        
        topCarousel.translatesAutoresizingMaskIntoConstraints = false
        topCarousel.event = event
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.font = UIFont.headerTwo()
        subTitleLabel.textColor = UIColor.lightCopy()
        subTitleLabel.text = "DRAG SHOW"
        subTitleLabel.numberOfLines = 0
        contentView.addSubview(subTitleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.headerOne()
        titleLabel.textColor = UIColor.primaryCopy()
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.numberOfLines = 0
        aboutLabel.font = UIFont.body()
        aboutLabel.textColor = UIColor.primaryCopy()
        contentView.addSubview(aboutLabel)
        
        timeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        timeTitleLabel.font = UIFont.body()
        timeTitleLabel.textColor = UIColor.lightCopy()
        timeTitleLabel.text = "DATE & TIME"
        contentView.addSubview(timeTitleLabel)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont.body()
        timeLabel.textColor = UIColor.primaryCopy()
        timeLabel.numberOfLines = 0
        contentView.addSubview(timeLabel)
        
        ticketTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        ticketTitleLabel.font = UIFont.body()
        ticketTitleLabel.textColor = UIColor.lightCopy()
        ticketTitleLabel.text = "TICKETS"
        contentView.addSubview(ticketTitleLabel)
        
        ticketLabel.translatesAutoresizingMaskIntoConstraints = false
        ticketLabel.font = UIFont.body()
        ticketLabel.textColor = UIColor.primaryCopy()
        ticketLabel.text = "FREE"
        contentView.addSubview(ticketLabel)
        
        locationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        locationTitleLabel.font = UIFont.body()
        locationTitleLabel.textColor = UIColor.lightCopy()
        locationTitleLabel.text = "LOCATION"
        contentView.addSubview(locationTitleLabel)
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.numberOfLines = 0
        locationLabel.font = UIFont.body()
        locationLabel.textColor = UIColor.primaryCopy()
        contentView.addSubview(locationLabel)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isUserInteractionEnabled = false
        contentView.addSubview(mapView)
        
        reportButton.translatesAutoresizingMaskIntoConstraints = false
        reportButton.setTitle("REPORT", for: .normal)
        reportButton.setTitleColor(UIColor.primaryCTA(), for: .normal)
        reportButton.titleLabel?.font = UIFont.cta()
        reportButton.addTarget(self, action: #selector(reportButtonTouched), for: .touchUpInside)
        contentView.addSubview(reportButton)
        
        subTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        subTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 4).isActive = true
        
        aboutLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        aboutLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        aboutLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        //aboutLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        timeTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        timeTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        timeTitleLabel.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 20).isActive = true
        
        timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        timeLabel.topAnchor.constraint(equalTo: timeTitleLabel.bottomAnchor, constant: 4).isActive = true
        
        ticketTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        ticketTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        ticketTitleLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20).isActive = true
        
        ticketLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        ticketLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        ticketLabel.topAnchor.constraint(equalTo: ticketTitleLabel.bottomAnchor, constant: 4).isActive = true
        
        locationTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        locationTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        locationTitleLabel.topAnchor.constraint(equalTo: ticketLabel.bottomAnchor, constant: 20).isActive = true
        
        locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        locationLabel.topAnchor.constraint(equalTo: locationTitleLabel.bottomAnchor, constant: 4).isActive = true
        
        mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        reportButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        reportButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20).isActive = true
        reportButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        reportButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        reportButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        
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
            timeLabel.text = "\(DateStringHelper.fullDescription(of: date as Date).uppercased()) - \(event.repeatRules().rules(abreviated: false))"
        }
        aboutLabel.text = event.about
        if let locationName = event.locationName {
            var locationString = locationName
            if let address = event.address {
                //TODO: Find a way to do this that is smarter.
                locationString += "\n\(address.replacingOccurrences(of: ", United States", with: ""))"
            }
            locationLabel.text = locationString
        }
        
        let coordinate = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = event.locationName
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        mapView.region = region
        
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
    
    @objc func shareButtonTouched() {
        print("SHARE")
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
