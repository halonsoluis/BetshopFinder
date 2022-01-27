//
//  BetshopDataRetrieverTests.swift
//  BetshopAPITests
//
//  Created by Hugo Alonso on 27/01/2022.
//

import XCTest
@testable import BetshopAPI

class BetshopDataRetrieverTests: XCTestCase {

    func test_BetshopDataRetriever_generatesValidURL() throws {
        let sut = BetshopDataRetriever()

        let url = sut.urlForBetshopsInBoundingBox(
            topRightLatitude: 48.16124,    //------(lat, long)
            topRightLongitude: 11.60912,   //----------------
            bottomLeftLatitude: 48.12229,  //----------------
            bottomLeftLongitude: 11.52741  //(lat, long)-----
        )

        let expectedURL = "https://interview.superology.dev/betshops?boundingBox=48.16124,11.60912,48.12229,11.52741"

        XCTAssertEqual(url?.absoluteString, expectedURL)
    }

    func test_doesNotGenerateURLWithRepeatedQuery_afterSequentialCalls() throws {
        let sut = BetshopDataRetriever()

        _ = sut.urlForBetshopsInBoundingBox(
            topRightLatitude: 46.16124,
            topRightLongitude: 13.60912,
            bottomLeftLatitude: 42.12229,
            bottomLeftLongitude: 11.52741
        )

        let url = sut.urlForBetshopsInBoundingBox(
            topRightLatitude: 48.16124,    //------(lat, long)
            topRightLongitude: 11.60912,   //----------------
            bottomLeftLatitude: 48.12229,  //----------------
            bottomLeftLongitude: 11.52741  //(lat, long)-----
        )

        let expectedURL = "https://interview.superology.dev/betshops?boundingBox=48.16124,11.60912,48.12229,11.52741"

        XCTAssertEqual(url?.absoluteString, expectedURL)
    }

    func test_load_fromLocalURLReturnsModels() async throws {
        let sut = BetshopDataRetriever()

        guard let url = Bundle(for: type(of: self)).url(forResource: "exampleLocations", withExtension: "json") else {
            XCTFail("Example data not found")
            return
        }

        let betshops = try await sut.load(url: url)

        XCTAssertEqual(betshops.count, 3)

    }

}
