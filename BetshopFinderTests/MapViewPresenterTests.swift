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

class MapViewPresenterTests: XCTestCase {

    func test_newRegionSelection_TriggersAnnotationRequest() async throws {
        let api = BetshopAPISpy()
        let view = MapViewSpy()
        let sut = MapViewPresenter(
            betshopAPI: api,
            userLocation: UserLocationHandler(),
            router: Router(mainViewResolver: { nil }),
            mapView: view
        )

        try await sut.newRegionVisible(
            region: MapViewViewModel.defaultMunichLocation().mapRegion,
            existingAnnotations: []
        )

        XCTAssertEqual(api.storesDidCalledWithArea.count, 1)
    }

    func test_newRegionSelection_DoesNotTriggersAnnotationRequestForExistingOnes() async throws {
        let api = BetshopAPISpy()
        let view = MapViewSpy()
        let userLocation = UserLocationHandlerDummy()

        let sut = MapViewPresenter(
            betshopAPI: api,
            userLocation: userLocation,
            router: Router(mainViewResolver: { nil }),
            mapView: view
        )

        api.storesReturnedModels = [BetshopModel(
            id: 2312,
            name: "name",
            address: "address",
            topLevelAddress: "topLevelAddress",
            location: (lat: 123.0, lng: 123.0)
        )]

        try await sut.newRegionVisible(
            region: MapViewViewModel.defaultMunichLocation().mapRegion,
            existingAnnotations: [
                Betshop(
                    id: 2312,
                    name: "String",
                    address: "",
                    topLevelAddress: "",
                    coordinate: CLLocationCoordinate2DMake(123, 123)
                )
            ]
        )

        XCTAssertEqual(view.updateCalledWithModel.count, 1)
        XCTAssertEqual(view.updateCalledWithModel.first?.annotations, [])
    }

    func test_newRegionSelection_triggersAnnotationRequestForNewOnes() async throws {
        let api = BetshopAPISpy()
        let view = MapViewSpy()
        let userLocation = UserLocationHandlerDummy()

        let sut = MapViewPresenter(
            betshopAPI: api,
            userLocation: userLocation,
            router: Router(mainViewResolver: { nil }),
            mapView: view
        )

        api.storesReturnedModels = [BetshopModel(
            id: 2312,
            name: "name",
            address: "address",
            topLevelAddress: "topLevelAddress",
            location: (lat: 123.0, lng: 123.0)
        )]

        try await sut.newRegionVisible(
            region: MapViewViewModel.defaultMunichLocation().mapRegion,
            existingAnnotations: []
        )

        XCTAssertEqual(view.updateCalledWithModel.count, 1)
        XCTAssertEqual(view.updateCalledWithModel.first?.annotations.map(\.id), [2312])
    }

}

class UserLocationHandlerDummy: UserLocationHandler {
    override func startUpdating() {
        userLocation?(nil)
    }
}

class MapViewSpy: MapView {
    var updateCalledWithModel: [MapViewViewModel] = []
    func update(with model: MapViewViewModel) {
        updateCalledWithModel.append(model)
    }
}

class BetshopAPISpy: BetshopAPI {
    var storesDidCalledWithArea: [Area] = []
    var storesReturnedModels: [BetshopModel] = []
    func stores(in area: Area) async throws -> [BetshopModel] {
        storesDidCalledWithArea.append(area)
        return storesReturnedModels
    }
}
