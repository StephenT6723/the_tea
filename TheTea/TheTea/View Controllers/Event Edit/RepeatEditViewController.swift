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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "REPEATS"
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTouched))
        navigationItem.leftBarButtonItem = cancelButton
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTouched))
        navigationItem.rightBarButtonItem = saveButton
        
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
    
    //MARK: Actions
    
    @objc func cancelButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepeatTableViewCell.self), for: indexPath) as? RepeatTableViewCell else {
            return RepeatTableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Mondays"
        case 1:
            cell.titleLabel.text = "Tuesdays"
        case 2:
            cell.titleLabel.text = "Wednesdays"
        case 3:
            cell.titleLabel.text = "Thursdays"
        case 4:
            cell.titleLabel.text = "Fridays"
        case 5:
            cell.titleLabel.text = "Saturdays"
        default:
            cell.titleLabel.text = "Sunday"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let event = eventsFRC.object(at: indexPath)
        //let detailVC = EventDetailViewController(event:event)
        //navigationController?.pushViewController(detailVC, animated: true)
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
