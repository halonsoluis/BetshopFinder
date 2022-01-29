//
//  Betshop.swift
//  betshops
//
//  Created by Hugo Alonso on 27/01/2022.
//

import Foundation
import MapKit

class Betshop: NSObject, Identifiable, MKAnnotation {
    static func == (lhs: Betshop, rhs: Betshop) -> Bool {
        lhs.id == rhs.id
    }

    let id: Int64

    let name: String
    let address: String
    let topLevelAddress: String

    var coordinate: CLLocationCoordinate2D

    //Harcoded Data not provided by the API
    static let workingHours = (opening: "08:00", closing:"16:00")

    init(id: Int64, name: String, address: String, topLevelAddress: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.address = address
        self.topLevelAddress = topLevelAddress
        self.coordinate = coordinate
    }
}

extension Betshop {
    var openStatus: String {
        return OpenHoursCalculator.storeStatus()
    }
}
