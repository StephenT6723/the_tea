//
//  RepeatEditViewController.swift
//  TheTea
//
//  Created by Stephen Thomas on 10/26/18.
//  Copyright © 2018 The Tea LLC. All rights reserved.
//

import UIKit

class RepeatEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView(frame: CGRect(), style: UITableView.Style.grouped)
    var rules = EventRepeatRules()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Repeats"
        
        view.backgroundColor = .clear
        
        //table view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RepeatTableViewCell.self, forCellReuseIdentifier: String(describing: RepeatTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.reloadData()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    //MARK: Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DaysOfTheWeek.allCases.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepeatTableViewCell.self), for: indexPath) as? RepeatTableViewCell else {
            return RepeatTableViewCell()
        }
        
        let allDays = DaysOfTheWeek.allCases
        let repeatingDays = rules.repeatingDays()
        
        if indexPath.row == DaysOfTheWeek.allCases.count {
            cell.titleLabel.text = "NEVER"
            
            cell.radioButton.isSelected = repeatingDays.count == 0
            
            return cell
        }
        
        let day = allDays[indexPath.row]
        
        cell.titleLabel.text = day.plural().uppercased()
        
        cell.radioButton.isSelected = repeatingDays.contains(day)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == DaysOfTheWeek.allCases.count {
            rules.neverRepeat()
        } else {
            let allDays = DaysOfTheWeek.allCases
            let day = allDays[indexPath.row]
            rules.toggleDay(day: day)
        }
        
        tableView.reloadData()
    }
}

class RepeatTableViewCell: UITableViewCell {
    let titleLabel = UILabel()
    let radioButton = RadioButton(frame: CGRect())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        radioButton.isUserInteractionEnabled = false
        contentView.addSubview(radioButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.cta()
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        radioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 36).isActive = true
        radioButton.heightAnchor.constraint(equalToConstant: RadioButton.preferedSize).isActive = true
        radioButton.widthAnchor.constraint(equalToConstant: RadioButton.preferedSize).isActive = true
        radioButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
