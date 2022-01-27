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

            Spacer()

            ZStack(alignment: .bottom) {
                Spacer()

                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Image("pin.symbolic")

                        VStack(alignment: .leading, spacing: 16) {
                            Text(betshop.name)
                                .font(.headline)

                            Text(betshop.address)
                                .font(.headline)

                            Text(betshop.topLevelAddress)
                                .font(.headline)
                        }

                        Spacer()

                        Image("close")
                    }

                    HStack {
                        Image("phone")

                        Text("311-5444")
                            .font(.headline)
                    }

                    HStack {

                        Text("Open now")

                        Button {

                        } label: {
                            Text("Route")
                                .font(.callout)
                                .fontWeight(.bold)
                        }

                    }
                }.padding()
            }
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
                location: CLLocationCoordinate2D())
        )
            .previewDevice("iPhone 13 mini")
    }
}

