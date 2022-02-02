//
//  MainCompositionRoot.swift
//  BetshopFinder
//
//  Created by Hugo Alonso on 30/01/2022.
//

import Foundation
import UIKit
import BetshopAPI
import MapKit

protocol MainRooter {
    func presentDetails(store: Betshop?)
}

final class MainCompositionRoot {

    private func createMapKitView() -> MapViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateInitialViewController() as! MapViewController
    }

    private func prepareMainView() -> UIViewController {
        let mapView = createMapKitView()
        let router = Router(mainViewResolver: { mapView.view })
        let betshopStoresResolver = BetshopAPIAdapter(betshopAPI: SuperologyBetshopAPI.defaultBetshopAPI())

        let presenter = MapViewPresenter(
            betshopStoresResolver: betshopStoresResolver,
            userLocation: UserLocationHandler(),
            router: router,
            mapView: ThreadSafeMapView(mapView: mapView)
        )
        let mapHandler = MapHandler(delegate: presenter)

        mapView.mapHandler = mapHandler
        mapView.presenter = presenter

        return mapView
    }

    func createWindowFor(scene: UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: scene)
        window.rootViewController = prepareMainView()
        window.makeKeyAndVisible()
        return window
    }
}

protocol BetshopStoresFinder {
    func stores(in area: MKCoordinateRegion, excluding existingAnnotations: [Betshop]) async throws -> [Betshop]
}

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
extension BetshopModel: Identifiable {}
extension Betshop {
    fileprivate convenience init(model: BetshopModel) {
        self.init(
            id: model.id,
            name: model.name,
            address: model.address,
            topLevelAddress: model.topLevelAddress,
            coordinate: CLLocationCoordinate2D(latitude: model.location.lat, longitude: model.location.lng)
        )
    }
}

extension Array where Element == BetshopModel {
    fileprivate func filterThoseNotIn(existingAnnotations: [Betshop]) -> [BetshopModel] {
        let newAnnotationsIds = Set(self.map(\.id))
        let oldAnnotationsIds = Set(existingAnnotations.map(\.id))

        let alreadyInMap = newAnnotationsIds.intersection(oldAnnotationsIds)
        let newlyArrived = newAnnotationsIds.subtracting(alreadyInMap)

        return self.filter { newlyArrived.contains($0.id) }
    }
}
