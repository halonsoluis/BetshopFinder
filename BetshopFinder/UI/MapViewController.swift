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
    var presenter: MapViewPresenterProtocol?
    private var lastRequest: UUID?

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = MapViewPresenter()
        presenter?.mapView = ThreadSafeMapView(mapView: self)

        configureMap()
        presenter?.viewIsLoaded()
    }

    func configureMap() {
        map.delegate = self
        map.register(BetshopAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }

    func update(with model: MapViewViewModel) {
        updateRegion(region: model.mapRegion)
        updateAnnotations(annotations: model.annotations, selected: model.selected)
    }

    func updateRegion(region: MKCoordinateRegion) {
        map.setRegion(region, animated: false)
    }

    func updateAnnotations(annotations: [Betshop], selected: Betshop?) {
        map.addAnnotations(annotations)

        let selectedAnnotations = map.selectedAnnotations.compactMap { $0 as? Betshop }

        guard let selected = selected else {
            map.deselectAnnotation(map.selectedAnnotations.first, animated: true)
            return
        }

        guard !selectedAnnotations.contains(selected) else {
            return
        }

        if !selectedAnnotations.isEmpty && !selectedAnnotations.contains(selected) {
            map.deselectAnnotation(map.selectedAnnotations.first, animated: true)
        }
    }

    private func retrieveAnnotationsFromMap() -> [Betshop] {
        let clusters = map.annotations.compactMap { $0 as? MKClusterAnnotation }
        let annotationsInClusters = clusters.map(\.memberAnnotations).joined().compactMap { $0 as? Betshop }
        let notClusteredAnnotations = map.annotations.compactMap { $0 as? Betshop }

        return annotationsInClusters + notClusteredAnnotations
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKClusterAnnotation) else {
            return mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: annotation)
        }

        guard !(annotation is Betshop) else {
            return mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation)
        }

        return nil
    }

    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        let cluster = MKClusterAnnotation(memberAnnotations: memberAnnotations)

        if memberAnnotations.count > 10 {
            cluster.title = (memberAnnotations.first as? Betshop)?.topLevelAddress
        } else {
            cluster.title = (memberAnnotations.first as? Betshop)?.address
        }

        return cluster
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let lastRequest = UUID()
        self.lastRequest = lastRequest
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            guard lastRequest == self.lastRequest else { return }

            Task {
                try await self.presenter?.newRegionVisible(
                    region: mapView.region,
                    existingAnnotations: self.retrieveAnnotationsFromMap()
                )
            }
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let view = view as? BetshopAnnotationView, let betshop = view.annotation as? Betshop else {
            return
        }
        view.image = UIImage(named: BetshopAnnotationView.imageSelected)
        presenter?.newSelection(store: betshop)
        map.showAnnotations([betshop], animated: true)
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let view = view as? BetshopAnnotationView else {
            return
        }

        view.image = UIImage(named: BetshopAnnotationView.imageNotSelected)
        presenter?.newSelection(store: nil)
    }
}
