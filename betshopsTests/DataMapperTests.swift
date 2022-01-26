//
//  DataMapperTests.swift
//  betshopsTests
//
//  Created by Hugo Alonso on 25/01/2022.
//

import XCTest
@testable import betshops

struct DataMapper {
    static func buildModel(from data: DecodedBetshop) -> BetshopModel {
        BetshopModel(
            id: data.id,
            name: data.name,
            address: data.address,
            city: data.city,
            county: data.county,
            location: (data.location.lat, data.location.lng)
        )
    }
}

class DataMapperTests: XCTestCase {

    func testMapper_createsBetshopModel_withValidData() {
        let betshopData = exampleData
        let betshop = DataMapper.buildModel(from: betshopData)

        XCTAssertEqual(betshop.id, betshopData.id)
        XCTAssertEqual(betshop.name, betshopData.name)
        XCTAssertEqual(betshop.address, betshopData.address)
        XCTAssertEqual(betshop.city, betshopData.city)
        XCTAssertEqual(betshop.county, betshopData.county)
        XCTAssertEqual(betshop.location.lat, betshopData.location.lat)
        XCTAssertEqual(betshop.location.lng, betshopData.location.lng)
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
