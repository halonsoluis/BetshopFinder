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
    @Published var mapRegion = MKCoordinateRegion() {
        didSet {
            regionHasChanged()
        }
    }
    @Published var selected: Betshop? {
        didSet {
            shouldPresentDetails = selected != nil
        }
    }
    @Published var shouldPresentDetails = false

    private let munich = CLLocationCoordinate2D(
        latitude: 48.137154,
        longitude: 11.576124
    )
    private let defaultSpan = MKCoordinateSpan(
        latitudeDelta: 0.01,
        longitudeDelta: 0.01
    )

    func regionHasChanged() {
        let mapRegion = self.mapRegion
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard mapRegion == self.mapRegion else { return }

            Task {
                let betshopsFromAPI = try await SuperologyBetshopAPI
                    .defaultBetshopAPI()
                    .stores(in: self.boundingBox)

                DispatchQueue.main.async { [self] in
                    annotations = betshopsFromAPI
                        .map(Betshop.init)
                }
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
    convenience init(model: BetshopModel) {
        self.init(
            id: model.id,
            name: model.name,
            address: model.address,
            topLevelAddress: model.topLevelAddress,
            coordinate: CLLocationCoordinate2D(latitude: model.location.lat, longitude: model.location.lng)
        )
    }
}

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        return lhs.center.longitude == rhs.center.longitude
        && lhs.center.latitude == rhs.center.latitude
        && lhs.span.latitudeDelta == rhs.span.latitudeDelta
        && lhs.span.longitudeDelta == rhs.span.longitudeDelta
    }
}
