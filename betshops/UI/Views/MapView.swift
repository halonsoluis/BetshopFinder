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

            //The map implementation does not perform clustering (not yet supported) https://developer.apple.com/forums/thread/684811
            //Which leads to a huge loss in performance
            //This leaves me with 33 options
            // - Do the clustering manually - Potential introduction of errors, nice activity, time consuming when there's already something like that implemented in the system.
            // - Use MapView from UIKit. - Next to try
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
