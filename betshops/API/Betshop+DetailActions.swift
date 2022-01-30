//
//  Betshop+DetailActions.swift
//  betshops
//
//  Created by Hugo Alonso on 30/01/2022.
//

import Foundation

extension Betshop {
    var openStatus: String {
        return OpenHoursCalculator.storeStatus()
    }

    func navigate() {
        OpenInMapsApp.navigate(to: self)
    }
}
