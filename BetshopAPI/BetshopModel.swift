//
//  BetshopModel.swift
//  betshops
//
//  Created by Hugo Alonso on 26/01/2022.
//

import Foundation

public struct BetshopModel {
    public let id: Int64

    public let name: String
    public let address: String
    public let topLevelAddress: String

    public let location: (lat: Double, lng: Double)
}
