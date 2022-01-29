//
//  MapViewController.swift
//  BetshopFinder
//
//  Created by Hugo Alonso on 29/01/2022.
//

import UIKit
import MapKit
import BetshopAPI

class MapViewController: UIViewController, MapView {

    @IBOutlet var map: MKMapView!
    var presenter: MapViewPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMap()
    }

    func configureMap() {
        map.delegate = self
        presenter = MapViewPresenter(betshopAPI: SuperologyBetshopAPI.defaultBetshopAPI())
        presenter?.mapView = self
    }

    func update(with model: MapViewViewModel) {
        map.setRegion(model.mapRegion, animated: true)
        setupAnnotationOnScreen(model.annotations, selected: model.selected)
        if let selected = model.selected {
            map.selectAnnotation(selected, animated: false)
        }
    }

    func setupAnnotationOnScreen(_ newAnnotations: [Betshop], selected: Betshop?) {
        for change in newAnnotations.difference(from: map.annotations as! [Betshop]) {
            switch change {
            case let .remove(_, oldElement, _):
                if oldElement != selected {
                    map.removeAnnotation(oldElement)
                }
            case let .insert(_, newElement, _):
                map.addAnnotation(newElement)
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        Task {
            try await presenter?.newRegionVisible(region: mapView.region)
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {

    }
}
