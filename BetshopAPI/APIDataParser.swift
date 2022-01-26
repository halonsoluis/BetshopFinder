//
//  APIDataParser.swift
//  BetshopAPI
//
//  Created by Hugo Alonso on 27/01/2022.
//

import Foundation

class APIDataParser {

    private struct DataCapsule:Decodable {
        let betshops: [DecodedBetshop]
    }

    func decode(dataURL url: URL) throws -> [DecodedBetshop] {
        let jsonData = try Data(contentsOf: url)
        let capsule = try JSONDecoder().decode(DataCapsule.self, from: jsonData)
        return capsule.betshops
    }
}
