//
//  BetshopStoreDetails.swift
//  betshops
//
//  Created by Hugo Alonso on 27/01/2022.
//

import SwiftUI
import MapKit

struct BetshopStoreDetailsView: View {
    let betshop: Betshop

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            ZStack(alignment: .bottom) {
                Spacer()

                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Image("pin.symbolic")

                        VStack(alignment: .leading, spacing: 16) {
                            Text(betshop.name)
                                .font(.title3)
                                .foregroundColor(.black)

                            Text(betshop.address)
                                .font(.caption)
                                .foregroundColor(.black)

                            Text(betshop.topLevelAddress)
                                .font(.caption)
                                .foregroundColor(.black)

                            HStack {
                                Text(betshop.openStatus)
                                    .font(.callout)
                                    .foregroundColor(.green)

                                Spacer()

                                Label("Route", systemImage: "location.magnifyingglass")
                                    .labelStyle(.titleAndIcon)
                                    .foregroundColor(.blue)
                                    .onTapGesture(perform: betshop.navigate)

                            }

                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .shadow(radius: 20)
                )
            }
            .padding()
        }
    }
}

struct BetshopStoreDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BetshopStoreDetailsView(
            betshop: Betshop(
                id: 23,
                name: "name",
                address: "address",
                topLevelAddress: "topLevelAddress",
                coordinate: CLLocationCoordinate2D())
        )
            .previewDevice("iPhone 13 mini")
    }
}

