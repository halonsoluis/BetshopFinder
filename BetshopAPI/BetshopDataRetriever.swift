//
//  BetshopDataRetriever.swift
//  BetshopAPI
//
//  Created by Hugo Alonso on 27/01/2022.
//

import Foundation

struct BetshopDataRetriever {

    private let betshopAPI: URLComponents = {
        var betshopAPI = URLComponents()
        betshopAPI.scheme = "https"
        betshopAPI.host = "interview.superology.dev"
        betshopAPI.path = "/betshops"
        return betshopAPI
    }()

    func urlForBetshopsInBoundingBox(
        topRightLatitude:Double,
        topRightLongitude: Double,
        bottomLeftLatitude: Double,
        bottomLeftLongitude:Double) -> URL? {
            let queryValue = [topRightLatitude,
                              topRightLongitude,
                              bottomLeftLatitude,
                              bottomLeftLongitude]
                .map(\.description)
                .joined(separator: ",")

            var betshopAPI = self.betshopAPI
            betshopAPI.queryItems = [
                URLQueryItem(name: "boundingBox", value: queryValue),
            ]
            return betshopAPI.url
        }

    func load(url: URL) async throws -> [DecodedBetshop] {
        struct DataCapsule:Decodable {
            let betshops: [DecodedBetshop]
        }

        let session = URLSession.shared
        let (jsonData, _) = try await session.data(from: url)

        let capsule = try JSONDecoder().decode(DataCapsule.self, from: jsonData)

        return capsule.betshops
    }
}
