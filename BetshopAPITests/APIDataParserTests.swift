//
//  APIDataParserTests.swift
//  BetshopAPITests
//
//  Created by Hugo Alonso on 27/01/2022.
//

import XCTest
@testable import BetshopAPI

class APIDataParser {

    private struct DataCapsule:Decodable {
        let betshops: [DecodedBetshop]
    }

    func decode(dataURL url: URL) throws -> [DecodedBetshop] {
        let jsonData = try Data(contentsOf: url)
        let capsule = try JSONDecoder().decode(DataCapsule.self, from: jsonData)
        return capsule.betshops
    }
}

class APIDataParserTests: XCTestCase {

    func testExample() throws {
        guard let url = Bundle(for: type(of: self)).url(forResource: "exampleLocations", withExtension: "json") else {
            XCTFail("Example data not found")
            return
        }

        let betshops = try APIDataParser().decode(dataURL: url)

        XCTAssertEqual(betshops.count, 3)
    }

}
