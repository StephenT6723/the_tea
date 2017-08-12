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
        
        //setup table view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EventListTableViewCell.self, forCellReuseIdentifier: EventListTableViewCell.self.description())
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventListTableViewCell.self.description(), for: indexPath) as? EventListTableViewCell else {
            return EventListTableViewCell()
        }
        
        let event = eventsFRC.object(at: indexPath)
        cell.textLabel?.text = event.name
        return cell
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
        guard let updatedIndexPath = indexPath, let updatedNewIndexPath = newIndexPath else {
            return
        }
        
        switch type {
        case .insert:
            tableView.insertRows(at: [updatedNewIndexPath], with: .fade)
        case .delete:
            tableView.deleteRows(at: [updatedIndexPath], with: .fade)
        case .update:
            tableView.reloadRows(at: [updatedIndexPath], with: .fade)
        case .move:
            tableView.moveRow(at: updatedIndexPath, to: updatedNewIndexPath)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
