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
        removeDetailViewIfNeeded()
        map.deselectAnnotation(map.selectedAnnotations.first, animated: true)
    }

    func removeDetailViewIfNeeded() {
        guard let detailView = view.viewWithTag(Self.infoViewTag) else {
            return
        }
        detailView.removeFromSuperview()
    }

    func createDetailView(for store: Betshop) -> UIView {
        let detailView = DetailView()
            .makeUI(store)
        detailView.view.backgroundColor = .clear

        return detailView.view
    }

    private static let infoViewTag = 1234567890
    func attachViewAtTheBottom(_ bottomView: UIView) {
        view.addSubview(bottomView)

        bottomView.tag = Self.infoViewTag
        bottomView.translatesAutoresizingMaskIntoConstraints = false

        bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive =  true
    }

    func presentDetails(store: Betshop) {
        removeDetailViewIfNeeded()
        attachViewAtTheBottom(
            createDetailView(for: store)
        )
    }
}

extension MapViewController: MapView {
    func update(with model: MapViewViewModel) {
        updateRegion(region: model.mapRegion)
        updateAnnotations(annotations: model.annotations, selected: model.selected)
    }
}
