//
//  betshopsApp.swift
//  betshops
//
//  Created by Hugo Alonso on 25/01/2022.
//

import SwiftUI

@main
struct betshopsApp: App {
    var body: some Scene {
        WindowGroup {
            MapView()
                .environmentObject(MapViewModel())
        }
    }
}
