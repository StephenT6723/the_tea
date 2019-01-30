//
//  CitySelectViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 1/26/19.
//  Copyright © 2019 The Tea LLC. All rights reserved.
//

import UIKit

protocol CitySelectViewControllerDelegate {
    func citySelected(city: City)
}

class CitySelectViewController: UIViewController, SingleSelectListDelegate {
    private let selectList = SingleSelectList(frame: CGRect())
    private let saveButton = UIButton()
    private let missingCityButton = UIButton()
    var delegate: CitySelectViewControllerDelegate?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Choose Location"
        view.backgroundColor = .clear
        if let nav = navigationController as? ClearNavigationController {
            nav.backgroundImageView.image = UIImage(named: "placeholderBackground")
        }
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTouched))
        cancelButton.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.cta() as Any,
                                             NSAttributedString.Key.foregroundColor:UIColor.white], for: .normal)
        cancelButton.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.cta() as Any,
                                             NSAttributedString.Key.foregroundColor:UIColor.white], for: .highlighted)
        navigationItem.leftBarButtonItem = cancelButton
        
        let cities = CityManager.allCities()
        
        selectList.translatesAutoresizingMaskIntoConstraints = false
        selectList.delegate = self
        if let selectedCity = CityManager.selectedCity() {
            selectList.updateSelectedIndex(animated: false, index: cities.firstIndex(of: selectedCity) ?? 0)
        }
        view.addSubview(selectList)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("SAVE", for: .normal)
        saveButton.titleLabel?.font = UIFont.cta()
        saveButton.setTitleColor(UIColor.primaryCTA(), for: .normal)
        saveButton.layer.cornerRadius = 5
        saveButton.backgroundColor = .white
        saveButton.addTarget(self, action: #selector(saveButtonTouched), for: .touchUpInside)
        view.addSubview(saveButton)
        
        missingCityButton.translatesAutoresizingMaskIntoConstraints = false
        missingCityButton.setTitle("Don't see your city? Let us know.", for: .normal)
        missingCityButton.titleLabel?.font = UIFont.cta()
        missingCityButton.addTarget(self, action: #selector(missingCityButtonTouched), for: .touchUpInside)
        view.addSubview(missingCityButton)
        
        selectList.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        selectList.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        selectList.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        selectList.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        missingCityButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        missingCityButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        
        saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: missingCityButton.topAnchor, constant: -20).isActive = true
    }
    
    //MARK: Actions
    
    @objc func cancelButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func missingCityButtonTouched() {
        print("MISSING CITY")
        //TODO: Connect this
    }
    
    @objc func saveButtonTouched() {
        let cities = CityManager.allCities()
        let city = cities[selectList.selectedIndex]
        if city != CityManager.selectedCity() {
            CityManager.selectCity(city: city)
            delegate?.citySelected(city: city)
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Single Select List Delegate
    
    func numberOfItemsIn(list: SingleSelectList) -> Int {
        let cities = CityManager.allCities()
        return cities.count
    }
    
    func view(for list: SingleSelectList, at index: Int) -> UIView {
        let cities = CityManager.allCities()
        let city = cities[index]
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        label.textColor = .white
        label.text = "\(city.name ?? ""), \(city.state ?? "")"
        view.addSubview(label)
        
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }
    
    func rowHeightIn(list: SingleSelectList) -> CGFloat {
        return 60
    }
}
