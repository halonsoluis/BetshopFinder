//
//  BetshopAPIIntegrationTests.swift
//  BetshopAPIIntegrationTests
//
//  Created by Hugo Alonso on 27/01/2022.
//

import XCTest
@testable import BetshopAPI

class BetshopAPIIntegrationTests: XCTestCase {

    func test_API_works() throws {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "interview.superology.dev"
        components.path = "/betshops"
        components.queryItems = [
            URLQueryItem(name: "boundingBox", value: "48.16124,11.60912,48.12229,11.52741"),
        ]

        let betshops = try APIDataParser().decode(dataURL: components.url!)

        XCTAssertEqual(betshops.count, 109)
    }

    func test_APIUsingBetshopDataRetriever_works() throws {

        let url = BetshopDataRetriever().urlForBetshopsInBoundingBox(
            topRightLatitude: 48.16124,    //------(lat, long)
            topRightLongitude: 11.60912,   //----------------
            bottomLeftLatitude: 48.12229,  //----------------
            bottomLeftLongitude: 11.52741  //(lat, long)-----
        )

        let betshops = try APIDataParser().decode(dataURL: url!)

        XCTAssertEqual(betshops.count, 109)
    }
}