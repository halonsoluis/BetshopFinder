//
//  MapViewModel.swift
//  betshops
//
//  Created by Hugo Alonso on 27/01/2022.
//

import MapKit
import BetshopAPI

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
        annotations = []
        mapRegion = MKCoordinateRegion(
            center: munich,
            span: defaultSpan
        )
    }

    func selectedPin(_ betshop: Betshop) {
        self.selected = betshop
    }

    func regionHasChanged() {
        Task {
            let betshopsFromAPI = try await SuperologyBetshopAPI.defaultBetshopAPI().stores(in: boundingBox)

            DispatchQueue.main.async { [self] in
                annotations = betshopsFromAPI.map(Betshop.init)
            }
        }
    }

    private var boundingBox: Area {
        //Using approach found @ https://stackoverflow.com/a/12607213/2683201 for defining the bounding box
        let latMin = mapRegion.center.latitude - 0.5 * mapRegion.span.latitudeDelta;
        let latMax = mapRegion.center.latitude + 0.5 * mapRegion.span.latitudeDelta;
        let lonMin = mapRegion.center.longitude - 0.5 * mapRegion.span.longitudeDelta;
        let lonMax = mapRegion.center.longitude + 0.5 * mapRegion.span.longitudeDelta;

        return Area(
            topRight: Location(latitude: latMax, longitude: lonMax),
             bottomLeft: Location(latitude: latMin, longitude: lonMin)
        )
    }
}

extension Betshop {
    init(model: BetshopModel) {
        self.init(
            id: model.id,
            name: model.name,
            address: model.address,
            topLevelAddress: model.topLevelAddress,
            location: CLLocationCoordinate2D(latitude: model.location.lat, longitude: model.location.lng)
        )
    }
}
