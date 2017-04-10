//
//  MapViewController.swift
//  Yelp
//
//  Created by Josh Jeong on 4/10/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var businessLocations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapBusinesses()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func mapBusinesses() {
        for location in businessLocations {
            let annotation = MKPointAnnotation()
            annotation.title = location.title
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            mapView.addAnnotation(annotation)
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
}
