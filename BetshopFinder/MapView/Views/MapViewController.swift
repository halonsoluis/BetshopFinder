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
    var detailView: UIViewController?

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
            deselectAnnotation()
            return
        }

        presentDetails(store: selected)

        guard !selectedAnnotations.contains(selected) else {
            return
        }

        if !selectedAnnotations.isEmpty && !selectedAnnotations.contains(selected) {
            deselectAnnotation()
        }
    }

    func deselectAnnotation() {
        map.deselectAnnotation(map.selectedAnnotations.first, animated: true)

        guard let detailView = detailView else {
            return
        }
        detailView.dismiss(animated: true) {
            detailView.removeFromParent()
            detailView.view.removeFromSuperview()
            self.detailView = nil
        }

    }

    func presentDetails(store: Betshop) {
        guard detailView == nil else {
            return
        }

        let detailView = DetailView().makeUI(store)
        detailView.view.backgroundColor = .clear
        addChild(detailView)
        view.addSubview(detailView.view)

        self.detailView = detailView

        guard let infoView = detailView.view else {
            return
        }
        infoView.translatesAutoresizingMaskIntoConstraints = false

        infoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        infoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        infoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive =  true

    }
}

extension MapViewController: MapView {
    func update(with model: MapViewViewModel) {
        updateRegion(region: model.mapRegion)
        updateAnnotations(annotations: model.annotations, selected: model.selected)
    }
}
