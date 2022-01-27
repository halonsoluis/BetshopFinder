//
//  BetshopModel.swift
//  betshops
//
//  Created by Hugo Alonso on 26/01/2022.
//

import Foundation

public struct BetshopModel {
    let id: Int64

    let name: String
    let address: String
    let topLevelAddress: String

    let location: (lat: Double, lng: Double)
}
