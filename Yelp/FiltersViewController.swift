//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Josh Jeong on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String: AnyObject])
}

class FiltersViewController: UIViewController, FiltersViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    var foodCategories = [[String:String]]()
    var switchStates = [IndexPath: Bool]()
    var filterData = [("Sort By", [["title" : "Best Match", "filter_type": "sort", "value": 0],
                                   ["title" : "Distance", "filter_type": "sort", "value": 1],
                                   ["title" : "Highest Rated", "filter_type": "sort", "value": 2]]),
                      ("Offering Deal", [["title" : "Offering Deal", "filter_type": "deals_filter", "value": 0]]),
                      ("Distance", [["title" : "0.3 miles", "filter_type": "radius_filter", "value": 0.3],
                                    ["title" : "1 mile", "filter_type": "radius_filter", "value": 1],
                                    ["title" : "5 miles", "filter_type": "radius_filter", "value": 5],
                                    ["title" : "20 miles", "filter_type": "radius_filter", "value": 20]])
                    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        foodCategories = Category().getFoodCategories()
        filterData.append(("Categories", foodCategories))
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "FilterTableHeaderView")
    }

    @IBAction func onCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSearchButton(_ sender: UIBarButtonItem) {
        var filters = [String: AnyObject]()
        var categoryFilters = [String]()
        for (row, isSelected) in switchStates {
            let filterSectionIndex = row[0]
            let filterIndex = row[1]
            let filterSection = filterData[filterSectionIndex].1
            let filterType = filterSection[filterIndex]["filter_type"] as! String
            let filterValue = filterSection[filterIndex]["value"] as AnyObject
   
            if isSelected {
                switch filterType {
                    case "category_filter":
                        categoryFilters.append(filterValue as! String)
                        break
                    case "deals_filter":
                        filters[filterType] = switchStates[row] as AnyObject?
                        break
                    default:
                        filters[filterType] = filterValue
                        break
                }
            }
        }
        
        if categoryFilters.count > 0 {
            filters["category_filter"] = categoryFilters as AnyObject?
        }
        
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
        dismiss(animated: true, completion: nil)
    }
}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource, SwitchTableViewCellDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return filterData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterData[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableViewCell", for: indexPath) as! SwitchTableViewCell
        let filtersInSection = filterData[indexPath.section].1

        cell.delegate = self
        cell.switchLabel.text = filtersInSection[indexPath.row]["title"] as? String ?? ""
        cell.onSwitch.isOn = switchStates[indexPath] ?? false
        cell.selectionStyle = .none
        return cell
    }
    
    func switchTableViewCell(switchTableViewCell: SwitchTableViewCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchTableViewCell)!
        let filterSection = indexPath.section
        
    
        if filterSection == 0 || filterSection == 2 {
            for filter in switchStates {
                if filter.key[0] == filterSection {
                    switchStates.removeValue(forKey: filter.key)
                }
            }
        }
        
        switchStates[indexPath] = value
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FilterTableHeaderView")! as UITableViewHeaderFooterView
        header.textLabel?.text = filterData[section].0
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
