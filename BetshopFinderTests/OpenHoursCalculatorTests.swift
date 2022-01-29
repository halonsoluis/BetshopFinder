//
//  OpenHoursCalculatorTests.swift
//  BetshopFinderTests
//
//  Created by Hugo Alonso on 29/01/2022.
//

import XCTest

enum OpenHoursCalculator {
    private static let openingHour = "08:00"
    private static let closingHour = "16:00"

    static func storeStatus(now: Date = Date()) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        let current = dateFormatter.string(from: now)

        let currentTime = dateFormatter.date(from: current)!
        let openingTime = dateFormatter.date(from: openingHour)!
        let closingTime = dateFormatter.date(from: closingHour)!

        if (currentTime >= openingTime && currentTime < closingTime) {
            return "Open Now until \(closingHour)"
        }

        return "Opens tomorrow at \(openingHour)"
    }
}

class OpenHoursCalculatorTests: XCTestCase {

    func test_openHours_showOpenNowWhenInBetweenWorkingHours() throws {
        let afterWorkingHours = "09:00"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        let now = dateFormatter.date(from: afterWorkingHours)!

        XCTAssertEqual(OpenHoursCalculator.storeStatus(now: now), "Open Now until 16:00")
    }

    func test_openHours_showOpensTomorrowWhenAfterWorkingHours() throws {
        let afterWorkingHours = "21:00"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        let now = dateFormatter.date(from: afterWorkingHours)!
        XCTAssertEqual(OpenHoursCalculator.storeStatus(now: now), "Opens tomorrow at 08:00")
    }
}
//
//NSDateFormatter *dateFormatter = [NSDateFormatter new];
//dateFormatter.locale = locate;
//
//if ([[NSCalendar currentCalendar] isDateInToday:date]
//        || [[NSCalendar currentCalendar] isDateInTomorrow:date]
//        || [[NSCalendar currentCalendar] isDateInYesterday:date]) {
//    dateFormatter.dateStyle = NSDateFormatterShortStyle;
//    dateFormatter.timeStyle = NSDateFormatterNoStyle;
//    dateFormatter.doesRelativeDateFormatting = YES;
//    return [dateFormatter stringFromDate:date];
//}
//
//[dateFormatter setDateFormat:@"E d MMMM yyyy"];
//return [dateFormatter stringFromDate:date];
