//
//  MapView2.swift
//  betshops
//
//  Created by Hugo Alonso on 28/01/2022.
//

import SwiftUI
import MapKit

struct MapView2: UIViewRepresentable {

    @EnvironmentObject private var viewModel: MapViewModel

    class Coordinator: NSObject, MKMapViewDelegate {

        var parent: MapView2

        init(_ parent: MapView2) {
            self.parent = parent
        }

        /// showing annotation on the map
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? Betshop else { return nil }

            return mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationView.ReuseID, for: annotation)
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            parent.viewModel.mapRegion = mapView.region

            _ = parent.viewModel.$annotations.sink { newStores in
                let newAnnotations = newStores

                guard let existingLocations = mapView.annotations as? [Betshop] else {
                    return
                }

                for change in newAnnotations.difference(from: existingLocations) {
                  switch change {
                  case let .remove(_, oldElement, _):
                      let selectedStores = mapView.selectedAnnotations.compactMap { $0 as? Betshop }
                      if !selectedStores.contains(oldElement) {
                          mapView.removeAnnotation(oldElement)
                      }
                  case let .insert(_, newElement, _):
                      mapView.addAnnotation(newElement)
                  }
                }
            }
        }


        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let betshop = view.annotation as? Betshop else { return }

            mapView.selectedAnnotations = [betshop]
            parent.viewModel.selected = betshop
            view.image = UIImage(named: "pin.selected")
        }

        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            view.image = UIImage(named: "pin")
            parent.viewModel.selected = nil
        }
    }

    func makeCoordinator() -> Coordinator {
        MapView2.Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        //  creating a map
        let view = MKMapView()
        // connecting delegate with the map
        view.delegate = context.coordinator
        view.setRegion(viewModel.mapRegion, animated: false)
        view.mapType = .standard

        view.register(AnnotationView.self, forAnnotationViewWithReuseIdentifier: AnnotationView.ReuseID)

        return view

    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
}

class AnnotationView: MKAnnotationView {

    static let ReuseID = "notSelectedBetshop"
    static let clusterID = "storesCluster"

    /// setting the key for clustering annotations
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        image = UIImage(named: "pin")
        clusteringIdentifier = Self.clusterID
        displayPriority = .defaultHigh
    }

    override func prepareForReuse() {
        image = UIImage(named: "pin")
        super.prepareForReuse()
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
