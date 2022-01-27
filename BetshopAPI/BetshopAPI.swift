//
//  BetshopAPI.swift
//  BetshopAPI
//
//  Created by Hugo Alonso on 27/01/2022.
//

import Foundation

public struct Location {
    let latitude: Double
    let longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

public struct Area {
    let topRight: Location
    let bottomLeft: Location

    public init(topRight: Location, bottomLeft: Location) {
        self.topRight = topRight
        self.bottomLeft = bottomLeft
    }
}

public protocol BetshopAPI {
    func stores(in area: Area) async throws -> [BetshopModel]
}
