//
//  OpenHoursCalculatorTests.swift
//  BetshopFinderTests
//
//  Created by Hugo Alonso on 29/01/2022.
//

import XCTest

enum OpenHoursCalculator {
    static func storeStatus(now: NSDate = NSDate(), workingHours: (opening: String, closing: String)) -> String {
        return "Open Now"
    }
}

class OpenHoursCalculatorTests: XCTestCase {

    func test_openHours_showOpenNowWhenInBetweenWorkingHours() throws {
        XCTAssertEqual(OpenHoursCalculator.storeStatus(workingHours: (opening: "8:00", closing: "20:00")), "Open Now")
    }
}
