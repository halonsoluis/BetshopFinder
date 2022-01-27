//
//  MapAnnotationView.swift
//  betshops
//
//  Created by Hugo Alonso on 27/01/2022.
//

import SwiftUI
import MapKit

struct MapAnnotationView: View {
    let selected: Bool

    var body: some View {
        Image(selected ? "pin.selected" : "pin")
            .resizable()
            .padding()
    }
}


struct MapAnnotationViewSelected_Previews: PreviewProvider {
    static var previews: some View {
        MapAnnotationView(selected: true)
            .previewDevice("iPhone 13 mini")
    }
}

struct MapAnnotationViewNotSelected_Previews: PreviewProvider {
    static var previews: some View {
        MapAnnotationView(selected: false)
            .previewDevice("iPhone 13 mini")
    }
}
