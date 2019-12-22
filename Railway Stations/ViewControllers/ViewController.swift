//
//  ViewController.swift
//  Railway Stations
//
//  Created by Karim Cordilia on 05/07/2019.
//  Copyright © 2019 Karim Cordilia. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var customCalloutView: UIView!
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var stationTypeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        RailwayServerNetworking.loadRailwayData { payload in
            DispatchQueue.main.async {
                payload.payload.forEach({ station in
                    self.placeAnnotation(station: station)
                })
            }
        }
    }
    
    func placeAnnotation(station: ServerStation) {
        guard
            let latitude = station.lat,
            let longitude = station.lng
            else { return }
        let annotation = MKPointAnnotation()
        annotation.title = station.namen.lang
        annotation.subtitle = station.stationType
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        self.mapView.addAnnotation(annotation)
    }

}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView?.canShowCallout = true
        annotationView?.detailCalloutAccessoryView = customCalloutView
        annotationView?.clusteringIdentifier = identifier
        annotationView?.glyphImage = UIImage(named: "train")
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard
            let annotation = view.annotation,
            let title = annotation.title,
            let subtitle = annotation.subtitle,
            let unwrappedTitle = title,
        let unwrappedSubtitle = subtitle
            else { return }
        stationNameLabel.text = unwrappedTitle
        stationTypeLabel.text = unwrappedSubtitle.capitalized.replacingOccurrences(of: "_", with: " ")
    }
}

