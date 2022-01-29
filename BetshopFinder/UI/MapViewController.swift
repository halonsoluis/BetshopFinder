//
//  MapViewController.swift
//  BetshopFinder
//
//  Created by Hugo Alonso on 29/01/2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet var map: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMap()
    }

    func configureMap() {
        map.delegate = self
    }

    func update(with model: MapViewViewModel) {
        map.setRegion(model.mapRegion, animated: false)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {

    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {

    }
}
