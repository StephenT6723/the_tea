//
//  EventListViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/11/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit
import CoreData

class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, EventCollectionCarouselDelegate, CarouselDelegate {
    private let tableView = UITableView(frame: CGRect(), style: UITableView.Style.grouped)
    private let timeFormatter = DateFormatter()
    private let weekdayFormatter = DateFormatter()
    private let dateFormatter = DateFormatter()
    private let maxEventsPerDay = 3
    private var featuredCollections = EventCollectionManager.featuredEventCollections()
    private let carouselHeader = EventCollectionCarouselHeaderView(frame: CGRect(x:0, y:0, width:300, height: EventCollectionCarouselHeaderView.preferedHeight))
    private let noEventsView = NoEventsView(frame: CGRect())
    private let navActivityIndicator = UIActivityIndicatorView(style: .gray)
    var eventsFRC = NSFetchedResultsController<Event>() {
        didSet {
            eventsFRC.delegate = self
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "The Gay Agenda".uppercased()
        view.backgroundColor = .white

        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
        weekdayFormatter.dateFormat = "EEEE"
        dateFormatter.dateFormat = "MMM d"
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "navLogo"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navActivityIndicator)
        
        //table view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 50
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tableView.backgroundColor = .white
        tableView.register(EventCarouselTableViewCell.self, forCellReuseIdentifier: String(describing: EventCarouselTableViewCell.self))
        tableView.register(EventListHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: EventListHeaderView.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.clipsToBounds = false
        view.addSubview(tableView)
        
        //carousel
        carouselHeader.carousel.delegate = self
        tableView.tableHeaderView = carouselHeader
        
        noEventsView.translatesAutoresizingMaskIntoConstraints = false
        noEventsView.button.addTarget(self, action: #selector(retryEventFetch), for: .touchUpInside)
        noEventsView.alpha = 0
        view.addSubview(noEventsView)
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        noEventsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        noEventsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        noEventsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        noEventsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        NotificationCenter.default.addObserver(forName: .featuredUpdatedNotificationName, object: nil, queue: nil) { (notification: Notification) in
            self.updateCarouselContent()
        }
        
        updateCarouselContent()
        updateEvents()
    }
    
    //MARK: Actions
    
    @objc func seeAllTapped(sender: UIButton) {
        let section = sender.tag
        
        guard let sectionInfo = eventsFRC.sections?[section] else { return }
        
        let sectionName = sectionInfo.name
        
        let eventCollectionVC = EventCollectionViewController()
        let selectedEventsFRC = EventManager.events(with: sectionName)
        eventCollectionVC.eventsFRC = selectedEventsFRC
        eventCollectionVC.title = "\(title(forHeader: section)), \(subTitle(forHeader: section))"
        navigationController?.pushViewController(eventCollectionVC, animated: true)
    }
    
    func updateCarouselContent() {
        self.featuredCollections = EventCollectionManager.featuredEventCollections()
        self.carouselHeader.carousel.updateContent()
    }
    
    func updateEvents() {
        let eventRefreshNeeded = eventsFRC.fetchedObjects?.count == 0 || EventManager.eventsStale()
        if eventRefreshNeeded {
            noEventsView.alpha = 1
        } else {
            navActivityIndicator.startAnimating()
        }
        noEventsView.label.text = "FETCHING EVENTS"
        noEventsView.showLoader(animated: false)
        EventManager.updateUpcomingEvents(onSuccess: {
            UIView.animate(withDuration: 0.3, animations: {
                self.noEventsView.alpha = 0
            })
            self.navActivityIndicator.stopAnimating()
            self.tableView.reloadData()
        }) { (error) in
            self.noEventsView.label.text = "UNABLE TO FETCH EVENTS"
            self.noEventsView.showButton(animated: true)
            self.navActivityIndicator.stopAnimating()
            print("Error loading events")
            //TODO: Display this error somewhere when the no events view is hidden.
        }
    }
    
    @objc func retryEventFetch() {
        updateEvents()
    }
    
    //MARK: Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = eventsFRC.sections else {
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
        
        guard let sections = eventsFRC.sections else {
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = eventsFRC.object(at: indexPath)
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
            guard let sectionInfo = eventsFRC.sections?[section] else { return } //debug
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
        
        guard let sections = eventsFRC.sections else {
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
        
        let event = eventsFRC.object(at: indexPath)
        
        let cellView = EventView(frame: CGRect())
        cellView.image = UIImage(named: "eventPlaceholder1")
        cellView.subtitleLabel.text = "DRAG SHOW"
        cellView.titleLabel.text = event.name
        cellView.timeLabel.text = timeFormatter.string(from: event.startTime ?? Date())
        cellView.placeLabel.text = "Pieces Bar"
        
        return cellView
    }
    
    func carousel(_ carousel: Carousel, didSelect index: Int) {
        let section = carousel.tag
        let indexPath = IndexPath(row: index, section: section)
        
        let event = eventsFRC.object(at: indexPath)
        let detailVC = EventDetailViewController(event:event)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //MARK: Helpers
    
    func title(forHeader section: Int) -> String {
        guard let sectionInfo = eventsFRC.sections?[section] else { return "" }
        
        let todayString = DateStringHelper.dataString(from: Date())
        
        let dataString = sectionInfo.name
        guard let sectionDate = DateStringHelper.date(from: dataString) else { return "" }
        
        if todayString == dataString {
            return "Today"
        }
        
        return weekdayFormatter.string(from: sectionDate).capitalized
    }
    
    func subTitle(forHeader section: Int) -> String {
        guard let sectionInfo = eventsFRC.sections?[section] else { return "" }
        
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

class NoEventsView: UIView {
    let label = UILabel()
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    let button = PrimaryCTA(frame: CGRect())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.lightBackground()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.headerOne()
        label.textColor = UIColor.primaryCopy()
        label.textAlignment = .center
        label.numberOfLines = 0
        addSubview(label)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("RETRY", for: .normal)
        button.alpha = 0
        addSubview(button)
        
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30).isActive = true
        
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 170).isActive = true
        button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 34).isActive = true
        button.heightAnchor.constraint(equalToConstant: PrimaryCTA.preferedHeight).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func showButton(animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            self.button.alpha = 1
            self.activityIndicator.alpha = 0
        }
    }
    
    func showLoader(animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            self.button.alpha = 0
            self.activityIndicator.alpha = 1
        }
    }
}
