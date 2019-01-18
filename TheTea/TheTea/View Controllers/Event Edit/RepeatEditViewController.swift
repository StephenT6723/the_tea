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
        
        view.backgroundColor = .white
        
        //table view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RepeatTableViewCell.self, forCellReuseIdentifier: String(describing: RepeatTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.reloadData()
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
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepeatTableViewCell.self), for: indexPath) as? RepeatTableViewCell else {
            return RepeatTableViewCell()
        }
        
        let allDays = DaysOfTheWeek.allCases
        let repeatingDays = rules.repeatingDays()
        
        if indexPath.row == DaysOfTheWeek.allCases.count {
            cell.titleLabel.text = "NEVER"
            
            if repeatingDays.count == 0 {
                cell.titleLabel.textColor = UIColor.primaryCopy()
            } else {
                cell.titleLabel.textColor = UIColor.lightCopy()
            }
            
            cell.accessoryType = .none
            
            return cell
        }
        
        let day = allDays[indexPath.row]
        
        cell.titleLabel.text = day.plural().uppercased()
        if repeatingDays.contains(day) {
            cell.titleLabel.textColor = UIColor.primaryCopy()
            cell.accessoryType = .checkmark
        } else {
            cell.titleLabel.textColor = UIColor.lightCopy()
            cell.accessoryType = .none
        }
        
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.cta()
        titleLabel.textColor = UIColor.primaryCopy()
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
