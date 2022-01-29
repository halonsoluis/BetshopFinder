//
//  OpenHoursCalculatorTests.swift
//  BetshopFinderTests
//
//  Created by Hugo Alonso on 29/01/2022.
//

import XCTest

enum OpenHoursCalculator {
    static func storeStatus(now: NSDate = NSDate(), workingHours: (opening: String, closing: String)) -> String {
        return "Open Now until \(workingHours.closing)"
    }
}

class OpenHoursCalculatorTests: XCTestCase {

    func test_openHours_showOpenNowWhenInBetweenWorkingHours() throws {
        XCTAssertEqual(OpenHoursCalculator.storeStatus(workingHours: (opening: "08:00", closing: "20:00")), "Open Now until 20:00")
    }

//    func test_openHours_showOpensTomorrowWhenAfterWorkingHours() throws {
//        XCTAssertEqual(OpenHoursCalculator.storeStatus(workingHours: (opening: "08:00", closing: "20:00")), "Opens tomorrow at 08:00")
//    }
}
