//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BusinessesViewController: UIViewController, FiltersViewControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let searchBar = UISearchBar()
    let locationManager = CLLocationManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var businesses: [Business] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        createSearchBar()
        requestLocationAuthorization()
        getCurrentLocation()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        let sort = filters["sort"] as? Int ?? 0
        let categories = filters["category_filter"] as? [String] ?? nil
        let radius = filters["radius_filter"] as? Int ?? nil
        var dealsBool = false
        if let deals = filters["deals_filter"] as? Int {
            dealsBool = deals == 1
        }
        
        Business.searchWithTerm(term: "Restaurant", sort: YelpSortMode(rawValue: sort), categories: categories, deals: dealsBool, radius: radius, completion: { (businesses: [Business]?, error: Error?) -> Void in
            if let businesses = businesses {
                self.businesses = businesses
                self.tableView.reloadData()
            }
        })
    }
    
    func createSearchBar() {
        searchBar.placeholder = "Search..."
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    func searchBusiness(term: String) {
        Business.searchWithTerm(term: term, completion: { (businesses: [Business]?, error: Error?) -> Void in
            if let businesses = businesses {
                self.businesses = businesses
                self.tableView.reloadData()
            }
        })
    }
    
    func dismissKeyboard() {
        searchBar.text = ""
        searchBar.endEditing(true)
    }
    
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            appDelegate.currentLocation = locationManager.location?.coordinate
        }
        searchBusiness(term: "Restaurant")
    }
    
    @IBAction func didTapMapButton(_ sender: UIBarButtonItem) {
        var businessLocations = [Location]()
        for business in businesses {
            if let businessCoordinate = business.locationCoordinates {
                businessLocations.append(businessCoordinate)
            }
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        vc.businessLocations = businessLocations
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessTableViewCell", for: indexPath) as! BusinessTableViewCell
        cell.business = businesses[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissKeyboard()
        
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let term = searchBar.text {
            searchBusiness(term: term)
            dismissKeyboard()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
}
