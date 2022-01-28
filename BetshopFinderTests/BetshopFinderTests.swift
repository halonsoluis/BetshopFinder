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
       let sut = makeSUT()

       sut.loadViewIfNeeded()

       XCTAssertNotNil(sut.map)
    }

    func test_whenViewIsLoaded_delegateIsSetToController() throws {
        let sut = makeAndPrepareSUT()

        XCTAssertIdentical(sut.map.delegate, sut)
     }

    //MARK: - HELPER METHODS

    private func makeAndPrepareSUT() -> MapViewController {
        let sut = makeSUT()

        sut.loadViewIfNeeded()

        return sut
    }

    private func makeSUT() -> MapViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let sut = storyboard.instantiateInitialViewController() as! MapViewController

        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut)
        }

        return sut
    }

}
