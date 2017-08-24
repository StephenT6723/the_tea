//
//  EventListViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/11/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit
import CoreData

class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    private let tableView = UITableView()
    var eventsFRC = NSFetchedResultsController<Event>() {
        didSet {
            eventsFRC.delegate = self
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "The Tea"
        edgesForExtendedLayout = UIRectEdge()
        view.backgroundColor = .white
        
        //navigation buttons
        let createButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEventTapped))
        navigationItem.rightBarButtonItem = createButton
        
        let accountButton = UIBarButtonItem(title: "My Account", style: .plain, target: self, action: #selector(myAccountTapped))
        navigationItem.leftBarButtonItem = accountButton
        
        //setup table view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EventListTableViewCell.self, forCellReuseIdentifier: String(describing: EventListTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        //layout
        let margins = view.layoutMarginsGuide
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    //MARK: Actions
    
    func addEventTapped() {
        let addEventVC = EventEditViewController()
        let addNav = UINavigationController(rootViewController: addEventVC)
        addNav.navigationBar.isTranslucent = false
        present(addNav, animated: true, completion: nil)
    }
    
    func myAccountTapped() {
        let profileVC = MyAccountViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.navigationBar.isTranslucent = false
        present(profileNav, animated: true, completion: nil)
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
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventListTableViewCell.self), for: indexPath) as? EventListTableViewCell else {
            return EventListTableViewCell()
        }
        
        let event = eventsFRC.object(at: indexPath)
        cell.textLabel?.text = event.name
        if let startTime = event.startTime {
            cell.detailTextLabel?.text = DateStringHelper.fullDescription(of: startTime as Date)
        }
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
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
