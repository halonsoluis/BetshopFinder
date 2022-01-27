//
//  MapView.swift
//  betshops
//
//  Created by Hugo Alonso on 25/01/2022.
//

import SwiftUI
import MapKit

struct BetshopModel: Identifiable {
    let id: Int64

    let name: String
    let address: String
    let topLevelAddress: String

    let location: CLLocationCoordinate2D

    //Harcoded Data not provided by the API
    static let workingHours = (opening: "08:00", closing:"16:00")
}

struct MapView: View {
    let annotations = [
        BetshopModel(id: 2350329, name: "Lenbachplatz 7", address: "80333 Muenchen", topLevelAddress: "Muenchen - Bayern", location: CLLocationCoordinate2D(latitude: 48.1405515, longitude: 11.5689638))
    ]

    @State var mapRegion = MKCoordinateRegion(
        center: munich,
        span: defaultSpan
    )

    var body: some View {
        Map(coordinateRegion: $mapRegion, annotationItems: annotations, annotationContent: { betshop in
            MapAnnotation(coordinate: betshop.location) {
                Image(systemName: "mappin.circle.fill")
                    .font(.largeTitle)
            }

        })
            .ignoresSafeArea()
    }
}

extension MapView {
    private static let munich = CLLocationCoordinate2D(
        latitude: 48.137154,
        longitude: 11.576124
    )
    private static let defaultSpan = MKCoordinateSpan(
        latitudeDelta: 0.1,
        longitudeDelta: 0.1
    )
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .previewDevice("iPhone 13 mini")
    }
}
