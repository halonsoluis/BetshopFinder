//
//  DataMapperTests.swift
//  betshopsTests
//
//  Created by Hugo Alonso on 25/01/2022.
//

import XCTest
@testable import BetshopAPI

class DataMapperTests: XCTestCase {

    func testMapper_createsBetshopModel_withValidData() {
        let betshop = DataMapper.buildModel(from: exampleData)

        XCTAssertEqual(betshop.id, 2350329)
        XCTAssertEqual(betshop.name, "Lenbachplatz 7")
        XCTAssertEqual(betshop.address, "80333 Muenchen")
        XCTAssertEqual(betshop.topLevelAddress, "Muenchen - Bayern")
        XCTAssertEqual(betshop.location.lat, 48.1405515)
        XCTAssertEqual(betshop.location.lng, 11.5689638)
    }
}

extension DataMapperTests {
    var exampleData: DecodedBetshop {
        DecodedBetshop(
            name: "Lenbachplatz 7",
            location: GeoLocation(
                lng: 11.5689638,
                lat: 48.1405515
            ),
            id: 2350329,
            county: "Bayern",
            city_id: 80333,
            city: "Muenchen",
            address: "80333 Muenchen"
        )
    }
}
