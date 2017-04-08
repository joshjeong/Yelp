//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Josh Jeong on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters fitlers: [String: AnyObject])
}

class FiltersViewController: UIViewController, FiltersViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    var categories = [[String:String]]()
    var switchSates = [Int:Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = Category().getList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSearchButton(_ sender: UIBarButtonItem) {
        var filters = [String: AnyObject]()
        var selectedCategories = [String]()
        for (row, isSelected) in switchSates {
            if isSelected {
                selectedCategories.append(categories[row]["alias"]!)
            }
            if selectedCategories.count > 0 {
                filters["categories"] = selectedCategories as AnyObject?
            }
        }
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
        dismiss(animated: true, completion: nil)
    }
}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource, SwitchTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableViewCell", for: indexPath) as! SwitchTableViewCell
        cell.switchLabel.text = categories[indexPath.row]["title"]
        cell.delegate = self
        
        cell.onSwitch.isOn = switchSates[indexPath.row] ?? false
        
        return cell
    }
    
    func switchTableViewCell(switchTableViewCell: SwitchTableViewCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchTableViewCell)!
        switchSates[indexPath.row] = value
    }
}
