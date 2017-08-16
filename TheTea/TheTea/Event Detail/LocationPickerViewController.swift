//
//  LocationPickerViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 8/15/17.
//  Copyright © 2017 The Tea LLC. All rights reserved.
//

import UIKit
import MapKit

//TODO: Add support for custom locations that don't match search any search results.

protocol LocationPickerViewControllerDelegate {
    func locationPicker(sender: LocationPickerViewController, selected location:EventLocation)
}

class LocationPickerViewController: UIViewController {
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    let tableView = UITableView()
    let searchBar = UISearchBar()
    var delegate: LocationPickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Place"
        edgesForExtendedLayout = UIRectEdge()
        searchCompleter.delegate = self
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTouched))
        navigationItem.leftBarButtonItem = cancelButton
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: String(describing: LocationTableViewCell.self))
        view.addSubview(tableView)
        
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    func cancelButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
}

extension LocationPickerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
}

extension LocationPickerViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension LocationPickerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LocationTableViewCell.self)) as? LocationTableViewCell {
            cell.textLabel?.text = searchResult.title
            cell.detailTextLabel?.text = searchResult.subtitle
            return cell
        }
        return UITableViewCell(style: .subtitle, reuseIdentifier: nil)
    }
}

extension LocationPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearchRequest(completion: completion)
        if let delegate = self.delegate {
            let searchResult = searchResults[indexPath.row]
            let locationName = searchResult.title
            let address = searchResult.subtitle
            
            if address.characters.count > 0 {
                let search = MKLocalSearch(request: searchRequest)
                search.start { (response, error) in
                    if let coordinate = response?.mapItems[0].placemark.coordinate {
                        let latitude = coordinate.latitude
                        let longitude = coordinate.longitude
                        let eventLocation = EventLocation(locationName: locationName, address: address, latitude: latitude, longitude: longitude)
                        delegate.locationPicker(sender: self, selected: eventLocation)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                let eventLocation = EventLocation(locationName: locationName, address: "", latitude: 0, longitude: 0)
                delegate.locationPicker(sender: self, selected: eventLocation)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

class LocationTableViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
