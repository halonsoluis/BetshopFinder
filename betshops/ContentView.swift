//
//  ContentView.swift
//  betshops
//
//  Created by Hugo Alonso on 25/01/2022.
//

import SwiftUI
import MapKit

struct ContentView: View {

    @State var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 48.137154,
            longitude: 11.576124
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.1,
            longitudeDelta: 0.1
        )
    )

    var body: some View {
        Map(coordinateRegion: $mapRegion)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 13 mini")
    }
}
