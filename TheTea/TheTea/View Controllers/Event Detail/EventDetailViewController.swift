//
//  EventDetailViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/13/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit
import MapKit

class EventDetailViewController: UIViewController, MKMapViewDelegate {
    var event : Event
    
    let contentView = UIView()
    let topPanelView = TopPanelView()
    let imageView = UIImageView()
    let scrollView = UIScrollView()
    
    private let titleLabel = UILabel()
    private let favoriteButton = UIButton()
    private let favoriteButtonSize: CGFloat = 50
    private let favoriteActivityIndicator = UIActivityIndicatorView(style: .gray)
    private let aboutLabel = UILabel()
    
    private let timeTitleLabel = UILabel()
    private let timeLabel = UILabel()
    
    private let ticketTitleLabel = UILabel()
    private let ticketLabel = UILabel()
    private let ticketButton = PrimaryCTA()
    
    private let locationTitleLabel = UILabel()
    private var locationTopContraint = NSLayoutConstraint()
    private let locationLabel = UILabel()
    
    private let hostsTitleLabel = UILabel()
    private var hostLabels = [EventDetailHostView]()
    
    private let reportButton = UIButton()
    
    private let mapView = MKMapView()
    private let mapButton = UIButton()
    
    convenience init(event: Event) {
        self.init()
        self.event = event
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.event = Event()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.event = Event()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "EVENT DETAIL"
        view.backgroundColor = .white
        
        if MemberDataManager.canEditEvent(event:event) {
            let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTouched))
            navigationItem.rightBarButtonItem = editButton
        } else {
            let reportButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareButtonTouched))
            navigationItem.rightBarButtonItem = reportButton
        }
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "eventPlaceholder18")
        imageView.contentMode = .scaleAspectFill
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.headerOne()
        titleLabel.textColor = UIColor.primaryCopy()
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTouched), for: .touchUpInside)
        contentView.addSubview(favoriteButton)
        
        favoriteActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(favoriteActivityIndicator)
        
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.numberOfLines = 0
        aboutLabel.font = UIFont.body()
        aboutLabel.textColor = UIColor.primaryCopy()
        contentView.addSubview(aboutLabel)
        
        timeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        timeTitleLabel.font = UIFont.sectionTitle()
        timeTitleLabel.textColor = UIColor.lightCopy()
        timeTitleLabel.text = "DATE & TIME"
        contentView.addSubview(timeTitleLabel)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = UIFont.headerTwo()
        timeLabel.textColor = UIColor.primaryCopy()
        timeLabel.numberOfLines = 0
        contentView.addSubview(timeLabel)
        
        ticketTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        ticketTitleLabel.font = UIFont.sectionTitle()
        ticketTitleLabel.textColor = UIColor.lightCopy()
        ticketTitleLabel.text = "TICKETS"
        contentView.addSubview(ticketTitleLabel)
        
        ticketLabel.translatesAutoresizingMaskIntoConstraints = false
        ticketLabel.font = UIFont.headerTwo()
        ticketLabel.textColor = UIColor.primaryCopy()
        contentView.addSubview(ticketLabel)
        
        ticketButton.translatesAutoresizingMaskIntoConstraints = false
        ticketButton.addTarget(self, action: #selector(ticketButtonTouched), for: .touchUpInside)
        contentView.addSubview(ticketButton)
        
        locationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        locationTitleLabel.font = UIFont.sectionTitle()
        locationTitleLabel.textColor = UIColor.lightCopy()
        locationTitleLabel.text = "LOCATION"
        contentView.addSubview(locationTitleLabel)
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.numberOfLines = 0
        locationLabel.font = UIFont.headerTwo()
        locationLabel.textColor = UIColor.primaryCopy()
        contentView.addSubview(locationLabel)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isUserInteractionEnabled = false
        mapView.delegate = self
        contentView.addSubview(mapView)
        
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        mapButton.addTarget(self, action: #selector(mapButtonTouched), for: .touchUpInside)
        contentView.addSubview(mapButton)
        
        hostsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        hostsTitleLabel.font = UIFont.sectionTitle()
        hostsTitleLabel.textColor = UIColor.lightCopy()
        hostsTitleLabel.text = "HOSTS"
        contentView.addSubview(hostsTitleLabel)
        
        reportButton.translatesAutoresizingMaskIntoConstraints = false
        reportButton.setTitle("REPORT", for: .normal)
        reportButton.setTitleColor(UIColor.primaryCTA(), for: .normal)
        reportButton.titleLabel?.font = UIFont.cta()
        reportButton.addTarget(self, action: #selector(reportButtonTouched), for: .touchUpInside)
        contentView.addSubview(reportButton)
        
        //TODO: Remove ! operator
        let hostsArray = event.sortedHosts()
        var previousHostView: EventDetailHostView?
        for i in 0..<hostsArray.count {
            let host = hostsArray[i]
            
            let hostView = EventDetailHostView(frame: CGRect())
            hostView.translatesAutoresizingMaskIntoConstraints = false
            hostView.label.text = host.name
            hostView.imageView.image = UIImage(named: "placeholder_profile_image")
            hostView.button.tag = i
            hostView.button.addTarget(self, action: #selector(hostButtonTouched), for: .touchUpInside)
            contentView.addSubview(hostView)
            
            if previousHostView != nil {
                hostView.topAnchor.constraint(equalTo: previousHostView!.bottomAnchor).isActive = true
            } else {
                hostView.topAnchor.constraint(equalTo: hostsTitleLabel.bottomAnchor, constant: 4).isActive = true
            }
            
            hostView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            hostView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            hostView.heightAnchor.constraint(equalToConstant: EventDetailHostView.preferredHeight).isActive = true
            
            if i == hostsArray.count - 1 {
                hostView.bottomAnchor.constraint(equalTo: reportButton.topAnchor, constant: -10).isActive = true
            }
            
            previousHostView = hostView
        }
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 88).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        
        favoriteButton.widthAnchor.constraint(equalToConstant: 47).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        favoriteButton.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -6).isActive = true
        favoriteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -14).isActive = true
        
        favoriteActivityIndicator.centerXAnchor.constraint(equalTo: favoriteButton.centerXAnchor).isActive = true
        favoriteActivityIndicator.topAnchor.constraint(equalTo: favoriteButton.bottomAnchor, constant: 10).isActive = true
        
        aboutLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        aboutLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        aboutLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        
        timeTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        timeTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        timeTitleLabel.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 34).isActive = true
        
        timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        timeLabel.topAnchor.constraint(equalTo: timeTitleLabel.bottomAnchor, constant: 8).isActive = true
        
        ticketTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        ticketTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        ticketTitleLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 34).isActive = true
        
        ticketLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        ticketLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        ticketLabel.topAnchor.constraint(equalTo: ticketTitleLabel.bottomAnchor, constant: 8).isActive = true
        
        ticketButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        ticketButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        ticketButton.topAnchor.constraint(equalTo: ticketTitleLabel.bottomAnchor, constant: 8).isActive = true
        ticketButton.heightAnchor.constraint(equalToConstant: PrimaryCTA.preferedHeight).isActive = true
        
        locationTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        locationTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        locationTopContraint = locationTitleLabel.topAnchor.constraint(equalTo: ticketLabel.bottomAnchor, constant: 34)
        locationTopContraint.isActive = true
        
        locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        locationLabel.topAnchor.constraint(equalTo: locationTitleLabel.bottomAnchor, constant: 8).isActive = true
        
        mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        mapButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor).isActive = true
        mapButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor).isActive = true
        mapButton.topAnchor.constraint(equalTo: mapView.topAnchor).isActive = true
        mapButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        
        hostsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        hostsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        hostsTitleLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 30).isActive = true
        
        reportButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        reportButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        reportButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        reportButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        
        scrollView.addSubview(contentView)
        
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.event.managedObjectContext == nil {
            self.navigationController?.popViewController(animated: false)
        }
        updateContent()
    }
    
    func updateImageView() {
        guard let image = imageView.image else {
            return
        }
        
        contentView.removeFromSuperview()
        
        let imageSize = image.size
        let ratio = imageSize.height / imageSize.width
        
        let width = UIScreen.main.bounds.width
        let imageHeight = width * ratio
        
        topPanelView.translatesAutoresizingMaskIntoConstraints = false
        topPanelView.topPanelHeight = imageHeight
        topPanelView.updateContent(topPanel: imageView, scrollableView: contentView)
        view.addSubview(topPanelView)
        
        topPanelView.topAnchor.constraint(equalTo: view.topAnchor, constant: 88).isActive = true
        topPanelView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        topPanelView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topPanelView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func updateContent() {
        let imageURL = event.fullImageURL()
        let url = URL(string: imageURL)
        imageView.kf.setImage(with: url) { result in
            switch result {
            case .success(_):
                self.updateImageView()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        titleLabel.text = event.name?.capitalized
        updateFavoriteButton()
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
        var timeString = ""
        
        if let startTime = event.startTime {
            if event.repeatRules().repeatingDays().count == 0 {
                timeString = DateStringHelper.fullDescription(of: startTime as Date)
            } else {
                timeString = "\(event.repeatRules().rules(abreviated: false)) - \(timeFormatter.string(from: startTime))"
               
            }
            
            if let endTime = event.endTime {
                timeString += " - \(timeFormatter.string(from: endTime))"
            }
        }
        
        timeLabel.text = timeString

        let textContent = event.about ?? ""
        guard let font = UIFont.body() else {
            return
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2.5
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle
            ])
        aboutLabel.attributedText = textString
        if let locationName = event.locationName {
            var locationString = locationName
            if let address = event.address {
                //TODO: Find a way to do this that is smarter.
                locationString += "\n\(address.replacingOccurrences(of: ", United States", with: ""))"
            }
            locationLabel.text = locationString
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        let priceString = event.price == 0 ? "Free" : numberFormatter.string(from: NSNumber(value: event.price))
        
        ticketLabel.text = priceString
        ticketButton.setTitle(priceString, for: .normal)
        
        if event.ticketURL?.count ?? 0 > 0 {
            ticketButton.alpha = 1
            locationTopContraint.constant = 54
        } else {
            ticketButton.alpha = 0
            locationTopContraint.constant = 34
        }
        
        let coordinate = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = event.locationName
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        mapView.region = region
    }
    
    func updateFavoriteButton() {
        self.event.favorited() ? favoriteButton.setImage(UIImage(named: "heart"), for: .normal) : favoriteButton.setImage(UIImage(named: "emptyHeart"), for: .normal)
    }
    
    //MARK: Map View Delegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "mapPin")
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    //MARK: Actions
    
    @objc func favoriteButtonTouched() {
        favoriteActivityIndicator.startAnimating()
        favoriteButton.isUserInteractionEnabled = false
        EventManager.toggleFavorite(event: event, onSuccess: {
            self.updateFavoriteButton()
            self.favoriteActivityIndicator.stopAnimating()
            self.favoriteButton.isUserInteractionEnabled = true
        }) { (error) in
            //TODO: Display this error to the user
            print("Error setting favorite")
            self.favoriteActivityIndicator.stopAnimating()
            self.favoriteButton.isUserInteractionEnabled = true
        }
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
    
    @objc func hostButtonTouched(sender: UIButton) {
        let hostsArray = event.sortedHosts()
        let host = hostsArray[sender.tag]
        //TODO: Present Host View.
        print("Show Host: \(host.name!)")
    }
    
    @objc func ticketButtonTouched() {
        guard let url = URL(string: event.ticketURL ?? "") else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func mapButtonTouched() {
        let latitude: CLLocationDegrees = event.latitude
        let longitude: CLLocationDegrees = event.longitude
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = event.locationName
        mapItem.openInMaps(launchOptions: options)
    }
}

class EventDetailHostView : UIView {
    let imageView = UIImageView()
    let label = UILabel()
    let button = UIButton()
    static let preferredHeight: CGFloat = 40
    private static let imageViewSize: CGFloat = 30
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = EventDetailHostView.imageViewSize / 2
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.headerTwo()
        label.textColor = UIColor.primaryCopy()
        addSubview(label)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: EventDetailHostView.imageViewSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: EventDetailHostView.imageViewSize).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class EventDetailCarousel : UIView {
    static let preferedHeight: CGFloat = 202.0
    private var imageViews = [UIImageView]()
    private let scrollView = UIScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        updateContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateContent() {
        for imageView in imageViews {
            imageView.removeFromSuperview()
        }
        
        imageViews.removeAll()
        
        var previousImageView: UIImageView?
        
        for i in 0..<4 {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "eventPlaceholder\(i)")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            scrollView.addSubview(imageView)
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            imageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
            
            if previousImageView != nil {
                imageView.leadingAnchor.constraint(equalTo: previousImageView!.trailingAnchor).isActive = true
                imageView.widthAnchor.constraint(equalTo: previousImageView!.widthAnchor).isActive = true
            } else {
                imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
                imageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            }
            
            if i == 3 {
                imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
            }
            
            previousImageView = imageView
        }
    }
}
