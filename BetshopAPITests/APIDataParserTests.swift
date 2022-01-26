//
//  APIDataParserTests.swift
//  BetshopAPITests
//
//  Created by Hugo Alonso on 27/01/2022.
//

import XCTest
@testable import BetshopAPI

class APIDataParserTests: XCTestCase {

    func test_JSONData_isProperlyDecoded() throws {
        guard let url = Bundle(for: type(of: self)).url(forResource: "exampleLocations", withExtension: "json") else {
            XCTFail("Example data not found")
            return
        }

        let betshops = try APIDataParser().decode(dataURL: url)

        XCTAssertEqual(betshops.count, 3)
    }
}
