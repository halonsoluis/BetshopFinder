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
    static func exampleBetshopList() -> [Betshop] {
        [
            Betshop(id: 2350329, name: "Lenbachplatz 7", address: "80333 Muenchen", topLevelAddress: "Muenchen - Bayern", location: CLLocationCoordinate2D(latitude: 48.1405515, longitude: 11.5689638)),
            Betshop(id: 2350330, name: "Lenbachplatz 1", address: "80333 Muenchen", topLevelAddress: "Muenchen - Bayern", location: CLLocationCoordinate2D(latitude: 48.1305510, longitude: 11.5689630)),
            Betshop(id: 2350331, name: "Lenbachplatz 3", address: "80333 Muenchen", topLevelAddress: "Muenchen - Bayern", location: CLLocationCoordinate2D(latitude: 48.1005510, longitude: 11.5689635)),
            Betshop(id: 2350332, name: "Lenbachplatz 4", address: "80333 Muenchen", topLevelAddress: "Muenchen - Bayern", location: CLLocationCoordinate2D(latitude: 48.1205514, longitude: 11.5689630))
        ]
    }
}
