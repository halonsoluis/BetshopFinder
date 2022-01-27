//
//  SuperologyBetshopAPI.swift
//  BetshopAPI
//
//  Created by Hugo Alonso on 27/01/2022.
//

import Foundation

public class SuperologyBetshopAPI: BetshopAPI {
    let dataRetriever: BetshopDataRetriever

    init(dataRetriever: BetshopDataRetriever = BetshopDataRetriever()) {
        self.dataRetriever = dataRetriever
    }

    public func stores(in area: Area) async throws -> [BetshopModel] {
        let url = dataRetriever.urlForBetshopsInBoundingBox(
            topRightLatitude: area.topRight.latitude,
            topRightLongitude: area.topRight.longitude,
            bottomLeftLatitude: area.bottomLeft.latitude,
            bottomLeftLongitude: area.bottomLeft.longitude
        )

        guard let url = url else {
            return []
        }

        let models = try await dataRetriever.load(url: url)

        return models.map(DataMapper.buildModel)
    }
}


extension SuperologyBetshopAPI {
    public static func defaultBetshopAPI() -> BetshopAPI {
        SuperologyBetshopAPI(
            dataRetriever: BetshopDataRetriever()
        )
    }
}
