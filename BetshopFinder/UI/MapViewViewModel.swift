//
//  MapViewViewModel.swift
//  BetshopFinder
//
//  Created by Hugo Alonso on 29/01/2022.
//

import Foundation
import MapKit

struct MapViewViewModel {

    var annotations: [Betshop] = []
    var mapRegion = MKCoordinateRegion()
    var selected: Betshop?
}

extension MapViewViewModel {

    private static let munich = CLLocationCoordinate2D(
        latitude: 48.137154,
        longitude: 11.576124
    )
    private static let defaultSpan = MKCoordinateSpan(
        latitudeDelta: 0.01,
        longitudeDelta: 0.01
    )

    static func defaultMunichLocation() -> MapViewViewModel {
        var map = MapViewViewModel()
        map.mapRegion = MKCoordinateRegion(
            center: munich,
            span: defaultSpan
        )
        return map
    }
}
