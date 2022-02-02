//
//  OpenHoursCalculatorTests.swift
//  BetshopFinderTests
//
//  Created by Hugo Alonso on 29/01/2022.
//

import XCTest
@testable import BetshopFinder

final class OpenHoursCalculatorTests: XCTestCase {

    func test_openHours_showOpenNowWhenInBetweenWorkingHours() throws {
        let now = dateFortime(hour: "09:00")

        XCTAssertEqual(OpenHoursCalculator.storeStatus(now: now), "Open Now until 16:00")
    }

    func test_openHours_showOpensTomorrowWhenAfterWorkingHours() throws {
        let now = dateFortime(hour: "21:00")

        XCTAssertEqual(OpenHoursCalculator.storeStatus(now: now), "Opens tomorrow at 08:00")
    }

    func test_openHours_showOpensTodayWhenBeforeWorkingHours() throws {
        let now = dateFortime(hour: "07:00")

        XCTAssertEqual(OpenHoursCalculator.storeStatus(now: now), "Opens today at 08:00")
    }

    private func dateFortime(hour: String) -> Date {
        let afterWorkingHours = hour

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        return dateFormatter.date(from: afterWorkingHours)!
    }
}
