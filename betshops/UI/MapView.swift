//
//  MapView.swift
//  betshops
//
//  Created by Hugo Alonso on 25/01/2022.
//

import SwiftUI
import MapKit

struct MapView: View {

    @State var mapRegion = MKCoordinateRegion(
        center: munich,
        span: defaultSpan
    )

    var body: some View {
        Map(coordinateRegion: $mapRegion)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .previewDevice("iPhone 13 mini")
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
