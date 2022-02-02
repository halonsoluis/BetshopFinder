//
//  BetshopAPIAdapterTests.swift
//  BetshopAPITests
//
//  Created by Hugo Alonso on 02/02/2022.
//

import XCTest
import MapKit
import BetshopAPI
@testable import BetshopFinder

final class BetshopAPIAdapterTests: XCTestCase {

    func test_newRegionSelection_DoesNotTriggersAnnotationRequestForExistingOnes() async throws {
        let api = BetshopAPISpy()

        let sut = BetshopAPIAdapter(betshopAPI: api)

        api.storesReturnedModels = [BetshopModel(
            id: 2312,
            name: "name",
            address: "address",
            topLevelAddress: "topLevelAddress",
            location: (lat: 123.0, lng: 123.0)
        )]

        let annotations = try await sut.stores(
            in: MapViewViewModel.defaultMunichLocation().mapRegion,
            excluding: [
                Betshop(
                    id: 2312,
                    name: "",
                    address: "",
                    topLevelAddress: "",
                    coordinate: CLLocationCoordinate2DMake(123.0, 123.0)
                )
            ]
        )

        XCTAssertEqual(api.storesDidCalledWithArea.count, 1)
        XCTAssertEqual(annotations, [])
    }

    func test_newRegionSelection_triggersAnnotationRequestForNewOnes() async throws {
        let api = BetshopAPISpy()
        let sut = BetshopAPIAdapter(betshopAPI: api)

        api.storesReturnedModels = [BetshopModel(
            id: 2312,
            name: "name",
            address: "address",
            topLevelAddress: "topLevelAddress",
            location: (lat: 123.0, lng: 123.0)
        )]

        let annotations = try await sut.stores(
            in: MapViewViewModel.defaultMunichLocation().mapRegion,
            excluding: []
        )

        XCTAssertEqual(api.storesDidCalledWithArea.count, 1)
        XCTAssertEqual(annotations.map(\.id), [2312])
    }

}

private final class BetshopAPISpy: BetshopAPI {
    var storesDidCalledWithArea: [Area] = []
    var storesReturnedModels: [BetshopModel] = []

    func stores(in area: Area) async throws -> [BetshopModel] {
        storesDidCalledWithArea.append(area)
        return storesReturnedModels
    }
}
