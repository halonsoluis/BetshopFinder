//
//  BetshopAPIAdapter.swift
//  BetshopFinder
//
//  Created by Hugo Alonso on 02/02/2022.
//

import Foundation
import BetshopAPI
import MapKit

struct BetshopAPIAdapter: BetshopStoresFinder {
    let betshopAPI: BetshopAPI

    func stores(in region: MKCoordinateRegion, excluding existingAnnotations: [Betshop]) async throws -> [Betshop] {
        try await betshopAPI
            .stores(in: boundingBox(for: region))
            .filterThoseNotIn(existingAnnotations: existingAnnotations)
            .map(Betshop.init)
    }

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

private extension Betshop {
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

private extension Array where Element == BetshopModel {
    func filterThoseNotIn(existingAnnotations: [Betshop]) -> [BetshopModel] {
        let newAnnotationsIds = Set(self.map(\.id))
        let oldAnnotationsIds = Set(existingAnnotations.map(\.id))

        let alreadyInMap = newAnnotationsIds.intersection(oldAnnotationsIds)
        let newlyArrived = newAnnotationsIds.subtracting(alreadyInMap)

        return self.filter { newlyArrived.contains($0.id) }
    }
}
