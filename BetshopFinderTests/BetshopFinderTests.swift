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

    func test_update_appliesRegionInModelToTheMap() throws {
        let sut = makeAndPrepareSUT()
        let munichCenter = MapViewViewModel.defaultMunichLocation().mapRegion.center

        sut.update(with: MapViewViewModel.defaultMunichLocation())

        XCTAssertEqual(sut.map.region.center.latitude, munichCenter.latitude, accuracy: 0.0000001)
        XCTAssertEqual(sut.map.region.center.longitude, munichCenter.longitude, accuracy: 0.0000001)
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
