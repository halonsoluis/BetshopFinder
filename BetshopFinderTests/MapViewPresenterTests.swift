//
//  MapViewPresenterTests.swift
//  BetshopFinderTests
//
//  Created by Hugo Alonso on 29/01/2022.
//

import XCTest
import BetshopAPI
@testable import BetshopFinder
import CoreLocation
import MapKit

class MapViewPresenterTests: XCTestCase {

    func test_newRegionSelection_TriggersAnnotationRequest() async throws {
        let api = BetshopAPISpy()
        let view = MapViewSpy()
        let sut = MapViewPresenter(
            betshopStoresFinder: api,
            userLocation: UserLocationHandler(),
            router: Router(mainViewResolver: { nil }),
            mapView: view
        )

        try await sut.newRegionVisible(
            region: MapViewViewModel.defaultMunichLocation().mapRegion,
            existingAnnotations: []
        )

        XCTAssertEqual(api.storesDidCalledWithRegion.count, 1)
    }

    func test_newRegionSelection_triggersAnnotationRequestForNewOnes() async throws {
        let api = BetshopAPISpy()
        let view = MapViewSpy()
        let userLocation = UserLocationHandlerDummy()

        let sut = MapViewPresenter(
            betshopStoresFinder: api,
            userLocation: userLocation,
            router: Router(mainViewResolver: { nil }),
            mapView: view
        )

        api.storesReturnedModels = [Betshop(
            id: 2312,
            name: "name",
            address: "address",
            topLevelAddress: "topLevelAddress",
            coordinate: CLLocationCoordinate2D(latitude: 123.0, longitude: 123.0)
        )]

        try await sut.newRegionVisible(
            region: MapViewViewModel.defaultMunichLocation().mapRegion,
            existingAnnotations: []
        )

        XCTAssertEqual(view.updateCalledWithModel.count, 1)
        XCTAssertEqual(view.updateCalledWithModel.first?.annotations.map(\.id), [2312])
    }

}

private class UserLocationHandlerDummy: UserLocationHandler {
    override func startUpdating() {
        userLocation?(nil)
    }
}

private class MapViewSpy: MapView {
    var updateCalledWithModel: [MapViewViewModel] = []
    func update(with model: MapViewViewModel) {
        updateCalledWithModel.append(model)
    }
}

private class BetshopAPISpy: BetshopStoresFinder {
    var storesDidCalledWithRegion: [MKCoordinateRegion] = []
    var storesReturnedModels: [Betshop] = []

    func stores(in area: MKCoordinateRegion, excluding existingAnnotations: [Betshop]) async throws -> [Betshop] {
        storesDidCalledWithRegion.append(area)
        return storesReturnedModels
    }
}
