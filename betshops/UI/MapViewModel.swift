//
//  MapViewModel.swift
//  betshops
//
//  Created by Hugo Alonso on 27/01/2022.
//

import MapKit

class MapViewModel: ObservableObject {
    @Published var annotations: [Betshop]
    @Published var mapRegion = MKCoordinateRegion()
    @Published var selected: Betshop?

    private let munich = CLLocationCoordinate2D(
        latitude: 48.137154,
        longitude: 11.576124
    )
    private let defaultSpan = MKCoordinateSpan(
        latitudeDelta: 0.01,
        longitudeDelta: 0.01
    )

    init() {
        annotations = Betshop.exampleBetshopList()
        mapRegion = MKCoordinateRegion(
            center: munich,
            span: defaultSpan
        )
    }

    func selectedPin(_ betshop: Betshop) {
        self.selected = betshop
    }

}
