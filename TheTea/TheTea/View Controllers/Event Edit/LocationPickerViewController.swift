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
    
    let topDivider = UIView()
    let searchTextField = UITextField()
    var delegate: LocationPickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Location"
        
        edgesForExtendedLayout = []
        
        view.backgroundColor = .clear
        
        searchCompleter.delegate = self
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTouched))
        navigationItem.leftBarButtonItem = cancelButton
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.font = UIFont(name: "Montserrat-SemiBold", size: 20)
        searchTextField.textColor = .white
        searchTextField.tintColor = .white
        searchTextField.addTarget(self, action: #selector(searchTextUpdated), for: .editingChanged)
        view.addSubview(searchTextField)
        
        topDivider.translatesAutoresizingMaskIntoConstraints = false
        topDivider.backgroundColor = .white
        view.addSubview(topDivider)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: String(describing: LocationTableViewCell.self))
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        searchTextField.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 80).isActive = true
        
        topDivider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        topDivider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        topDivider.heightAnchor.constraint(equalToConstant: 2).isActive = true
        topDivider.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 8).isActive = true
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topDivider.bottomAnchor, constant: 10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextField.becomeFirstResponder()
    }
    
    @objc func cancelButtonTouched() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func searchTextUpdated() {
        if let searchText = searchTextField.text {
            searchCompleter.queryFragment = searchText
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LocationTableViewCell.self)) as? LocationTableViewCell {
            cell.customTitleLabel.text = searchResult.title
            cell.customSubtitleLabel.text = searchResult.subtitle
            return cell
        }
        return UITableViewCell(style: .subtitle, reuseIdentifier: nil)
    }
}

extension LocationPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearch.Request(completion: completion)
        if let delegate = self.delegate {
            let searchResult = searchResults[indexPath.row]
            let locationName = searchResult.title
            let address = searchResult.subtitle
            
            if address.count > 0 {
                let search = MKLocalSearch(request: searchRequest)
                search.start { (response, error) in
                    if let coordinate = response?.mapItems[0].placemark.coordinate {
                        let latitude = coordinate.latitude
                        let longitude = coordinate.longitude
                        let eventLocation = EventLocation(locationName: locationName, address: address, latitude: latitude, longitude: longitude)
                        delegate.locationPicker(sender: self, selected: eventLocation)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } else {
                let eventLocation = EventLocation(locationName: locationName, address: "", latitude: 0, longitude: 0)
                delegate.locationPicker(sender: self, selected: eventLocation)
                navigationController?.popViewController(animated: true)
            }
        }
    }
}

class LocationTableViewCell: UITableViewCell {
    let customTitleLabel = UILabel()
    let customSubtitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        customTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        customTitleLabel.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        customTitleLabel.textColor = .white
        contentView.addSubview(customTitleLabel)
        
        customSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        customSubtitleLabel.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        customSubtitleLabel.textColor = .white
        contentView.addSubview(customSubtitleLabel)
        
        customTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
        customTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40).isActive = true
        customTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        
        customSubtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
        customSubtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40).isActive = true
        customSubtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
