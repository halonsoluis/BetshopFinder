//
//  DecodedBetshop.swift
//  betshops
//
//  Created by Hugo Alonso on 26/01/2022.
//

import Foundation

struct DecodedBetshop: Decodable {
    let name: String
    let location: GeoLocation
    let id: Int64
    let county: String
    let city_id: Int64
    let city: String
    let address: String
}

struct GeoLocation: Decodable {
    let lng: Double
    let lat: Double
}
