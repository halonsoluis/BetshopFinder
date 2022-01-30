//
//  MapHandler.swift
//  BetshopFinder
//
//  Created by Hugo Alonso on 29/01/2022.
//

import Foundation
import MapKit

protocol MapHandlerDelegate: AnyObject {
    func newRegionVisible(region: MKCoordinateRegion, existingAnnotations: [Betshop]) async throws
    func newSelection(store: Betshop?)
}

class MapHandler: NSObject, MKMapViewDelegate {
    private var lastRequest: UUID?
    private var delegate: MapHandlerDelegate?
    private let maximumLongitudeDeltaForPresentingAnnotations = 5.0

    init(delegate: MapHandlerDelegate?) {
        self.delegate = delegate
    }

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

        guard mapView.region.span.longitudeDelta < maximumLongitudeDeltaForPresentingAnnotations else {
            mapView.removeAnnotations(mapView.annotations)
            return
        }

        let lastRequest = UUID()
        self.lastRequest = lastRequest
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            guard lastRequest == self.lastRequest else { return }

            Task {
                try await self.delegate?.newRegionVisible(
                    region: mapView.region,
                    existingAnnotations: self.retrieveAnnotationsFromMap(map: mapView)
                )
            }
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let view = view as? BetshopAnnotationView, let betshop = view.annotation as? Betshop else {
            return
        }
        view.image = UIImage(named: BetshopAnnotationView.imageSelected)
        delegate?.newSelection(store: betshop)
        mapView.showAnnotations([betshop], animated: true)
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let view = view as? BetshopAnnotationView else {
            return
        }

        view.image = UIImage(named: BetshopAnnotationView.imageNotSelected)
        delegate?.newSelection(store: nil)
    }

    private func retrieveAnnotationsFromMap(map: MKMapView) -> [Betshop] {
        let clusters = map.annotations.compactMap { $0 as? MKClusterAnnotation }
        let annotationsInClusters = clusters.map(\.memberAnnotations).joined().compactMap { $0 as? Betshop }
        let notClusteredAnnotations = map.annotations.compactMap { $0 as? Betshop }

        return annotationsInClusters + notClusteredAnnotations
    }
}
