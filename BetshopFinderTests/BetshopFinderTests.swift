//
//  BetshopFinderTests.swift
//  BetshopFinderTests
//
//  Created by Hugo Alonso on 29/01/2022.
//

import XCTest
@testable import BetshopFinder

class MapViewControllerTests: XCTestCase {

   func test_whenViewIsLoaded_mapIsLinked() throws {
       let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
       let sut = storyboard.instantiateInitialViewController() as! MapViewController

       sut.loadViewIfNeeded()

       XCTAssertNotNil(sut.map)
    }

    func test_whenViewIsLoaded_delegateIsSetToController() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let sut = storyboard.instantiateInitialViewController() as! MapViewController

        sut.loadViewIfNeeded()

        XCTAssertIdentical(sut.map.delegate, sut)
     }

}
