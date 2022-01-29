//
//  OpenInMapsApp.swift
//  BetshopFinder
//
//  Created by Hugo Alonso on 29/01/2022.
//

import Foundation
import MapKit

enum OpenInMapsApp {
    static func navigate(to store: Betshop) {
        let placemark = MKPlacemark(coordinate: store.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = store.name
        mapItem.openInMaps(launchOptions: [:])
    }
}
