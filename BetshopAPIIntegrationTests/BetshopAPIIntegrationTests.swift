//
//  BetshopAPIIntegrationTests.swift
//  BetshopAPIIntegrationTests
//
//  Created by Hugo Alonso on 27/01/2022.
//

import XCTest
import BetshopAPI

class BetshopAPIIntegrationTests: XCTestCase {

    func test_SuperologyBetshopAPI_downloadsData() async throws {

        let sut = SuperologyBetshopAPI.defaultBetshopAPI()

        let area = Area(
            topRight: Location(latitude: 48.16124, longitude: 11.60912),
            bottomLeft: Location(latitude: 48.12229, longitude: 11.52741)
        )

        let betshops = try await sut.stores(in: area)

        XCTAssertEqual(betshops.count, 109)
    }
}
