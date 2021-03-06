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

    var presenter: MapViewPresenterProtocol?
    var mapHandler: MapHandler?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMap()
        
        presenter?.viewIsLoaded()
    }

    private func configureMap() {
        map.delegate = mapHandler
        map.register(BetshopAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }

    private func updateRegion(region: MKCoordinateRegion) {
        map.setRegion(region, animated: false)
    }

    private func updateAnnotations(annotations: [Betshop], selected: Betshop?) {
        map.addAnnotations(annotations)

        let selectedAnnotations = map.selectedAnnotations.compactMap { $0 as? Betshop }

        guard let selected = selected else {
            deselectAnnotation()
            return
        }

        guard !selectedAnnotations.contains(selected) else {
            return
        }

        if !selectedAnnotations.isEmpty && !selectedAnnotations.contains(selected) {
            deselectAnnotation()
        }
    }

    func deselectAnnotation() {
        map.deselectAnnotation(map.selectedAnnotations.first, animated: true)
    }
}

extension MapViewController: MapView {
    func update(with model: MapViewViewModel) {
        updateRegion(region: model.mapRegion)
        updateAnnotations(annotations: model.annotations, selected: model.selected)
    }
}
