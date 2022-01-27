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

//Picked up from https://www.swiftbysundell.com/articles/making-async-system-apis-backward-compatible/
//As my Mac is currently @ version 11.6.2
@available(iOS, deprecated: 15.0, message: "Use the built-in API instead")
@available(macOS, deprecated: 12.0, message: "Use the built-in API instead")
private extension URLSession {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: url) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }

                continuation.resume(returning: (data, response))
            }

            task.resume()
        }
    }
}
