//
//  EventListViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/11/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit
import CoreData

class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, EventCollectionCarouselDelegate {
    private let tableView = UITableView(frame: CGRect(), style: UITableViewStyle.grouped)
    private let timeFormatter = DateFormatter()
    private let weekdayFormatter = DateFormatter()
    private let dateFormatter = DateFormatter()
    private let maxEventsPerDay = 3
    var eventsFRC = NSFetchedResultsController<Event>() {
        didSet {
            eventsFRC.delegate = self
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "The Gay Agenda".uppercased()
        //edgesForExtendedLayout = UIRectEdge()
        view.backgroundColor = .white

        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
        weekdayFormatter.dateFormat = "EEEE"
        dateFormatter.dateFormat = "MMM d"
        
        //navigation buttons
        let createButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEventTapped))
        navigationItem.rightBarButtonItem = createButton
        
        //setup table view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 50
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tableView.backgroundColor = UIColor.lightBackground()
        tableView.register(EventListTableViewCell.self, forCellReuseIdentifier: String(describing: EventListTableViewCell.self))
        tableView.register(EventListHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: EventListHeaderView.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.clipsToBounds = false
        view.addSubview(tableView)
        
        //carousel
        let carouselHeader = EventCollectionCarouselHeaderView(frame: CGRect(x:0, y:0, width:300, height: EventCollectionCarouselHeaderView.preferedHeight))
        carouselHeader.carousel.delegate = self
        tableView.tableHeaderView = carouselHeader
        
        //layout
        let margins = view.layoutMarginsGuide
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    //MARK: Actions
    
    @objc func addEventTapped() {
        let addEventVC = EventEditViewController()
        let addNav = UINavigationController(rootViewController: addEventVC)
        addNav.navigationBar.isTranslucent = false
        present(addNav, animated: true, completion: nil)
    }
    
    @objc func myAccountTapped() {
        let loginVC = MyAccountViewController()
        let loginNav = UINavigationController(rootViewController: loginVC)
        loginNav.navigationBar.isTranslucent = false
        present(loginNav, animated: true, completion: nil)
    }
    
    //MARK: Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = eventsFRC.sections else {
            return 0
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = eventsFRC.sections else {
            return 0
        }
        
        guard section < sections.count else {
            return 0
        }
    
        let sectionInfo = sections[section]
        let rowCount = sectionInfo.numberOfObjects > maxEventsPerDay ? maxEventsPerDay : sectionInfo.numberOfObjects
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
        guard let sectionInfo = eventsFRC.sections?[section] else { return header }
        
        let todayString = DateStringHelper.dataString(from: Date())
        
        let dataString = sectionInfo.name
        guard let sectionDate = DateStringHelper.date(from: dataString) else { return header }
        
        if todayString == dataString {
            header.titleLabel.text = "TODAY"
        } else {
            header.titleLabel.text = weekdayFormatter.string(from: sectionDate).uppercased()
        }
        
        header.subTitleLabel.text = dateFormatter.string(from: sectionDate)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventListTableViewCell.self), for: indexPath) as? EventListTableViewCell else {
            return EventListTableViewCell()
        }
        
        let event = eventsFRC.object(at: indexPath)
        cell.titleLabel.text = event.name
        cell.subTitleLabel.text = EventListTableViewCell.subTitle(for: event, timeFormatter: timeFormatter)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = eventsFRC.object(at: indexPath)
        let detailVC = EventDetailViewController(event:event)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //MARK: FRC Delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.reloadData()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //MARK: Carousel Delegate
    
    func numberOfCollectionsIn(carousel: EventCollectionCarousel) -> Int {
        return 4
    }
    
    func image(for carousel: EventCollectionCarousel, atIndex: Int) -> UIImage {
        return UIImage()
    }
    
    func carousel(_ carousel: EventCollectionCarousel, didSelectIndex: Int) {
        
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
