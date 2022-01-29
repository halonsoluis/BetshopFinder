//
//  MapViewPresenterTests.swift
//  BetshopFinderTests
//
//  Created by Hugo Alonso on 29/01/2022.
//

import XCTest
import BetshopAPI
@testable import BetshopFinder

class MapViewPresenterTests: XCTestCase {

    func test_newRegionSelection_TriggersAnnotationRequest() async throws {
        let api = BetshopAPISpy()
        let view = MapViewSpy()
        let sut = MapViewPresenter(betshopAPI: api)
        sut.mapView = view

//        let testModel = BetshopModel(
//            id: 2312
//            name: "name"
//            address: "address"
//            topLevelAddress: "topLevelAddress"
//            location: (lat: 123.0, lng: 123.0)
//        )
//        api.storesReturnedModels = [testModel]
        try await sut.newRegionVisible(region: MapViewViewModel.defaultMunichLocation().mapRegion)

        XCTAssertEqual(api.storesDidCalledWithArea.count, 1)
//        XCTAssertEqual(view.updateCalledWithModel.count, 1)
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
