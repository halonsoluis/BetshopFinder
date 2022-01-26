//
//  DataMapper.swift
//  betshops
//
//  Created by Hugo Alonso on 26/01/2022.
//

import Foundation

struct DataMapper {
    static func buildModel(from data: DecodedBetshop) -> BetshopModel {
        BetshopModel(
            id: data.id,
            name: data.name,
            address: data.address,
            topLevelAddress: "\(data.city) - \(data.county)",
            location: (data.location.lat, data.location.lng)
        )
    }
}
