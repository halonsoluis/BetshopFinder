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
        ZStack(alignment: .bottom) {

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
            .ignoresSafeArea()

            if let selectedBetshop = viewModel.selected {
                BetshopStoreDetailsView(betshop: selectedBetshop)
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .previewDevice("iPhone 13 mini")
            .environmentObject(MapViewModel())
    }
}
