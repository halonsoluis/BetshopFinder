//
//  Betshop.swift
//  BetshopFinder
//
//  Created by Hugo Alonso on 29/01/2022.
//

import MapKit

class Betshop: NSObject, Identifiable, MKAnnotation {
    let id: Int64
    let name: String
    let address: String
    let topLevelAddress: String

    var coordinate: CLLocationCoordinate2D

    init(id: Int64, name: String, address: String, topLevelAddress: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.address = address
        self.topLevelAddress = topLevelAddress
        self.coordinate = coordinate
    }
}
