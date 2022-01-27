//
//  SuperologyBetshopAPI.swift
//  BetshopAPI
//
//  Created by Hugo Alonso on 27/01/2022.
//

import Foundation

public class SuperologyBetshopAPI: BetshopAPI {
    let parser: APIDataParser
    let dataRetriever: BetshopDataRetriever

    init(parser: APIDataParser = APIDataParser(),
         dataRetriever: BetshopDataRetriever = BetshopDataRetriever()) {
        self.parser = parser
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

        let models = try parser.decode(dataURL: url)

        return models.map(DataMapper.buildModel)
    }
}


extension SuperologyBetshopAPI {
    public static func defaultBetshopAPI() -> BetshopAPI {
        SuperologyBetshopAPI(
            parser: APIDataParser(),
            dataRetriever: BetshopDataRetriever()
        )
    }
}
