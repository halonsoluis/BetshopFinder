//
//  MapView.swift
//  betshops
//
//  Created by Hugo Alonso on 25/01/2022.
//

import SwiftUI
import MapKit

struct MapView: View {

    @EnvironmentObject private var viewModel: MapViewModel

    var body: some View {
        Map(coordinateRegion: $viewModel.mapRegion,
            interactionModes: .all,
            showsUserLocation: true,
            userTrackingMode: .none,
            annotationItems: viewModel.annotations, annotationContent: { betshop in

            MapAnnotation(coordinate: betshop.location) {
                MapAnnotationView(selected: betshop == viewModel.selected)
                    .onTapGesture {
                        viewModel.selectedPin(betshop)
                    }
            }

        })
            .onChange(of: viewModel.mapRegion) { newRegion in
                viewModel.regionHasChanged()
            }
            .ignoresSafeArea()
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

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .previewDevice("iPhone 13 mini")
            .environmentObject(MapViewModel())
    }
}
