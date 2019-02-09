//
//  SplashViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 1/30/19.
//  Copyright © 2019 The Tea LLC. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    private let gradientLayer = CAGradientLayer()
    private let selectList = SingleSelectList(frame: CGRect())
    private var topConstraint = NSLayoutConstraint()
    private var citySelectView = UIView()
    private var loadingView = UIView()
    private let logoLoader = LogoLoader(frame: CGRect())
    let backgroundImageView = UIImageView(image: UIImage(named: "splash"))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        loadingView = updateLoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        
        citySelectView = updateCitySelectView()
        citySelectView.translatesAutoresizingMaskIntoConstraints = false
        citySelectView.alpha = 0
        view.addSubview(citySelectView)
        
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topConstraint = loadingView.topAnchor.constraint(equalTo: view.topAnchor)
        topConstraint.isActive = true
        loadingView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        citySelectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        citySelectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        citySelectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        citySelectView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        updateCities()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        logoLoader.animate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func updateLoadingView() -> UIView {
        let loadingView = UIView()
        
        let logoTopSpacer = UIView()
        let logoImageView = UIImageView(image: UIImage(named: "logoWhite"))
        let logoBottomSpacer = UIView()
        
        logoTopSpacer.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(logoTopSpacer)
        
        logoLoader.translatesAutoresizingMaskIntoConstraints = false
        logoLoader.contentMode = .scaleAspectFill
        loadingView.addSubview(logoLoader)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFill
        loadingView.addSubview(logoImageView)
        
        logoBottomSpacer.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(logoBottomSpacer)
        
        logoTopSpacer.topAnchor.constraint(equalTo: loadingView.topAnchor).isActive = true
        logoTopSpacer.bottomAnchor.constraint(equalTo: logoLoader.topAnchor).isActive = true
        
        logoLoader.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        logoLoader.heightAnchor.constraint(equalToConstant: LogoLoader.preferedSize).isActive = true
        logoLoader.widthAnchor.constraint(equalToConstant: LogoLoader.preferedSize).isActive = true
        
        logoImageView.topAnchor.constraint(equalTo: logoLoader.bottomAnchor, constant: 24).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        
        logoBottomSpacer.topAnchor.constraint(equalTo: logoImageView.bottomAnchor).isActive = true
        logoBottomSpacer.heightAnchor.constraint(equalTo: logoTopSpacer.heightAnchor).isActive = true
        logoBottomSpacer.bottomAnchor.constraint(equalTo: loadingView.bottomAnchor).isActive = true
        
        logoLoader.animate()
        
        return loadingView
    }
    
    func updateCitySelectView() -> UIView {
        let saveButton = UIButton()
        let missingCityButton = UIButton()
        let citySelectView = UIView()
        let welcomeLabel = UILabel()
        let chooseLocationLabel = UILabel()
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.text = "Welcome!"
        welcomeLabel.font = UIFont(name: "Montserrat-SemiBold", size: 32)
        welcomeLabel.textColor = .white
        citySelectView.addSubview(welcomeLabel)
        
        chooseLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        chooseLocationLabel.text = "Choose a Loction to Begin"
        chooseLocationLabel.font = UIFont(name: "Montserrat-Bold", size: 16)
        chooseLocationLabel.textColor = .white
        citySelectView.addSubview(chooseLocationLabel)
        
        selectList.translatesAutoresizingMaskIntoConstraints = false
        citySelectView.addSubview(selectList)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("SAVE", for: .normal)
        saveButton.titleLabel?.font = UIFont.cta()
        saveButton.setTitleColor(UIColor.primaryCTA(), for: .normal)
        saveButton.layer.cornerRadius = 5
        saveButton.backgroundColor = .white
        saveButton.addTarget(self, action: #selector(saveButtonTouched), for: .touchUpInside)
        citySelectView.addSubview(saveButton)
        
        missingCityButton.translatesAutoresizingMaskIntoConstraints = false
        missingCityButton.setTitle("Don't see your city? Let us know.", for: .normal)
        missingCityButton.titleLabel?.font = UIFont.cta()
        missingCityButton.addTarget(self, action: #selector(missingCityButtonTouched), for: .touchUpInside)
        citySelectView.addSubview(missingCityButton)
        
        welcomeLabel.topAnchor.constraint(equalTo: citySelectView.topAnchor, constant: 64).isActive = true
        welcomeLabel.centerXAnchor.constraint(equalTo: citySelectView.centerXAnchor).isActive = true
        
        chooseLocationLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 30).isActive = true
        chooseLocationLabel.centerXAnchor.constraint(equalTo: citySelectView.centerXAnchor).isActive = true
        
        selectList.leadingAnchor.constraint(equalTo: citySelectView.leadingAnchor).isActive = true
        selectList.trailingAnchor.constraint(equalTo: citySelectView.trailingAnchor).isActive = true
        selectList.topAnchor.constraint(equalTo: chooseLocationLabel.bottomAnchor, constant: 30).isActive = true
        selectList.bottomAnchor.constraint(equalTo: citySelectView.bottomAnchor).isActive = true
        
        missingCityButton.centerXAnchor.constraint(equalTo: citySelectView.centerXAnchor).isActive = true
        missingCityButton.bottomAnchor.constraint(equalTo: citySelectView.bottomAnchor, constant: -40).isActive = true
        
        saveButton.leadingAnchor.constraint(equalTo: citySelectView.leadingAnchor, constant: 40).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: citySelectView.trailingAnchor, constant: -40).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: missingCityButton.topAnchor, constant: -20).isActive = true
        
        return citySelectView
    }
    
    func setCitySelectVisible(_ visible: Bool) {
        selectList.delegate = self
        //topConstraint.constant = visible ? -1 * view.bounds.height : 0
        UIView.animate(withDuration: 0.5) {
          //  self.view.layoutIfNeeded()
            self.loadingView.alpha = visible ? 0 : 1
            self.citySelectView.alpha = visible ? 1 : 0
        }
    }
    
    @objc func saveButtonTouched() {
        let cities = CityManager.allCities()
        let city = cities[selectList.selectedIndex]
        CityManager.selectCity(city: city)
        setCitySelectVisible(false)
        updateEvents()
    }
    
    @objc func missingCityButtonTouched() {
        print("MISSING CITY")
        //TODO: Connect this
    }
    
    func updateCities() {
        CityManager.updateAllCities(onSuccess: {
            if CityManager.selectedCity() == nil {
                 self.setCitySelectVisible(true)
            } else {
                self.updateEvents()
            }
        }) { (error) in
            if CityManager.selectedCity() == nil {
                print("Error loading Cities. No selected City")
                let alert = UIAlertController(title: "Error", message: "Unable to update The Gay Agenda", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                    self.updateCities()
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                //even if the city select failed we skip to events if we already have a city selected
                self.updateEvents()
            }
        }
    }
    
    func updateEvents() {
        EventManager.updateUpcomingEvents(onSuccess: {
            self.dismiss(animated: true, completion: nil)
        }) { (error) in
            print("Error loading events")
            let alert = UIAlertController(title: "Error", message: "Unable to load new events", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
                self.updateEvents()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension SplashViewController: SingleSelectListDelegate {
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
