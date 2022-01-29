//
//  MapViewPresenter.swift
//  BetshopFinder
//
//  Created by Hugo Alonso on 29/01/2022.
//

import Foundation
import MapKit
import BetshopAPI
import SwiftUI

protocol MapView: AnyObject {
    func update(with model: MapViewViewModel)
}

class MapViewPresenter {
    weak var mapView: MapView?
    private let betshopAPI: BetshopAPI

    var viewModel: MapViewViewModel?

    init(betshopAPI: BetshopAPI) {
        self.betshopAPI = betshopAPI
    }

    func newRegionVisible(region: MKCoordinateRegion) async throws {

        let boundingBox = self.boundingBox(for: region)

        let betshopsFromAPI = try await betshopAPI.stores(in: boundingBox)

        let model = MapViewViewModel()
        model.annotations = betshopsFromAPI.map(Betshop.init)
        model.mapRegion = region
        model.selected = viewModel?.selected

        viewModel = model

        updateViewInTheMainThread(model: model)
    }

    func updateViewInTheMainThread(model: MapViewViewModel) {
        if Thread.isMainThread {
            mapView?.update(with: model)
        } else {
            DispatchQueue.main.async { [self] in
                mapView?.update(with: model)
            }
        }

    }
}


extension MapViewPresenter {
    private func boundingBox(for mapRegion: MKCoordinateRegion) -> Area {
        //Using approach found @ https://stackoverflow.com/a/12607213/2683201 for defining the bounding box
        let latMin = mapRegion.center.latitude - 0.5 * mapRegion.span.latitudeDelta;
        let latMax = mapRegion.center.latitude + 0.5 * mapRegion.span.latitudeDelta;
        let lonMin = mapRegion.center.longitude - 0.5 * mapRegion.span.longitudeDelta;
        let lonMax = mapRegion.center.longitude + 0.5 * mapRegion.span.longitudeDelta;

        return Area(
            topRight: Location(latitude: latMax, longitude: lonMax),
            bottomLeft: Location(latitude: latMin, longitude: lonMin)
        )
    }
}


extension Betshop {
    convenience init(model: BetshopModel) {
        self.init(
            id: model.id,
            name: model.name,
            address: model.address,
            topLevelAddress: model.topLevelAddress,
            coordinate: CLLocationCoordinate2D(latitude: model.location.lat, longitude: model.location.lng)
        )
    }
}
