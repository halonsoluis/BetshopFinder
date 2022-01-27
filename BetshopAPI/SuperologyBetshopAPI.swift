//
//  SuperologyBetshopAPI.swift
//  BetshopAPI
//
//  Created by Hugo Alonso on 27/01/2022.
//

import Foundation

class SuperologyBetshopAPI: BetshopAPI {
    func stores(in area: Area) async throws -> [BetshopModel] {
        let url = BetshopDataRetriever().urlForBetshopsInBoundingBox(
            topRightLatitude: area.topRight.latitude,
            topRightLongitude: area.topRight.longitude,
            bottomLeftLatitude: area.bottomLeft.latitude,
            bottomLeftLongitude: area.bottomLeft.longitude
        )

        guard let url = url else {
            return []
        }

        let models = try APIDataParser().decode(dataURL: url)

        return models.map(DataMapper.buildModel)
    }
}
