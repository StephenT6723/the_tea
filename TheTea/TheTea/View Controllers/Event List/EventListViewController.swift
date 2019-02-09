//
//  EventListViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/11/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit
import CoreData

class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, EventCollectionCarouselDelegate, CarouselDelegate, CitySelectViewControllerDelegate {
    private let tableView = UITableView(frame: CGRect(), style: UITableView.Style.grouped)
    private let timeFormatter = DateFormatter()
    private let weekdayFormatter = DateFormatter()
    private let dateFormatter = DateFormatter()
    private let maxEventsPerDay = 3
    private var featuredCollections = EventCollectionManager.featuredEventCollections()
    private let quoteHeader = EventListTableViewHeader(frame: CGRect(x: 0, y: 0, width: 300, height: 208))
    private var showSplash = true
    var eventsFRC: NSFetchedResultsController<Event>? {
        didSet {
            eventsFRC?.delegate = self
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if EventManager.eventsStale() {
            EventManager.resetAllEvents()
            eventsFRC = nil
        }

        view.backgroundColor = .white

        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
        weekdayFormatter.dateFormat = "EEEE"
        dateFormatter.dateFormat = "MMM d"
        
        updateNavButtons()
        
        //table view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 50
        tableView.backgroundColor = .white
        tableView.register(EventCarouselTableViewCell.self, forCellReuseIdentifier: String(describing: EventCarouselTableViewCell.self))
        tableView.register(EventListHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: EventListHeaderView.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.clipsToBounds = false
        view.addSubview(tableView)
        
        //quote header
        quoteHeader.locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        tableView.tableHeaderView = quoteHeader
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        updateNavButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if showSplash {
            let splashVC = SplashViewController()
            present(splashVC, animated: false, completion: nil)
        } else {
            updateQuoteHeader()
            if eventsFRC == nil {
                eventsFRC = EventManager.allFutureEvents()
            }
            tableView.reloadData()
        }
        
        showSplash = false
    }
    
    //MARK: Actions
    
    @objc func seeAllTapped(sender: UIButton) {
        let section = sender.tag
        
        guard let sectionInfo = eventsFRC?.sections?[section] else { return }
        
        let sectionName = sectionInfo.name
        
        let eventCollectionVC = EventCollectionViewController()
        let selectedEventsFRC = EventManager.events(with: sectionName)
        eventCollectionVC.eventsFRC = selectedEventsFRC
        eventCollectionVC.title = "\(title(forHeader: section)), \(subTitle(forHeader: section))"
        navigationController?.pushViewController(eventCollectionVC, animated: true)
    }
    
    @objc func myProfileButtonTouched() {
        if !MemberDataManager.isLoggedIn() {
            let loginVC = LoginViewController()
            let loginNav = ClearNavigationController(rootViewController: loginVC)
            present(loginNav, animated: true, completion: nil)
            return
        }
        
        let myAccountVC = MyProfileViewController()
        let myAccountNav = UINavigationController(rootViewController: myAccountVC)
        present(myAccountNav, animated: true, completion: nil)
    }
    
    func updateQuoteHeader() {
        guard let selectedCity = CityManager.selectedCity() else {
            return
        }
        quoteHeader.updateContent(city: selectedCity)
    }
    
    func updateNavButtons() {
        let navImageView = UIImageView(image: UIImage(named: "navLogo"))
        navImageView.contentMode = .scaleAspectFill
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navImageView)
        
        let profileIconContainer = UIView()
        profileIconContainer.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        profileIconContainer.backgroundColor = UIColor.white
        profileIconContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        profileIconContainer.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.16).cgColor
        profileIconContainer.layer.shadowOpacity = 1
        profileIconContainer.layer.shadowRadius = 5
        profileIconContainer.layer.cornerRadius = 15
        
        let profileImageView = UIImageView(image: UIImage(named: "defaultAvatar"))
        profileImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFit
        profileIconContainer.addSubview(profileImageView)
        
        let profileButton = UIButton()
        profileButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        profileButton.addTarget(self, action: #selector(myProfileButtonTouched), for: .touchUpInside)
        profileIconContainer.addSubview(profileButton)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileIconContainer)
    }
    
    @objc func locationButtonTapped() {
        let locationVC = CitySelectViewController()
        locationVC.delegate = self
        let nav = ClearNavigationController(rootViewController: locationVC)
        present(nav, animated: true, completion: nil)
    }
    
    //MARK: Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = eventsFRC?.sections else {
            return 0
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: EventListHeaderView.self)) as? EventListHeaderView else {
            return EventListHeaderView()
        }
        
        header.titleLabel.text = title(forHeader: section)
        header.subTitleLabel.text = subTitle(forHeader: section)
        
        header.seeAllButton.tag = section
        header.seeAllButton.addTarget(self, action: #selector(seeAllTapped(sender:)), for: .touchUpInside)
        
        guard let sections = eventsFRC?.sections else {
            return nil
        }
        
        guard section < sections.count else {
            return nil
        }
        
        let sectionInfo = sections[section]
        
        header.seeAllButton.alpha = sectionInfo.numberOfObjects > maxEventsPerDay ? 1 : 0
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventCarouselTableViewCell.self), for: indexPath) as? EventCarouselTableViewCell else {
            return EventCarouselTableViewCell()
        }
        
        cell.carousel.tag = indexPath.section
        cell.carousel.delegate = self
        cell.carousel.updateContent()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let event = eventsFRC?.object(at: indexPath) else {
            return
        }
        let detailVC = EventDetailViewController(event:event)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //MARK: FRC Delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    //MARK: Collection Carousel Delegate
    
    func numberOfCollectionsIn(carousel: EventCollectionCarousel) -> Int {
        return featuredCollections.count
    }
    
    func collection(for carousel: EventCollectionCarousel, at index: Int) -> EventCollection? {
        if index < featuredCollections.count {
            let collection = featuredCollections[index]
            return collection
        }
        return nil
    }
    
    func carousel(_ carousel: EventCollectionCarousel, didSelect index: Int) {
        if index < featuredCollections.count {
            let collection = featuredCollections[index]
            
            let section = 0 //debug
            guard let sectionInfo = eventsFRC?.sections?[section] else { return } //debug
            let sectionName = sectionInfo.name //debug
            
            let eventCollectionVC = EventCollectionViewController()
            let selectedEventsFRC = EventManager.events(with: sectionName) //collection.eventsFRC(sortDescriptors: nil) debug
            eventCollectionVC.eventsFRC = selectedEventsFRC
            eventCollectionVC.title = collection.title?.uppercased()
            navigationController?.pushViewController(eventCollectionVC, animated: true)
        }
    }
    
    //MARK: Carousel Delegate
    
    func numberOfItemsIn(carousel: Carousel) -> Int {
        let index = carousel.tag
        
        guard let sections = eventsFRC?.sections else {
            return 0
        }
        
        guard index < sections.count else {
            return 0
        }
        
        let sectionInfo = sections[index]
        let rowCount = sectionInfo.numberOfObjects > maxEventsPerDay ? maxEventsPerDay : sectionInfo.numberOfObjects
        return rowCount
    }
    
    func view(for carousel: Carousel, at index: Int) -> UIView? {
        let section = carousel.tag
        let indexPath = IndexPath(row: index, section: section)
        
        guard let event = eventsFRC?.object(at: indexPath) else {
            return nil
        }
        
        let cellView = EventView(frame: CGRect())
        if let url = event.fullImageURL() {
            cellView.imageURL = url
        } else {
            cellView.image = event.backupImage()
        }
        let subtitleColor = event.canceled ? UIColor(red:0.92, green:0.4, blue:0.4, alpha:1) : UIColor.lightCopy()
        cellView.update(title: event.name, subtitle: event.subtitle(), subtitleColor: subtitleColor)
        cellView.timeLabel.text = timeFormatter.string(from: event.startTime ?? Date())
        cellView.placeLabel.text = event.locationName
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        let priceString = event.price == 0 ? "Free" : numberFormatter.string(from: NSNumber(value: event.price))
        cellView.priceLabel.text = priceString
        
        return cellView
    }
    
    func carousel(_ carousel: Carousel, didSelect index: Int) {
        let section = carousel.tag
        let indexPath = IndexPath(row: index, section: section)
        
        guard let event = eventsFRC?.object(at: indexPath) else {
            return
        }
        let detailVC = EventDetailViewController(event:event)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //MARK: City Select Delegate
    
    func citySelected(city: City) {
        quoteHeader.updateContent(city: city)
    }
    
    //MARK: Helpers
    
    func title(forHeader section: Int) -> String {
        guard let sectionInfo = eventsFRC?.sections?[section] else { return "" }
        
        let todayString = DateStringHelper.dataString(from: Date())
        
        let dataString = sectionInfo.name
        guard let sectionDate = DateStringHelper.date(from: dataString) else { return "" }
        
        if todayString == dataString {
            return "Today"
        }
        
        return weekdayFormatter.string(from: sectionDate).capitalized
    }
    
    func subTitle(forHeader section: Int) -> String {
        guard let sectionInfo = eventsFRC?.sections?[section] else { return "" }
        
        let dataString = sectionInfo.name
        guard let sectionDate = DateStringHelper.date(from: dataString) else { return "" }
        
        return dateFormatter.string(from: sectionDate).uppercased()
    }
}

class EventCollectionCarouselHeaderView: UIView {
    static let preferedHeight = 172
    let carousel = EventCollectionCarousel(frame: CGRect(x:0, y:0, width:300, height: EventCollectionCarouselHeaderView.preferedHeight))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        carousel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(carousel)
        
        carousel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        carousel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        carousel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        carousel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
