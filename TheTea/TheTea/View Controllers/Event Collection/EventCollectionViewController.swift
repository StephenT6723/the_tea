//
//  EventCollectionViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 3/29/18.
//  Copyright © 2018 The Tea LLC. All rights reserved.
//

import UIKit
import CoreData

enum CollectionSortType: String, CaseIterable {
    case hot = "Hot"
    case time = "Now"
    case new = "New"
    
    func sortDecriptors() -> [NSSortDescriptor] {
        var descriptors = [NSSortDescriptor]()
        
        switch self {
        case .hot:
            let hotnessSort = NSSortDescriptor(key: "hotness", ascending: false)
            descriptors.append(hotnessSort)
        case .time:
            let startTimeSort = NSSortDescriptor(key: "startTime", ascending: true)
            descriptors.append(startTimeSort)
        default:
            let locationSort = NSSortDescriptor(key: "dateCreated", ascending: false)
            descriptors.append(locationSort)
        }
        
        return descriptors
    }
}

class EventCollectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    private let tableView = UITableView(frame: CGRect(), style: UITableView.Style.grouped)
    private let segmentedControl = SegmentedControl()
    private let timeFormatter = DateFormatter()
    private var selectedSort: CollectionSortType {
        get {
            let cases = CollectionSortType.allCases
            return cases[segmentedControl.selectedIndex]
        }
    }
    var eventsFRC = NSFetchedResultsController<Event>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        
        //table view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 50
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tableView.backgroundColor = .white
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: String(describing: EventTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.clipsToBounds = false
        view.addSubview(tableView)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        var items = [String]()
        for sortType in CollectionSortType.allCases {
            items.append(sortType.rawValue)
        }
        segmentedControl.items = items
        segmentedControl.backgroundColor = UIColor(white: 1, alpha: 0.9)
        segmentedControl.addTarget(self, action: #selector(sortTapped), for: .valueChanged)
        view.addSubview(segmentedControl)
        
        //layout
        let margins = view.layoutMarginsGuide
        
        segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    //MARK: Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = eventsFRC.sections else {
            return 0
        }
        
        guard section < sections.count else {
            return 0
        }
        
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventTableViewCell.self), for: indexPath) as? EventTableViewCell else {
            return EventTableViewCell()
        }
        
        let event = eventsFRC.object(at: indexPath)
        if let url = event.fullImageURL() {
            cell.eventView.imageURL = url
        } else {
            cell.eventView.image = event.backupImage()
        }
        let subtitleColor = event.canceled ? UIColor(red:0.92, green:0.4, blue:0.4, alpha:1) : UIColor.lightCopy()
        cell.eventView.update(title: event.name, subtitle: event.subtitle(), subtitleColor: subtitleColor)
        cell.eventView.timeLabel.text = timeFormatter.string(from: event.startTime ?? Date())
        cell.eventView.placeLabel.text = event.locationName
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        let priceString = event.price == 0 ? "Free" : numberFormatter.string(from: NSNumber(value: event.price))
        cell.eventView.priceLabel.text = priceString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = eventsFRC.object(at: indexPath)
        let detailVC = EventDetailViewController(event:event)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //MARK: Actions
    
    @objc func sortTapped() {
        updateData()
    }
    
    func updateData() {
        let request = NSFetchRequest<Event>(entityName:"Event")
        request.predicate = eventsFRC.fetchRequest.predicate
        request.sortDescriptors = selectedSort.sortDecriptors()
        
        let context = CoreDataManager.sharedInstance.viewContext()
        let newFRC = NSFetchedResultsController<Event>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try newFRC.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        eventsFRC = newFRC
        tableView.reloadRows(at: tableView.indexPathsForVisibleRows ?? [], with: .none)
    }
}
