//
//  MapViewController.swift
//  BetshopFinder
//
//  Created by Hugo Alonso on 29/01/2022.
//

import UIKit
import MapKit
import BetshopAPI

class MapViewController: UIViewController {
    @IBOutlet var map: MKMapView!

    var presenter: MapViewPresenterProtocol?
    var mapHandler: MapHandler?

    override func viewDidLoad() {
        super.viewDidLoad()

        //This has to go to a composition root.
        presenter = MapViewPresenter()
        presenter?.mapView = ThreadSafeMapView(mapView: self)

        mapHandler = MapHandler(delegate: presenter as? MapHandlerDelegate)
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
            map.deselectAnnotation(map.selectedAnnotations.first, animated: true)
            return
        }

        presentDetails(store: selected)

        guard !selectedAnnotations.contains(selected) else {
            return
        }

        if !selectedAnnotations.isEmpty && !selectedAnnotations.contains(selected) {
            map.deselectAnnotation(map.selectedAnnotations.first, animated: true)
        }
    }

    func presentDetails(store: Betshop) {
        let view = DetailView().makeUI(store)

        self.definesPresentationContext = true
        self.modalPresentationStyle = .pageSheet

        view.view.backgroundColor = .clear

        present(view, animated: true, completion: nil)
    }
}

extension MapViewController: MapView {
    func update(with model: MapViewViewModel) {
        updateRegion(region: model.mapRegion)
        updateAnnotations(annotations: model.annotations, selected: model.selected)
    }
}
