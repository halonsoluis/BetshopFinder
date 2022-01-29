//
//  OpenHoursCalculator.swift
//  BetshopFinder
//
//  Created by Hugo Alonso on 29/01/2022.
//

import Foundation

enum OpenHoursCalculator {
    private static let openingHour = "08:00"
    private static let closingHour = "16:00"
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()

    static func storeStatus(now: Date = Date()) -> String {
        let current = dateFormatter.string(from: now)

        guard current < closingHour else {
            return "Opens tomorrow at \(openingHour)"
        }

        guard current < openingHour else {
            return "Open Now until \(closingHour)"
        }
        //Extra case not considered in the exercise
        return "Opens today at \(openingHour)"
    }
}
