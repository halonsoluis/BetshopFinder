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

    func newRegionVisible(region: MKCoordinateRegion, existingAnnotations: [Betshop]) async throws {

        let boundingBox = self.boundingBox(for: region)

        let newBetshopsFromAPI = try await betshopAPI
            .stores(in: boundingBox)
            .filterThoseNotIn(existingAnnotations: existingAnnotations)
            .map(Betshop.init)


        let model = MapViewViewModel(
            annotations: newBetshopsFromAPI,
            mapRegion: region,
            selected: viewModel?.selected
        )

        viewModel = model

        mapView?.update(with: model)
    }

    func newSelection(store: Betshop?) {
        var model = viewModel!
        model.selected = store

        viewModel = model
        updateViewInTheMainThread(model: model)
    }

    private func updateViewInTheMainThread(model: MapViewViewModel) {
        if Thread.isMainThread {
            mapView?.update(with: model)
        } else {
            DispatchQueue.main.async { [self] in
                mapView?.update(with: model)
            }
        }

    }
}

extension Array where Element == BetshopModel {
    func filterThoseNotIn(existingAnnotations: [Betshop]) -> [BetshopModel] {
        let newAnnotationsIds = Set(self.map(\.id))
        let oldAnnotationsIds = Set(existingAnnotations.map(\.id))

        let alreadyInMap = newAnnotationsIds.intersection(oldAnnotationsIds)
        let newlyArrived = newAnnotationsIds.subtracting(alreadyInMap)

        return self.filter { newlyArrived.contains($0.id) }
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

extension BetshopModel: Identifiable {}
