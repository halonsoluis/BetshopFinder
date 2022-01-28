//
//  Betshop.swift
//  betshops
//
//  Created by Hugo Alonso on 27/01/2022.
//

import Foundation
import MapKit

struct Betshop: Identifiable, Equatable {
    static func == (lhs: Betshop, rhs: Betshop) -> Bool {
        lhs.id == rhs.id
    }

    let id: Int64

    let name: String
    let address: String
    let topLevelAddress: String

    let location: CLLocationCoordinate2D

    //Harcoded Data not provided by the API
    static let workingHours = (opening: "08:00", closing:"16:00")
}

extension Betshop {
    var openStatus: String {
        return "Open Now"
    }
}
