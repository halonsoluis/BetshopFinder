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
}

public struct Area {
    let topRight: Location
    let bottomLeft: Location
}

public protocol BetshopAPI {
    func stores(in area: Area) async -> [BetshopModel]
}
